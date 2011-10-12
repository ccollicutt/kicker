#raw

# Xen networking
echo 'options netloop nloopbacks=9' >>/etc/modprobe.conf
echo -e '#!/bin/sh\n\nXENDIR="/etc/xen/scripts"\n' >/etc/xen/scripts/my-network-bridge
for i in $(seq 0 5); do
  echo '$XENDIR/network-bridge "$@" netdev=eth'${i}' bridge=xenbr'${i}' vifnum='${i}   >>/etc/xen/scripts/my-network-bridge
done
chmod 755 /etc/xen/scripts/my-network-bridge
patch /etc/xen/xend-config.sxp <<EOF
91c91
< (network-script network-bridge)
---
> (network-script my-network-bridge)
EOF

#end raw
