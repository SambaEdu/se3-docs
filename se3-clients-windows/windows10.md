# Intégration des `clients-windows10`

Voici la procédure pour intégrer un `windows10` à un domaine géré par un `se3`.


## Prérequis

Il est nécessaire que le serveur `se3` soit au minimum en **Wheezy 3.0.5**. Le paquet **sambaedu-client-windows** doit être installé

Une recommendation : partez d'un `windows10` de base, c'est-à-dire uniquement avec `windows10`, rien d'autre. Ou refaites une installation propre à l'aide du paquet **sambaedu-client-windows**, c'est automatisé et cela permet d'avoir un poste compatible à 100 % avec SambaEdu

Les instructions complètes sont ici  :




**note**
Pour le moment l'installation automatique ne permet pas de partitionner le disque  avec un espace libre pour installer un `client-linux`.


## Intégration (osbsolète, ne pas utiliser !!!)

1. Ouvrir une session en administrateur local  
2. Se connecter à \\\\ip_du_serveur_se3\Progs\install\domscripts ou \\\\se3\progs\install\domscripts avec l'identifiant "adminse3"  
3. Fusionner **Win10-Samba44.reg** (clique droit sur Win10-Samba44.reg → Fusionner)  
cela va ajouter les clés de registre à la base de registre et le répertoire `netlogon` devient accessible comme sur un `windows7`  

Parfois un problème de droits sur le fichier **Win10-Samba44.reg**  empêche la fusion dans la base de registre du poste. Il faut alors le copier sur le bureau tout simplement et le fusionner depuis cet endroit. 

4. Exécuter **rejointSE3.exe**  
la suite est identique à l'intégration d'un `windows7`

Il arrive que l'intégration bloque à une étape, il suffit de redémarrer le poste pour que la procédure continue.

**Astuce :** afin de pouvoir fusionner le fichier reg directement sans passer par une clé `usb`, on ne se connecte pas à \\\se3\netlogon\domscripts directement mais au dossier cité précedemment qui est un lien.


**Astuce 2 :** Il faut bien penser à **désactiver la mise en veille** des postes pour que l'intégration se fasse correctement.


**Astuce 3 :** Si le poste était auparavant intégré en W7/w10 , et que w10 a été déployé avec une image contenant
les utilisateurs *administrateur* et *adminse3* , utilisateurs faisant bien partie du groupe *administrateur*,que la fusion du fichier **Win10-Samba44.reg** a été faite sur cette image, alors l'integration peut se faire à distance par l'interface. On va dans le *module DHCP*, *réservations actives*, puis *réintégrer le poste*.


## Références

* recommendations pour les [clients-windows](../se3-clients-windows/clients-windows.md#prérequis-pour-lintégration-de-clients-windows).
* installation des [clients-linux](../pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique).

