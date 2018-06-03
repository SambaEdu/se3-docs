Installation d'un partage nfs pour effectuer des sauvegardes **backuppc** , **par scripts** ou de **VM proxmox**.

On ne le dira jamais assez, il est indispensable de faire des sauvagardes de ses données. L'idéal étant que les sauvegardes ne soient **pas dans le même espace physique que les serveurs** (en cas d'incendie, d'inondation,etc).

Si on ne dispose pas d'un NAS, on peut utiliser un vieux serveur qui sera relié au switch principal en Gigabyte. Ce serveur doit être équipé de disques neufs (ou alors on prends des risques).

On dispose ici d'un disque de petite contenance sda pour installer le système (distrib debian serveur).On a aussi deux disques sdb et sdc identiquesde capacité importante.

On va créer un raid1 (mirroring) logiciel entre sdb et sdc. Ce raid sera monté ensuite dans le système. Les disques sont des disques sata, aucune carte raid n'est nécessaire puisqu'il s'agit d'un raid logiciel et donc géré par Débian.

Il n'est pas du tout obligatoire de faire un raid logiciel (utiliser un raid rajoute une probabilité de problème logiciel). On pourra suivre le mode opératoire en zappant la partie raid et en remplaçant /dev/md0 par /dev/sdb1 (si disque sdb1)




* [installation de la debian server](#installation-de-la-debian-server)
* [Création du raid1 logiciel](#création-du-raid1-logiciel)
* [Montage du raid](#montage-du-raid)
* [Création du partage nfs](#création-du-partage-nfs)
* [Montage du partage nfs sur le se3 ou noeud proxmox](#montage-du-partage-nfs-sur-le-se3-ou-noeud-proxmox)
     * [Montage du partage nfs pour backuppc](#montage-du-partage-nfs-pour-backuppc)
     * [utilisation du partage nfs pour Proxmox](#utilisation-du-partage-nfs-pour-proxmox)



# installation de la debian server 
* On boot avec un livecd netinstall debian stretch (https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.4.0-amd64-netinst.iso)
* On choisit le mode avancé (pas graphical install qui est inutile pour un serveur).
* On choisi le nom, mots de passe root et utilisateurs.
* On va partitionner le disque sda  choisir "mode assisté, utiliser un disque entier". Valider.
* On va aussi créer une partition sdb1 (et sdc1 si on veut faire un raid logiciel plus tard). On clique sur sdb et on valide pour faire une partition utilisant le disque entier.Idem pour sdc.

Ainsi sdb1 (et sdc1 sont créées). 2.png

* Lire un autre cd :non

* Choix du miroir
On peut utiliser celui du se3 (apt-cacher). On montera jusqu'à choisir **manuel**
Nom d'hote du miroir de l'archive debian: **http://172.20.0.2:9999** 
On valide puis on entre **/ftp.fr.debian.org/debian/**

* Choix du proxy: on entre celui de l'Amon (ex: http://172.20.0.1:3128)
* Choix des logiciels à installer: seulement **serveur ssh et utilitaires usuels du système.**
* Installer le grub sur le disque sda (ainsi, pas de problème en cas de changement de config du raid).
* on redémarre.

On réservera une ip pour le serveur sur le dhcp du se3 ou on pourra modifier le fichier /etc/network/interface
```
auto enp0s3
iface enp0s3 inet static  
address 172.20.0.6
netmask 255.255.0.0
gateway 172.20.0.1
```

# Création du raid1 logiciel
* On installe le paquet mdadm
```
apt-get install mdadm
```
* On indique que les partitions sdb1 et sdc1 vont servir pour le raid1
```
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

Le raid est maintenant créé sous le device md127.
```
mdadm --examine --scan --verbose >> /etc/mdadm/mdadm.conf
update-initramfs -u -k all

```
On redémarre le serveur pour que le raid soit bien sous le bon nom /dev/md0 (il peut apparaitre sous le nom /dev/md126 ou md127) .
Un lsblk permet de vérifier que sdb et sdc sont bien dans md0.

Il faut maintenant le formater .
```
mkfs.ext4 /dev/md0
```

# Montage du raid
```
mkdir /home/partage-nfs

nano /etc/fstab
```
On ajoute les lignes relatives au montage du raid
```
/dev/md0      /mhome/partage-nfs     ext4      defaults      0      2
```
On lance ensuite
```
mount -a
```
Normalement la commande lsblk doit donner une arborescence de ce genre:

```
NAME   MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda      8:0    0    20G  0 disk
├─sda1   8:1    0    19G  0 part  /
├─sda2   8:2    0     1K  0 part
└─sda5   8:5    0  1022M  0 part  [SWAP]
sdb      8:16   0 100,6G  0 disk
└─md0    9:0    0 100,6G  0 raid1 /home/partage-nfs
sdc      8:32   0 100,6G  0 disk
└─md0    9:0    0 100,6G  0 raid1 /home/partage-nfs
sr0     11:0    1  1024M  0 rom
```

# Création du partage nfs

Il faut ajouter les sources non-free dans les paquets

```
nano /etc/apt/sources.list
```
On ajoute "contrib et non-free" après "main" sur les dépots existants.

```
apt-get update
apt-get upgrade
apt install nfs-kernel-server nfs-common
```
Un fichier  de configuration /etc/exports a été créé. C'est dans ce fichier qu'on va indiquer l'emplacement physique du partage, et les ip des clients autorisés à se connecter.

```
nano /etc/exports
```

On ajoute dans le fichier (en remplaçant IP_client1 par l'ip du poste autorisé à se connecter, donc l'ip du se3, ou d'un serveur proxmox. On peut évidemment ajouter plusieurs clients )

```
/home/partage-nfs IP_client1(rw,no_subtree_check,sync,no_root_squash) IP_client2(rw,no_subtree_check,sync,no_root_squash)
```
On relance le service
```
service nfs-kernel-server restart nfs
```

Remarque: On peut aussi créer deux  sous répertoires dans /home/partage-nfs: un backuppc pour faire les sauvegardes backuppc, puis un autre pour les exports de vm ou les sauvegardes par script.

Dans ce cas, on mettra dans le fichier/etc/export une ligne personnalisée pour chaque partage.

# Montage du partage nfs sur le se3 ou noeud proxmox

## Montage du partage nfs pour backuppc
Sur le se3, on fera le montage de façon manuelle pour voir si le partage fonctionne.
```
mount -t nfs 172.20.0.6:/home/partage-nfs /var/lib/backuppc/
mount
umount /var/lib/backuppc
```
Il sera préferable d'ajouter une ligne de montage automatique au fichier /etc/fstab

```
172.20.0.6:/home/partage-nfs /var/lib/backuppc nfs rw 0 2
```
puis
```
mount -a
mount
```
On regarde si le montage est maintenant bien fait. On ira aussi vérifier sur l'interface du se3 (partie sauvegarde>configuration) si le nouvel espace de stockage est bien pris en compte.

On doit remettre les bons droits à backuppc

```
chown -R backuppc:backuppc /var/lib/backuppc
chmod -R 775 /var/lib/backuppc
```
## utilisation du partage nfs pour Proxmox
On ira dans l'interface proxmox. Ajout stokage > NFS>
ID: partage-nfs (ou ce que vous voulez!)
serveur: ip du partage nfs
export: /home/partage-nfs
Contenu: ce que vous voulez (iso, sauvegardes de machines,etc.)









