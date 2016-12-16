# Reconfiguration du paquet et restauration des droits

Il est nécessaire de reconfigurer le paquet `se3-clients-linux` dans plusieurs situations :

* pour restaurer des droits corrects sur les fichiers du paquet
* pour réadapter les scripts à l'environnement de votre serveur si…
    * …son `IP` a changé
    * …le `skel` a été modifié
    * …le `logon_perso` a été modifié
    * …

La reconfiguration du paquet `se3-clients-linux` peut se faire en utilisant une des 2 méthodes suivantes.


#### via le `se3`

Pour cela, il vous suffit de lancer la commande suivante
en tant que `root` sur une console du serveur `se3` :
```sh
dpkg-reconfigure se3-clients-linux
```

#### via un `client-linux`

Si vous avez ouvert une session sur un `client-linux` avec le compte `admin`,
vous pourrez double-cliquer sur le fichier `reconfigure.bash`
accessible en passant par le lien symbolique `clients-linux` sur le Bureau
puis par le répertoire `bin/` (le mot de passe root du serveur `se3` sera demandé).

Voir le schéma de [l'arborescence du répertoire `clients-linux/`](visite_rapide.md#arborescence-du-répertoire-clients-linux).


**Remarque :** en réalité, ces deux procédures ne font pas que reconfigurer les droits sur les fichiers, elles permettent aussi d'injecter le contenu du fichier `logon_perso` dans le fichier `logon`. Ce point est abordé dans la section [personnalisation](script_logon.md#le-logon_perso).

