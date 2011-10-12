install
#if $key
key $key
#else 
key --skip
#end if
url --url=http://129.128.216.194/mrepo/$os-x86_64/disc1/
repo --name=updates --baseurl=http://129.128.216.194/mrepo/$os-x86_64/RPMS.updates/
lang en_US.UTF-8
keyboard us
#if $isencrypted == True
rootpw --iscrypted $rootpw
#else
rootpw $rootpw
#end if
firewall --enabled --port=22:tcp
authconfig --enableshadow --enablemd5
selinux --disabled
timezone --utc $timezone
services --enabled ntpd,rsyslog --disabled gpm,yum-updatesd,rhnsd,bluetooth,cups
#if $ipaddress and $nameservers
network --device eth0 --noipv6 --bootproto static --ip $ipaddress --netmask $netmask --gateway $gateway --nameserver $nameservers --hostname $hostname
#else if $ipaddress
network --device eth0 --noipv6 --bootproto static --ip $ipaddress --netmask $netmask --gateway $gateway --hostname $hostname
#else
#pass
#end if

# Perform the kickstart install in text mode, not gui
text

# Completely command line mode 
cmdline

# Reboot after install is completed
reboot
