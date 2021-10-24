# Unix System Administration - Log Book

M. Crabtree - B00414581

---

## Lab 1
1. *Name and explain one qualifier selected by you for each of the three commands*
	1. `ls -h` prints human readable file sizes (e.g. 1K, 2G, etc.) when used in conjunction with `-s` and `l`
	2. `locate -c` prints the number of matching files instead of the absolute path (unless used in conjunction with `--print`)
	3. `cd -` an argument of a single hyphen is converted to `$OLDPWD` returning the user to the last directory they were in. If the directory change was successful, the absolute pathname of the new working directory is written to stdout.
	4. `pwd -P` prints the symbolically linked working directory as opposed to its symbolic location. See below.

```sh
# An example of pwd -P in an active session
mc@hearth ~/.config $ ls -lah | grep alacritty
lrwxrwxrwx  1 mc mc   36 Aug 29 16:50 alacritty -> ../dotfiles/config/.config/alacritty
mc@hearth ~/.config $ cd alacritty
mc@hearth ~/.config/alacritty (master) $ pwd
/home/mc/.config/alacritty
mc@hearth ~/.config/alacritty (master) $ pwd -P
/home/mc/dotfiles/config/.config/alacritty
```

2. *Who are you (what is your user name) in this setup?*
```sh
[student@UWS ~]$ whoami		# prints the username associated with the current user's ID
student
```

3. *What type of information does `df` display?*

   `df` reports file system disk space usage; It displays the amount of free space available on a file system matching the name argument. 

4. *What are the names of the different filesystems that are displayed? What is the mount-*
   *point for the filesystem source beginning /dev/root?*

```bash
[student@UWS ~]$ df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/root              1048576    137428    911148  13% /
devtmpfs                255020       228    254792   0% /dev
tmpfs                   255180         0    255180   0% /dev/shm
tmpfs                   255180        24    255156   0% /tmp
tmpfs                   255180        48    255132   0% /run
/dev/sda1                 3963        31      3728   1% /media/disk1
```

- The names of the filesystems:

```bash
[student@UWS ~]$ df | awk '{print $1}'
Filesystem
/dev/root
devtmpfs
tmpfs
tmpfs
tmpfs
/dev/sda1
```

- `/dev/root` is mounted on the root directory.

5. *What do the Used and Available columns stand for?*

`Used` is the number of used blocks on a system, and `Available` shows the number of available blocks. Blocks can be set to units of 1024 bytes, an overridden value using `-BG`, or 512 bytes if `POSIXLY_CORRECT` is set.

6. *What is the directory name displayed by the `pwd` command?*

`/home/student/subdir`

7. *Use the man command man ls to find out what information is given by ls -l? Try*
   *to figure out which column shows file size. What is the size of the newly created file, file2?*

- `ls -l` uses a long list format giving further info about each item
- `file1` is zero bytes in size
- `file2` is 20 bytes in size

8. *Use the pwd command to find out what happened and in which directory you currently*
   *reside? What is the meaning of the double dot `..` if used in conjunction with the cd*
   *command?*

```bash
[student@UWS subdir]$ cd ..		# change pwd to the parent directory
[student@UWS ~]$ pwd
/home/student					# pwd is the parent dir
```

9. *Use the `pwd` command to find out what happened and your current directory*

```bash
[student@UWS ~]$ cd ./subdir	# from this dir, head to /subdir
[student@UWS subdir]$ pwd
/home/student/subdir			# pwd is now the subdir
```

The `.` in `cd ./subdir` represents the current directory. From this directory we moved into the sub-directory `subdir`.

10. *In which directory did the command `cd` just move you?*

```bash
[student@UWS subdir]$ pwd
/home/student/subdir			# currently in subdir
[student@UWS subdir]$ cd		# cd command with zero arguments ...
[student@UWS ~]$ pwd
/home/student					# ... changes directory to the current user's home dir
```

11. *Are there any hidden files in the root directory called `/`?*

```bash
[student@UWS ~]$ ls
Desktop  subdir
[student@UWS ~]$ ls -lah
total 24
drwxr-sr-x    4 student  student      138 Sep 14 11:25 .				# hidden
drwxr-xr-x    3 root     root          61 Sep 14 11:25 ..				# hidden
-rw-------    1 student  student      105 Sep 14 11:56 .bash_history	# hidden
-r--r-----    1 student  student     1004 Sep 14 11:25 .bashrc			# hidden
drwxr-xr-x    2 student  student       37 Sep 14 11:25 Desktop
drwxr-sr-x    2 student  student       81 Sep 14 11:55 subdir
```

Any directory name beginning with `.` represents a hidden directory. The listings for `.` and `..` represent the current and parent directories respectively, and are ommitted by default when running `ls` with no arguments.

12. *How many filesystems are there in total listed in the root directory called `/`?*

The wording of this question is a little ambiguous. 

```bash
[student@UWS ~]$ df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/root              1048576    137428    911148  13% /
devtmpfs                255020       228    254792   0% /dev
tmpfs                   255180         0    255180   0% /dev/shm
tmpfs                   255180        24    255156   0% /tmp
tmpfs                   255180        48    255132   0% /run
/dev/sda1                 3963        31      3728   1% /media/disk1
[student@UWS ~]$ df /
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/root              1048576    137428    911148  13% /
```

1. If the question is how many filesystems are mounted on the root dorectory, i.e. `/` then the answer is one: `/dev/root`
2. If, on the other hand, the question is how many filesystems are _contained within_ `/` then the answer is four including `/dev/root`, given that `/dev`, `/tmp`, and `/run` are mount points for filesystems contained within immediate subdirectories within `/`

## Lab 2

1. *Identify and note the line in /etc/mtab that contains the mount-information
associated with the disk device.*

```bash
[root@UWS ~]# cat /etc/mtab | grep floppy
/dev/loop0 /media/floppy ext2 rw,relatime,errors=continue 0 0
```

2. *Note down the outputs of the commands `ls –l /dev/loop0` and `ls –l
/media/floppy`. Compare the outputs and comment on what is actually achieved by the mount command that you have just performed.*

```bash
[root@UWS ~]# ls -l /dev/loop0
brw-------    1 root     root        7,   0 Sep 20 18:53 /dev/loop0
[root@UWS ~]# ls -l /media/floppy/
total 13
-rw-r--r--    1 root     root            61 Sep 13  2020 file.txt
drwx------    2 root     root         12288 Sep 13  2020 lost+found
```

The floppy disk image has been attached to `/dev/loop0` which, in turn, is mounted onto `/media/floppy`. The use of a loop device allows for loop mounting of images onto the overall filesystem as though they were physical devices. 

The difference between the outputs stems from the fact that the disk image is mounted *via* the loop device onto `/media/floppy`, the logical point at which the contents of the image are mounted onto the overall filesystem.

3. *After mounting the virtual floppy, has /etc/fstab changed as well, or are all
entries still the same?*

No changes. `fstab` defines filesystems to be mounted at boot, and *how* they're integrated as part of the overall filesystem.

4. *Why is it important not to have target media mounted while you try to create a file system?*

If mounted, the kernel may try to perform read or write operations on the target media. Unmounting the media ensures there is no risk of the operating system accessing the device and interfering with the creation of a new filesystem.

5. *How many inodes and blocks are created on the system?*

Assuming "the system" refers to the overal filesystem:

```bash
[root@UWS ~]# df / -P
Filesystem           1024-blocks    Used Available Capacity Mounted on
/dev/root              1048576    138868    909708  13% /
[root@UWS ~]# find / -type f -print | wc -l
16203
```
- 1,048,576 blocks (~1.0G using `df / -h`)
- The number of inodes is contingent on the size of the filesystem, with a default configuration of one inode per 2048 bytes. Assuming this to be the case there are 524,288 inodes in `/dev/root`.

6. *How many blocks are reserved for the super user (root)?*

5% of the total capacity is reserved by the root user to prevent the system from failing if or when it runs out of available space. In this instance, 5% of 1,048,576 blocks is ~52,429 blocks.

7. *Manually run the program fsck on the virtual floppy. What is displayed by fsck?*

Given that the filesystem is mounted at present: 

```bash
[root@UWS ~]# fsck /dev/loop0
fsck from util-linux 2.32.1
e2fsck 1.44.2 (14-May-2018)
/dev/loop0 is mounted.
e2fsck: Cannot continue, aborting.
```

Unmounting the filesystem results in the following output: 

```bash
[root@UWS ~]# umount /dev/loop0
[root@UWS ~]# fsck /dev/loop0
fsck from util-linux 2.32.1
e2fsck 1.44.2 (14-May-2018)
/dev/loop0: clean, 12/184 files, 48/1440 blocks
```

8. *Note any files and directories that are on the floppy at this time.*

```bash
[root@UWS floppy]# ls -la /media/floppy
total 19
drwxr-xr-x    3 root     root          1024 Sep 21 10:37 .
drwxr-xr-x    3 root     root            60 Sep  9  2020 ..
-rw-r--r--    1 root     root            61 Sep 13  2020 file.txt
drwx------    2 root     root         12288 Sep 13  2020 lost+found
-rw-r--r--    1 root     root            11 Sep 21 10:37 tst.dat
```

9. *Can you think of any apocalyptic scenario that might produce an entry in the
lost+found directory?*

An improper shutdown might result in orphaned inodes, or if a block device experiences some kind of hardware failure.

10. *Why would the kernel not allow you to dismount a filesystem that you are currently using?*

Pending IO operations should complete before a filesystem is unmounted. Linux, for example, buffers writing to disk in RAM until such a time as the kernel deems appropriate.

11. *Use the command cd /root, before issuing the command line umount /media/floppy again. Does the un-mounting operation work now?*

Yes.

```bash
[root@UWS ~]# cd /root
[root@UWS ~]# pwd
/root
[root@UWS ~]# umount /media/floppy
[root@UWS ~]# mount
/dev/root on / type 9p (rw,sync,dirsync,relatime,trans=virtio)
devtmpfs on /dev type devtmpfs (rw,relatime,size=255020k,nr_inodes=63755,mode=75
5)
proc on /proc type proc (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,gid=5,mode=620,ptmxmode=666)
tmpfs on /dev/shm type tmpfs (rw,relatime,mode=777)
tmpfs on /tmp type tmpfs (rw,relatime)
tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755)
sysfs on /sys type sysfs (rw,relatime)
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
```

12. *Why can you still set on the floppy, even though you have just ejected the floppy disk?*

The mount point we used to access the image in the overall filesystem is a directory we created. Devices, virtual or otherwise, are usually mounted onto empty directories by convention.

13. *Explain why you no longer see the previous files lost+found and tst.dat on the mount-point?*

Because we've unmounted the image and its contained filesystem from the overall filesystem.

14. *Explain the difference between the two command lines given. What does the  re-direction operator > do?*

```bash
[root@UWS ~]# echo '1234567890' test.dat
1234567890 test.dat
[root@UWS ~]# echo '1234567890' > test.dat
```

- The first command is doing little more than supplying standard input to the `echo` programme, and `echo` is doing what it does: redrecting standard input to standard output.
- The second command uses the `>` redirection character which redirects the standard input on the left to a designated file on the right. The file is created if it doesn't already exists, and if it does, the content of the file is overwritten.

15. *(After performing the `mv` command) What happened to the original `test.dat` file?*

```bash
[root@UWS ~]# mv test.dat test_01.dat
[root@UWS ~]# ls -l
total 1448
drwxr-xr-x    2 root     root            37 Sep 21 13:01 Desktop
-rw-r--r--    1 root     root            11 Sep 21 13:13 test_01.dat
-rw-------    1 student  root       1474560 Sep 21 13:07 virtual_floppy.img
```

When using `mv` without specifying an alternate directory `mv` acts as though the file has been renamed. The inode of the file has not changed, instead the name of the directory entry associated with that inode has been modified.

16. *Examine the file test_01.dat with the cat command. What does the operator `>>` do?*

```bash
[root@UWS ~]# echo 'abcdefghi' >> test_01.dat
[root@UWS ~]# cat test_01.dat
1234567890
abcdefghi
```

The `>>` operator has appended the standard output of `echo` to the designated file.

17. *Based on the commands shown above: Explain the effect of the `–i` qualifier in the `cp` command.*

```[root@UWS ~]# cp test_01.dat test_a.dat
[root@UWS ~]# cp -i test_01.dat test_b.dat
[root@UWS ~]# cp -i test_01.dat test_b.dat
cp: overwrite 'test_b.dat'?
```

`cp`'s `-i` flag prompts the user if they wish to go ahead with the change if an overwrite will occur. The `-i` stands for 'interactive'.

18. *(After performing `cmp test_a.dat test_b/dat`) What is the output of the above command line, or is there no output at all?*

There is no output, indicating that there are no differences between the two files specified.

19. *What is the output of the above cmp command now and why?*

```bash
[root@UWS ~]# echo 'ei caramba' >> test_a.dat
[root@UWS ~]# cmp test_a.dat test_b.dat
cmp: EOF on test_b.dat
```

`cmp` reached the end of `test_b.dat` before reaching the end of file on `test_a.dat`. 

```bash
student@UWS ~]$ od -c test_b.dat
0000000   1   2   3   4   5   6   7   8   9   0  \n   a   b   c   d   e
0000020   f   g   h   i  \n
0000025
[student@UWS ~]$ od -c test_a.dat
0000000   1   2   3   4   5   6   7   8   9   0  \n   a   b   c   d   e
0000020   f   g   h   i  \n   e   i       c   a   r   a   m   b   a  \n
0000040
```

20. *What is the output of the above command? Do you know another Unix command that does roughly the same?*

```bash
[student@UWS ~]$ cat test_a.dat
1234567890
abcdefghi
ei caramba
```

In cases like these with only a single argument `cat` will send the contents of a given file to standard out.put `less` will page through a file's content, `more` will print a file's content to standard output with a single argument, and `echo` can also be used in novel ways to print to standard output.

```bash
[student@UWS ~]$ less test_a.dat ; more test_a.dat ; echo "$(less test_a.dat)"
1234567890
abcdefghi
ei caramba
1234567890
abcdefghi
ei caramba
1234567890
abcdefghi
ei caramba
```

21. *What will cat do with the 3 files? Can you achieve the same result with the more command?*

```bash
[student@UWS ~]$ cat test_a.dat test_b.dat test_c.dat > test_abc.dat
[student@UWS ~]$ cat test_a.dat test_b.dat test_c.dat
1234567890
abcdefghi
ei caramba
1234567890
abcdefghi
Doh!
```

`cat` will concatenate the content of any given files and print their combined content to standard out. When the `>` operator is used along with a designated file name, the standard output of cat will be redirected to become the content of the file.

`more` will print to standard output the content of any files it's given, and on certain systems, will page through the results, and will allow the user to search using `/` while paging.

```bash
[student@UWS ~]$ more test_a.dat test_b.dat test_c.dat > more_test
[student@UWS ~]$ cat more_test
1234567890
abcdefghi
ei caramba
1234567890
abcdefghi
Doh!
```

22. *What does the `./` represent in the above command line and is it redundant here?*

`./` represents the current directory. The same result could have been achieved with the following command:

```bash
[student@UWS ~]$ cp test_abc.dat temp10/
```

23. *Try `cp test_abc.dat ./temp10/*` . What will be the result and does it differ from the previous `cp` command-line `cp test_abc.dat ./temp10/.` ?*

```bash
[student@UWS ~]$ cp test_abc.dat ./temp10/. && cat temp10/test_abc.dat
1234567890
abcdefghi
ei caramba
1234567890
abcdefghi
Doh!
```

We can see here that the file `test_abc.dat` has been copied to `temp10/` and the file name has been preserved.

```bash
[student@UWS ~]$ cp test_a.dat ./temp10/* && ls -lah temp10/
total 12
drwxr-sr-x    2 student  student       66 Sep 21 19:23 .
drwxr-sr-x    4 student  student      246 Sep 21 18:46 ..
-rw-r--r--    1 student  student       32 Sep 21 19:53 test_abc.dat
[student@UWS ~]$ cat temp10/test_abc.dat
1234567890
abcdefghi
ei caramba
```

This second command, particularly `cat`, demonstrates that `test_a.dat` has been copied to `temp10/`  though the original content has been overwritten by that of `test_a.dat` while the original name has been preserved. 

```bash
[student@UWS ~]$ cp test_a.dat ./temp10/. && ls -lah temp10/
total 16
drwxr-sr-x    2 student  student       93 Sep 21 19:23 .
drwxr-sr-x    4 student  student      246 Sep 21 18:46 ..
-rw-r--r--    1 student  student       32 Sep 21 19:57 test_a.dat
-rw-r--r--    1 student  student       32 Sep 21 19:53 test_abc.dat
```

Performing this third command shows that using the `/.` notation in `cp`'s destination argument preserves the source filename in the destination directory as opposed to the behaviour of the wildcard: overwriting the content of the first file it encounters, or creating a new file if none exists. Using `cp -i` will prevent any files from being overwritten.

24. *Has the `-i` qualifier for `rm` the same meaning as for the `cp` command?*

`rm -i` will prompt before each removal. `cp -i` will also prompt before overwriting a file.

25. *What does the asterisk sign ‘*’ represent in the above expression?*

`*` represents a wildcard, which can represent anything in a given expression. In the following example we can use the wildcard as part of an argument for the `find` command to locate each of our `.dat` files:

```bash
[student@UWS ~]$ ls
Desktop       temp10        test_01.dat   test_a.dat    test_abc.dat  test_b.dat    test_c.dat
[student@UWS ~]$ find . -name '*.dat'
./test_01.dat
./test_a.dat
./test_b.dat
./test_c.dat
./test_abc.dat
```

26. *Write down the permissions (in words) of `/etc/fstab` and `/etc/shadow` in your logbook, and explain why the latter is so highly restricted.*

```bash
[student@UWS ~]$ ls -la /etc/fstab
-rw-r--r--    1 root     root           334 Sep  9  2020 /etc/fstab
```

|    user     | group | world |
| :---------: | :---: | :---: |
| read, write | read  | read  |

```bash
[student@UWS ~]$ ls -la /etc/shadow
-rw-------    1 root     root           360 Sep 22 09:09 /etc/shadow
```

|    user     | group | world |
| :---------: | :---: | :---: |
| read, write |  n/a  |  n/a  |

`shadow` contains encrypted passwords for all users who are defined in the `passwd` file and is readable by none other than `root`, which is why I had to perform `su -` in the following code block before I could `cat` the content of `shadow`.

```bash
[student@UWS ~]$ cat /etc/shadow
cat: cant open '/etc/shadow': Permission denied
[student@UWS ~]$ su -
[root@UWS ~]# cat /etc/shadow
root:$5$nAjmGoNs$dTVSaUVPM3v/AzxeE7tt ... 99999:7::::::
-- snip --
student:$1$9JBdC6to$lVduSFgip ... 99999:7:::
```

27. *To which category, do you think the root-user belongs (user, group, world, or none of these)?*

Taking a look at the persmissions for a file such as `/etc/shadow`, and given that `root` was able to read its contents in the above example, we can surmise that `root` is a user and their persmissions are defined in the first three permissions columns (in this instance, read and write).

```bash
[student@UWS ~]$ ls -la /etc/shadow
-rw-------    1 root     root           360 Sep 22 09:09 /etc/shadow
```

28. *Check the entries in /etc/group to find out which users in your system belong to the group ‘audio’.*

```bash
[student@UWS ~]$ grep audio /etc/group
audio:x:29:
```

`audio` has no members. We can surmise this by inspecting the properties of an alternate group:
```bash
[student@UWS ~]$ grep wheel /etc/group
wheel:x:10:root,student
```

29. *Use the ls –l command to find out the default user, group and world permissions for this newly created file.*

```bash
[root@UWS ~]# echo 'Donuts' > test_a.dat
[root@UWS ~]# ls -l test_a.dat
-rw-r--r--    1 root     root             7 Sep 22 10:18 test_a.dat
```

|    user     | group | world |
| :---------: | :---: | :---: |
| read, write | read  | read  |

30. *How did the permission, user- and group-ownership change? Describe in your own words what user, group and world are allowed to do with the file. What is achieved by the commands chgrp and chown?*

```bash
[root@UWS ~]# ls -l test_a.dat
-rw-r--r--    1 root     root             7 Sep 22 10:18 test_a.dat
[root@UWS ~]# chmod 777 test_a.dat
[root@UWS ~]# chown student test_a.dat
[root@UWS ~]# chgrp www-data test_a.dat
[root@UWS ~]# ls -l test_a.dat
-rwxrwxrwx    1 student  www-data         7 Sep 22 10:18 test_a.dat
```

- `chmod 777` applied read, write, and execute privileges to the user, the the group, and world.
- The file's user has full read, write, and execute permissions. The same is true for any member of the file's designated group, as well as all other users.
- `chgrp` modified the file's designated group ownership, from `root` to `www-data`.
- `chown` modified the file's designated owner from `root` to `student`.

31. *Is a permission of 7 (in octal notation) a good idea to enable for world-access?*

No. Any user with filesystem access can execute a file with `world` permissions set to 7.

32. *Change the permissions in a way that the user can read and write, but the group and world can only read the file. Note the necessary command in your lab-book.*

```bash
[root@UWS ~]# chmod 644 test_a.dat && ls -l test_a.dat
-rw-r--r--    1 student  www-data         7 Sep 22 10:18 test_a.dat
```

33. *What is the most permissive access that you can grant in octal representation?*

`777`

34. *What is the default permission given to the new directory /root/temp11?*

```bash
[root@UWS ~]# ls -la | grep temp11
drwxr-xr-x    2 root     root            37 Sep 22 10:29 temp11
```

|         user         |     group     |     world     |
| :------------------: | :-----------: | :-----------: |
| read, write, execute | read, execute | read, execute |


35. * Which directory permission will allow you to create a files inside of it ? (eg: executing touch and echo commands)*

We can find out by cycling through the permissions, making a directory, assigning ownership to `root`, and setting full, read, read permissions:
```bash
[student@UWS Desktop]$ mkdir testdir
[student@UWS Desktop]$ sudo chown root testdir/
[student@UWS Desktop]$ sudo chmod 744 testdir/
[student@UWS Desktop]$ ls -l
total 4
drwxr--r--    2 root     student         37 Sep 22 10:50 testdir
[student@UWS Desktop]$ touch testdir/file1
touch: testdir/file1: Permission denied
[student@UWS Desktop]$ tree
.
-- testdir
 
1 directory, 0 files
[student@UWS Desktop]$ sudo touch testdir/file1
[student@UWS Desktop]$ sudo tree
.
-- testdir
    -- file1
 
1 directory, 1 file
[student@UWS Desktop]$ tree
.
-- testdir
 
1 directory, 0 files
```

At this point we can see that with `root` as the owner of the directory, `student` cannot view the contents of `testdir`, nor can it create files within the directory.

Adding `group` write permissions to `testdir` maintains `student`'s inability to view or create files in the directory:
```bash
[student@UWS Desktop]$ sudo chmod 764 testdir/
[student@UWS Desktop]$ ls -l
total 4
drwxrw-r--    2 root     student         59 Sep 22 10:50 testdir
[student@UWS Desktop]$ tree
.
-- testdir
 
1 directory, 0 files
[student@UWS Desktop]$ touch testdir/studentfile
touch: testdir/studentfile: Permission denied
```


Finally, adding execute permissions to the `group`, `student` is able to finally view and create files in the directory:
```bash
[student@UWS Desktop]$ sudo chmod 774 testdir/
[student@UWS Desktop]$ touch testdir/studentfile
[student@UWS Desktop]$ tree
.
-- testdir
    |-- file1
    |-- studentfile
 
1 directory, 2 files
```

36. *Which directory permission is necessary to run a binary executable located inside of it?*

Execute.

37. *Which directory permission is necessary to run a shell-script located insede of it ? (a shell script is an ASCII code!)*

It depends. `source myscript.sh` requires read permissions. In the instance of executing using `./myscript.sh` the kernel will abort execution after parsing a shebang `#!` if the user does not have execute permissions on that script.

38. *Interpret the machine response to this command based on your knowledge about the permissions of the directory. Does the setting of 733 allow `ls` to be performed?*

The permissions granted to the directory means that user `student` cannot read the contents of `temp11`.

```bash
[student@UWS root]$ pwd
/root
[student@UWS root]$ ls -la | grep temp11
drwx-wx-wx    2 root     root            91 Sep 22 10:29 temp11
[student@UWS root]$ cd temp11/
[student@UWS temp11]$ ls -la
ls: cant open '.': Permission denied
total 0
[student@UWS temp11]$ sudo ls -la
total 16
drwx-wx-wx    2 root     root            91 Sep 22 10:29 .
-- snip --
```

39. *Write down the kernel response for each of the 3 ‘more’-command lines given below.*

```bash
[root@UWS ~]# more /root/temp11/test_a.dat
Donuts
[root@UWS ~]# more /root/temp11/test_b.dat
Donuts
[root@UWS ~]# more /root/temp11/test_c.dat
more: /root/temp11/test_c.dat: No such file or directory
```

40. *Write down the response of the kernel to each of the 3 ‘cp’-command given above.*

```bash
[root@UWS ~]# cp /root/temp11/test_a.dat /home/student
[root@UWS ~]# cp /root/temp11/test_b.dat /home/student
[root@UWS ~]# cp /root/temp11/test_c.dat /home/student
cp: can't stat '/root/temp11/test_c.dat': No such file or directory
```

41. *Explain why you can copy a file, although you can’t see it with the ls command.*

```bash
[student@UWS ~]$ ls -lah /root/ | grep temp11
drwx-wx-wx    2 root     root          91 Sep 22 10:29 temp11
```

Student has execute permissions which allow for the use of any file inside a directory but the user must specifiy an exact file name.

42. *Can you create a file that can be copied by group and world users, residing in a directory with a permission setting of 700?*

Given the permissions of the directory, no.

```bash
[root@UWS ~]# touch temp11/q42.file
[root@UWS ~]# chmod 700 temp11/
[root@UWS ~]# ls -lah /root/temp11 | grep q42.file
-rwxrwxrwx    1 root     root           0 Sep 22 13:05 q42.file
[root@UWS ~]# exit
logout
[student@UWS ~]$ cp /root/temp11/q42.file /home/student
cp: cant stat '/root/temp11/q42.file': Permission denied
[student@UWS ~]$ sudo chmod 777 /root/temp11/q42.file
[student@UWS ~]$ cp /root/temp11/q42.file /home/student
cp: cant stat '/root/temp11/q42.file': Permission denied
```

43. *Anonymous ftp-servers only allow users to copy files when they know the file’s name. Based on your observations above, which permission would you grant to an anonymous ftp server directory called `download_here` and a file that you create for public download called `download_me`? Which permission would you grant to a file within this directory that should not be downloaded by group or world, called `no_download`? Comment on the advantages of running an anonymous server.*

- `download_here`: 711 allowing full permissions for the owner, execute only for group and world.
- `download_me`: 751 allowing full access for the owner, read and execute for the group, and execute only for world.
- `no_download`: 700 allowing full permissions for the owner and no permissions for group or world.
- Anonymous servers allow for the sharing of files without having to create a user acocunt every time someone new wants to downlload a file. Permissions can be carefully configured to ensure only certain actions can be performed.

44. *Based on your fresh experience: Which of the following permission settings in octal representation are potentially dangerous when assigned to a directory: 700, 033, 633, 644, 755? Comment on each one individually.*

- `700` creates a directory which is essenaitlly non-existent for anyone except the owner.
- `033` defines a directory with zero permissions for the owner, and write and execute permissions for groups and the public. This allows for the creation, renaming, deletion of files, potentially disastrous, but without read permissions someone would need to know the names of the files they wanted to interact with ahead of time. Unwise for the owner to have zero permissions.
- `633` allows the owner to read and write but not execute. The same security concerns exist as outlined for `033`.
- `644` allows read and write permissions for the owner, and read permissions for all others. Groups and world would not be able to read the contents of the directory. 
- `755` allows full permissions for the owner, and read and execute permissions for group and world. Group and world would be able to read the contents of a directory and execute its content. 

## Lab 3

1. Name the different directories under the `/` directory

```sh
[root@UWS /]# ls -lah | grep '^d'
drwxrwxrwx   22 root     root         501 Sep 28 18:11 .
drwxrwxrwx   22 root     root         501 Sep 28 18:11 ..
drwxr-xr-x    2 root     root        2.3K Nov 29  2020 bin
drwxrwxr-x    3 root     root          82 Dec 10  2020 boot
drwxr-xr-x    4 root     root        2.4K Sep 28 18:11 dev
drwxr-xr-x   17 root     root        1.3K Dec 10  2020 etc
drwxr-xr-x    3 root     root          61 Sep 28 18:11 home
drwxr-xr-x    6 root     root        1.6K Nov 29  2020 lib
drwxr-xr-x    2 root     root          57 Nov 29  2020 libexec
drwxr-xr-x    4 root     root          82 Sep  9  2020 media
drwxr-xr-x    2 root     root          37 Sep  9  2020 mnt
drwxr-xr-x    2 root     root          37 Sep  9  2020 opt
dr-xr-xr-x   60 root     root           0 Sep 28 18:11 proc
drwx------    3 root     root          85 Sep  9  2020 root
drwxr-xr-x    5 root     root         380 Sep 28 18:11 run
drwxr-xr-x    2 root     root        2.6K Dec 10  2020 sbin
dr-xr-xr-x   12 root     root           0 Sep 28 18:11 sys
drwxrwxrwt    5 root     root         160 Sep 28 18:11 tmp
drwxr-xr-x   10 root     root         253 Dec 10  2020 usr
drwxrwxr-x    3 root     root         289 Dec 10  2020 uwslabs
drwxr-xr-x    5 root     root         221 Nov 29  2020 var
```

| Dir. Name | Contents                                                     |
| --------- | ------------------------------------------------------------ |
| `/bin`    | Contains critical programmes required by the system in order to function |
| `/boot`   | Location for the bootable kernel and bootloader configuration |
| `/dev`    | Access points for devices present in the system              |
| `/etc`    | Configuration files                                          |
| `/home`   | With the exception of root, the location of each user's home directory |
| `/lib`    | Shared libraries for applications                            |
| `/media`  | A default location for mounting devices                      |
| `/mnt`    | An additional mount point for devices                        |
| `/opt`    | A location where applications can be installed               |
| `/proc`   | Information about resources available to the system          |
| `/root`   | The root user's home directory                               |
| `/sbin`   | Applications generally only available to the root user, daemon processes |
| `/sys`    | Contains a `sysfs` filesystem, information about system hardware |
| `/tmp`    | A location for temporary files generated, used, by applications |
| `/usr`    | Contains executables, libraries, other system resources      |
| `/var`    | Contains files which are subject to change often, sysem logs, spools, etc. |

2. *(After attempting to change to a parent directory from `/`) Explain why there is no difference.*

`/` has no parent folder, it is the top level of the file system.

3. *Are there any hidden files in the root directory? If yes: What are their names?*

Yes. `.fscmd`.

4. *Explain the meaning of the `.` (‘dot’) and the `..` (‘double dot’) in the command lines `cd .` and `cd ..`*

- `.` represents the current working directory
- `..` represents the parent directory
- `cd .` change directory to the present working directory
- `cd ..` change directory to the parent of the present working directory

5. *Are there any subdirectories in `/bin`?*

```sh
[root@UWS bin]# ls -d */
ls: */: No such file or directory
```

If `.` and `..` are considered directories then there are two, otherwise no.

6. *How many commands are in `/bin`? Write down and explain two commands that you already know.*

```sh
[root@UWS bin]# ls -ALd * | wc -w
103
```

List all files in the present directory, except `.` and `..`, list the referenced file for any symbolic link, and list the directory's entries instead of its contents, omitting the total. Pipe the result through to `wc` and print the number of words to standard out.

7. *Which of the four directories `/bin`, `/usr/bin `, `/usr/sbin `, `/opt` contains the most commands?*

```sh
[root@UWS /]# find /bin/ -type f -executable | wc -l
97
[root@UWS /]# find /usr/bin/ -type f -executable | wc -l
254
[root@UWS /]# find /usr/sbin/ -type f -executable | wc -l
46
[root@UWS /]# find /opt -type f -executable | wc -l
0
```

8. *Which of the four directories contains a large set of gnome-desktop related applications?*

```sh
[student@UWS usr]$ sudo find / -name '*gnome*' 2> /dev/null
Password:
/usr/share/bash-completion/completions/gnome-mplayer
```

It appears that the only gnome-related *file* appears in `/usr/share/bash-completion/completions`, and there appear to be zero executable *applications* on the filesystem.

```sh
[student@UWS usr]$ find / -name -executable '*gnome*' 2> /dev/null
[student@UWS usr]$
```

9. *Can you locate the `chroot` binary within `/usr/sbin`? Where does it point to?*

The question seems to imply that `chroot` should symbolically linked to an alternate location, however this appears to not be the case. The `chroot` binary is located in `/`

```sh
[student@UWS usr]$ sudo find / -executable -name 'chroot' 2> /dev/null | xargs file
/usr/sbin/chroot: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-
linux.so.2, for GNU/Linux 4.12.0, stripped
[student@UWS usr]$ sudo find / -executable -name 'chroot' 2> /dev/null | xargs file
"/usr/sbin/chroot: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-
linux.so.2, for GNU/Linux 4.12.0, stripped"
```

10. *What is the smallest size allocated to a directory file in `/usr`?*

A directory called `i586-buildroot-linux-gnu`.

```sh
[student@UWS usr]$ ls -lahSr /usr/ | grep '^d'
drwxr-xr-x    3 root     root          57 Nov 11  2020 i586-buildroot-linux-gnu
drwxrwxr-x    6 root     root         123 Dec 10  2020 local
-- snip --
drwxr-xr-x   11 root     root        4.2K Dec 10  2020 lib
drwxr-xr-x    2 root     root        6.8K Dec 10  2020 bin
```

11. *Why might `/usr/lib` be so large?*

```sh
[student@UWS usr]$ du -sh /usr/lib
68.0M   /usr/lib
```

Given that it contains shared libraries to be used by (potentially) all applications, it stands to reason that a significant amount of common utility will be located in `/usr/lib`, hence the overly large file size relative to other directories.

By comparison, on my own computer the same folder comes in at `6.0GB`.

12. *Which is the biggest standard directory in our system?*

```sh
[student@UWS /]$ sudo du -hc -d 1 2> /dev/null | sort -gr | grep M
136.0M  total
136.0M  .
111.4M  ./usr
5.8M    ./lib
5.0M    ./boot
4.6M    ./var
3.3M    ./sbin
2.5M    ./uwslabs
2.4M    ./bin
```

`/usr` appears to be the largest standard directory.

13. *What is the total size of our current system?*

The total size of the current system is 136 Megabytes.

14. *Try the command `cat /etc/passwd > /dev/stdout`. (The `cat` command displays (concatenates) the contents of a file to an output device such as the screen…) Explain why you see the contents of the file displayed*

```sh
[student@UWS /]$ cat /etc/passwd > /dev/stdout
root:x:0:0:root:/root:/bin/sh
daemon:x:1:1:daemon:/usr/sbin:/bin/false
-- snip --
nobody:x:65534:65534:nobody:/home:/bin/false
student:x:1000:1000:Linux User,,,:/home/student:/bin/bash
```

The content of the file is redirected from standard output, the default behaviour for `cat` and redirected to `stdout`, which then outputs an input stream to standard output. See below for a further example.

```sh
[student@UWS /]$ echo "hello world" > /dev/stdout
hello world
```

15. *If stderr is the standard channel for displaying error messages. Where is stderr directed to?*

Since the terminal functions in terms of text streams, and `stderr` outputs to standard output, `stderr` directs output to standard output as default behaviour.

16. *What is the meaning of the -l qualifier in the grep command?*

`grep -l` will only output matching filenames.

17. *Which files reference the IP-address?*

Assuming the solution uses the lopback address:
```sh
[student@UWS ~]$ sudo find /etc -type f -exec grep -l '127.0.0.1' {} \;
/etc/security/access.conf
/etc/hosts
```

Assuming otherwise:
```sh
[student@UWS ~]$ netstat -ie
Kernel Interface table
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.5.226.169  netmask 255.255.0.0  broadcast 10.5.255.255
        ether 02:8e:83:9a:5a:ff  txqueuelen 1000  (Ethernet)
        RX packets 3091  bytes 222020 (216.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 1535 (1.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
 
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2  bytes 140 (140.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2  bytes 140 (140.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
[student@UWS ~]$ sudo find /etc -type f -exec grep -l '10.5.226.169' {} \;		# zero results
[student@UWS ~]$ 
```

18. *How would you make absolutely sure, you are examining the whole filesystem for e.g. the occurrence of a pattern like `127.0.0.1`?*

I'd alter the command to search from `/` rather than `/etc`:
```sh
[student@UWS ~]$ sudo find / -mindepth 0 > find_from_root
[student@UWS ~]$ sudo find /etc -mindepth 0 > find_from_etc
[student@UWS ~]$ wc -l find_from_root
20935 find_from_root
[student@UWS ~]$ wc -l find_from_etc
108 find_from_etc
```

19. *Locate the Linux commands `fsck` and `find` in the filesystem*

```sh
[student@UWS ~]$ find / -name 'find' -or -name 'fsck' 2> /dev/null
/sbin/fsck
/usr/bin/find
/usr/share/bash-completion/completions/find
/usr/share/bash-completion/completions/fsck
[student@UWS ~]$ whereis find
find: /usr/bin/find /usr/share/man/man1/find.1.gz
[student@UWS ~]$ whereis fsck
fsck: /sbin/fsck.ext4 /sbin/fsck /sbin/fsck.ext2 /sbin/fsck.ext3 /usr/share/man/man8/fsck.8.gz
```

- `/sbin/fsck`
- `/usr/bin/find`

20. *Locate the standar C library represented by the file `libc.so.6`*

```sh
[student@UWS ~]$ find / -name 'libc.so.6' 2> /dev/null
/lib/libc.so.6
```

21. *Locate and run the application `dmesg` using only the find command. Write down the full (find) command line that you used in your log-book.*

```sh
[student@UWS ~]$ find / -name 'dmesg' -executable 2> /dev/null -exec {} \;
[    0.000000] Linux version 4.12.0 (hecmargi@maximo) (gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04) ) #2 Mon Nov 30 12:20:22 CET 2020
[    0.000000] CPU: vendor_id 'AuthenticX86' unknown, using generic init.
               CPU: Your system may be unstable.
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
-- snip --
[    5.947823] clocksource: Switched to clocksource pit
[    8.657060] random: crng init done
```

22. *What is the full size of the `/home` directory?*

```sh
[student@UWS ~]$ du -hc /home
4.0K    /home/student/Desktop
680.0K  /home/student
684.0K  /home
684.0K  total
```

684K 

23. *Determine the number of shared libraries in `/lib`. Shared libraries end in `.so.*` (Where `*` represents a wildcard).*

```sh
[student@UWS ~]$ find /lib -name "*.so*" | wc -l
88
```

24. *Find out whether `libreoffice` has an entry in `/var`.*

It does not.

```sh
[student@UWS ~]$ sudo find /var | grep libreoffice
[student@UWS ~]$ 
```

25. *Deduce the role of `/var/log/messages` by reviewing its contents.*

```sh
[student@UWS ~]$ less /var/log/messages
-- snip --
Oct  2 11:58:09 UWS user.info kernel: console [hvc0] enabled
Oct  2 11:58:09 UWS user.info kernel: loop: module loaded
Oct  2 11:58:09 UWS user.info kernel: i8042: No controller found
Oct  2 11:58:09 UWS user.info kernel: NET: Registered protocol family 17
Oct  2 11:58:09 UWS user.info kernel: 9pnet: Installing 9P2000 support
Oct  2 11:58:09 UWS user.info kernel: registered taskstats version 1
Oct  2 11:58:09 UWS user.info kernel: VFS: Mounted root (9p filesystem) readonly on device 0:14.
Oct  2 11:58:09 UWS user.info kernel: devtmpfs: mounted
Oct  2 11:58:09 UWS user.info kernel: Freeing unused kernel memory: 320K
Oct  2 11:58:09 UWS user.info kernel: Write protecting the kernel text: 3780k
Oct  2 11:58:09 UWS user.info kernel: Write protecting the kernel read-only data: 900k
-- snip --
```

It appears that the file is a place for kernel messages, information about the system, information about boot processes, critical information, etc.

26. *What information is given about the unsuccessful login attempt? Could you identify the hacking culprit at once?*

From `man ps | grep ruser`:

> ruser ... real user ID.  This will be the textual user ID, if it can be obtained and the field width permits, or a decimal representation otherwise.

```sh
[student@UWS ~]$ tail /var/log/messages
-- snip --
Oct  2 13:35:36 UWS authpriv.notice su: pam_unix(su-l:auth): authentication failure; logname=student uid=1000 euid=0 tty=console ruser=student rhost=  user=root
Oct  2 13:35:38 UWS auth.notice su: FAILED SU (to root) student on console
[student@UWS ~]$ cat /etc/passwd | grep 1000
student:x:1000:1000:Linux User,,,:/home/student:/bin/bash
```

User `student` failed to switch user to root at 12:35:38 on the 2nd October.

27. *How does the tail command compare to the more command?*

`more` reads the entire input file before paging thorugh its content. `less` performs much the same functionality without the need to read the entire file. It also allows for a command mode which gives users opportunities to interact with the content, i.e. sending a file to `less` and searching for a specific pattern.

28. *What is the name and the size of the biggest filesystem entry of `/proc`? Do you have any idea what it may represent?*

```sh
[student@UWS proc]$ ls -lahS
total 4
-r--------    1 root     root     1023.9M Oct  2 14:08 kcore
drwxrwxrwx   22 root     root         501 Oct  2 10:57 ..
lrwxrwxrwx    1 root     root          11 Oct  2 14:08 mounts -> self/mounts
lrwxrwxrwx    1 root     root           8 Oct  2 14:08 net -> self/net
dr-xr-xr-x   60 root     root           0 Oct  2 10:58 .
dr-xr-xr-x    8 root     root           0 Oct  2 11:16 1
dr-xr-xr-x    8 root     root           0 Oct  2 11:16 10
-- snip --
```

`kcore` appears to be the largest file. We can find more information about it by using `file`:

```sh
[student@UWS proc]$ sudo file kcore
kcore: ELF 32-bit LSB core file Intel 80386, version 1 (SYSV), SVR4-style, from loglevel=3 console=hvc0 root=root rootfstype=9p rootflags=trans=virtio ro TZ=UT
```

It's the kernel core!

29. What is the link between the PID of the running processes and the directory names within `/proc`?

There is a direct relationship in that there is a directory in `/proc` for each process ID running at the time. Consider the following example:

```sh
[student@UWS ~]$ ps -ef | grep sleep
student   1398  1117  0 14:25 hvc0     00:00:00 grep sleep
[student@UWS ~]$ sleep 600 &
[2] 1399
[student@UWS ~]$ ps -ef | grep sleep
student   1399  1117  1 14:26 hvc0     00:00:00 sleep 600
student   1401  1117  0 14:26 hvc0     00:00:00 grep sleep
```
- `sleep` is not currently running
- `sleep` is executed and sent to the background using `&` for 600 seconds
- querying `ps -ef` again shows `sleep` with a process ID of `1399`

```sh
[student@UWS ~]$ ls -lah /proc | grep 1399
dr-xr-xr-x    8 student  student        0 Oct  2 14:26 1399
[student@UWS ~]$ ls /proc/1399
auxv             cpuset           gid_map          mounts           oom_score_adj    schedstat        status
cgroup           cwd              limits           mountstats       pagemap          setgroups        syscall
clear_refs       environ          map_files        net              personality      smaps            task
cmdline          exe              maps             ns               projid_map       stack            timerslack_ns
comm             fd               mem              oom_adj          root             stat             uid_map
coredump_filter  fdinfo           mountinfo        oom_score        sched            statm            wchan
[student@UWS ~]$ kill 1399
[2]-  Terminated              sleep 600
[student@UWS ~]$ ls /proc/1399
ls: /proc/1399: No such file or directory
```

- `ls` is run on `/proc` and fed to `grep` with a pattern matching the process ID
- a directory is found containing a number of files, directories, links, etc.
- the process is terminated using `kill` against the corresponding process ID
- running `ls` a second time on the directory reveals that the directory no longer exists. A direct relationship exists.

30. *What do you think will happen to each directory in /proc after the associated process has been killed?*

I think that when a process is killed its corresponding directory entry in `/proc` will no longer exist.

31. *What is written in the `cmdline` file? Does this agree with the information as given by the command, `ps -ef`?*

each instance of `cmdline` contains the content of the `CMD` column for each entry returned by `ps-ef`.

32. *What is the status (check the contents of `/proc/1/status`) and the memory size (`VmSize`) that is used by the init process?*

```sh
[student@UWS ~]$ cat /proc/1/status | grep VmSize
VmSize:     2108 kB
```

33. *Name the different directories that are present in the `/media` directory.*

- `disk1`

34. *Now set in `/media/floppy` (having a formatted floppy with some data on it inserted).*

```sh
root@UWS ~]# cd /media/floppy/
[root@UWS floppy]# echo 'a dummy file' > testfile.dat
[root@UWS floppy]# ls -l
total 14
-rw-r--r--    1 root     root            61 Sep 13  2020 file.txt
drwx------    2 root     root         12288 Sep 13  2020 lost+found
-rw-r--r--    1 root     root            13 Oct  2 20:58 testfile.dat
```

35. *Why is the actual password depicted as `x`, although the password is not `x`?*

This indicastes that the password is encrypted as part of `/etc/shadow`.

36. *What is the user identification (UID), home directory and login shell of the root-user?*

```sh
[student@UWS /]$ more /etc/passwd
root:x:0:0:root:/root:/bin/sh
```

- `0`
- `/root`
- `/bin/sh`

37. *What is the UID of the daemon called `uucp`?*

```sh
[student@UWS /]$ grep uucp /etc/passwd
[student@UWS /]$ cat etc/passwd
root:x:0:0:root:/root:/bin/sh
daemon:x:1:1:daemon:/usr/sbin:/bin/false
bin:x:2:2:bin:/bin:/bin/false
sys:x:3:3:sys:/dev:/bin/false
sync:x:4:100:sync:/bin:/bin/sync
mail:x:8:8:mail:/var/spool/mail:/bin/false
www-data:x:33:33:www-data:/var/www:/bin/false
operator:x:37:37:Operator:/var:/bin/false
nobody:x:65534:65534:nobody:/home:/bin/false
student:x:1000:1000:Linux User,,,:/home/student:/bin/bash
```

There appears to be no entry for `uucp` as part of the list of users.

38. *Determine the UID of student in the Debian system.*

`1000`

39. *How many users use the `/bin/sh` shell as their login shell?*

```sh
[student@UWS /]$ more /etc/passwd | grep '/bin/sh' | wc -l
1
```

- 1
- `wc -l` receives standard input and returns the number of lines present in the input.

## Lab 04

1. *What is the difference between `ps` and `ps -ef`?*

- `ps` shows the active processes for the current user
- `ps -ef` shows all active processes

2. *Explain the meaning of the column headers `UID`, `PID`, `PPID` and `CMD`*

| Header | Meaning                                                      |
| ------ | ------------------------------------------------------------ |
| UID    | User ID, who the process belongs to                          |
| PID    | Process ID, the unique number assigned to a process when it's started up |
| PPID   | Parent Process ID                                            |
| CMD    | The command line being executed                              |

3. *Write down the process identifiers of at least two processes that have the PPID of 1, representing the init process*

```sh
[student@UWS ~]$ ps --ppid 1
  PID TTY          TIME CMD
   82 ?        00:00:00 syslogd
   84 ?        00:00:00 klogd
   92 ?        00:00:00 rpcbind
  112 ?        00:00:00 dhcpcd
  119 ?        00:00:00 dropbear
  126 ?        00:00:00 rpc.statd
  138 ?        00:00:00 rpc.mountd
  144 ?        00:00:00 crond
  174 ?        00:00:00 login
```

4. *Is the process `ps -ef` listed itself? If yes, what is its PID on the system?*

```sh
[student@UWS ~]$ ps -ef | grep student
root       174     1  0 19:42 ?        00:00:00 login -- student
student    192   174  0 19:44 hvc0     00:00:01 -bash
student    246   192  0 20:09 hvc0     00:00:00 ps -ef
student    247   192  0 20:09 hvc0     00:00:00 grep student
```

- Yes
- 246

5. *How many processes in total are currently being run by the root user?*

```sh
[student@UWS ~]$ ps -fu root | wc -l
45
```

44

6. *What is the PID of the terminal and the nano process?*

```sh
[student@UWS ~]$ nano &
[1] 253
[student@UWS ~]$ ps
  PID TTY          TIME CMD
  192 hvc0     00:00:02 bash
  253 hvc0     00:00:00 nano
  254 hvc0     00:00:00 ps
 
[1]+  Stopped                 nano
```

- nano: 253
- bash: 192

7. *What is the function of the ampersand & in the above command?*

`&` sends a process to the background.

8. *What is the PID and PPID of the terminal and the two processes nano and vi? What is the relation between the calling terminal shell and the two processes?*

```sh
[student@UWS ~]$ ps -ef | grep -e nano -e vi
student    253   192  0 20:11 hvc0     00:00:00 nano
student    255   192  0 20:16 hvc0     00:00:01 vi
```

`nano` and `vi` have PIDs 253 and 255 respectively, and they both share PPID 192, which is the PID of `bash`

9. *Did this kill the process vi?*

```sh
[student@UWS ~]$ kill 255; ps -fu student
UID        PID  PPID  C STIME TTY          TIME CMD
student    192   174  0 19:44 hvc0     00:00:02 -bash
student    253   192  0 20:11 hvc0     00:00:00 nano
student    255   192  0 20:16 hvc0     00:00:01 vi
student    275   192  0 20:20 hvc0     00:00:00 ps -fu student
```

No.

10. *Use the man kill command and check for the meaning of the qualifier -9 to find out why the process has been killed this time?*

`-9` represents a `KILL` signal, which unconditionally and immediately halts the execution of a programme.

11. *What is the PPID and PID of each `top` process?*

```sh
[student@UWS ~]$ ps -ef | grep top
student    200   199  0 09:54 hvc0     00:00:00 top
student    202   201  0 09:54 hvc0     00:00:00 top
student    205   201  0 09:54 hvc0     00:00:00 grep top
```

- PIDs: 200, 199
- PPIDs: 202, 201

12. *What happened to the two top processes? Were they killed too? What is the new PPID of the two top processes? Can you therefore explain what happens to orphaned processes?*

```sh
[student@UWS ~]$ ps -ef | grep top
student    200   199  0 09:54 hvc0     00:00:00 top
student    207   199  0 09:55 hvc0     00:00:00 grep top
```

When the parent process was killed, the child was also killed. Process 200 remains in the background as its parent was untouched. If the question requires the overall parent to be killed, i.e. PID 199 `bash`, the terminal emulator would be killed along with its child processes, and the user would be required to log in.

An orphaned process is one whose parent has terminated but continues to execute. Running `ps -ax` and finding an absence of `PID -1` allows us to confirm that there are no current zombie or orphaned processes:

```sh
[student@UWS ~]$ ps -ax | head
  PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:02 init [3]
    2 ?        S      0:00 [kthreadd]
    3 ?        S      0:00 [kworker/0:0]
    4 ?        S<     0:00 [kworker/0:0H]
    5 ?        S      0:00 [kworker/u2:0]
    6 ?        S<     0:00 [mm_percpu_wq]
    7 ?        S      0:00 [ksoftirqd/0]
    8 ?        S      0:00 [kdevtmpfs]
    9 ?        S<     0:00 [netns]
-- snip --
```

If any of the `top` processes had been orphaned and adopted by `init` we'd see them with a PID of `1`.

13. *Describe the output that you see. How much approximate CPU time (in %) does the cruncher program use while it is still running?*

![[Pasted image 20211005120713.png]]

`top` appears in the terminal window with a cascading series of processes stemming from `init`, leading to `cruncher` and `top`, before a series of processes related to `[kthreadd]` appears. In CPU time %, `cruncher` appears to use between 3-5%.

14. *In what order does the top command display the processes?*

`top` displays processes in %CPU descending in a tree format, i.e. a `cruncher`, when using significant CPU time, will appear as a child of `init`. If `cruncher` is the most intensive process running at the time, `init` will appear at the top of the list despite its current %CPU reading of ~0.

15. *How many processes are running on your machine in total? How many of them are sleeping?*

```sh
[root@UWS ~]# top
top - 11:14:24 up  1:30,  1 user,  load average: 0.00, 0.03, 0.01
Tasks:  49 total,   1 running,  47 sleeping,   1 stopped,   0 zombie
-- snip --
```

- 49 total
- 47 sleeping

16. *The ‘Tasks’ row has space for zombie processes. Do you have any idea what a zombie in a Unix-like system might refer to?*

When a process is killed it informs its parent of its pending termination. If this is successful its PID will be removed from `ps`. If the parent fails to acknowledge the termination, for whatever reason, the process becomes a zombie process. A zombie process has been terminated, (and therefore) cannot be killed, and its resources have been freed. Either init adopts the zombie process, or the process is cleared on boot.

17. *What is the priority number of the program cruncher? Does it change at all?*

20, and the priority value does not appear to change throughout the programme's lifetime.

18. *What is the highest priority that any of the processes gets assigned?*

- BSD C Shell & standalone: 20
- System V C Shell: 39

19. *What priority level is given to the majority of the processes?*

20

20. *Is any swap space used at this time?*

`0.0GiB`

21. *Explain briefly what kind of information vmstat displays here? What do the two qualifiers: 10 and 4 stand for?*

Statistics pertaining to the system's virtual memory. `vmstat n` will cause the programme to refresh every `n` seconds, where 10 is every ten seconds, and 4 is every four seconds.

22. *What numbers change in the vmstat display? What does the number in the `r` column represent?*

With a number of `cruncher` programmes executing in the background:
- columns `r, in, cs, us, sy,`, and `id` all change at least once.
- `r` represents the number of runnable processes which are either running, or waiting for run time.

23. *What happens, while running the application programs, to the last three entries shown below the cpu heading that are labelled: `us sy id`? To which value do they always add up? Can you interpret their meaning?*

The values of `us, sy`, and `id` each add up to 100. These numbers vary over time, with `id` appearching to change once at upon initial execution of the `vmstat` command, and when the background instances of `cruncher` appear to have each completed processing.

```sh
[root@UWS ~]# vmstat 10
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 4  0      0 495352      0   4952    0    0     0     0  904   78  9 15 77  0  0
 5  0      0 495352      0   4952    0    0     0     0 3608  368 36 64  0  0  0
 4  0      0 495384      0   4952    0    0     0     0 3626  369 37 63  0  0  0
 4  0      0 495260      0   4952    0    0     0     0 3636  366 39 61  0  0  0
 4  0      0 495352      0   4952    0    0     0     0 3638  370 38 62  0  0  0
 0  0      0 496160      0   4944    0    0     0     0 2753  276 28 47 25  0  0
```

 24. *What happens to the number associated with the `us` column once all cruncher sessions have terminated?*

 It rests at zero.

 25. *What information does uptime provide?*

```sh
[root@UWS ~]# uptime
 11:55:33 up 12 min,  1 user,  load average: 0.44, 0.83, 0.46
```

The length of time that the system has been running, the number of logged in users, the time and date the system came online, and information about the system's average load.

26. *What is the name and the significance of the process that is displayed in the leftmost position*

`init`. Its significance is that it is the direct, indirect parent of all processes running on the system.

27. *Write down all linking processes between init and pstree. Could you obtain the same information using the ps command?*

`init --> login --> bash --> pstree`

A clumsy way of performing this would be to find the process ID of some programme and work backward:

```sh
[student@UWS ~]$ sleep 600 &
[1] 238
[student@UWS ~]$ ps -o ppid= -p 238
  192
[student@UWS ~]$ ps -o ppid= -p 192
  174
[student@UWS ~]$ ps -o ppid= -p 174
    1
```

28. *What are the nice numbers of some processes: e.g. init , kthread, cron and udevd?*

```sh
[student@UWS ~]$ top -b -n 1 | grep "NI\|cron\|init\|kthread\|udevd"
  PID USER      PR  NI    VIRT    RES  %CPU  %MEM     TIME+ S COMMAND
    1 root      20   0    2.1m   0.7m   0.0   0.1   0:02.84 S init [3]
  144 root      20   0    2.1m   0.8m   0.0   0.2   0:00.11 S  - /usr/sbin/crond -f
  333 student   20   0    2.9m   1.0m   0.0   0.2   0:00.03 S          - grep NI\|cron\|init\|kthread\|udevd
    2 root      20   0    0.0m   0.0m   0.0   0.0   0:00.01 S [kthreadd]
````

They're all 0.

29. *What is the nice number (NI) given by the system to the cruncher script?*

20.

30. *Note the actual outputs for real, user and sys times for the cruncher script after it has finished executing.*

```sh
[root@UWS ~]#
real    0m15.022s
user    0m4.394s
sys     0m9.989s
```

31. *Note the real, user and sys times again and comment on any difference in the real time value*

```sh
[root@UWS ~]# time nice -n 19 ./cruncher > /dev/null
real    0m14.351s
user    0m4.453s
sys     0m9.710s
```

This second command was able to perform 0.671s faster than the previous command, possibly due to the increased processor time enjoyed by the process as a result of the reduction in nice value.

32. *Why do you think, user and sys time are not so different when compared to the values obtained after the first run of cruncher?*

The processing time is the factor affected by the reduction in the process' nice value, the time it takes for the system to read the file and the time it takes to process system calls will be the same. 

33. *Note the actual outputs for real, user and sys time again. Comment on any improvement in performance.*

```sh
[root@UWS ~]# time nice -n -20 ./cruncher > /dev/null
real    0m14.649s
user    0m4.582s
sys     0m9.965s
[root@UWS ~]#
```

There was no real effect on performance, presumably because there are so few active processes running on the system.

35. *Note the actual outputs of the time command for real, user and sys. How do the time differences between nice 19 and nice -20 compare to the time differences on a quiet system?*

```sh
[root@UWS ~]# time nice -n 19 ./cruncher > /dev/null &
[2] 9044
[root@UWS ~]# time nice -n -20 ./cruncher > /dev/null &
[3] 9110
[root@UWS ~]#
real    0m13.012s
user    0m4.497s
sys     0m8.321s
 
real    0m27.496s
user    0m4.467s
sys     0m9.770s
```

The `nice -20` command completed roughly twice as fast as the `nice 19` command.

36. *Note the output of the renice command.*

```sh
[root@UWS ~]# time nice -n 19 ./cruncher > /dev/null &
[2] 9850
[root@UWS ~]# renice -20 9850
9850 (process ID) old priority 0, new priority -20
[root@UWS ~]#
real    0m14.696s
user    0m4.178s
sys     0m9.481s
```

37. *Estimate the performance gain of the above action.*

After reconfiguring the nice value, the process runs about twice as fast as it would with its initial nice value.

38. *Which file contains a list of users who are allowed to submit requests to the crontab facility?*

If it exists, `cron.allow`.

39. *Which file contains a list of users who are NOT allowed to submit request to the crontab facility? If a user’s name appears in both lists, which list takes precedence?*

`cron.deny`, and `cron.allow` respectively.

40. *Explain the result of the above command in detail.*

```sh
[root@UWS etc]# du -k /home
4       /home/student/Desktop
4       /home/student/.config/procps
8       /home/student/.config
20      /home/student
24      /home
```

This command lists the sizes of a directory and its subdirectory in a given unit - in this case, `KB`.

41. *What does the piping in the `sort –nr` and the `head –5` do to the `du -k /home` output? Explain in detail.*

- `sort –nr` sorts some input in reverse numerical order
- `head -5` receives a test stream and outputs the top five lines of that stream

42. *Note the output of the above command.*

```sh
[root@UWS etc]# crontab -l
5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55 * * * * du -k /home | sort -nr | head -5 >> /root/test.dat
```

43. *What happens to the size of /root/test.dat over time? Do you see any danger in having a steadily growing output file in a directory?*

The cronjob uses the append operator `>>`, meaning every five minutes another five lines will be added to the file, an disk space, while cheap, is finite!

44. *What would be the entry in /tmp/entries to perform the command once every day at 23:15?*

```sh
15 23 * * * du -k /home | sort -nr | head -5 >> /root/test.dat
```

45. *What would be required to perform it at 4:30pm on the 21 st of January every year?*

```sh
30 16 21 1 * du -k /home | sort -nr | head -5 >> /root/test.dat
```

46. *Find an alternative cron syntax that could be used to specify that a job be performed every 5 minutes. Note the alternative notation as the answer in your logbook.*

```sh
*/5 * * * * * du -k /home | sort -nr | head -5 >> /root/test.dat
```

47. *In which different time-periods are the system cron-jobs ordered?*

```sh
[root@UWS etc]# ls -lah | grep cron
drwxr-xr-x    2 root     root          60 Nov 11  2020 cron.d
drwxr-xr-x    2 root     root          37 Nov 11  2020 cron.daily
drwxr-xr-x    2 root     root          37 Nov 11  2020 cron.hourly
drwxr-xr-x    2 root     root          37 Nov 11  2020 cron.monthly
drwxr-xr-x    2 root     root          37 Nov 11  2020 cron.weekly
```

- daily
- hourly
- monthly
- weekly

48. *Note an example of a cron-job service task that is found in the cron.daily directory.*

```sh
[root@UWS etc]# ls -lah cron.daily/
total 8
drwxr-xr-x    2 root     root          37 Nov 11  2020 .
drwxr-xr-x   17 root     root        1.3K Dec 10  2020 ..
```

There aren't any!

49. *What is the exact meaning of the -r character in the crontab -r command line?*

The -r option causes the current crontab to be removed.
