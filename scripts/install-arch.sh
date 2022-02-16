#! /bin/bash

########################################
# >> Author : Ticks
# >> Email : 2938384958@qq.cim
# >> Des : Install the archlinux

function check_network()
{
	local timeout=3
	local target=www.baidu.com

	ping -c 5 -i 0.2 -W ${timeout} ${target} > /dev/null 2>&1

	if [ $? -eq 0 ]; then
		return 0
	else
		return 1
	fi
	return 1
}

function cmd_exist()
{
	local ret='0'
	command -v $1 > /dev/null 2>&1 || { local ret='1'; }

	if [ "$ret" -ne 0 ]; then
		return 1
	fi

	return 0
}

function check_uefi()
{
	dir=/sys/firmware/efi
	if [ -d $dir ]; then
		return 0
	fi
	return 1
}

function err_echo()
{
	echo -e "\033[31m $1 \033[0m"
}

####################################### start ###################################
clear
echo "###################################################"
echo ">> Welcome to use the ArchLinux Install Script."
echo ">> This script can help you install the Arch."
read -r -p ">> Are you sure to install ArchLinux?[Y/n]" ready

case $ready in
	[yY])
		;;
	[nN])
		echo ">> Bye ~"
		exit 0
		;;
	*)
		err_echo ">> Error Input !"
		echo ">> Bye ~"
		exit 0
		;;
esac

for i in `seq -w 3 -1 0`
do
	echo -n -e ">> Install will be begining . . .(${i})\r"
	sleep 1s
done
echo -n -e "\n"

echo ">> Check the boot way. . ."
check_uefi
if [ $? -eq 1 ]; then
	err_echo ">> Your computer isnot boot with uefi, please check your boot way !"
	echo ">> Bye~"
	exit 1
fi

echo ">> Check the network. . ."
check_network
if [ $? -eq 1 ]; then
	err_echo ">> Please check your network !"
	echo ">> Bye ~"
	exit 1
fi

echo ">> update the system time. . ."
timedatectl set-ntp true
hwclock --systohc --utc

echo ">> list the disks. . ."
fdisk -l

while 1
do
read -r -p ">> Please input the disk you want to use [/dev/XXX]: " useDisk
if [ -c $useDisk ];then
	break
fi
echo ">> The disk isnot exist !"
done

cfdisk /dev/$useDisk
echo ">> The Disk[${useDisk}]:"
fdisk -l $useDisk

echo ">> mount the disks. . ."

while 1
do
	read -r -p ">> Please input the disk will install on root filesystem [/] like [/dev/nvme0n1xx] : " rootDisk
	if [-c $rootDisk]; then
		break
	fi
	err_echo ">> The disk isnot exist !"
done
mkfs.ext4 $rootDisk
mount $rootDisk /mnt

while 1
do
	read -r -p ">> Please input the disk will install on boot filesystem [/boot] like [/dev/nvme0n1xx] : " bootDisk
	if [-c $bootDisk]; then
		break
	fi
	err_echo ">> The disk isnot exist !"
done
mkfs.vfat -F 32 $bootDisk
mkdir -p /mnt/boot
mount $bootDisk /mnt/boot

while 1
do
	read -r -p ">> Please input the disk will install on home filesystem [/home] like [/dev/nvme0n1xx] : " homeDisk
	if [-c $homeDisk]; then
		break
	fi
	err_echo ">> The disk isnot exist !"
done
mkfs.ext4 $homeDisk
mkdir -p /mnt/home
mount $homeDisk /mnt/home

while 1
do
	read -r -p ">> Please input the disk will install on swap filesystem like [/dev/nvme0n1xx](input n not use) : " swapDisk
	if [ $swapDisk == "n" ]; then
		break
	fi
	if [ $swapDisk == "N" ]; then
		break
	fi
	if [-c $swapDisk]; then
		break
	fi
	err_echo ">> The disk isnot exist !"
done
mkswap $swapDisk
swapon $swapDisk

echo ">> change the mirrorlist. . ."
cmd_exist reflector
if [ $? -eq 1 ]; then
	echo ">> Install the reflector. . ."
	pacman -S reflector
fi
reflector --country 'China' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

echo ">> Install the base system and software. . ."
pacstrap /mnt base base-devel linux linux-firmware vim e2fsprogs ntfs-3g wget curl git

echo ">> Genfstab. . ."
genfstab -U -p /mnt >> /mnt/etc/fstab


cat /mnt/install-arch.sh <<EOF
#! /bin/bash
echo ">> set the localtime. . ."
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo ">> set the locale.gen. . ."
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
sed -i 's/^#zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
locale-gen

echo ">> set the root password: "
passwd

read -r -p ">> Please input your computer name: " pcName

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
hostsStr="127.0.0.1    localhost\n::1    localhost\n127.0.1.1    ${pcName}.localdomain    ${pcName}"
cat $hostsStr >> /etc/hosts

echo "Install uefi boot"
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux --recheck
grub-mkconfig -o /boot/boot/grub.cfg

echo "Install the networkmanager"
pacman -S iwd dhcpcd networkmanager
systemctl enable iwd
systemctl enable dhcpcd
systemctl enable NetworkManager

exit 0
EOF
echo ">> After you chroot arch, you can use \"bash install-arch.sh\" to continue install !"
sleep 3
arch-chroot /mnt

echo ">> umount the disks. . ."
umount -R /mnt
err_echo "The Install Script is end, please ch-root to check the config before you reboot your computer !!!"
sleep 7
###################################### end #####################################
exit 0

