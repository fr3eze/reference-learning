Reference:
https://classicforum.manjaro.org/index.php?topic=16484.0
https://wiki.archlinux.org/index.php/Migrate_installation_to_new_hardware#Installation_guide_first_half


Create a overal backup tarball
```
sudo tar czf /backup.tar.gz --exclude=/backup.tar.gz --exclude=/dev --exclude=/mnt --exclude=/proc --exclude=/sys --exclude=/tmp --exclude=/lost+found /
```
