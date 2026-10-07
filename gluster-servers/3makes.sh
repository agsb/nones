sudo rm -rf \
        //pool/data/brick1/gfs \
        //pool/data/brick2/gfs \
        //pool/data/brick4/gfs \

sudo gluster volume create nine replica 3 transport tcp \
        gluster1://pool/data/brick1/gfs \
        gluster2://pool/data/brick2/gfs \
        gluster3://pool/data/brick4/gfs \



