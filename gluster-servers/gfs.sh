
# A simple script for use glusterfs
# agsb@2026




# deletes

for vol in ones dual four nine ; do
        sudo gluster volume stop ${vol} && \
                sudo gluster volume delete ${vol}
done


# creates

# for n in {1..8} ; do
# echo create brick${n}
# sudo mkdir -p //pool/data/brick${n}
# done

# bricks of 64 Gb
sudo mount /dev/sdb5  //pool/data/brick4

sudo btrfs device add -f /dev/sdb6  //pool/data/brick4
sudo btrfs device add -f /dev/sdb7  //pool/data/brick4
sudo btrfs device add -f /dev/sdb8  //pool/data/brick4

#sudo btrfs filesystem balance  //pool/data/brick4

# bricks of 128 Gb
sudo mount /dev/sdb9  //pool/data/brick2

sudo btrfs device add -f /dev/sdb10  //pool/data/brick2

#sudo btrfs filesystem balance  //pool/data/brick2

# bricks of 256 Gb
 sudo mount /dev/sdb11 //pool/data/brick1


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


sudo rm -rf \
        //pool/data/brick1/gfs \
        //pool/data/brick2/gfs \
        //pool/data/brick4/gfs \

sudo gluster volume create nine replica 3 transport tcp \
        gluster1://pool/data/brick1/gfs \
        gluster2://pool/data/brick2/gfs \
        gluster3://pool/data/brick4/gfs \




# sudo gluster volume start ones
# sudo gluster volume start dual
# sudo gluster volume start four

sudo gluster volume start nine
sudo gluster volume status
sudo gluster volume info

# could be in fstab
sudo mount -t glusterfs localhost:/nine /pool/repo -o _netdev

