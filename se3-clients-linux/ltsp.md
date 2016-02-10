# Installation d'un serveur LTSP avec une carte ethernet

## Pre-requis

* Avec le module tftp de l'interface web du se3, installer sur votre (futur) serveur LTSP une distribution Debian Wheezy avec intégration au domaine SE3 (avec fichier preseed)
* Dans le module dhcp de l'interface web du se3, réserver l'adresse IP du poste que vous venez d'installer.
* Dans le dossier clients-linux/ltsp (accessible sur le bureau d'un poste Debian Wheezy intégré au se3), renseigner le fichier addr_MAC_clients (vide par défaut) en y indiquant l'addresse MAC (une par ligne) des postes que vous voulez configurer en clients légers.
* Si vos clients légers sont dans la réservation active du dhcp du se3, il faut les supprimer.


## Installation du serveur LTSP

* S'identifier sur votre (futur) serveur LTSP avec les identifiants admin du se3.
* Ouvrir un terminal, s'identifier en tant que root, puis saisir :
`cd /mnt/_admin/clients-linux/ltsp/`
* Executer le script d'installation d'un serveur pour 1 carte réseau :
`bash installation_LTSP_1carte_wheezy.sh`

* Pendant l'installation, on vous demandera l'adresse IP de fin de la plage dynamique et celle de début de la plage de réservation (ces adresses sont facilement récupérable via le module dhcp de l'interface web du se3) : les adresses IP affectées aux clients légers seront prises entre ces deux bornes.

## A faire après l'installation du serveur LTSP

* Se connecter au serveur SE3 en ssh
* Créer un lien symbolique vers le group de clients légers. Pour cela, saisir :
`ln -s /home/netlogon/clients-linux/ltsp/dhcpd_ltsp.conf /etc/dhcp/dhcpd_ltsp.conf"`
* Puis, via l'interface web du se3, dans le menu "configuration" du module DHCP, renseigner le fichier de configuration à inclure pour le group de vos clients légers :
`/etc/dhcp/dhcpd_ltsp.conf`
* Enfin, valider la modification (le serveur DHCP va redémarrer et inclure ce fichier de conf) et vérifier que le serveur DHCP du se3 redémarre.
* Vous pouvez désormais démarrer vos clients légers et vérifier que tout fonctionne.
