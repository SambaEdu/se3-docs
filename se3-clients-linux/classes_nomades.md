# Le cas des classes nomades

**Note :** pour les clients-linux `Jessie` et `Trusty`, la gestion de l'interface réseau ayant changée, il faudra retester les indications données dans cette partie.

Utiliser GNU/Linux sur des ordinateurs portables dans un
domaine Se3 présente un atout extraordinaire : [le mécanisme
des profils](gestion_profils.md#le-mécanisme-des-profils)
limite au maximum les échanges entre le serveur et le client
une fois la session ouverte.

Autrement dit, il n'y a aucun
risque de voir la session ouverte « planter » en raison
d'une micro-coupure wifi.

L'intégration au domaine d'un ordinateur issu d'une classe
nomade ne présente qu'une spécificité : le client doit,
**avant l'ouverture de session**, déjà être connecté au réseau
sans fil.

Pour ce faire, il suffira d'indiquer dans le
fichier `/etc/network/interfaces` le `SSID` et `le mot de passe du réseau sans fil`
auquel le client est censé se connecter.

Il est également recommandé, par la même occasion, de
désactiver l'interface ethernet, sans quoi le processus de
boot se trouvera allongé de plusieurs secondes voire
dizaines de secondes (durant lesquelles le client cherchera
à obtenir une IP du serveur sur toutes les interfaces
activées).

Un moyen extrêmement simple et rapide de réaliser cette
manipulation est bien sûr d'utiliser `unefois/`.

Ainsi, admettons que les clients de votre classe nomade soit nommés
`nomade-01`, `nomade-02`, jusqu'à `nomade-15`.

Avant leur intégration au domaine, vous pouvez par exemple :

* déposer dans le répertoire `/var/www/` de votre Se3 le
fichier `interfaces` configuré par vos soins

* préparer un script intitulé `reseau-nomade.unefois`
contenant les lignes suivantes :

```sh
#!/bin/bash

wget http://IP_DE_VOTRE_SE3/interfaces
mv /etc/network/interfaces /etc/network/interfaces.old
mv interfaces /etc/network/
/etc/init.d networking restart
```

**Note :** Changez bien sûr `IP_DE_VOTRE_SE3` par l'IP réelle
de votre Se3.

* Déposer dans le répertoire `/home/netlogon/clients-linux/unefois/^nomade-/`
du serveur ledit script

* Lancer l'intégration au domaine de vos clients.

Les ordinateurs de la classe nomade redémarreront une
première fois après l'intégration au domaine : laissez-les
branchés en filaire.

Lors de leur premier boot en version « intégrés »,
les clients récupéreront le fichier de
configuration du réseau et se connecteront automatiquement
au réseau wifi adéquat.

Le jour où vous aurez besoin de faire d'importantes mises à
jour, vous pourrez tout aussi facilement refaire
momentanément basculer ces postes en filaire.


