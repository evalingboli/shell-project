#!/bin/bash

while true; do
    option=$(zenity --title="安排表" --list --column="选项" --text="请选择您需要的操作：" \
        "添加课表" "显示课表" "删除课表" "修改课表" "复制课表" "插入课表" "退出" --width=400 --height=300)
    # 检查对话框返回的值
    if [[ $? -eq 1 ]]; then
        # 用户点击了关闭按钮
        exit 0
    fi
    case $option in
    "添加课表")
        while true; do
            input=$(zenity --forms --title="添加课表" --text="请输入班级、课号课程、时间、周数、课时数：" \
                --add-entry="班级" \
                --add-entry="课号课程" \
                --add-entry="时间" \
                --add-entry="周数" \
                --add-entry="课时数" --width=400 --height=300)

            if [ $? -eq 0 ]; then
                echo "$input " >>anpaibiao.txt
            else
                break
            fi
        done
        ;;
    "显示课表")
        zenity --text-info --title="显示课表" --filename="anpaibiao.txt" --width=900 --height=500
        ;;
    "删除课表")
        while true; do
            course_number=$(zenity --entry --title="删除课表" --text="请输入需要删除的课号：" --width=400 --height=300)
            if [ $? -eq 0 ]; then
                sed -i "/$course_number/d" anpaibiao.txt
                zenity --info --title="删除课表" --text="删除成功！" --width=400 --height=300
            else
                break
            fi
        done
        ;;
    "修改课表")
        while true; do

            line_number=$(zenity --entry --title="修改课表" --text="请输入需要修改的行号：" --width=400 --height=300)

            if [ $? -eq 0 ]; then
                current_data=$(awk -v m=$line_number 'NR==m' anpaibiao.txt)
                input=$(zenity --forms --title="修改课表" --text="请依次输入班级、课号课程、时间、周数、课时数：" \
                    --add-entry="班级" \
                    --add-entry="课号课程" \
                    --add-entry="时间" \
                    --add-entry="周数" \
                    --add-entry="课时数" \
                    --separator=" " --width=400 --height=300)
            else
                break
            fi

            if [ $? -eq 0 ]; then
                sed -i "${line_number}s/.*/$input/" anpaibiao.txt
                zenity --info --title="修改课表" --text="修改成功！" --width=400 --height=300
            else
                break
            fi
        done
        ;;
    "复制课表")
        while true; do
            file_to_copy=$(zenity --file-selection --title="复制课表" --filename="/path/to/file" --width=400 --height=300)
            if [ $? -eq 0 ]; then
                destination_folder=$(zenity --file-selection --directory --title="复制课表" --filename="/path/to/folder" --width=400 --height=300)
            else
                break
            fi
            if [ $? -eq 0 ]; then
                cp -r "$file_to_copy" "$destination_folder"
            else
                break
            fi
            zenity --info --title="复制课表" --text="复制成功！" --width=400 --height=300
        done
        ;;
    "插入课表")
        while true; do
            insert_line=$(zenity --entry --title="插入课表" --text="请输入需要插入的行：" --width=400 --height=300)
            if [ $? -eq 0 ]; then
                input=$(zenity --forms --title="插入课表" --text="请依次输入班级、课号课程、时间、周数、课时数：" \
                    --add-entry="班级" \
                    --add-entry="课号课程" \
                    --add-entry="时间" \
                    --add-entry="周数" \
                    --add-entry="课时数" \
                    --separator=" " --width=400 --height=300)
            else
                break
            fi
            if [ $? -eq 0 ]; then
                sed -i "${insert_line}i${input}" anpaibiao.txt
                zenity --info --title="插入课表" --text="插入成功！" --width=400 --height=300
            else
                break
            fi
        done
        ;;
    "退出")
        exit 0
        ;;
    esac
done
