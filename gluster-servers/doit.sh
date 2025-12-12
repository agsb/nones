
# reserve

sudo apt install net-tools

# mask interfaces

DEVICE=`ifconfig | grep 'mtu 1500'  | cut -f1 -d:`

sudo ip addr add 192.168.10.21/24 dev $DEVICE
sudo ip addr add 192.168.10.22/24 dev $DEVICE
sudo ip addr add 192.168.10.23/24 dev $DEVICE

# actualize hosts

sudo echo '# glustefs setup ~~~~ ' >> /etc/hosts
sudo echo '192.168.10.21      gluster1' >> /etc/hosts
sudo echo '192.168.10.22      gluster2' >> /etc/hosts
sudo echo '192.168.10.23      gluster3' >> /etc/hosts

# update setup servers

# init the servers

# controls servers

# leave running


