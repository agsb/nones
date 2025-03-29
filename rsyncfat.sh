#/usr/bin/bash
#rsync --progress --modify-window=1 --update --recursive --times --size-only $@
#mount -t vfat -o remount,user,noauto,noexec,nodev,nosuid,nodiratime,shortname=mixed,iocharset=utf8 
rsync --recursive --update --times --size-only --modify-window=4 $@
