# Clients-Linux et Wifi

Si on désire placer des clients linux dans une salle dépourvue de cablage réseau, alors on pourra utiliser le wifi.

## Installation du client-linux

L'installation devra d'abord se faire par installation automatique à l'aide de prise réseau `RJ45`. Celle-ci sera très rapide et automatisée (Le script s'arretera néanmoins pour demander le nom netbios du poste).

**Remarque :** On ne fera pas encore de réservation d'IP par le se3 puisque l'adresse mac utilisée est ici celle de la carte eth0, et non celle de la carte wifi (wlan0).

Une fois une session réseau ouverte un première fois (pour générer le skel, et faire tous les transferts de fichiers volumineux), on redémarre…


## Configuration du Wifi

…puis on se logue avec un compte local.

Il faut maintenant désactiver la gestion du wifi par network-manager, et indiquer les informations de connexion au fichier `/etc/network/interfaces`.

Sur un terminal en root du client, on lance la commande suivante :
```sh
apt-get remove --purge network-manager
```

On modifie ensuite le fichier de configuration réseau
```
nano /etc/network/interfaces
```
On peut commenter toutes les lignes relatives à eth0, cela évitera qu'au démarrage le poste cherche une adresse ip par dhcp (qu'il ne trouvera pas) et ne fasse perdre du temps.

Ensuite, on ajoutera les lignes suivantes en remplaçant évidemment les données par celles du réseau (et wlan0 le cas échéant par le nom de la carte utlisée).

```
# My wifi device
auto wlan0
iface wlan0 inet dhcp
wpa-ap-scan 1
wpa-scan-ssid 1
wpa-essid xxxxx
wpa-psk xxxxxxxxxx
```

**Remarques:**  
- Les lignes "wpa-ap-scan 1" et "wpa-scan-ssid 1" ne sont nécéssaires que si le réseau est un réseau caché.

- On n'oubliera pas de modifier les droits d'accès au fichier /etc/network/interfaces pour éviter que quelqu'un ne récupère la clef wifi :
```sh
chmod 600 /etc/network/interfaces
```

On peut redémarrer le poste. La connexion wifi doit maintenant se faire lors du boot (vérifiable dans les lignes de diagnostic). On pourra maintenant faire une réservation d'IP avec l'interface du se3.

