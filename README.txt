HOW to install Solaris 10 1/13

0. system configuraion

  os: ubuntu "Ubuntu 24.04.4 LTS"
  added packages:

1. Download Solaris11 1/13 (sol-10-u11-ga-sparc-dvd.iso) install iso
  image from Oracle and put it in ./isos directory.

2. create a hard disk image at least 10G byte size in vms/vm_test directory,
   with dd command
   $ cd vms/vm_test
   $ dd if=/dev/zero of=root.img bs=1048576 count=10240

3. Boot qemu
   $ ./run_vm_test.sh

4. Find console device. Type info chardev in qemu terminal.
   (qemu) info chardev
   serial1: filename=pty:/dev/pts/1
   parallel0: filename=null
   compat_monitor0: filename=stdio
   serial0: filename=file

    Then type below to connect sun4v serial console line.
   cu -l  /dev/pts/1

5. Type Return key, then you see ok prompt from open boot.
   ok

6. Boot solaris from the iso image

   ok boot /virtual-devices@100/disk@3

   Then, following logs will be showed:

	Boot device: /virtual-devices@100/disk@3  File and args: 
	SunOS Release 5.10 Version Generic_147147-26 64-bit
	Copyright (c) 1983, 2013, Oracle and/or its affiliates. All rights reserved.
	Configuring devices.
	Using RPC Bootparams for network configuration information.
	svc:/system/filesystem/local:default: WARNING: /usr/sbin/zfs mount -a failed: one or more file systems failed to mount
	Serial console, reverting to text install
	Beginning system identification...
	Searching for configuration file(s)...
	Search complete.
	Discovering additional network configuration...

7.  Solaris installer starts:

Select a Language

   0. English
   1. Brazilian Portuguese
   2. French
   3. German
   4. Italian
   5. Japanese
   6. Korean
   7. Simplified Chinese
   8. Spanish
   9. Swedish
  10. Traditional Chinese

Please make a choice (0 - 10), or press h or ? for help:

TYPE: 0  (according with your terminal environment)

What type of terminal are you using?
 1) ANSI Standard CRT
 2) DEC VT52
 3) DEC VT100
 4) Heathkit 19
 5) Lear Siegler ADM31
 6) PC Console
 7) Sun Command Tool
 8) Sun Workstation
 9) Televideo 910
 10) Televideo 925
 11) Wyse Model 50
 12) X Terminal Emulator (xterms)
 13) CDE Terminal Emulator (dtterm)
 14) Other
Type the number of your choice and press Return: 

TYPE: 3  (according with your terminal environment)


- The Oracle Solaris Installation Program --------------------------------------
  The Solaris installation program is divided into a series of short sections
  where you'll be prompted to provide information for the installation. At
  the end of each section, you'll be able to change the selections you've
  made before continuing.

  About navigation...
        - The mouse cannot be used
        - If your keyboard does not have function keys, or they do not
          respond, press ESC; the legend at the bottom of the screen
          will change to show the ESC keys to use for navigation.
--------------------------------------------------------------------------------
    Esc-2_Continue    Esc-6_Help

TYPE: Esc-2


- Identify This System ---------------------------------------------------------
  On the next screens, you must identify this system as networked or
  non-networked, and set the default time zone and date/time.

  If this system is networked, the software will try to find the information
  it needs to identify your system; you will be prompted to supply any
  information it cannot find.

  > To begin identifying this system, press F2.
--------------------------------------------------------------------------------
    Esc-2_Continue    Esc-6_Help

TYPE: Esc-2


- Host Name --------------------------------------------------------------------
   Enter the host name which identifies this system on the network.  The name
  must be unique within your domain; creating a duplicate host name will cause
  problems on the network after you install Solaris.

  A host name must have at least one character; it can contain letters,
  digits, and minus signs (-).


                           Host name_________

--------------------------------------------------------------------------------
    Esc-2_Continue    Esc-6_Help

TYPE: hostname you want.


Continue the install process, then it will fail with the following message
because para-virtualizaion disk driver (hsimd) not installed yet:

System identification complete.
/sbin/install-begin: test: argument expected
Exiting to shell...
#

5. Transfer hsimd disk driver package by cu ~p command,
  ~p
# ~[local hostname]p
File to send:

TYPE: hsimd.pkg.shar

Remote file name [hsimd.pkg.shar]: 
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 
...
...


6. Extract hsimd driver file

# sh hsimd.pkg.shar

# ls
adddrv.sh       adddrv_a.sh     hsimd           kernel          var
adddrv2.sh      etc             hsimd.pkg.shar  usr

# sh adddrv2.sh
...
Driver (hsimd) installed.

7. ensure the hsimd driver installed and running.
# modinfo | grep hsimd
182 7b7ee000   2970 323   1  hsimd (hsimd)

8. restart solaris install process
# install-solaris

Then, continue solaris install process.
select *no* automatic reboot

After solaris install, you should add the hsimd driver to installed image.

# sh adddrv_a.sh
# boot update-archive -R /a

Then reboot the system.






