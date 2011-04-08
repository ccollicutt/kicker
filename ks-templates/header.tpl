install
#if $has_license_key
key $key
#end if
lang en_US.UTF-8
keyboard us
#if $encrypted
rootpw $rootpw
#else
rootpw --iscrypted $rootpw
#end if
firewall --enabled --port=22:tcp,161:udp
authconfig --enableshadow --enablemd5
selinux --disabled
timezone --utc $timezone
services --enabled ntpd --disabled gpm,yum-updatesd,rhnsd,bluetooth,cups
#if $has_ipaddress and $has_nameservers
network --device eth0 --noipv6 --bootproto static --ip $ipadress --netmask $netmask --gateway $gateway --nameserver $nameservers --hostname $hostname
#else if $has_ipaddress
network --device eth0 --noipv6 --bootproto static --ip $ipaddress --netmask $netmask --gateway $gateway --hostname $hostname
#else
#pass
#end if
