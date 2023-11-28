#!/bin/bash

while true; do
    choice=$(zenity --list --title "机房管理系统" --text "欢迎进入机房管理系统" \
        --column "选项" --column "说明" \
        "管理员" "进入管理员模式" \
        "学生" "进入学生模式" \
        "退出系统" "退出机房管理系统" \
        --width=400 \
        --height=300 \
        --hide-header)

    # 检查对话框返回的值
    if [[ $? -eq 1 ]]; then
        # 用户点击了关闭按钮
        exit 0
    fi

    case $choice in
    "管理员")
        ./guanliyuan.sh
        ;;
    "学生")
        ./students.sh
        ;;
    "退出系统")
        exit 0
        ;;
    esac
done
