#! /bin/bash -v
#
vm_name=vm_test
conf_name=hwconf

#qemu_dir=$HOME/qemu
qemu_dir=.
bin_dir=${qemu_dir}/qemu-sun4v-build
iso_dir=${qemu_dir}/isos

vm_dir=${qemu_dir}/vms/${vm_name}

(cd ${vm_dir}/${conf_name}; make)
MEMSIZE="`grep ^#define ${vm_dir}/${conf_name}/local.conf | grep MEMSIZE | sed -e 's/.*MEMSIZE//'`"
echo MEMSIZE is $MEMSIZE
MEMSIZE=$(($MEMSIZE / 1024 / 1024))
echo $MEMSIZE
#
# Run OpenSPARC T1 with solaris disk image of OpenSPARCT2
#
${bin_dir}/qemu-system-sparc64 -M niagara -L ${vm_dir}/${conf_name} -nographic -m $MEMSIZE \
 -serial file:/dev/null \
 -serial pty \
 -d guest_errors,unimp \
 -drive format=raw,if=none,bus=0,unit=100,readonly=off,cache=none,\
file=${vm_dir}/root.img \
 -drive id=cdrom0,format=raw,if=none,bus=0,unit=103,readonly=on,cache=none,\
file=${iso_dir}/sol-10-u11-ga-sparc-dvd.iso

