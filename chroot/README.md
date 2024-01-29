fdisk -l

su
mkdir /chroot
mount /dev/sdXX /chroot # В нашем примере sdXX - это sda2
Если после

mount /dev/sdXX /chroot # В нашем примере sdXX - это sda2
возникают ошибки и у вас файловая система BTRFS, то эта команда должна иметь дополнительный вид (указываем, какой подраздел монтировать):

mount -o subvol=@ /dev/sdXX /chroot # В нашем примере sdXX - это sda2
for i in dev sys proc; do mount --bind -v /$i /chroot/$i; done
Чтобы использовать интернет-соединение в chroot нужно скопировать resolv.conf:

cp /etc/resolv.conf /chroot/etc/resolv.conf
4. Теперь надо сделать chroot в установленную систему.

chroot /chroot
5. Вы получили полный командный root-доступ к своей системе.
