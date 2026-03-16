
# reserve

sudo apt install net-tools

# mask interfaces, one ethernet ?

DEVICE=`ifconfig | grep 'mtu 1500'  | head -1 | cut -f1 -d:`

echo "$DEVICE"

sudo ip addr add 192.168.10.21/24 dev $DEVICE
sudo ip addr add 192.168.10.22/24 dev $DEVICE
sudo ip addr add 192.168.10.23/24 dev $DEVICE
sudo ip addr add 192.168.10.24/24 dev $DEVICE

# actualize hosts

grep 'glusterfs setup' /etc/hosts && exit

sudo tee -a /etc/hosts << END
# ~~~ glustefs setup ~~~~
 192.168.10.21      gluster1
 192.168.10.22      gluster2
 192.168.10.23      gluster3
 192.168.10.24      gluster4
# ~~~ end setup ~~~
END

exit

# update setup servers

# init the servers

# sudo systemctl start   glusterfs
# sudo systemctl enable  glusterfs

# controls servers

# leave running


