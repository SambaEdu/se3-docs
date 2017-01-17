# Installation automatique d'un `Se3`

…article en chantier…

* [Préliminaire](#préliminaire)
* [Le fichier `preseed`](#le-fichier-preseed)
* [Incorporer le fichier `preseed` à l'archive d'installation](#incorporer-le-fichier-preseed-à-larchive-dinstallation)
* [Utiliser l'archive d'installation personnalisée](#utiliser-larchive-dinstallation-personnalisée)
* [Solution alternative](#solution-alternative)
* [Références](#références)


## Préliminaire

L'objectif est de créer un `CD d'installation` complètement automatisé de son `SE3 Wheezy`, ainsi, avec ce `CD` *personnalisé* et une sauvegarde de son `SE3`, cela permettra très rapidement de (re)-mettre en production son `SE3`, que ce soit sur la même machine ou sur une autre machine.


## Le fichier `preseed`

Il faut commencer par (re)-créer son fichier `preseed` en utilisant [l'interface ad doc](http://dimaker.tice.ac-caen.fr/dise3xp/se3conf-xp.php?dist=wheezy).

Les explications sont dans la [documentation création du fichier `preseed`](http://wwdeb.crdp.ac-caen.fr/mediase3/index.php/Installation_sous_Debian_Wheezy_en_mode_automatique)


Il faut ensuite télécharger les fichiers **se3.preseed** et **setup_se3.data** ainsi créés en remplaçant les xxxx par le nombre qui convient :
```sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/xxxx/se3.preseed
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/xxxx/setup_se3.data
```

Il faut effectuer des modifications du `preseed` pour une automatisation complète :
```sh
nano ./se3.preseed
```
#MODIFIE, pour éviter un problème de fichier corrompu avec netcfg.sh
#mais cela poses peut être des problèmes par la suite car pas de réseau juste dans l'installateur
#d-i preseed/run string netcfg.sh
#AJOUTE, pour indiquer le miroir et eventuellement le proxy pour atteindre le miroir
#Mirror settings
#If you select ftp, the mirror/country string does not need to be set.
#d-i mirror/protocol string ftp

d-i mirror/country string manual
d-i mirror/http/hostname string ftp.fr.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
#AJOUTE, pour evite de répondre à la question
#Some versions of the installer can report back on what software you have
#installed, and what software you use. The default is not to report back,
#but sending reports helps the project determine what software is most
#popular and include it on CDs.
popularity-contest popularity-contest/participate boolean false
#AJOUTE, pour installer par exemple les packages des modules du se3 mais j'ai pas essayé
#Individual additional packages to install
#d-i pkgsel/include string backuppc ...
#Whether to upgrade packages after debootstrap.
#Allowed values: none, safe-upgrade, full-upgrade
#d-i pkgsel/upgrade select none
#MODIFIE Preseed commands
----------------
d-i preseed/early_command string cp /cdrom/setup_se3.data ./; \
    cp /cdrom/se3.preseed ./; \
    cp /cdrom/se3scripts/* ./; \
    chmod 755 se3-early-command.sh se3-post-base-installer.sh install_phase2.sh; \
    ./se3-early-command.sh se3-post-base-installer.sh 

Il faut aussi télécharger les fichiers suivants qui seront aussi nécessaires
```sh
mkdir ./se3scripts
cd se3scripts
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/se3-early-command.sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/se3-post-base-installer.sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/sources.se3
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/install_phase2.sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/profile
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/bashrc
cd ..
```


## Incorporer le fichier `preseed` à l'archive d'installation


## Utiliser l'archive d'installation personnalisée


## Solution alternative


## Références

Voici quelques références que nous avons utilisé pour la rédaction de cette documentation :

* Article du site [`Debian Facile`](https://debian-facile.org) : [preseed debian](https://debian-facile.org/doc:install:preseed) qui décrit l'incorporation d'un fichier `preseed`.
* …

