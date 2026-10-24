#!/bin/bash

# Переходим в папку, где лежит сам скрипт (корень репозитория Obsidian)
cd "$(dirname "$0")"

# Добавляем все изменения в индекс git
git add -A

# Собираем уникальные имена измененных папок/файлов верхнего уровня
# Исключаем служебные файлы squatz или самого гита (например, .gitignore)
CHANGED_PLACES=$(git diff --cached --name-only | awk -F/ '{print $1}' | grep -v '^\.' | sort -u | paste -sd ", " -)

# Если изменений нет, просто выходим
if [ -z "$CHANGED_PLACES" ]; then
    echo "Нет изменений для отправки."
    exit 0
fi

# Формируем дату и время
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M")

# Объединяем дату и места работы в текст коммита
COMMIT_MSG="Sync: $CURRENT_TIME [$CHANGED_PLACES]"

echo "Фиксируем изменения: $COMMIT_MSG"

# Коммитим и отправляем на GitHub Pages
git commit -m "$COMMIT_MSG"
git push origin main

