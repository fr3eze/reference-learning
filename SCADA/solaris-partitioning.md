How to Partition a Hard Drive in Solaris

# How to Partition a Hard Drive in Solaris

<sub>Source:http://www.ufsdump.org/labs/howto-partition-disk-allfreehog.html</sub>

1. The format utility is used for partitioning Solaris UFS based file systems. It is an interactive menu driven utility.

    ```
    $format
    
	0. c0t0d0 <SUN2.1G cyl 2733 alt 2 hd 19 sec 80>
	/devices/pci@1f,0/pci@1,1/ide@3/dad@0,0
	1. c0t1d0 <SUN2.1G cyl 2733 alt 2 hd 19 sec 80>
	/devices/pci@1f,0/pci@1,1/ide@3/dad@0,0
    ```

2. Be sure you select the right disk. Disk 1 is chosen here because it is not currently in use. You CAN'T partition a disk with mounted filesystems.

    ```
    Specify disk (enter its number): 1
    selecting c0t1d0

    [disk formatted]
    ```

3. You are taken into the format interactive menu. There are many options available within this menu. Many, however, are not used on a daily basis.

    ```
    FORMAT MENU:
            disk       - select a disk
            type       - select (define) a disk type
            partition  - select (define) a partition table
            current    - describe the current disk
            format     - format and analyze the disk
            repair     - repair a defective sector
            label      - write label to the disk
            analyze    - surface analysis
            defect     - defect list management
            backup     - search for backup labels
            verify     - read and display labels
            save       - save new disk/partition definitions
            inquiry    - show vendor, product and revision
            volname    - set 8-character volume name
            !<cmd>     - execute <cmd>, then return
            quit
    ```

4. The "partiton" option is responsible for partitioning a disk. Type "partition" at the format interactive prompt.

    ```
    format> partition
    ```

5. You are now taken to the partition interactive menu. Notice the change in the prompt.

    ```
    PARTITION MENU:
            0      - change `0' partition
            1      - change `1' partition
            2      - change `2' partition
            3      - change `3' partition
            4      - change `4' partition
            5      - change `5' partition
            6      - change `6' partition
            7      - change `7' partition
            select - select a predefined table
            modify - modify a predefined partition table
            name   - name the current table
            print  - display the current table
            label  - write partition map and label to the disk
            !<cmd> - execute <cmd>, then return
            quit
    ```

6. The "modify" option is used to partition an entire disk. Type "modify" at the partition prompt.

    ```
    partition> modify
    ```

7. There are two ways to partition an entire disk. The first is to calculate by hand the cylinder offsets of each partition. This can lead to overlapping filesystems which will corrupt data. The "All Free Hog" option enables partitioning of a disk by size (b, kb, mb, gb) and the utility calculates the required cylinder offsets.

    ```
    Select partitioning base:
            0. Current partition table (original)
            1. All Free Hog
    ```

8. Select the "All Free Hog" option.

    ```
    Choose base (enter number) [0]? 1
    
    9) The "All Free Hog" utility will give a printout of the current size of the disk (reported by "Part 2").  Select "yes" to confirm that this is the correct disk.
    
    Part      Tag    Flag     Cylinders         Size            Blocks
      0       root    wm       0                0         (0/0/0)            0
      1       swap    wu       0                0         (0/0/0)            0
      2     backup    wu       0 - 13324        6.00GB    (13325/0/0) 12592125
      3 unassigned    wm       0                0         (0/0/0)            0
      4 unassigned    wm       0                0         (0/0/0)            0
      5 unassigned    wm       0                0         (0/0/0)            0
      6        usr    wm       0                0         (0/0/0)            0
      7 unassigned    wm       0                0         (0/0/0)            0
    
    Do you wish to continue creating a new partition
    table based on above table[yes]? yes
    ```

10. Since free hog does the math for you based on the sizes you specify,  any left over space will be made into partition 6.

    ```
    Free Hog partition[6]? 6
    ```
    
11. Enter sizes for each partition. If you do not want to use a specific partition, then just press "enter" and the slice will be skipped.

    ```
    Enter size of partition '0' [0b, 0c, 0.00mb, 0.00gb]: 1000mb
    Enter size of partition '1' [0b, 0c, 0.00mb, 0.00gb]: 1000mb
    Enter size of partition '3' [0b, 0c, 0.00mb, 0.00gb]: 1000mb
    Enter size of partition '4' [0b, 0c, 0.00mb, 0.00gb]: 1000mb
    Enter size of partition '5' [0b, 0c, 0.00mb, 0.00gb]: 1000mb
    Enter size of partition '7' [0b, 0c, 0.00mb, 0.00gb]: 1000mb
    ```

12. Upon completion of the partitioning, the "All Free Hog" utility will print the new partitioning scheme.
Notice that you were never prompted to fenter a size for partition 6. However, a size has been
assigned. This is the "All Free Hog" utility taking all leftover space and placing it on partition 6.

    ```
    Part      Tag    Flag     Cylinders         Size            Blocks
      0       root    wm       3 -  2170     1000.37MB    (2168/0/0)   2048760
      1       swap    wu    2171 -  4338     1000.37MB    (2168/0/0)   2048760
      2     backup    wu       0 - 13324        6.00GB    (13325/0/0) 12592125
      3 unassigned    wm    4339 -  6506     1000.37MB    (2168/0/0)   2048760
      4 unassigned    wm    6507 -  8674     1000.37MB    (2168/0/0)   2048760
      5 unassigned    wm    8675 - 10842     1000.37MB    (2168/0/0)   2048760
      6        usr    wm   10843 - 11156      144.89MB    (314/0/0)     296730
      7 unassigned    wm   11157 - 13324     1000.37MB    (2168/0/0)   2048760
    ```

13. Confirm the current partitioning scheme by typing "yes".
    
    ```
    Okay to make this the current partition table[yes]?  yes
    ```
    
14. Give the partitioning table a name.

    ```
    Enter table name (remember quotes): "darren"
    ```

15. Label the disk. This step is the "point of no return". Up until this step, you can exit out of the format utility without making any changes to the disk.

    ```
    Ready to label disk, continue? y
    ```

16. Quit out of the partitioning menu.

    ```
    partition> quit
    ```

17. From within the format menu, save the partitioning table to a file for later use. Save the label to the /etc/format.dat system file.

    ```
    format> save
    Saving new disk and partition definitions
    Enter file name["./format.dat"]: /etc/format.dat
    ```

18. Exit it out of the format menu to complete the exercise

    ```
    format> quit
    ```
