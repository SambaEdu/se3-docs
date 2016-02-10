# Liste des applications à installer


* [Objectifs](#objectifs)
* [Les paquets installés](#les-paquets-installés)
    * [Liste pour la distribution](#liste-pour-la-distribution)
    * [Liste pour l'environnement de Bureau](#liste-pour-lenvironnement-de-bureau)
    * [La liste perso](#la-liste-perso)


# Objectifs

Des applications ont été sélectionnées pour que l'utilisateur ait à sa disposition des applications qui pourront être utiles pour ses diverses activités.

D'autres applications sont installées pour faciliter l'administration des `clients-linux`.

**Remarque :** par la suite, des applications pourront être installés sur les `clients-linux` à l''aide du mécanisme des scripts `unefois` (voir la documentation du paquet `se3-clients-linux`)


# Les paquets installés

Les applications sont installées à plusieurs moments du processus.

Durant la **phase 1** (installation de la distribution), les paquets suivants sont installés :

`distribution Debian` :

administration  | administration  | utilisation
----------------|-----------------|------------
openssh-server  | screen          | zip
mc              | vim             | unzip
tofrodos        | ssmtp           | geogebra
conky           | ntp             | vlc
sqlite3         | tree
gnome-tweak-tool| ldap-utils



`distribution Ubuntu` :

administration  | utilisation
----------------|---------------
openssh-server  | zip
ldap-utils      | unzip
tree            | geogebra
screen          | vlc
vim             | evince
ssmtp           |
ntp             |


Durant la **phase 2** (post-installation et intégration), les paquets installés sont issus de 3 listes :

* liste concernant la distribution (`Debian` ou `Ubuntu`)
* liste concernant `l'environnement de Bureau`
* liste perso à la discrétion de l'administrateur du serveur `se3`

Les listes se trouvent dans le répertoire `/home/netlogon/clients-linux/install/`.


## Liste pour la distribution

Selon la distribution installée, `Debian` ou `Ubuntu`, cette liste se nommera `mesapplis-debian.txt` ou `mesapplis-ubuntu.txt`.


## Liste pour l'environnement de Bureau


Selon l'environnement de Bureau choisi, Gnome, Ldce ou Xfce, cette liste se nommera `mesapplis-debian-gnome.txt`, `mesapplis-debian-ldxe.txt` ou `mesapplis-debian-xfce.txt`.


## La liste perso

Enfin, une liste perso permettra à l'administrateur de rajouter des paquets à sa convenance. Cette liste se nomme `mesapplis-debian-perso.txt`.

Nous vous recommendons **de mettre un paquet par ligne** et d'éventuellement **laisser des lignes vides** et des **commentaires** pour améliorer la lisibilité de votre liste.

Vous pourrez écrire **des commentaires** comme pour l'écriture de scripts `Bash` : il suffit de commencer vos commentaires par un `#` ; la partie de la ligne située à droite du commentaire ne sera pas prise en compte.

**Remarque :** lors des mises à jour du dispositif `pxe-clients-linux`, ce fichier `/home/netlogon/clients-linux/install/mesapplis-debian-perso.txt` est préservé, en ce sens que la mise à jour le laisse tel qu'il était lors de sa dernière modification par l'administrateur du serveur `se3`.
