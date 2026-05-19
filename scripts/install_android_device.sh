#!/bin/bash

# Сборка, установка и запуск на Android (USB).
# Если API < minSdk или нет USB — эмулятор.

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

echo "📱 Summify → Android (девайс или эмулятор)"
echo "   $PROJECT_ROOT"
echo ""

MODE="${1:-release}"
if [[ "$MODE" != "release" && "$MODE" != "debug" ]]; then
    echo -e "${RED}Использование: $0 [release|debug]${NC}"
    exit 1
fi

MIN_SDK=$(grep -E 'minSdkVersion' android/app/build.gradle | grep -oE '[0-9]+' | head -1)
MIN_SDK=${MIN_SDK:-24}
TARGET_KIND="device"
DEVICE_ID=""

adb_api_level() {
    local serial="$1"
    adb -s "$serial" shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r'
}

# Подходит ли adb-серийник (эмулятор или API >= minSdk), не из чёрного списка.
pick_suitable_adb_device() {
    local reject_serial="${1:-}"
    local serial api

    while read -r serial status; do
        [[ "$status" != "device" ]] && continue
        [[ -n "$reject_serial" && "$serial" == "$reject_serial" ]] && continue

        if [[ "$serial" =~ ^emulator- ]]; then
            echo "$serial"
            return 0
        fi

        api=$(adb_api_level "$serial")
        if [[ "$api" =~ ^[0-9]+$ ]] && [[ "$api" -ge "$MIN_SDK" ]]; then
            echo "$serial"
            return 0
        fi
    done < <(adb devices 2>/dev/null | awk 'NR>1 {print $1, $2}')

    return 1
}

pick_flutter_emulator_id() {
    flutter devices 2>/dev/null | grep -E "android" | grep -i emulator | head -1 | awk -F '•' '{print $2}' | xargs
}

use_android_emulator() {
    local reject_serial="${1:-}"
    TARGET_KIND="emulator"
    DEVICE_ID=""

    DEVICE_ID=$(pick_flutter_emulator_id || true)
    if [[ -n "$DEVICE_ID" ]]; then
        api=$(adb_api_level "$DEVICE_ID" 2>/dev/null || echo 0)
        if [[ "$api" =~ ^[0-9]+$ ]] && [[ "$api" -ge "$MIN_SDK" ]]; then
            echo -e "${GREEN}✅ Эмулятор (уже запущен): $DEVICE_ID (API $api)${NC}"
            return
        fi
        DEVICE_ID=""
    fi

    DEVICE_ID=$(pick_suitable_adb_device "$reject_serial" || true)
    if [[ -n "$DEVICE_ID" ]] && [[ "$DEVICE_ID" =~ ^emulator- ]]; then
        api=$(adb_api_level "$DEVICE_ID")
        echo -e "${GREEN}✅ Эмулятор (уже запущен): $DEVICE_ID (API $api)${NC}"
        return
    fi
    DEVICE_ID=""

    echo "🚀 Запуск Android Emulator (нужен API >= $MIN_SDK)..."
    EMULATOR_ID=$(flutter emulators 2>/dev/null | grep -E "Pixel_7_API_36|API_2[4-9]|API_3[0-9]" | awk -F '•' '{print $1}' | xargs | head -1 || true)
    [[ -z "$EMULATOR_ID" ]] && EMULATOR_ID=$(flutter emulators 2>/dev/null | grep -i android | awk -F '•' '{print $1}' | xargs | head -1 || true)
    [[ -z "$EMULATOR_ID" ]] && { echo -e "${RED}❌ Нет AVD с API >= $MIN_SDK. Создайте AVD в Android Studio.${NC}"; exit 1; }

    echo "   AVD: $EMULATOR_ID"
    flutter emulators --launch "$EMULATOR_ID" || true

    echo "⏳ Ожидание эмулятора (USB $reject_serial игнорируется)..."
    for _ in $(seq 1 90); do
        sleep 2
        DEVICE_ID=$(pick_suitable_adb_device "$reject_serial" || true)
        if [[ -n "$DEVICE_ID" ]] && [[ "$DEVICE_ID" =~ ^emulator- ]]; then
            api=$(adb_api_level "$DEVICE_ID")
            echo -e "${GREEN}✅ Эмулятор: $DEVICE_ID (API $api)${NC}"
            return
        fi
    done

    echo -e "${RED}❌ Эмулятор не поднялся за 3 мин.${NC}"
    echo "   Отключите старый телефон по USB или запустите AVD вручную: flutter emulators --launch Pixel_7_API_36"
    exit 1
}

REJECT_USB=""

echo "🔍 Поиск устройства (minSdk $MIN_SDK)..."
if command -v adb &>/dev/null; then
    CANDIDATE=$(adb devices | awk 'NR>1 && $2=="device" {print $1}' | head -1)
    if [[ -n "$CANDIDATE" ]]; then
        API=$(adb_api_level "$CANDIDATE")
        if [[ "$API" =~ ^[0-9]+$ ]] && [[ "$API" -ge "$MIN_SDK" ]]; then
            DEVICE_ID="$CANDIDATE"
            echo -e "${GREEN}✅ USB: $DEVICE_ID (API $API)${NC}"
        else
            REJECT_USB="$CANDIDATE"
            echo -e "${YELLOW}⚠️  $CANDIDATE — Android API $API, приложению нужен API >= $MIN_SDK (устройство слишком старое).${NC}"
            echo -e "${YELLOW}   Переключаемся на эмулятор…${NC}"
        fi
    fi
fi

if [[ -z "$DEVICE_ID" ]]; then
    use_android_emulator "$REJECT_USB"
fi
echo ""

flutter pub get

echo ""
echo "🔨 flutter run ($MODE) на $DEVICE_ID"
echo "   Сборка может занять несколько минут. Приложение откроется само."
echo "   Остановка: q или Ctrl+C в этом терминале."
echo ""

if [[ "$MODE" == "release" ]]; then
    flutter run --release -d "$DEVICE_ID"
else
    flutter run --debug -d "$DEVICE_ID"
fi
