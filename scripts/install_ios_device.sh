#!/bin/bash

# Сборка, установка и запуск на iPhone/iPad (USB).
# Если физического девайса нет — iOS Simulator (debug).

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

echo "📱 Summify → iOS (девайс или симулятор)"
echo "   $PROJECT_ROOT"
echo ""

MODE="${1:-release}"
if [[ "$MODE" != "release" && "$MODE" != "debug" ]]; then
    echo -e "${RED}Использование: $0 [release|debug]${NC}"
    exit 1
fi

pick_device_id_from_line() {
    echo "$1" | awk -F '•' '{print $2}' | xargs
}

echo "🔍 Поиск устройства..."
FLUTTER_DEVICES=$(flutter devices 2>/dev/null || true)

DEVICE_LINE=$(echo "$FLUTTER_DEVICES" | grep -E "ios" | grep -E "iPhone|iPad" | grep -v -i simulator | grep -v -i wireless | head -1 || true)
TARGET_KIND="device"

if [[ -z "$DEVICE_LINE" ]]; then
    echo -e "${YELLOW}⚠️  USB iPhone/iPad не найден → симулятор${NC}"
    DEVICE_LINE=$(echo "$FLUTTER_DEVICES" | grep -i simulator | grep -E "iPhone|iPad" | head -1 || true)
    TARGET_KIND="simulator"

    if [[ -z "$DEVICE_LINE" ]]; then
        echo "🚀 Запуск iOS Simulator..."
        EMULATOR_ID=$(flutter emulators 2>/dev/null | grep -E "ios|iOS" | awk -F '•' '{print $1}' | xargs | head -1 || true)
        [[ -z "$EMULATOR_ID" ]] && EMULATOR_ID="apple_ios_simulator"
        flutter emulators --launch "$EMULATOR_ID" || true
        open -a Simulator 2>/dev/null || true
        for _ in $(seq 1 30); do
            sleep 2
            FLUTTER_DEVICES=$(flutter devices 2>/dev/null || true)
            DEVICE_LINE=$(echo "$FLUTTER_DEVICES" | grep -i simulator | grep -E "iPhone|iPad" | head -1 || true)
            [[ -n "$DEVICE_LINE" ]] && break
        done
    fi

    if [[ -z "$DEVICE_LINE" ]]; then
        echo -e "${RED}❌ Симулятор недоступен. Проверьте Xcode.${NC}"
        exit 1
    fi

    if [[ "$MODE" == "release" ]]; then
        echo -e "${YELLOW}   На симуляторе: debug вместо release${NC}"
        MODE="debug"
    fi
fi

DEVICE_ID=$(pick_device_id_from_line "$DEVICE_LINE")
echo -e "${GREEN}✅ $TARGET_KIND: $DEVICE_LINE${NC}"
echo ""

flutter pub get
(cd ios && pod install)

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
