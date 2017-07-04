# Intégration des `clients-windows10`

Voici la procédure pour intégrer un `windows10` à un domaine géré par un `se3`.


## Prérequis

Il est nécessaire que le serveur `se3` soit au minimum en **Wheezy 3.0.2**.

Une recommendation : partez d'un `windows10` de base, c'est-à-dire uniquement avec `windows10`, rien d'autre. Et avec un espace libre pour installer un `client-linux`.


## Intégration

1. Ouvrir une session en administrateur local
2. Se connecter à \\\\ip_du_serveur_se3\Progs\install\domscripts
3. Fusionner **Win10-Samba44.reg**  
cela va ajouter les clés de registre à la base de registre et le répertoire `netlogon` devient accessible comme sur un `windows7`.
4. Exécuter **rejointSE3.exe**  
la suite devrait être identique à l'intégration d'un `windows7`.

**Astuce :** afin de ne pas avoir à utiliser de clé `usb`, on ne se connecte pas à netlogon :
- Accès à \\\\se3 puis login / pass admin
- ensuite progs\install\domscripts → qui est un lien vers \\\se3\netlogon\domscripts
- Fusion du .reg
- Lancement de rejoinSE3.exe. La suite fonctionne puisque l'accès à netlogon est autorisé par le .reg précédent.
- enjoy


## Références

* recommendations pour les [clients-windows](../se3-clients-windows/clients-windows.md#prérequis-pour-lintégration-de-clients-windows).
* installation des [clients-linux](../pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique).

