#!/bin/bash

# Загальна кількість
total_pacman=$(pacman -Qq | wc -l)
total_aur=$(yay -Qmq --quiet --noconfirm | wc -l)

# Оновлення
updates_pacman=$(checkupdates 2>/dev/null | wc -l)
updates_aur=$(yay -Qum --quiet --noconfirm 2>/dev/null | wc -l)

# Up to date
uptodate_pacman=$((total_pacman - updates_pacman))
uptodate_aur=$((total_aur - updates_aur))

# Відсоток
total=$((total_pacman + total_aur))
uptodate=$((uptodate_pacman + uptodate_aur))
percent=$((uptodate * 100 / total))

# Колір залежно від відсотка
if [ "$percent" -ge 90 ]; then
    color="#a3be8c"  # зелений
elif [ "$percent" -ge 70 ]; then
    color="#ebcb8b"  # жовтий
else
    color="#bf616a"  # червоний
fi

# Вивід JSON
echo "{\"text\": \"  <span color='$color'>${percent}%</span>\", \"tooltip\": \"Pacman: $uptodate_pacman/$total_pacman\\nAUR: $uptodate_aur/$total_aur\", \"class\": \"\"}"
