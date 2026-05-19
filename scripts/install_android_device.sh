#!/bin/bash

# Сборка, установка и запуск на Android (USB).
# Если API < minSdk или нет USB — эмулятор (предпочтительно API 34+).

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
MIN_SDK=${MIN_SDK:-34}
TARGET_KIND="device"
DEVICE_ID=""

use_android_emulator() {
    TARGET_KIND="emulator"
    DEVICE_ID=""
    DEVICE_LINE=$(flutter devices 2>/dev/null | grep -E "android" | grep -i emulator | head -1 || true)

    if [[ -z "$DEVICE_LINE" ]]; then
        echo "🚀 Запуск Android Emulator..."
        EMULATOR_ID=$(flutter emulators 2>/dev/null | grep -E "Pixel_7_API_36|API_3[4-9]" | awk -F '•' '{print $1}' | xargs | head -1 || true)
        [[ -z "$EMULATOR_ID" ]] && EMULATOR_ID=$(flutter emulators 2>/dev/null | grep -i android | awk -F '•' '{print $1}' | xargs | head -1 || true)
        [[ -z "$EMULATOR_ID" ]] && { echo -e "${RED}❌ Нет AVD с API >= $MIN_SDK${NC}"; exit 1; }
        flutter emulators --launch "$EMULATOR_ID" || true
        for _ in $(seq 1 60); do
            sleep 2
            DEVICE_ID=$(adb devices 2>/dev/null | awk 'NR>1 && $2=="device" {print $1}' | head -1)
            [[ -n "$DEVICE_ID" ]] && break
        done
    else
        DEVICE_ID=$(echo "$DEVICE_LINE" | awk -F '•' '{print $2}' | xargs)
    fi

    [[ -z "$DEVICE_ID" ]] && { echo -e "${RED}❌ Эмулятор не поднялся${NC}"; exit 1; }
    echo -e "${GREEN}✅ Эмулятор: $DEVICE_ID${NC}"
}

echo "🔍 Поиск устройства (minSdk $MIN_SDK)..."
if command -v adb &>/dev/null; then
    CANDIDATE=$(adb devices | awk 'NR>1 && $2=="device" {print $1}' | head -1)
    if [[ -n "$CANDIDATE" ]]; then
        API=$(adb -s "$CANDIDATE" shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r' || echo 0)
        if [[ "$API" =~ ^[0-9]+$ ]] && [[ "$API" -ge "$MIN_SDK" ]]; then
            DEVICE_ID="$CANDIDATE"
            echo -e "${GREEN}✅ USB: $DEVICE_ID (API $API)${NC}"
        else
            echo -e "${YELLOW}⚠️  $CANDIDATE API $API < $MIN_SDK → эмулятор${NC}"
        fi
    fi
fi

[[ -z "$DEVICE_ID" ]] && use_android_emulator
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
