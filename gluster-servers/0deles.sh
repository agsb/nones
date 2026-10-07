
for vol in ones dual four nine ; do
        sudo gluster volume stop ${vol} && \
                sudo gluster volume delete ${vol}
done

