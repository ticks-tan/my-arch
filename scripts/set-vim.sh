#! /bin/sh
######################################
# * @Author: Ticks
# * @Email : 2938384958@qq.com
# * @Des   : vim配置文件复制脚本
#####################################3

clear
echo "------------------------------------------------------------------------------"
echo ">> 此脚本主要功能:"
echo ">> 1. One Dark主题 和 Material 主题"
echo ">> 2. C/C++代码补全(使用LSP服务+clangd进行补全，其他语言也可简单配置完成安装)"
echo ">> 3. 实时代码检查，进行报错提示"
echo ">> 4. 定义跳转(普通模式下使用 \dd)"
echo ">> 5. 变量重命名(普通模式下使用 \rr)"
echo ">> 6. 函数信息显示(普通模式下使用 \hh)"
echo ">> 7. 代码格式化"
echo ">> 7. 括号自动补全"
echo ">> 8. Git代码管理"
echo ">> 9. 目录树查看(Ctrl + T)"
echo "------------------------------------------------------------------------------"
echo ">> 此脚本会备份原有~/.vimrc配置文件和~/.vim目录，备份目录为~/vim-backup"

read -r -p ">> 在开始前请确保您可以正常访问Github,是否继续?[y/n]" start_install
case $start_install in
	[nN])
		echo ">> 感谢您使用本脚本！"
		exit 0
		;;
	[yY])
		echo ">> 开始运行配置脚本. . ."
		;;
	*)
		echo ">> 感谢您使用本脚本！"
		exit 0
		;;
esac

# 检查命令是否满足
if ! command -v zip; then
	echo ">> zip 命令不存在，请确保系统可以使用zip命令！"
	exit -1
fi

if ! command -v curl; then
	echo ">> curl命令不存在，请确保系统可以使用curl命令！"
fi


if ! command -v git; then
	echo ">> git命令不存在，请确保系统可以使用git命令！"
	exit -1
fi

if ! command -v python; then
	echo ">> python命令不存在，请确保系统可以使用python命令! "
	exit -1
fi

if ! command -v pip; then
	echo ">> pip命令不存在，请确保系统可以使用git命令! "
	exit -1
fi

echo ">> 创建备份目录. . ."
mkdir -p -v ~/vim-backup

echo ">> 拷贝原有配置. . ."

zip -q -r vim-backup.zip ~/.vim ~/.vimrc && mv vim-backup.zip ~/vim-backup

echo ">> 此vim配置使用vim-plug管理插件，See Github -> https://github.com/junegunn/vim-plug"
echo ">> 安装vim-plug插件管理工具. . ."
vimPlug=~/.vim/autoload/plug.vim
if [ -f "$vimPlug" ]; then
    echo ">> 已安装vim-plug"
else
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo ">> 插件安装完成，开始下载vim配置. . ."

git clone https://gitee.com/Ticks_Gitee/my-vim.git

echo ">> 复制新的配置文件. . ."

cp -f my-vim/.vimrc ~/

echo ">> 清理临时文件夹. . ."

rm -rf my-vim

for i in `seq -w 5 -1 1`
do
	echo -en ">> 打开vim安装插件(第一次打开会提示错误，请直接输入ENTER) -- ${i}s. \r"
	sleep 1s
done

vim -c ":PlugInstall" -c ":qa"

colorFile=~/.vim/plugged/material.vim/colors/material.vim
if [ -f "$colorFile" ]; then
    mkdir -p ~/.vim/colors && cp ${colorFile} ~/.vim/colors
fi

echo ">> 安装代码补全依赖 -- neovim"
pip install neovim

echo ">> 注意：此配置文件使用的主题为material，需要终端开启256和真彩色支持"
echo ">> 通常情况下添加 export TERM=xterm-256color 环境变量可开启256色支持"
echo "安装完成，感谢您使用本脚本！"

exit 0
