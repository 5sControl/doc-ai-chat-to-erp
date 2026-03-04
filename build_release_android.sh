#!/bin/bash

# SummifyFlutter: подъём версии из pubspec.yaml и сборка релизного AAB.
# Версия — единственный источник: pubspec.yaml (формат x.y.z+build).

set -e

echo "🚀 Сборка релиза Android (AAB)"
echo "==============================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PUBSPEC_FILE="pubspec.yaml"
if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "❌ Ошибка: $PUBSPEC_FILE не найден!"
    exit 1
fi

CURRENT_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | tr -d ' ')
if [ -z "$CURRENT_VERSION" ]; then
    echo "❌ Ошибка: версия не найдена в $PUBSPEC_FILE"
    exit 1
fi

VERSION_PART=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_PART=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)
if [ -z "$BUILD_PART" ] || [ "$BUILD_PART" = "$CURRENT_VERSION" ]; then
    echo "❌ Ошибка: формат версии должен быть x.y.z+build (например 1.8.0+56)"
    exit 1
fi

# Подъём patch: 1.8.0 -> 1.8.1
IFS='.' read -r -a PARTS <<< "$VERSION_PART"
LAST_IDX=$((${#PARTS[@]} - 1))
PARTS[$LAST_IDX]=$((${PARTS[$LAST_IDX]:-0} + 1))
NEW_VERSION_PART=$(IFS='.'; echo "${PARTS[*]}")

NEW_BUILD_NUMBER=$((BUILD_PART + 1))
NEW_VERSION="$NEW_VERSION_PART+$NEW_BUILD_NUMBER"

echo -e "📦 Текущая: ${YELLOW}$CURRENT_VERSION${NC}"
echo -e "📦 Новая:   ${GREEN}$NEW_VERSION${NC}"
echo ""

echo -e "${BLUE}✏️  Обновляем $PUBSPEC_FILE...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
else
    sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
fi
echo -e "${GREEN}✅ Версия обновлена${NC}"
echo ""

echo -e "${BLUE}📥 Зависимости...${NC}"
flutter pub get
echo ""

# Исправление битого NDK: если папка NDK есть без source.properties — удалить, Gradle перекачает
NDK_DIR="${ANDROID_HOME:-$HOME/Library/Android/sdk}/ndk"
if [ -d "$NDK_DIR" ]; then
    for dir in "$NDK_DIR"/28.* "$NDK_DIR"/26.* "$NDK_DIR"/27.*; do
        [ -d "$dir" ] || continue
        if [ ! -f "$dir/source.properties" ]; then
            echo -e "${YELLOW}⚠️  Удаляю битый NDK (нет source.properties): $dir${NC}"
            rm -rf "$dir"
            echo -e "${GREEN}   Gradle скачает NDK заново при сборке.${NC}"
        fi
    done
fi
echo ""

echo -e "${BLUE}🔨 Сборка AAB...${NC}"
flutter build appbundle --release

AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
if [ ! -f "$AAB_PATH" ]; then
    echo "❌ AAB не найден: $AAB_PATH"
    exit 1
fi

mkdir -p builds
FINAL_NAME="builds/summify-v${NEW_VERSION_PART}-${NEW_BUILD_NUMBER}.aab"
cp "$AAB_PATH" "$FINAL_NAME"
AAB_SIZE=$(du -h "$FINAL_NAME" | cut -f1)

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 AAB собран${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📌 Версия: ${GREEN}$NEW_VERSION${NC}"
echo -e "📁 Файл:  ${YELLOW}$FINAL_NAME${NC}"
echo -e "💾 Размер: $AAB_SIZE"
echo ""

