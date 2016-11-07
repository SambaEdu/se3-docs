#Prérequis pour l'intégration de clients windows

Ceci correspond aux configurations testées et validées pour l'intégration de postes Windows à un domaine SE3. Vu l'infinité de situations possibles, seule ces configurations sont supportées et feront l'objet d'une assistance.

##Système : 
Il faut impérativement partir d'un poste fraîchemet installé. Le temps perdu à refaire une installation propre sera toujours du temps qu'on ne perdra pas ensuite à résoudre des incompatibilités. 
* Windows 7 Pro 32 et 64 bits. Il faut utiliser une version officielle sans personnalisations OEM, il est admis d'y ajouter les mises à jour ainsi que les drivers à l'aide d'outils tiers ( voir plus bas). En revanche aucune personnalistion de type GPO ne doit avoir été faite

* Windows 10 pro 64 bits l'iso à jour peut être téléchargée directement chez microsoft, et installée sur une clé USB

##Installation :
installation en mode Legacy Bios (surtout pas d'UEFI !), une seule partition windows + la petite partition de boot qui est créée automatiquement par l'installeur. Il est possible d'avoir un double boot linux, dans ce cas les partitions linux doivent être les suivantes.

##Ordre de boot :
Boot PXE activé (soit systématiquement, soit manuellement avec F12)

##Drivers : 
Tous les drivers utiles doivent être installés et à jour, voir les outils plus bas

##Licence et activation : 
Pour Windows 7 il faut activer à l'aide d'un outil tiers... Pour Windows 10, aucune activation n'est requise si le poste est éligible à une installation OEM

##Logiciels :
AUCUN logiciel installable à l'aide de Wpkg ne doit être installé préalablement. C'est une source de problème sans fin.
