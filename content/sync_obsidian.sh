#!/bin/bash

# Переходим в корень репозитория (там, где папка .git и папка content)
cd "$(dirname "$0")"

# Добавляем абсолютно все изменения в индекс гит
git add -A

# Вычисляем папку с наибольшим количеством изменений внутри content/
# 1. Смотрим только файлы, измененные в папке content/
# 2. Исключаем папку с картинками content/src и сам скрипт синхронизации
# 3. Если файл лежит прямо в корне content/ (например, index.md), пишем "content"
# 4. Если лежит в подпапке (например, content/OS-NETWORK/Cisco), берем имя этой подпапки (OS-NETWORK)
# 5. Считаем упоминания, сортируем по убыванию и берем лидера
MAIN_DIR=$(git diff --cached --name-only | grep '^content/' | grep -vE '(content/src/|sync_obsidian\.sh)' | awk -F/ '{
    if ($2 ~ /\.md$/ || $2 == "index.md" || $2 == "kek.md") {
        print "content"
    } else if ($2 != "") {
        print $2
    }
}' | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')

# Если изменений в content/ не обнаружено (например, вы правили только конфиги самого Quartz)
if [ -z "$MAIN_DIR" ]; then
    MAIN_DIR="quartz-system"
fi

# Получаем текущее время в формате ДД.ММ.ГГ ЧЧ:ММ
CURRENT_TIME=$(date "+%d.%m.%y %H:%M")

# Собираем заголовок коммита
COMMIT_MSG="Sync: $MAIN_DIR $CURRENT_TIME"

echo "Отправка изменений: $COMMIT_MSG"

# Фиксируем изменения и пушим в ветку master
git commit -m "$COMMIT_MSG"
git push origin master

