# Intégration des `clients-windows10`

Voici la procédure pour intégrer un `windows10` à un domaine géré par un `se3`.


## Prérequis

Il est nécessaire que le serveur `se3` soit au minimum en **Wheezy 3.0.2**.

Une recommendation : partez d'un `windows10` de base, c'est-à-dire uniquement avec `windows10`, rien d'autre. Et avec un espace libre pour installer un `client-linux`.


## Intégration

1. Ouvrir une session en administrateur local  
2. Se connecter à \\\\ip_du_serveur_se3\Progs\install\domscripts ou \\\\se3\progs\install\domscripts avec l'identifiant "adminse3"  
3. Fusionner **Win10-Samba44.reg** (clique droit sur Win10-Samba44.reg → Fusionner)  
cela va ajouter les clés de registre à la base de registre et le répertoire `netlogon` devient accessible comme sur un `windows7`  

Parfois un problème de droits empêche la fusion du fichier.reg. Il faut alors le copier sur un disque local et le fusionner depuis ce disque. 

4. Exécuter **rejointSE3.exe**  
la suite est identique à l'intégration d'un `windows7`

**Astuce :** afin de pouvoir fusionner le fichier reg directement sans passer par une clé `usb`, on ne se connecte pas à \\\se3\netlogon\domscripts directement mais au dossier cité précedemment qui est un lien.



## Références

* recommendations pour les [clients-windows](../se3-clients-windows/clients-windows.md#prérequis-pour-lintégration-de-clients-windows).
* installation des [clients-linux](../pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique).

