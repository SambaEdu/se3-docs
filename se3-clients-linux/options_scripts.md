#Les options des scripts d'intégration

Les deux scripts d'intégration `integration_squeeze.bash` et `integration_precise.bash`, qui doivent être exécutés en tant que `root` en local sur chaque client GNU/Linux à intégrer, utilisent exactement le même jeu d'options.



## Liste des différentes options

* [le nom d'hôte du client](#loption---nom-client-ou---nc)
* [le mote de passe pour `Grub`](#loption---mdp-grub-ou---mg)
* [le mot de passe pour le compte `root`](#loption---mdp-root-ou---mr)
* [ignorer la vérification de l'annuaire](#loption---ignorer-verification-ldap-ou---ivl)
* [installer le paquet `samba`](#loption---installer-samba-ou---is)
* [redémarrer le client-linux à la fin de l'intégration](#loption---redemarrer-client-ou---rc)


## Remarques importantes

* [Enregistrement du client-linux dans l'annuaire](#enregistrement-du-client-linux-dans-lannuaire)
* [Le répertoire `/mnt/`](#le-répertoire-mnt)


## Détails des options

### L'option `--nom-client` ou `--nc`

cette option vous permet de modifier le nom d'hôte du client.

* Si l'option n'est pas spécifiée, alors le client gardera le nom d'hôte qu'il possède déjà.

* Si l'option est spécifiée sans paramètre, alors le script d'intégration stoppera son exécution pour vous demander de saisir le nom de la machine.

* Si l'option est spécifiée avec un paramètre, comme dans : `./integration_squeeze.bash --nom-client="toto-04"` alors le script ne stoppera pas son exécution et effectuera directement le changement de nom en prenant comme nom le paramètre fourni (ici `toto-04`).

`Le nom d'hôte du client` est celui qui se trouve dans le fichier `/etc/hostname`. Ce n’est pas un nom DNS pleinement qualifié.

**Les caractères autorisés pour le choix du nom d'hôte sont :**  
  → les 26 lettres de l'alphabet en minuscules ou en majuscules, **sans accents**  
  → les chiffres  
  → le tiret du 6 (-)  
  → et c'est tout !  

**NB :** *De plus, le nom de la machine ne soit pas faire plus de 15 caractères*.


### L'option `--mdp-grub` ou `--mg`

Cette option vous permet d'ajouter un mot de passe dès qu'un utilisateur souhaite éditer un des items du menu `Grub` au démarrage.

* Si l'option `--mg` n'est pas spécifiée, alors la configuration de `Grub` est inchangée et a priori la faille de sécurité sera toujours présente.

* Si l'option est spécifié sans paramètre, alors le script d'intégration stoppera son exécution pour vous demander de saisir (*deux fois*) le futur mot de passe `Grub` (votre saisie ne s'affichera pas à l'écran).

* Si l'option est spécifiée avec un paramètre comme dans : `./integration_squeeze.bash --mdp-grub="1234"` alors le script ne stoppera pas son exécution et effectuera directement le changement de configuration de `Grub` en prenant comme mot de passe le paramètre fourni (ici `1234`).

En effet, en général, sur un système GNU/Linux fraîchement installé et utilisant `Grub` comme chargeur de boot, il est possible de sélectionner un des items du menu `Grub` et de l'éditer en appuyant sur la touche `e` sans devoir saisir le moindre mot de passe. Cela constitue une faille de sécurité potentielle car, dans ce cas, l'utilisateur peut très facilement éditer un des items du menu `Grub` et démarrer ensuite via cet item modifié de manière à devenir `root` sur la machine *sans avoir à saisir le moindre mot de passe*.

Avec l'option `--mg` , quand l'utilisateur voudra éditer un des items du menu `Grub`, il devra saisir les identifiants suivants :  
  → login : `admin`  
  → mot de passe : celui spécifié avec l'option `--mg`  


###L'option `--mdp-root` ou `--mr`

Cette option vous permet de modifier le mot de passe du compte `root`.

* Si vous ne spécifiez pas cette option, le mot de passe du compte `root` sera inchangé. 

* Si vous spécifiez cette option sans paramètre, alors le script d'intégration stoppera son exécution pour vous demander de saisir (*deux fois*) le futur mot de passe du compte `root` (votre saisie ne s'affichera pas sur l'écran).

* Si l'option est spécifiée avec un paramètre comme dans : `./integration_squeeze.bash --mdp-root="abcd"` alors le script ne stoppera pas son exécution et effectuera directement le changement de mot de passe en utilisant la valeur fournie en paramètre (ici `abcd`).


### L'option `--ignorer-verification-ldap` ou `--ivl`

Cette option, qui ne prend aucun paramètre, vous permet de continuer l'intégration sans faire de pause après la vérification LDAP.

* Si vous avez spécifié l'option `--ivl`, alors après avoir affiché le résultat de la recherche LDAP, le script continuera automatiquement l'intégration sans vous demander de confirmation.

* Si vous n'avez pas spécifié l'option `--ivl`, alors le script s'arrêtera à ce moment là et vous demandera si vous voulez continuer l'intégration.
    
En effet, lors de l'exécution du script d'intégration, quel que soit le jeu d'options choisi, une recherche dans `l'annuaire Ldap` du serveur est effectuée. Le script lancera une recherche de toutes les entrées dans l'annuaire correspondant à des machines susceptibles d'avoir un lien avec la machine qui est en train d'exécuter le script d'intégration au domaine.

Plus précisément la recherche porte sur toutes les entrées dans l'annuaire correspondant à des machines qui ont :  
  → même nom que la machine exécutant le script  
  → **ou** même adresse IP que la carte réseau de la machine exécutant le script  
  → **ou** même adresse MAC que la carte réseau de la machine exécutant le script  

Dans tous les cas, le résultat de cette recherche sera affiché.

Si par exemple vous vous apercevez que le nom d'hôte que vous avez choisi pour votre client GNU/Linux existe déjà dans l'annuaire du serveur, il faudra peut-être arrêter l'intégration (sauf si le système GNU/Linux est installé en dual boot avec Windows sur la machine et que le système Windows, lui, a déjà été intégré au domaine avec ce même nom).


### L'option `--installer-samba` ou `--is`

Cette option, qui ne prend aucun paramètre, provoquera l'installation de Samba sur le client GNU/Linux.

* Si vous ne spécifiez pas cette option, alors Samba ne sera pas installé sur le client GNU/Linux.

**Pour l'instant, il faut utiliser l'option `--is` systématiquement.**

En effet, lorsqu'un client GNU/Linux essaye de monter un partage Samba du serveur (notamment le partage `homes`), des scripts sont exécutés en amont côté serveur et le montage ne sera effectué qu'une fois ces scripts terminés. Or, l'un d'entre eux peut mettre un certain temps (environ 4 ou 5 secondes) à se terminer si Samba n'est pas installé sur la machine cliente. Par conséquent, si vous ne spécifiez pas l'option , vous risquez d'avoir des ouvertures de sessions un peu lentes (lors du montage des partages Samba). Donc pour l'instant, utilisez cette option lors de vos intégrations.


### L'option `--redemarrer-client` ou `--rc`

Cette option permet de lancer automatiquement un redémarrage du client GNU/Linux à la fin de l'exécution du script d'intégration.

* Si vous ne spécifiez pas cette option, il n'y aura pas de redémarrage à la fin de l'exécution du script.


**Redémarrage :** sachez que le redémarrage après intégration est nécessaire pour avoir un système opérationnel. Si les intégrations se déroulent sans erreur sur vos machines Linux, vous aurez donc tout intérêt à spécifier à chaque fois l'option `--rc` pour qu'il se fasse automatiquement.


## Enregistrement du client-linux dans l'annuaire

Quel que soit le jeu d'options que vous aurez choisi, **aucun enregistrement dans l'annuaire du serveur ne sera effectué par le script d'intégration**.


**Conséquence :** si vous souhaitez que votre client GNU/Linux fraîchement intégré figure dans l'annuaire du serveur, il faudra passer par **une réservation d'adresse IP de la carte réseau du client via le module DHCP du serveur**.


## Le répertoire `/mnt/`

Une fois un client intégré au domaine, **évitez de monter un disque ou un partage dans le répertoire `/mnt/`**.

En effet, le répertoire `/mnt/` est utilisé constamment par le client GNU/Linux (une fois que celui-ci est intégré au domaine) pour y effectuer des montages de partages, notamment au moment de l'ouverture de session d'un utilisateur du domaine, et ce répertoire est aussi constamment nettoyé , notamment juste après une fermeture de session.

Afin d'éviter le nettoyage intempestif d'un de vos disques ou d'un partage réseau de votre cru, utilisez un autre répertoire pour procéder au montage.

**Utilisez par exemple le répertoire `/media/` à la place**. En fait, utilisez ce que vous voulez sauf `/mnt/`.
