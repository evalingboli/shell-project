#!/bin/bash
clear
flag=1
flag2=0
IFS=:
input="zhanghao.txt" # 需要读取的文件
while true; do
    if [ $flag = 1 ]; then
        while true; do
            zh=$(zenity --entry --title="管理员登录" --text="请输入管理员帐号：" --width=400 --height=300)
            if [[ $? -eq 1 ]]; then
                # 用户点击了关闭按钮
                exit 0
            fi
            if [ -z "$zh" ]; then
                zenity --error --text="帐号不能为空！" --width=400 --height=300
            else
                break
            fi
        done

        while true; do
            mm=$(zenity --password --title="管理员登录" --text="请输入管理员密码：" --width=400 --height=300)
            if [[ $? -eq 1 ]]; then
                # 用户点击了关闭按钮
                exit 0
            fi
            if [ -z "$mm" ]; then
                zenity --error --text="密码不能为空！" --width=400 --height=300
            else
                break
            fi
        done

        valid_user=0
        while read ZH MM; do # 读取文件里的帐号和密码
            if [ "$zh" = "$ZH" ] && [ "$mm" = "$MM" ]; then
                valid_user=1
                break
            fi
        done <"$input" # 从文件中读取内容

        if [ $valid_user -eq 1 ]; then
            flag2=1
            flag=0
            clear
        else
            zenity --error --text="帐号或密码错误，请重新输入！" --width=400 --height=300
        fi
    fi

    if [ $flag2 = 1 ]; then # 帐号和密码配对成功则执行里面到内容
        while true; do
            choice=$(zenity --list --title="管理员菜单" --text="欢迎 $zh 老师" --column="选项" "安排表" "用户管理" "退出" --width=400 --height=300)
            if [[ $? -eq 1 ]]; then
                # 用户点击了关闭按钮
                exit 0
            fi
            case $choice in
            "安排表")
                clear
                bash anpaibiao.sh # 安排表程序
                ;;
            "用户管理")
                bash user.sh # 用户管理程序
                ;;
            "退出")
                exit 0 # 退出
                clear
                ;;
            esac
        done
    fi
done
