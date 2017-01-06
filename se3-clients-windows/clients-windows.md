# Prérequis pour l'intégration de `clients-windows`

Ceci correspond aux configurations testées et validées pour l'intégration de postes `Windows` à un domaine `SE3`. Vu l'infinité de situations possibles, seules ces configurations sont supportées et feront l'objet d'une assistance.

* [Système](#système)
* [Installation](#installation)
* [Ordre de boot](#ordre-de-boot)
* [Drivers](#drivers)
* [Licence et activation](#licence-et-activation)
* [Logiciels](#logiciels)
* [Outils](#outils)


## Système

Il faut impérativement partir d'un poste fraîchement installé. Le temps perdu à refaire une installation propre sera toujours du temps qu'on ne perdra pas ensuite à résoudre des incompatibilités.

* **`Windows10` Pro 64 bits**  
L'installeur peut être téléchargé directement chez `Microsoft` sans restrictions particulières, et installé sur une clé `USB`.

* **`Windows7` Pro 32 et 64 bits**  
Il faut utiliser une version officielle sans personnalisations `OEM`, il est admis d'y ajouter les mises à jour ainsi que les drivers à l'aide d'outils tiers : voir
[les outils](#outils) plus bas. En revanche aucune personnalistion de type `GPO` ne doit avoir été faite.

* **`WindowsXP` n'est plus supporté**, ni par `SE3`, ni par `Microsoft`, ni par les applications récentes.  
Si vous vous posez la question d'installer des postes `windowsXP`, [installez des `clients-linux`](../pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique) !


## Installation

Installation en mode `Legacy Bios`. **Surtout pas d'`UEFI` !**.

Une seule partition `windows` + la petite partition de boot qui est créée automatiquement par l'installeur. Pour cette partition, 100 Go sont largement suffisant.

Une astuce permet d'éviter la création de la partition de boot de 100Mo créée automatiquement à l'installation de Windows 7. Cela simplifie le clonage et la création d'images. Voici comment procéder.

**Avant de lancer l'installation de Windows** (par exemple avec gparted inclu dans SystemRescuCD via le boot PXE) :
* supprimer toute partition du disque,
* (re)créer une table de partition ms-dos (pas de gpt),
* créer la partition destinnée à recevoir l'OS (100G suffisent),
* formater cette partition en NTFS.

Ainsi, lors de l'installation, en choisisannt cette partition, la partition de boot de 100Mo ne sera pas créée.

Il est possible d'avoir un double-boot `Gnu/Linux`, dans ce cas [vous laisserez un espace vide](../pxe-clients-linux/utilisation.md#installation-en-double-boot) en partageant le disque dur en deux parties sensiblement égales.


## Ordre de boot

Boot `PXE` activé (soit systématiquement, soit manuellement avec `F12`).


## Drivers

Tous les drivers utiles doivent être installés et à jour : voir
[les outils](#outils) plus bas.


## Licence et activation

Pour `Windows7` il faut activer à l'aide d'un outil tiers…

Pour `Windows10`, aucune activation n'est requise si le poste est éligible à une installation `OEM`. Ceci implique généralement que les clés OEM SLIC V2.4 soient intégrées au Bios. Ce n'est malheureusement pas toujours le cas. On a alors deux possibilités légales pour éviter de devoir faire l'activation : intégrer les clés au Bios si on les possède, ou installer à partir du DVD OEM du constructeur.

''Attention'' Ne pas télécharger et utiliser Windows Loader pour Windows 10 : c'est un faux, qui en revanche installe de vrais virus !


## Logiciels

Aucun logiciel installable à l'aide de `Wpkg` ne doit être installé préalablement. C'est une source de problème sans fin.

Partez d'une installation de `Windows` de base et laissez le serveur `Wpkg` gérer les applications à installer.


## Outils

…à compléter…
* [Obtenir des ISO légalement](http://www.downflex.com/)
* [Pack de drivers](https://sdi-tool.org/)
* [Créer une clé USB bootable](http://www.winsetupfromusb.com/)
* [Créer une ISO personnalisée](http://rt7lite.com/)
* [Sauvegarder et restaurer l'activation](http://joshcellsoftwares.com/products/advancedtokensmanager/) ([Documentation](http://www.pcastuces.com/pratique/windows/sauvegarder_activation/page1.htm))
