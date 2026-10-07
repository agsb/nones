
# sudo gluster volume start ones
# sudo gluster volume start dual
# sudo gluster volume start four

sudo gluster volume start nine
sudo gluster volume status
sudo gluster volume info

# could be in fstab
sudo mount -t glusterfs localhost:/nine /pool/repo -o _netdev

