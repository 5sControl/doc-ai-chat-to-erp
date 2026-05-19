#!/bin/bash

# iOS: симулятор — flutter run (debug, hot reload).
#       физический iPhone/iPad — release-сборка + установка (можно отключить USB).
#
# Использование:
#   ./scripts/install_ios_device.sh           # авто: sim → debug+run, device → release install
#   ./scripts/install_ios_device.sh debug     # принудительно debug + flutter run
#   ./scripts/install_ios_device.sh release   # на девайсе: release install; на симуляторе → debug+run

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

echo "📱 Summify → iOS (девайс или симулятор)"
echo "   $PROJECT_ROOT"
echo ""

MODE="${1:-auto}"
if [[ "$MODE" != "auto" && "$MODE" != "release" && "$MODE" != "debug" ]]; then
    echo -e "${RED}Использование: $0 [auto|release|debug]${NC}"
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
fi

DEVICE_ID=$(pick_device_id_from_line "$DEVICE_LINE")
echo -e "${GREEN}✅ $TARGET_KIND: $DEVICE_LINE${NC}"
echo ""

flutter pub get
(cd ios && pod install)

echo ""

if [[ "$TARGET_KIND" == "simulator" ]]; then
    if [[ "$MODE" == "release" ]]; then
        echo -e "${YELLOW}   На симуляторе release не используется → debug + hot reload${NC}"
    fi
    echo -e "${CYAN}🔨 Симулятор: flutter run (debug)${NC}"
    echo "   Hot reload:  ${GREEN}r${NC}  |  Hot restart: ${GREEN}R${NC}  |  Выход: ${GREEN}q${NC} или Ctrl+C"
    echo "   Терминал должен оставаться открытым — так работает live reload."
    echo ""
    flutter run --debug -d "$DEVICE_ID"
    exit 0
fi

# Физический iPhone/iPad
if [[ "$MODE" == "debug" ]]; then
    echo -e "${CYAN}🔨 Девайс: flutter run (debug)${NC}"
    echo "   Hot reload: r | Hot restart: R | Кабель нужен, пока открыт этот терминал."
    echo ""
    flutter run --debug -d "$DEVICE_ID"
    exit 0
fi

echo -e "${CYAN}🔨 Девайс: release-сборка и установка${NC}"
echo "   После «Установлено» можно отключить USB — приложение останется на iPhone."
echo "   (без hot reload; для разработки с кабелем: $0 debug)"
echo ""

flutter build ios --release
flutter install --release -d "$DEVICE_ID"

echo ""
echo -e "${GREEN}✅ Установлено на iPhone/iPad. Можно отключить кабель и запустить приложение с экрана.${NC}"
