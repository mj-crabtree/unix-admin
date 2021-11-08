## Lab 07 - Configuration

1. *Describe what happened*

```sh
[root@UWS ~]# systemctl isolate rescue.target
You are in rescue mode. After logging in, type "journalctl -xb" to view
system logs, "systemctl reboot" to reboot, "systemctl default" or "exit"
to boot into default mode.
Give root password for system maintenance
(or type Control-D for normal startup):
sulogin: starting shell for system maintenance
```

- `systemctl isolate UNIT` starts the unit specified on the command line and its dependencies and stops all others
- `rescue.target` is the name of the unit to be loaded

2. *Is there any difference in the amount of free memory now available, and if yes, how much memory is freed in this mode?*

The first time this command was run:
```sh
[student@UWS ~]$ vmstat 5 5
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 480672      0  19320    0    0     0     0  252   21  8  4 88  0  0
 0  0      0 480672      0  19316    0    0     0     0  106    4  0  0 99  0  0
 0  0      0 480672      0  19304    0    0     0     0  102    4  0  1 99  0  0
 0  0      0 480704      0  19300    0    0     0     0  101    3  0  1 99  0  0
 0  0      0 480672      0  19296    0    0     0     0  101    3  0  1 99  0  0
```

Compared to the second time
```sh
[root@UWS ~]# vmstat 5 5 | awk '{print $4}'
free
484108
484108
484108
484108
484108
```

The difference is `-2436k`

3. *Is there any difference in the output and behaviour of such basic commands?*

```sh
[root@UWS ~]# ls -lah
total 24K
drwx------  4 root root  138 Nov 17  2020 .
drwxrwxrwx 20 root root  521 Nov  5 12:31 ..
-rw-------  1 root root   32 Nov  5 12:43 .bash_history
-r--r-----  1 root root 1004 Nov  5 12:32 .bashrc
drwxr-xr-x  3 root root   59 Nov  5 12:32 .local
drwxr-xr-x  2 root root   37 Nov  5 12:32 Desktop
[root@UWS ~]# cd .
[root@UWS ~]# cd Desktop/
[root@UWS Desktop]#
```

Nothing of note.

4. *What is the outcome of the command `init 0`?*

`init 0` shuts down the computer/

5. *How many different menu entries can you make out by studying the `/boot/grub/grub.cfg` file?*

```sh
[root@UWS ~]# cat /boot/grub/grub.cfg | grep menuentry
menuentry "Ubuntu, Linux 2.6.31-23-generic" {
menuentry "Ubuntu, Linux 2.6.31-23-generic (recovery mode)" {
```

Two. One for Ubuntu Linux, and its accompanying recovery mode.

6. *What is the image executable `vmlinuz` for the Linux kernel called? Please provide the absolute pathname.*

```sh
[root@UWS ~]# cat /boot/grub/grub.cfg | grep vm
        linux   /boot/vmlinuz console=hvc0 root=root rootfstype=9p rootflags=trans=virtio ro
        linux   /boot/vmlinuz console=hvc0 root=root rootfstype=9p rootflags=trans=virtio ro
[root@UWS ~]# file /boot/vmlinuz
"/boot/vmlinuz: Linux kernel x86 boot executable bzImage, version 4.12.0 (hecmargi@maximo) #10 Mon Oct 5 19:46:48 BST 2020, RO-rootFS, swap_dev 0x4, Normal VGA"
```

7. *What is the size of the compressed kernel image?*

```sh
[root@UWS ~]# ls -lah /boot/vmlinuz*
-rw-rw-r-- 1 root root 5.0M Nov 19  2020 /boot/vmlinuz
```

`5.0M`

8. *What level is chosen to be the default runlevel?*

```sh
[root@UWS sbin]# ls -lah /etc/systemd/system/*.target
lrwxrwxrwx 1 root root 45 Nov 19  2020 /etc/systemd/system/default.target -> ../../../lib/systemd/system/multi-user.target
[root@UWS ~]# runlevel
N 3
[root@UWS ~]# ls -l /lib/systemd/system | grep runlevel3
lrwxrwxrwx 1 ... runlevel3.target -> ../../../../usr/lib/systemd/system/multi-user.target
```

Calling the `runlevel` command immediately on reboot results in a returned equivalent run level of `3` which would indicate that `multi-user` is the default run level which is located at `/lib/systemd/system/multi-user.target`. 

9. *What is the message displayed if you stop the networking daemon?*

```sh
[root@UWS ~]# systemctl stop systemd-networkd
Warning: Stopping systemd-networkd.service, but it can still be activated by:
  systemd-networkd.socket
```

10. *What is the output of the `ping localhost` command once you have stopped the networking daemon?*

`ping` executes normally.

```sh
[root@UWS ~]# ping localhost
PING localhost (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.000 ms
64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.000 ms
^C
--- localhost ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1007ms
rtt min/avg/max/mdev = 0.000/0.000/0.000/0.000 ms
```

11. *What information was displayed after issuing the previous `systemctl` command?*

```sh
[root@UWS ~]# systemctl status systemd-networkd
● systemd-networkd.service - Network Service
   Loaded: loaded (/usr/lib/systemd/system/systemd-networkd.service; enabled; vendor preset: enabled)
   Active: inactive (dead) since Fri 2021-11-05 14:19:11 UTC; 1min 30s ago
     Docs: man:systemd-networkd.service(8)
  Process: 91 ExecStart=/usr/lib/systemd/systemd-networkd (code=exited, status=0/SUCCESS)
 Main PID: 91 (code=exited, status=0/SUCCESS)
   Status: "Shutting down..."
 
Nov 05 13:09:48 UWS systemd[1]: Starting Network Service...
Nov 05 13:09:51 UWS systemd-networkd[91]: Enumeration completed
Nov 05 13:09:51 UWS systemd-networkd[91]: request_name_destroy_callback n_ref=1
Nov 05 13:09:51 UWS systemd[1]: Started Network Service.
Nov 05 13:09:57 UWS systemd-networkd[91]: eth0: Gained carrier
Nov 05 14:19:10 UWS systemd[1]: Stopping Network Service...
Nov 05 14:19:11 UWS systemd[1]: Stopped Network Service.
```

Information pertaining to the status of the service, its process attributes, and any recent activity.

12. *Based on your knowledge of the boot process: Draw a diagram that shows the boot process from the very beginning (BIOS, LILO) to runlevel 2. Explain in your own words the complete boot process assuming you have to prepare the diagram for a potential client. Also investigate the standard System V runlevel settings and give some reasons why Debian mayhave deviated from this standard Research whether the standard Ubuntu, Redhat and Suse distributions adhere to the System V definitions of runlevels and note this in your answer.*

```mermaid
graph LR
	A(BIOS)-->B(MBR)
	B-->C(GRUB)
	C-->D(Kernel)
	D-->E(init)
	E-->F(Default Run level)
```

The question posits that the system will boot into runlevel 2 though this doesn't appear to be the default runlevel for the system (see Q.8). 

**The BIOS**
- The system BIOS will perform a number of self-checks on the system and ensure overall integrity
- It then finds, loads, and executes a boot loader programme from the Master Boot Record
- The boot loader programme is given control of the system by the BIOS

**Master Boot Record**
- Located on the first sector of the drive
- MBR loads and executes the GRUB bootloader, or LILO if applicable

**Grand Unified Bootloader**
- Loads the system kernel into memory
	- generally the default system kernel
- GRUB allows more than one operating system to be loaded which the user can select

**The Kernel**
- the root filesystem is mounted
	- specified in `grub.conf`
- `init` is executed with a pid of 1
	- the kernel is initialised by `init`
	- `initrd` is a ram based filesystem used by the kernel until a full filesystem is mounted
	- this partition also allows for necessary drivers to be utilised allowing access to hardware, including drive partitions

**`init`**
- On `init` based systems, the `inittab` file is read and the run level is determined
- The default run level specifies the applications required in order to achieve that status
- Generally speaking, the default run level on servers is 3, and 5 for GUI environments

**Default run level**
- Services are executed, run by `init` in accordance with the requirements specified by the default run level
- Services are loaded in accordance with their sequence number
	- e.g. a process with a sequence number of 15 will run before another with a sequecne number of 35

13. *Stop and start again the dropbear service and verify that it is running. Check again the PID address and compare it against the previous one. Which PID value is higher?*

The previous value was 138, the new value is 158. The new value is higher.

14. *Why the PID assigned*

The question is unclear, but when a new process is generated the system adds the value of `1` to the current process count until it reaches the maximum PID value determined by `/proc/sys/kernel/pid_max`

15. *Is which situation the PID number assigned can be smaller?*

Once the PID value has reached the maximum the system will begin assigning PIDs again from zero, unless there are `pid_max` number of concurrent processes running.

16. *Run the `pwd` command again and indicate the current directory.*

```sh
[student@UWS tmp]$ ssh localhost
Host 'localhost' is not in the trusted hosts file.
(ecdsa-sha2-nistp256 fingerprint sha1!! b7:2c:8e:ab:3e:ee:1d:12:6e:9f:03:da:b9:1
9:70:1d:31:af:51:46)
Do you want to continue connecting? (y/n) y
student@localhosts password:
[student@UWS ~]$ pwd
/home/student
```

17. *Explain why the current directory is not `tmp`*

We have logged into the remote session as `student` and, as such, have been placed into that user's home folder as normal.
