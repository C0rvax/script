#!/bin/bash
arc=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
fram=$(free -m | awk '$1 == "Mem:" {print $2}')                                      # definie la chaine de char "Mem:" comme le $1 et imprime $2 (cad le suivant)
uram=$(free -m | awk '$1 == "Mem:" {print $3}')                                      # même chose mais imprime le $3 (donc 2 après lui)
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')                        # on imprime le resultat $3/$2*100 en pourcentage 2 chiffres après la virgule (%.2f) (pas sur de moi)
fdisk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}') # grep -v 'x' : lignes qui ne contiennent pas x {ft += $2} END additionne ce qu'il y a dans la 2e col dans toutes les lignes
udisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}') # print $1 + $3 avec %.1f%% en arg de printf (cad float 1 chiffre apres la virgule terminé par un sign pourcentage)
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(ss -neopt state established | wc -l)
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | grep "ether" | awk '{print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
#Architecture: $arc
#CPU physical: $pcpu
#vCPU: $vcpu
#Memory Usage: $uram/${fram}MB ($pram%)
#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
#CPU load: $cpul
#Last boot: $lb
#LVM use: $lvmu
#Connections TCP: $ctcp ESTABLISHED
#User log: $ulog
#Network: IP $ip ($mac)
#Sudo: $cmds cmd"
echo $pram
fdisk2=$(df -BG | grep '^/dev/' | grep -v '/boot$')
echo $fdisk2
echo $fdisk
echo $udisk
