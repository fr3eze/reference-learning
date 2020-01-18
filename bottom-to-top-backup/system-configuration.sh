[fr3eze@ufo ~]$ lsblk -f
NAME        FSTYPE LABEL           UUID                                 FSAVAIL FSUSE% MOUNTPOINT
sda                                                                                    
├─sda1      ntfs   System Reserved D2500D91500D7E0B                                    
├─sda2      ntfs   Storage         80EE8584EE857368                                    
├─sda3      ntfs                   B6603B54603B1A97                                    
└─sda4      ntfs                   588A7D878A7D6284                                    
sdb                                                                                    
└─sdb1      ntfs   TOSHIBA EXT     7A5A21E05A219A41                                    
nvme0n1                                                                                
├─nvme0n1p1 swap                   e626e495-d5ff-4be5-bec6-d9652e7ed3ee                [SWAP]
├─nvme0n1p2 ext4                   2a50f129-f0f2-4225-81cd-d844f61fd167   13.1G    68% /home
├─nvme0n1p3 ext4                   04944925-c372-4a3c-842b-0fe218e45cc3  102.1G    33% /
└─nvme0n1p4 vfat                   1918-CB50                             498.8M     0% /boot/efi
[fr3eze@ufo ~]$ 

--------------------------------------------------------

[fr3eze@ufo ~]$ sudo fdisk -l
Disk /dev/nvme0n1: 232.91 GiB, 250059350016 bytes, 488397168 sectors
Disk model: Samsung SSD 960 EVO 250GB               
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: AA5E1763-CD55-42F2-8F54-36C9E80BDC0C

Device             Start       End   Sectors  Size Type
/dev/nvme0n1p1   1026048  33794047  32768000 15.6G Linux swap
/dev/nvme0n1p2  33794048 136194047 102400000 48.8G Linux filesystem
/dev/nvme0n1p3 136194048 488396876 352202829  168G Linux filesystem
/dev/nvme0n1p4      2048   1026047   1024000  500M Microsoft basic data

Partition table entries are not in disk order.


Disk /dev/sda: 1.84 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: ST2000DM006-2DM1
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x33338533

Device     Boot      Start        End    Sectors   Size Id Type
/dev/sda1  *          2048    1026047    1024000   500M  7 HPFS/NTFS/exFAT
/dev/sda2          1026048 2046239191 2045213144 975.2G  7 HPFS/NTFS/exFAT
/dev/sda3       2046240768 2047997951    1757184   858M 27 Hidden NTFS WinRE
/dev/sda4       2048000000 3907026943 1859026944 886.5G  7 HPFS/NTFS/exFAT


Disk /dev/sdb: 465.78 GiB, 500107862016 bytes, 976773168 sectors
Disk model: External USB 3.0
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xad20b2e4

Device     Boot Start       End   Sectors   Size Id Type
/dev/sdb1        2048 976771119 976769072 465.8G  7 HPFS/NTFS/exFAT
[fr3eze@ufo ~]$ 

--------------------------------------------------------

[fr3eze@ufo /]$ sudo df -T
Filesystem     Type      1K-blocks      Used Available Use% Mounted on
dev            devtmpfs    8156268         0   8156268   0% /dev
run            tmpfs       8196348      1524   8194824   1% /run
/dev/nvme0n1p3 ext4      172288252  59051456 104415344  37% /
tmpfs          tmpfs       8196348     98984   8097364   2% /dev/shm
tmpfs          tmpfs       8196348         0   8196348   0% /sys/fs/cgroup
tmpfs          tmpfs       8196348     45536   8150812   1% /tmp
/dev/nvme0n1p2 ext4       50133544  34266252  13290908  73% /home
/dev/nvme0n1p4 vfat         510984       280    510704   1% /boot/efi
tmpfs          tmpfs       1639268        12   1639256   1% /run/user/1000
/dev/sdb1      vfat        7865320   2601888   5263432  34% /run/media/fr3eze/540B-59F0
/dev/sdc1      fuseblk   488384532 330384516 158000016  68% /run/media/fr3eze/TOSHIBA EXT
/dev/sda2      fuseblk  1022606568 660453952 362152616  65% /run/media/fr3eze/Storage
/dev/sda4      fuseblk   929513468 595247144 334266324  65% /run/media/fr3eze/588A7D878A7D6284

--------------------------------------------------------

