# A simple script for use glusterfs

agsb@2026

  Este é um roteiro simplificado e minimo, para instalação e testes dos sistemas de arquivos btrfs e glustefs.

  Depois de realizado, temos um ambiente que podera ser testado
  
## Instalção basica para uso de Glusterfs e Btrfs

  Criar 3 hosts com Debian 13.5 e 64 Gb em partição principal. 
  
  Um dos hosts deve ter uma partição secundaria de no minimo 400 Gb.

  Todas as partições devem ser formatadas em BTRFS.

  Nos 3 hosts:
  
    1. Criar tres usuarios gfsm, gfst e gfsc, com os mesmos UID e GID, acima de 2000. 
        ( No glusterfs as permissoes do sistema de arquivo sao herdadas da maquina host que disponibiliza o serviço )
    
    2. Instalar/Atualizar os pacotes: 

        sudo apt update
        
        sudo apt install btrfs iproute2 glusterfs-common glusterfs-client glusterfs-server glusterfs-cli

    3. Inicializar os serviços de glusterfs ( apenas na 1a vez )
  
        sudo systemctl start   glusterfs
        
        sudo systemctl enable  glusterfs

    3. Criar ipv4 alias da interface de rede ethernet ligada na rede comum aos 3 hosts:
            o HOST deve ser de cada maquina, eg. 21 (host com a partição secundária de 400Gb), 22, 23, 24
            
# mask interfaces, one ethernet to rule all
NETW="192.168.10."
MASK="/24"
HOST="21"
DEVICE=`ifconfig | grep 'mtu 1500'  | head -1 | cut -f1 -d:`
echo "$DEVICE = ${NETW}${HOST}${MASK}"
sudo ip addr add ${NETW}${HOST}${MASK} dev $DEVICE
exit

    4. Criar no arquivo /etc/hosts, tres IPV4 correspondentes aos 3 hosts e um IPV4 extra de reserva, 
        eg.  24 como extra

# atualizar hosts
# verify if already done
grep 'glusterfs setup' /etc/hosts && exit
# else 
NETW="192.168.10."
sudo tee -a /etc/hosts << END
# ~~~ glustefs setup ~~~~
 ${NETW}21      gfone
 ${NETW}22      gftwo
 ${NETW}23      gfsix
 ${NETW}24      gften
END        
exit

    5. Criar os diretorios de montagem

        mkdir -p /var/shared/pool

        mkdir -p /var/log/pool

## No servidor 
     
  1. No host que tem a partição secundaria de 400 Gb, eg gfone, executar 

# identificar a particao por blkid
# BLKID-UUID=` blkid /dev/sd?????`
# teste de montagem da particao formatada em btrfs 
  sudo mount -t btrfs UUID=${BLKID-UUID} /var/shared/pool
# incluir no /etc/fstab NNN-UUID-MMMM é o valor do BLKID-UUID
  UUID=NNN-UUID-MMMM  /var/shared/pool  btrfs  defaults,nodev,noatime,owner 0 0 

  2. Criar o glusterfs no diretorio
  
sudo gluster volume create base gfone://var/shared/pool
        
  3. Incluir no script de boot do host gfone  

sudo mount -t btrfs UUID=${BLKID-UUID} /var/shared/pool
sudo gluster volume start base
sudo gluster volume status
sudo gluster volume info

  4. Criar diretorios com permissoes para usuarios etc

## No Cliente

  1. Verificar o acesso e montar o filesystem remoto

sudo mount -t glusterfs gfone:/base /var/share/pool/base -o _netdev
sudo gluster volume status
sudo gluster volume info

  2. incluir no /etc/fstab

gfone:/base /var/share/pool/base glusterfs defaults,nodev,noatime,owner,_netdev 0 0

  3. Incluir no script de boot do host cliente  

sudo mount -t glusterfs gfone:/base /var/share/pool/base -o _netdev
sudo gluster volume start base
sudo gluster volume status
sudo gluster volume info

## Teste de carga de arquivos

  Em uma das maquinas clientes gftwo ou gfsix ou gften
  
  1. Script para arquivos :

#/usr/bin/bash

# creates files with BLOCK * 4096 random bytes
# uses SLICE * 4 GB of disk
# agsb@ 2025

SECTOR=4096

BLOCK=$1

BLOCK=${BLOCK:=1}

SLICE=$2

SLICE=${SLICE:=1}

BLOCK=$(( BLOCK * 4096 ))

SLICE=$(( SLICE * 4096 * 1024 * 1024 ))

FILES=$(( SLICE / BLOCK ))

COUNT=$(( BLOCK / SECTOR ))

echo $SLICE in $FILES files of $BLOCK bytes with $COUNT sectors of 512 bytes

echo "Continue y/N ?"

read yes

if [ $yes != "Y" ] && [ $yes != "y" ] ; then
        echo Aborting...
        exit 0
fi

echo Continue...

NDIR=$BLOCK-`uuid`

mkdir $NDIR

# mark init
touch in0

cd $NDIR

# generate files

for n in $( seq 1 ${FILES} ) ; do
    echo $n
    # each dd is N * 512 bytes
    dd if=/dev/random of=`uuid` count=${COUNT}
done

cd ..

# mark ends
touch in1

exit

  2. Script para remover os arquivos criados

# mantem os arquivos de tempo in0 e in1
cd $1 
for j in 0 1 2 3 4 5 6 7 8 9 0 a b c d e f ; 
  do for i in 0 1 2 3 4 5 6 7 8 9 a b c d e f ; 
    do 
      rm ${j}${i}*  
    done  
  done
cd .. 
exit


## Extras, a posteriori

  1. Replicação automatica
  
# sudo gluster volume create base replica 3 transport tcp \
  # glone://pool/data/brick1/gfs gltwo://pool/data/brick2/gfs glsix://pool/data/brick6/gfs 
