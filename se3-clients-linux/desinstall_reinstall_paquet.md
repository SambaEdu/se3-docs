# Désinstallation/réinstallation du paquet se3-clients-linux

## Désinstallation complète

Si jamais vous souhaitez désinstaller complètement le paquet
`se3-clients-linux` de votre serveur, rien de plus simple.
En tant que `root` sur le serveur, il suffit de lancer la
commande suivante :

```sh
# Attention, nous vous conseillons tout de même vivement de
# procéder à une désinstallation partielle comme indiquée
# ci-dessous dans la section suivante.
apt-get purge se3-clients-linux
```

Et c'est tout. Une fois la commande ci-dessus exécutée,
votre serveur ne garde plus la moindre trace d'installation
du paquet `se3-clients-linux`.

**Attention :**  en désinstallant le paquet de la sorte
(avec `apt-get purge`), tout le répertoire
`/home/netlogon/clients-linux/` du serveur (et tout ce qu'il
contient) sera effacé. Si vous aviez pris la peine de vous
concocter un fichier `logon_perso` à votre sauce, d'écrire
de nombreux scripts dans le répertoire `unefois/` etc., tout
sera purement et simplement effacé.

## Désinstallation partielle en vue d'une réinstallation ultérieure

Avec la commande ci-dessous (où l'instruction `purge` est
remplacée par `remove`), les choses se passent un peu
différemment :

```sh
apt-get remove se3-clients-linux
```

Le paquet `se3-clients-linux` est bien désinstallé comme
dans le cas précédent, sauf que le répertoire
`/home/netlogon/clients-linux/` du serveur n'est pas
totalement effacé. Tous les fichiers/répertoires que vous
avez le droit de modifier seront conservés, si bien que
l'arborescence du répertoire ressemblera à ceci :

```sh
-- clients-linux/
    |-- bin/
    |    ‘-- logon_perso
    |-- distribs/
    |    |-- precise/
    |    |    ‘-- skel/
    |    ‘-- squeeze/
    |        ‘-- skel/
    |-- divers/
    ‘-- unefois/
```

Ainsi, après réinstallation du paquet, vous retrouverez inchangés :

* le fichier `logon_perso` ;
* tous les profils distants de chaque distribution prise en charge ;
* le contenu du répertoire `divers/` ;
* le contenu du répertoire `unefois/`.

En résumé, une réinstallation du paquet `se3-clients-linux`
avec conservation des fichiers/dossiers modifiables se fait
ainsi :

```sh
apt-get remove se3-clients-linux
apt-get install se3-clients-linux
```

Une telle réinstallation du paquet peut être utile si
jamais, pour une raison ou pour une autre, vous avez commis
un certain nombre de modifications malheureuses en voulant «
hacker » certains fichiers du paquet et que vous souhaitez
repartir de zéro sans pour autant perdre vos fichiers «
personnels 25 ». Autre cas où la réinstallation peut être
utile : lors d'une mise à jour du paquet (auquel cas
d'ailleurs il sera plus naturel d'exécuter la commande «
`apt-get dist-upgrade` »). Dans ce cas aussi, les fichiers «
personnels » seront conservés en l'état.

**Remarque :** ici, la notion de fichiers/répertoires «
modifiables » ou « personnels » n'est pas à prendre au pied
de la lettre. Dans l'absolu, vous pouvez tenter de modifier
ce que vous voulez dans les fichiers du paquet
`se3-clients-linux`. Simplement, sont considérés comme «
modifiables » (ou « personnels ») seulement les
fichiers/répertoires conservés lors d'une réinstallation ou
d'une mise à jour du paquet.


