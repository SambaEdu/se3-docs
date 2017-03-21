# Intégration des `clients-windows10`

Voici la procédure pour intégrer un `windows10` à un domaine géré par un `se3`.


## Prérequis

Il est nécessaire que le serveur `se3` soit au minimum en **Wheezy 3.0.2**.


## Intégration

1. Ouvrir une session en administrateur local
2. Se connecter à \\\\ip_du_serveur_se3\Progs\install\domscripts
3. Fusionner **Win10-Samba44.reg**  
cela va ajouter les clés de registre à la base de registre et le répertoire `netlogon` devient accessible comme sur un `windows7`.
4. Exécuter **rejointSE3.exe**
la suite devrait être identique à l'intégration d'un `windows7`.

