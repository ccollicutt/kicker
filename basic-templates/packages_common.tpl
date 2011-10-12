coreutils
SysVinit
chkconfig
initscripts
mingetty
module-init-tools
audit
bzip2
crontabs
logrotate
man
ntp
sendmail
procps
psacct
which
perl
bash
tar
rsync
openssh-clients
openssh-server
anacron
vixie-cron
crontabs
tcpdump
iptables
iptables-ipv6
system-config-securitylevel
yum
mlocate

# Remove
#if $os == 'rhel6'
-subscription-manager
#else
-yum-updatesd
#end if

# install rsyslog b/c it's better and can do tcp
-sysklogd
rsyslog
