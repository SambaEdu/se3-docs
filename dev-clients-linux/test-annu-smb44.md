# Tester la compatibilité d'un annuaire de production dans une machine virtuelle

Vous trouverez ci-dessous quelques explications concernant la mise en place d'un environnement de test d'un annuaire de production et le passage en `samba 4.4` et `se3 3.0` sur une machine virtuelle.

* [Préliminaires](#préliminaires)
* [La problématique](#la-problématique)    
* [Que fait le script de test ?](#que-fait-le-script-de-test-)
* [Que permet-il de vérifier ?](#que-permet-il-de-vérifier-)
* [Comment utiliser le script ?](#comment-utiliser-le-script-)
* [Les étapes du script](#les-étapes-du-script)
* [Mise à jour vers `samba 4.4` et `se3 3.0`](#mise-à-jour-vers-samba-44-et-se3-30)
* [Remontée des tests](#remontée-des-tests)


## Préliminaires

On suppose ici que vous avez déjà procédé à l'installation d'une machine virtuelle `SE3`. **Les tests ci-dessous ne sont prévus que dans ce cadre**.

Si vous voulez plus de détails sur la mise en place d'une machine virtuelle `SE3`, vous pourrez vous reporter à [la documentaion *ad hoc*](http://wiki.dane.ac-versailles.fr/index.php?title=Installer_un_r%C3%A9seau_SE3_avec_VirtualBox).


**Conseil :**  il est également plus prudent d'avoir un snapshot de sa VM sous la main avant de se lancer dans les tests…


## La problématique

Le passage sur **`se3` version 3.0** et donc **samba 4.4** demande un annuaire légèrement différent de l'actuel et respectant certaines normes induites par `samba 4.4.` Lors du passage en 3.0, l'annuaire est donc analysé et modifié par un script durant la mise à jour.

Toutefois, il peut être utile de tester, avant le passage en version 3.0, la compatibilité de l'annuaire sur une machine virtuelle en question mais cela demande d'avoir une machine virtuelle avec exactement les mêmes caractéristiques (nom de domaine samba, meme base DN, etc.).

Le script **test-ldap-smb44.sh**, dont nous allons détailler le mode de fonctionnement, se propose de résoudre cette problématique de compatibilité.


## Que fait le script de test ?

Le script **test-ldap-smb44.sh** analyse un export `ldap` prenant la forme d'un fichier `ldif` afin de mettre en place toute la structure `ldap/samba` correspondante. 


## Que permet-il de vérifier ?

Le script **test-ldap-smb44.sh** permet de vérifier tranquillement que l'annuaire passe la mise à jour `SE3 3.0` sans encombre et donc sa compatibilité avec `samba 4.4.`

Si tel n'est pas le cas, on peut alors remonter ses problèmes sur la liste de diffusion `se3-devel` afin que le défaut constaté sur l'annuaire testé puisse être pris en compte via un correctif adéquat. Ce correctif permettra, lors de la mise à jour, de bien passer correctement sur l'annuaire de production. 


## Comment utiliser le script ?

On commence par charger le script **test-ldap-smb44.sh** sur la machine virtuelle en le récupérant sur le dépot `Git` à l'aide de la commande suivante :
```sh
wget https://gist.githubusercontent.com/SambaEdu/bc0c2b4166c9152cbf786cefb271b2e8/raw/f9bce505cbd545ce05230c149892b0bee72b1830/test-ldap-smb44.sh
```

On dépose, dans le même dossier, un export de son annuaire de production que l'on veut tester. Par exemple, mettons qu'il se nomme **export.ldif** ; mais ce n'est pas obligatoire : il peut s'appeler autrement.

On lance le script avec le nom de l'export en argument :
```sh
bash test-ldap-smb44.sh export.ldif
```

## Les étapes du script

Dans un premier temps, une sauvegarde de l'annuaire en cours de fonctionnement est faite dans `/var/se3/save/ldap` afin de revenir à l'état initial par la suite si on le souhaite.

Ensuite, le script va tenter de trouver toutes les informations dont il a besoin dans l'export `ldif` donné en argument, à savoir la `basedn`, le `sid samba` et le `nom de domaine samba`.

Dans un premier temps la `base dn` trouvée sera affichée. Si cela convient, le script recherche les autres éléments puis donne un récapitulatif.

Voici un exemple :

     Résumé des modifications :
    - Analyse de export.ldif
    - Mise en place la base dn  ou=clg-hugo-gisors,ou=ac-rouen,ou=education,o=gouv,c=fr
    - Vidage de l'annuaire insertion du contenu de  export.ldif
    - Sid samba positionné à  S-1-5-21-1428338548-94502439-1745090853
    - Nom de domaine Samba récupéré   SAMBAEDU3
    
    Peut-on poursuivre? (o/n)

Le script commence alors les modifications.

En premier lieu il met à jour `mysql` avec les valeurs trouvées dans le fichier `ldif` :

    changement de la basedn dans mysql
    changement du sambaSID dans mysql
    changement du nom de domaine samba dans mysql
    
Ensuite il met en place une base ldap vierge puis intègre le fichier ldif

    Reconstruction de la conf ldap
    Pas de replication, LDAP local, SSL off
    
    Supression de /var/lib/ldap
    Intégration du fichier ldif  export.ldif
    .#################### 100.00% eta   none elapsed             03s spd 367.4 k/s
    Closing DB...

Après quoi viennent les modifications concernant `samba` :

    remise en place pass ldap samba
    Setting stored password for "cn=admin,ou=clg-hugo-gisors,ou=ac-rouen,ou=education,o=gouv,c=fr" in secrets.tdb
    changement du SID pour samba
    lancement update-smbconf.sh pour conf initiale
    Lancement correctSID.sh au cas ou
    Lancement update-smbconf.sh pour activation ldaptrusted
    
    Terminé !!

Normalement en une seule passe, le script devrait remettre en place un système fonctionnel.

Si tel n'est pas le cas, il peut être lancé une seconde fois. Il est par exemple possible que `samba` refuse de fonctionner dans un premier temps vue le bouleversement…


## Mise à jour vers `samba 4.4` et `se3 3.0`

Une fois la structure mise en place à l'aide du script *test-ldap-smb44.sh*, il reste à tester le passage en `samba 4.4`, **toujours sur la même VM**. Il faut donc installer le paquet `se3 3.0` disponible sur la branche `se3testing`.

Afin de se positionner sur la branche `se3testing`, on pourra se reporter à [la documentation détaillant la modification du fichier `/etc/apt/sources.list.d/se3.list`](../se3-clients-linux/upgrade-via-se3testing.md#%C3%89dition-du-fichier-etcaptsourceslistdse3list).


Une fois sur la branche `se3testing`, mettre à jour la liste des paquets puis installer les paquets `se3`, `se3-logonpy` et `se3-domain` :
```sh
apt-get update 
apt-get install se3 se3-logonpy se3-domain
```
`Samba 4.4` sera tiré par dépendance. Si d'autres modules sont utilisés, ils peuvent être mis à jour également. En effet, `samba 4.4` induit des modifications sur quasiment l'ensemble des paquets `Se3`.

Si des problèmes sont rencontrés, ils devraient être apparents lors de la  mise à jour.

Toutefois quelques tests manuels sont toujours possibles, les voici :

La commande suivante permet de vérifier que l'annuaire est bien en mode `ldap trusted`
```sh
grep trusted /etc/samba/smb.conf
```
    ldapsam:trusted = Yes


Les deux commandes suivantes testent l'annuaire sur des points qui poseront problème si l'annuaire n'est pas compatible avec `samba 4.4.` :

```sh
create_adminse3.sh
smbclient -L localhost -U admin
```

## Remontée des tests

Merci de remonter sur la liste de diffusion les résultats de vos tests.


