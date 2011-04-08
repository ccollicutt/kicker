install
key $key
lang en_US.UTF-8
keyboard us
rootpw --iscrypted $rootpw
firewall --enabled --port=22:tcp,161:udp
authconfig --enableshadow --enablemd5
selinux --disabled
timezone --utc $timezone
services --enabled ntpd --disabled gpm,yum-updatesd,rhnsd,bluetooth,cups
network --device eth0 --noipv6 --bootproto static --ip $ip --netmask $netmask --gateway $gateway --nameserver $nameservers --hostname $hostname


