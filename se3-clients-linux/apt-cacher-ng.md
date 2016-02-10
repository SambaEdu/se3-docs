# Mise en place d'apt-cacher-ng

`apt-cacher-ng` est un service de proxy APT. En clair, lors de
la mise à jour d'un client Linux, au lieu de récupérer les
nouvelles versions des packages directement via les dépôts
Debian, celui-ci va interroger le service apt-cacher-ng qui
à son tour va se charger de récupérer les mises à jours et
de les stocker en local. La prochaine fois qu'un autre
client Linux voudra effectuer la même mise à jour, il pourra
la récupérer directement via le serveur apt-cacher-ng ce qui
évitera de solliciter à nouveau la connexion Internet.
`apt-cacher-ng` est donc une sorte de miroir local qui se
remplit au fur et à mesure et qui évite la gestion d'un miroir local complet, d'autant plus que la pluaprt des paquest seront non utilisés.

Le module `clients-linux` du se3 met en œuvre cette solution `apt-cacher-ng` et le miroir local est stocké directement dans un répertoire du serveur se3. Ce qui peut poser des problèmes de place lorsqu'on a des disques durs de petites tailles (par exemple, 2 disques de 160 Go).

La solution présentée ici est d'utiliser un serveur supplémentaire qui stockera le miroir géré par `apt-cacher-ng` : le répertoire du serveur complémentaire contenant les données est monté dans le répertoire du se3 dédié à cette fonction.

On pourra s'inspirer de cette solution pour stocker sur le même serveur supplémentaire `des données de volume important`, données utilisées par vos collègues de langues ou de techno avec des vidéos par exemple : on peut leur créer un répertoire dédié accessible via le raccourci sur le Bureau "Docs sur le réseau", à renommer bien sûr en "Ressources sur le réseau" (c'est plus clair pour tous les utilisateurs). Ce répertoire dédié aura des droits particuliers pour que seul notre collègue puisse le voir et l'utiliser ;-) → cela se fait via l'interface web du se3.



## 1. Installer `Debian/Jessie` sur une machine

Cette machine sera un serveur distant (alice/192.168.1.4) et un
répertoire de cette machine, `/var/www/miroir/`, sera utilisé pour les paquets du
miroir `apt-cacher-ng` géré par le se3.



## 2. Sur le serveur distant `alice/192.168.1.4`

* Installer les paquets `apache2` et `nfs-kernel-server`, ainsi que `mc` (midnight-commander) :
```sh
aptitude install apache2 mc nfs-kernel-server
```

* Créer un répertoire `/var/www/miroir/` :
```sh
mkdir /var/www/miroir
```

* Pour partager `/var/www/miroir/` avec le `se3/192.168.1.3`, écrire
la ligne suivante dans `/etc/exports` :
```
/var/www/miroir 192.168.1.3(rw,no_root_squash)
```

* Relancer le service `nfs-kernel-server` :
```sh
service nfs-kernel-server restart
```
 ou bien, plus bavard :
```sh
/etc/init.d/nfs-kernel-server restart
```

* Vérifications que les services sont bien en place :
```sh
showmount -e
rpcinfo -p | grep nfs
cat /proc/filesystems | grep nfs
rpcinfo -p | grep portmap
```



## 3. Sur le serveur se3 `se3/192.168.1.3`

- voir les partages distants disponibles :
```sh
showmount -e 192.168.1.4
```

- droit root pour `/var/se3/apt-cacher-ng` avant le montage :
```sh
chown -R root:root /var/se3/apt-cacher-ng
```

- monter le répertoire distant :
```sh
mount -t nfs 192.168.1.4:/var/www/miroir /var/se3/apt-cacher-ng
```

- droits apt-cacher-ng après le montage :
```sh
chown -R apt-cacher-ng:apt-cacher-ng /var/se3/apt-cacher-ng
```

- relancer le service apt-cacher-ng :
```sh
service apt-cacher-ng restart
```

- vérifications du montage :
```sh
mount
```

- vérifications des droits : les droits en cas de montage (apt-cacher-ng) ou
démontage (root) :
```sh
ls -l /var/se3/apt-cacher-ng/ | grep apt-cacher-ng
```

- vérification que le service est opérationnel:
  - sur un client, changer le `/etc/apt/sources.list` pour mettre `192.168.1.3:9999`
  - sur ce client, lancer un `aptitude update` puis un `aptitude safe-upgrade`
  - le répertoire `/var/www/miroir` de `alice/192.168.1.4` doit se remplir.



## 4. Montage au redémarrage du se3 du répertoire distant

* Sur le se3 `se3/192.168.1.3`, ajouter dans le fichier `/etc/fstab` la ligne suivante :
```
192.168.1.4:/var/www/miroir /var/se3/apt-cacher-ng nfs _netdev,noatime,defaults 0 0
```

* Test des montages et alertes par courriel si nécessaire.
Un script à mettre dans `/root` du se3 : `espion_montage_alice.sh`
(le script est donné à la fin de cet article).

À mettre dans le crontab pour un lancement tous les jours à 8h02 :
```sh
crontab -e
```
ajouter la ligne :
```
02 08 * * * bash espion_montage_alice.sh
```

* Autre solution, non testée :
Sur le `se3/192.168.1.3`, tâche cron au démarrage (pour mémoire), rajouter la ligne suivante à la cron-table :
```
@reboot mount -t nfs 192.168.1.4:/var/www/miroir /var/se3/apt-cacher-ng
```

* Autre option : utiliser autofs ? → non testée



## 5. Pour les futures installations par pxe/preseed

* Dans l'interface du se3, décocher l'option de l'IP du miroir APT et supprimer les contenus des deux champs

* modifier les fichier preseed.



## 6. Les clients linux

- sur les clients-linux, il faudra modifier les `/etc/apt/sources.list`
en remplaçant, si on avait un miroir local, `IP_miroir/miroir` par `IP_serveur_se3:9999`
(par exemple en passant par un script unefois).



## 7. Divers

- Arrêt du service sur le `se3/192.168.1.3` :
```sh
service apt-cacher-ng stop
```

- Pour démonter le partage sur le `se3/192.168.1.3` :
```sh
umount /var/se3/apt-cacher-ng
```


****
**Annexe**
## Le script `espion_montage_alice.sh`

```sh
#!/bin/bash

##### ##### #####
#
# test du montage du répertoire distant du miroir apt-cacher-ng
# envoie d'un courriel si non monté
#
#
# version 20150609
#
#
##### ##### #####

#####
# quelques variables
MAIL_ADMIN=$(cat /etc/ssmtp/ssmtp.conf | grep root | cut -d "=" -f 2)
IP_alice="192.168.1.4"
rep_apt_cacher_ng="/var/se3/apt-cacher-ng"
COURRIEL="Le répertoire distant $IP_alice:/var/www/miroir n'est pas monté sur $rep_apt_cacher_ng"


test_montage()
{
# Le répertoire distant IP_alice:/var/www/miroir devrait être monté sur le répertoire rep_apt_cacher_ng du se3
montage=`mount | grep $IP_alice`
if [ -z "$montage" ]
then
    # le répertoire IP_alice:/var/www/miroir n'étant pas monté , on envoie un message d'alerte
    echo $COURRIEL | mail $MAIL_ADMIN -s "apt-caher-ng Se3 : répertoire non monté" -a "Content-type: text/plain; charset=UTF-8"
fi
}

#####
# début du programme
#
test_montage
exit 0
#
# fin du programme
#####
```




