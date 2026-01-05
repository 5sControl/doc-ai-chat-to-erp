#!/bin/bash

# Скрипт для автоматического инкремента build number и сборки релизного IPA для iOS

set -e  # Остановить при ошибке

echo "🚀 Начинаем процесс сборки релиза iOS..."

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Файл pubspec.yaml
PUBSPEC_FILE="pubspec.yaml"

# Проверяем наличие файла
if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "❌ Ошибка: файл $PUBSPEC_FILE не найден!"
    exit 1
fi

# Читаем текущую версию из pubspec.yaml
CURRENT_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | tr -d ' ')

if [ -z "$CURRENT_VERSION" ]; then
    echo "❌ Ошибка: не удалось найти версию в $PUBSPEC_FILE"
    exit 1
fi

echo "📦 Текущая версия: $CURRENT_VERSION"

# Парсим версию (формат: x.y.z+build)
VERSION_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# Проверяем, что build number существует
if [ -z "$BUILD_NUMBER" ] || [ "$BUILD_NUMBER" = "$CURRENT_VERSION" ]; then
    echo "❌ Ошибка: неправильный формат версии. Ожидается: x.y.z+build"
    exit 1
fi

# Инкрементируем build number
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
NEW_VERSION="$VERSION_NUMBER+$NEW_BUILD_NUMBER"

echo "🔄 Обновляем build number: $BUILD_NUMBER → $NEW_BUILD_NUMBER"

# Обновляем версию в pubspec.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
else
    # Linux
    sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
fi

echo -e "${GREEN}✅ Версия обновлена: $NEW_VERSION${NC}"

# Обновляем зависимости
echo "📥 Обновляем зависимости Flutter..."
flutter pub get

# Обновляем поды iOS
echo "📦 Обновляем CocoaPods..."
cd ios
pod install
cd ..

# Собираем релизный IPA
echo "🔨 Собираем релизный IPA..."
flutter build ipa --release

if [ $? -eq 0 ]; then
    IPA_PATH="build/ios/ipa/summishare.ipa"
    if [ -f "$IPA_PATH" ]; then
        IPA_SIZE=$(du -h "$IPA_PATH" | cut -f1)
        echo -e "${GREEN}✅ Релизный IPA успешно собран!${NC}"
        echo "📦 Файл: $IPA_PATH"
        echo "📊 Размер: $IPA_SIZE"
        echo "🔢 Версия: $NEW_VERSION"
    else
        echo "⚠️  IPA файл не найден по ожидаемому пути"
        echo "📂 Ищем IPA файлы..."
        find build/ios -name "*.ipa" 2>/dev/null | head -3
    fi
else
    echo "❌ Ошибка при сборке IPA"
    exit 1
fi

echo -e "${GREEN}🎉 Готово! Релизный билд создан с версией $NEW_VERSION${NC}"

