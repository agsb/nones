
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

