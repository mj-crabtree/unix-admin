# Unix System Administration - Log Book

M. Crabtree - B00414581

---

## Practical 1
1. *Name and explain one qualifier selected by you for each of the three commands*
	1. `ls -h`: prints human readable file sizes (e.g. 1K, 2G, etc.) when used in conjunction with `-s` and `l`
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
[student@UWS ~]$ ls -lah
total 24
drwxr-sr-x    4 student  student      138 Sep 14 11:25 .				# hidden
drwxr-xr-x    3 root     root          61 Sep 14 11:25 ..				# hidden
-rw-------    1 student  student      105 Sep 14 11:56 .bash_history	# hidden
-r--r-----    1 student  student     1004 Sep 14 11:25 .bashrc			# hidden
drwxr-xr-x    2 student  student       37 Sep 14 11:25 Desktop
drwxr-sr-x    2 student  student       81 Sep 14 11:55 subdir
```

Any directory name beginning with `.` represents a hidden directory.

