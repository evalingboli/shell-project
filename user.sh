#!/bin/bash

input="anpaibiao.txt" # 课表信息文件
input_pas="user.txt"  # 用户信息文件

while true; do
    option=$(zenity --title="用户管理" --list --column="选项" --text="欢迎进入用户管理" \
        "显示用户" "添加用户" "删除用户" "退出" --width=400 --height=300)

    # 检查对话框返回的值
    if [[ $? -eq 1 ]]; then
        # 用户点击了关闭按钮
        exit 0
    fi
    case $option in
    "显示用户")
        zenity --text-info --title="显示用户" --filename="user.txt" --width=900 --height=500
        ;;
    "添加用户")
        while true; do
            input=$(zenity --forms --title="添加用户" --text="请输入新用户的学号和密码：" \
                --add-entry="学号" \
                --add-password="密码" --width=400 --height=300)

            if [ $? -eq 0 ]; then
                xuehao=$(echo "$input" | awk '{print $1}')
                mima=$(echo "$input" | awk '{print $2}')

                echo "$xuehao $mima" >>user.txt
                zenity --info --title="添加用户" --text="添加用户成功！" --width=400 --height=300
            else
                break
            fi

            continue_add=$(zenity --question --title="添加用户" --text="是否继续添加用户？" --width=400 --height=300)
            if [ $? -eq 1 ]; then
                break
            fi
        done
        ;;
    "删除用户")
        while true; do
            xuehao=$(zenity --entry --title="删除用户" --text="请输入需要删除的用户学号：" --width=400 --height=300)

            if [ $? -eq 0 ]; then
                flag=0

                while IFS=":|" read -r user password; do
                    if [ "$user" = "$xuehao" ]; then
                        sed -i "/$xuehao/d" user.txt
                        userdel -f "$user"
                        zenity --info --title="删除用户" --text="$xuehao 用户删除成功！" --width=400 --height=300
                        flag=1
                        break
                    fi
                done <user.txt

                if [ "$flag" = 0 ]; then
                    zenity --info --title="删除用户" --text="$xuehao 用户不存在！" --width=400 --height=300
                fi
            else
                break
            fi

            continue_delete=$(zenity --question --title="删除用户" --text="是否继续删除用户？" --width=400 --height=300)
            if [ $? -eq 1 ]; then
                break
            fi
        done
        ;;
    "退出")
        exit 0
        ;;
    esac
done
