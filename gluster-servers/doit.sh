
# reserve

sudo apt install net-tools

# mask interfaces

DEVICE=`ifconfig | grep 'mtu 1500'  | cut -f1 -d:`

 echo "$DEVICE"

sudo ip addr add 192.168.10.21/24 dev $DEVICE
sudo ip addr add 192.168.10.22/24 dev $DEVICE
sudo ip addr add 192.168.10.23/24 dev $DEVICE

exit

# actualize hosts

echo '# glustefs setup ~~~~ '       | sudo tee -a  /etc/hosts
echo '192.168.10.21      gluster1'  | sudo tee -a  /etc/hosts
echo '192.168.10.22      gluster2'  | sudo tee -a  /etc/hosts
echo '192.168.10.23      gluster3'  | sudo tee -a  /etc/hosts

# update setup servers

# init the servers

sudo systemctl start   glusterfs
sudo systemctl enable  glusterfs

# controls servers

# leave running


