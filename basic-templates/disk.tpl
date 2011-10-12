#*------------------------------------------------------------------------------
There is a lot of logic here for disk, fs and volume names often based on the
mode that is set.
------------------------------------------------------------------------------*#

#if $mode == 'domU_xen'
#set $disk_type = 'xvda'
#else if $os == 'rhel5' and $mode == 'domU_kvm'
#set $disk_type = 'hda'
#else if $os == 'rhel6' and $mode == 'domU_kvm'
#set $disk_type = 'sda'
#else if $mode == 'dom0'
#set $disk_type = 'sda'
#else
#set $disk_type = 'sda'
#end if

#if $os == 'rhel6'
#set $fs_type = 'ext4'
#else
#set $fs_type = 'ext3'
#end if

#if $mode == 'dom0' or $mode == 'baremetal'
#set $system_vg_name = 'system'
#else
#set $system_vg_name = 'vmsystem'
#end if

## End logic -------------------------------------------------------------------

# Disk configuration
bootloader --location=mbr --driveorder=$disk_type
clearpart --initlabel --linux --drives=$disk_type
part /boot --fstype $fs_type --size=512 --ondisk=$disk_type
part pv.2 --size=1 --grow --ondisk=$disk_type
volgroup $system_vg_name --pesize=32768 pv.2
logvol swap --fstype swap --name=swap --vgname=$system_vg_name --size=512 --grow --maxsize=2048
logvol / --fstype $fs_type --name=root --vgname=$system_vg_name --size=256 --grow --maxsize=512
logvol /usr --fstype $fs_type --name=usr --vgname=$system_vg_name --size=1536 --grow --maxsize=4096
logvol /opt --fstype $fs_type --name=opt --vgname=$system_vg_name --size=512 --grow --maxsize=1024
logvol /tmp --fstype $fs_type --name=tmp --vgname=$system_vg_name --size=256 --grow --maxsize=512
logvol /var --fstype $fs_type --name=var --vgname=$system_vg_name --size=256 --grow --maxsize=2048
logvol /var/log --fstype $fs_type --name=varlog --vgname=$system_vg_name --size=1024 --grow --maxsize=2048
logvol /var/lib --fstype $fs_type --name=varlib --vgname=$system_vg_name --size=1536 --grow --maxsize=2048
