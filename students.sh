#!/bin/bash
input="user.txt" # 管理密码文件
flag=0
IFS=:
while true; do
    if [ $flag = 0 ]; then
        xuehao=$(zenity --entry --title="登录" --text="请输入帐号（学号）:" --width=400 --height=300)
        pass=$(zenity --password --title="登录" --text="请输入密码:" --width=400 --height=300)
        while read -r x y; do
            if [ "$x" != $xuehao ]; then
                continue # 帐号不匹配，则继续读取下一条信息
            fi
            if [ "$y" = $pass ]; then
                flag=1
            else
                zenity --error --title="错误" --text="输入有错！请重新输入！" --width=400 --height=300
                if [ $? -eq  ]; then
                    # 用户点击了关闭按钮
                    break
                fi
            fi
        done <$input
    fi

    if [ $flag = 1 ]; then
        while true; do
            # 使用Zenity创建学生菜单对话框
            s=$(zenity --list --title="学生菜单" --text="欢迎 $xuehao" \
                --column="选项" --column="描述" \
                1 "查看课表" \
                2 "课前准备" \
                3 "课后整理" \
                4 "退出" --width=400 --height=300)

            # 检查对话框返回的值
            if [[ $? -eq 1 ]]; then
                # 用户点击了关闭按钮
                exit 0
            fi
            case $s in
            1)
                zenity --info --title="课表" --text="班级         课号课程          上课时间           起始周和结束周          课时数\n$(cat anpaibiao.txt)" --width=900 --height=500
                ;;
            2)
                while true; do
                    # 使用Zenity创建课前准备菜单对话框
                    v=$(zenity --list --title="课前准备" --text="欢迎 $xuehao 学生进入课前准备菜单" \
                        --column="选项" --column="描述" \
                        1 "创建工作区和文件（夹）" \
                        2 "复制文件到系统" \
                        3 "退出" --width=400 --height=300)

                    # 检查对话框返回的值
                    if [[ $? -eq 1 ]]; then
                        # 用户点击了关闭按钮
                        break
                    fi
                    case $v in
                    1)
                        while true; do
                            cd "/home/user/project/work"
                            # 使用Zenity创建创建工作区确认对话框
                            zenity --question --title="创建工作区" --text="是否创建工作区 $xuehao？" --width=400 --height=300
                            if [ $? -eq 0 ]; then
                                if [ -e "$xuehao" ]; then
                                    zenity --info --title="提示" --text="******$xuehao 之前已创建！******" --width=400 --height=300
                                else
                                    mkdir "$xuehao"
                                    zenity --info --title="成功" --text="******$xuehao 已创建成功！******" --width=400 --height=300
                                fi
                            else
                                break
                            fi
                            cd "/home/user/project/work/$xuehao"
                            zenity --info --title="当前目录" --text="当前工作目录：$(pwd)" --width=400 --height=300

                            while true; do
                                # 使用Zenity创建是否创建文件夹和文件对话框
                                zenity --question --title="创建文件夹和文件" --text="是否需要创建文件夹和文件？" --width=400 --height=300

                                if [ $? -eq 1 ]; then
                                    clear
                                    break
                                fi
                                while true; do
                                    # 使用Zenity创建创建文件夹或文件对话框
                                    create_choice=$(zenity --list --title="创建文件夹或文件" --text="创建文件夹（夹）或文件？" \
                                        --column="选项" --column="描述" \
                                        "文件夹" "创建文件夹" \
                                        "文件" "创建文件" --width=400 --height=300)
                                    if [ $? -eq 1 ]; then
                                        clear
                                        break
                                    fi
                                    if [ "$create_choice" = "文件夹" ]; then
                                        cd "/home/user/project/work/$xuehao"
                                        while true; do
                                            folder_name=$(zenity --entry --title="创建文件夹" --text="请输入文件夹名称：" --width=400 --height=300)

                                            if [ $? -eq 1 ]; then
                                                clear
                                                break
                                            fi
                                            mkdir "$folder_name"
                                            clear
                                            zenity --info --title="成功" --text="     $folder_name 文件夹创建成功！" --width=400 --height=300
                                            zenity --info --title="工作区内容" --text="$(ls)" --width=400 --height=300
                                        done
                                    elif [ "$create_choice" = "文件" ]; then
                                        cd "/home/user/project/work/$xuehao"
                                        while true; do
                                            file_name=$(zenity --entry --title="创建文件" --text="请输入文件名称：" --width=400 --height=300)

                                            if [ $? -eq 1 ]; then
                                                clear
                                                break
                                            fi
                                            touch "$file_name"
                                            clear
                                            zenity --info --title="成功" --text="     $file_name 文件创建成功！" --width=400 --height=300
                                            zenity --info --title="工作区内容" --text="$(ls)" --width=400 --height=300
                                        done
                                    fi
                                done
                            done
                        done
                        ;;
                    2)
                        while true; do
                            file_path=$(zenity --file-selection --title="选择文件" --text="请选择需要复制的文件路径：" --width=400 --height=300)
                            if [[ $? -eq 1 ]]; then
                                # 用户点击了关闭按钮
                                break
                            fi
                            if [ -n "$file_path" ]; then
                                cp -r "$file_path" "/home/user/project/work/$xuehao"
                                cd "/home/user/project/work/$xuehao"
                                zenity --info --title="提示" --text="文件复制成功！" --width=400 --height=300
                                zenity --info --title="提示" --text="工作区内容如下：\n$(ls)" --width=400 --height=300
                                sleep 3
                            fi
                            clear
                        done
                        ;;

                    3)
                        break
                        ;;
                    esac
                done
                ;;
            3)
                while true; do
                    choice=$(zenity --list --title="课后整理菜单" --column="选项" --column="描述" \
                        "打包压缩并复制" "打包压缩工作区并复制到USB设备" \
                        "删除文件" "删除整个工作区" \
                        "退出" "退出菜单" --width=400 --height=300)
                    if [[ $? -eq 1 ]]; then
                        # 用户点击了关闭按钮
                        break
                    fi
                    case $choice in
                    "打包压缩并复制")
                        cd "/home/user/project/work/$xuehao"
                        tar -zcvf "$xuehao.tar.gz" ./
                        zenity --info --title="提示" --text="压缩成功！" --width=400 --height=300
                        cp -r "$xuehao.tar.gz" /mnt/usb
                        zenity --info --title="提示" --text="文件已成功复制到USB设备！" --width=400 --height=300
                        zenity --info --title="提示" --text="工作区内容如下：\n$(ls)" --width=400 --height=300
                        ;;
                    "删除文件")
                        cd "/home/user/project/work"
                        rm -r "$xuehao"
                        zenity --info --title="提示" --text="$xuehao 删除成功！" --width=400 --height=300
                        zenity --info --title="提示" --text="工作区内容如下：\n$(ls)" --width=400 --height=300
                        sleep 2
                        ;;
                    "退出")
                        break
                        ;;
                    esac
                done
                ;;

            4)
                exit 0
                ;;

            esac
        done
    fi
done
