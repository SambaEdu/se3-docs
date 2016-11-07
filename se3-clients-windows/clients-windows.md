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

* **Windows 10 pro 64 bits**  
L'installeur peut être téléchargé directement chez microsoft sans restrictions particulières, et installé sur une clé USB

* **Windows 7 Pro 32 et 64 bits**  
Il faut utiliser une version officielle sans personnalisations `OEM`, il est admis d'y ajouter les mises à jour ainsi que les drivers à l'aide d'outils tiers ( voir plus bas). En revanche aucune personnalistion de type `GPO` ne doit avoir été faite.

* **Windows XP n'est plus supporté**,  
ni par SE3, ni par Microsoft, ni par les applications récentes.  
Si vous vous posez la question d'installer des postes `windowsXP`, [installez des `clients-linux`](../pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique) !


## Installation

Installation en mode `Legacy Bios` (**surtout pas d'`UEFI` !**).

Une seule partition `windows` + la petite partition de boot qui est créée automatiquement par l'installeur. Pour cette partition, 100 Go sont largement suffisant.

Il est possible d'avoir un double-boot linux, dans ce cas vous laisserez un espace vide en partageant le disque dur en deux parties sensiblement égales.


## Ordre de boot

Boot `PXE` activé (soit systématiquement, soit manuellement avec `F12`).


## Drivers

Tous les drivers utiles doivent être installés et à jour : voir
[les outils](#outils) plus bas.


## Licence et activation

Pour `Windows7` il faut activer à l'aide d'un outil tiers…

Pour `Windows10`, aucune activation n'est requise si le poste est éligible à une installation `OEM`.


## Logiciels

Aucun logiciel installable à l'aide de `Wpkg` ne doit être installé préalablement. C'est une source de problème sans fin.

Partez d'une installation de `Windows` de base et laissez le serveur `Wpkg` gérer les applications à installer.


## Outils

…à venir…
