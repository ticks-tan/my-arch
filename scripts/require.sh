echo "install . . ."
sudo pacman -S alacritty kitty conky polybar rofi

echo "install fcitx5"
sudo pacman -S fcitx5 fcitx5-chinese-addons fcitx5-pinyin-zhwiki fcitx5-gtk fcitx5-qt
sudo echo -e "export INPUT_METHOD=\"fcitx5\"\nexport XMODIFIERS=\"@im=fcitx5\"\nexport GTK_IM_MODULE=\"fcitx5\"\nexport QT_IM_MODULE=\"fcitx5\"" > /etc/environment
