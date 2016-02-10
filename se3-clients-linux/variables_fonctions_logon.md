#Quelques variables et fonctions prêtes à l'emploi pour personnaliser le script de `logon`

Voici la liste des variables et des fonctions que vous pourrez utiliser dans le fichier `logon_perso` et qui seront susceptibles de vous aider à affiner le comportement du script de logon :


 **Les variables**                                    | **Les fonctions**
------------------------------------------------------|--------------------------------------------------------
  [`LOGIN`](#login)                                   |  [`monter_partage`](#monter_partage)
  [`NOM_COMPLET_LOGIN`](#nom_complet_login)           |  [`creer_lien`](#creer_lien)
  [`REP_HOME`](#rep_home)                             |  [`changer_icone`](#changer_icone)
  [`LISTE_GROUPES_LOGIN`](#liste_groupes_login)       |  [`changer_papier_peint`](#changer_papier_peint)
  [`DEMARRAGE`](#demarrage)                           |  [`activer_pave_numerique`](#activer_pave_numerique)
                                                      |  [`executer_a_la_fin`](#executer_a_la_fin)

**Nota :** d'autres [variables et fonctions](variables_fonctions.md) sont aussi utilisables dans le fichier `logon_perso`.


## `LOGIN`

Cette variable stocke l'identifiant de l'utilisateur qui a ouvert une session.

Cette variable n'a de sens que **lors de la phase d'ouverture et de fermeture** (c'est-à-dire uniquement à l'intérieur des fonctions `ouverture_perso` et `fermeture_perso`), pas lors de la phase d'initialisation (c'est-à-dire à l'intérieur de la fonction `initialisation_perso`) puisque personne n'a encore ouvert de session à ce moment-là.


## `NOM_COMPLET_LOGIN`

Cette variable stocke le nom complet (par exemple sous la forme « prénom nom » ou « pnom » selon le choix effectué pour la forme des identifiants) de l'utilisateur qui a ouvert une session.

Cette variable n'a de sens que **lors de la phase d'ouverture et de fermeture**.


## `REP_HOME`

Cette variable stocke le chemin absolu du répertoire `home` de l'utilisateur qui se connecte.

Par exemple, si le compte `toto` ouvre une session, la variable contiendra la chaîne `/home/toto`.

Remarquez que cette variable est un simple raccourci pour écrire `"/home/$LOGIN"`.

Cette variable n'a de sens que **lors des phases d'ouverture et de fermeture**.


## `LISTE_GROUPES_LOGIN`

Cette variable, qui n'a de sens **que lors de la phase d'ouverture**, stocke la
liste des groupes auxquels appartient l'utilisateur qui a ouvert une session (le
format étant un nom de groupe par ligne).

Une utilisation typique de cette variable est :
```sh
if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"; then
    # L'utilisateur qui se connecte appartient au
    # groupe Profs, alors faire ceci...
elif est_dans_liste "$LISTE_GROUPES_LOGIN" "Eleves"; then
    # L'utilisateur qui se connecte appartient au
    # groupe Eleves, alors faire cela...
fi
```

Au passage, dans ce code, aucune requête `LDAP` n'est effectuée puisque la
variable `LISTE_GROUPES_LOGIN` contient déjà la liste des groupes auxquels
appartient l'utilisateur qui vient de se connecter (la requête `LDAP` permettant de définir la variable `LISTE_GROUPES_LOGIN` a été faite par le script de `logon` en amont, une fois pour toute).


## `DEMARRAGE`

Cette variable stocke toujours la valeur `false`, **sauf** lorsqu'on se trouve **lors d'une phase d'initialisation** qui correspond à un démarrage du système où elle stocke alors la valeur `true`.

Cette variable n'a donc d'intérêt que **lorsqu'elle est utilisée dans la fonction `initialisation_perso`**.

Voici un exemple :
```sh
if "$DEMARRAGE"; then
    # On est lors d'une phase de démarrage
    # alors faire ceci...
fi
```


## `monter_partage`

Si vous voulez que les utilisateurs du domaine puissent avoir accès à des
partages réseau sur le serveur, il faudra forcément faire usage de cette fonction
qui est donc très importante.

Toutes les explications sur cette fonction se
trouvent dans la partie concernant [la personnalisation du script de `logon`](script_logon.md#gestion-du-montage-des-partages-réseau) 

Cette fonction n'a de sens que **lors de la phase d'ouverture**.


## `creer_lien`

Cette fonction, qui va de pair avec la précédente, sera détaillée aussi
dans la partie concernant [la personnalisation du script de `logon`](script_logon.md#la-fonction-creer_lien).

Cette fonction n'a de sens que **lors de la phase d'ouverture**.


## `changer_icone`

Cette fonction sera détaillée dans la partie concernant [la personnalisation du script de `logon`](script_logon.md#changer-les-icônes-représentants-les-liens-pour-faire-plus-joli).

Cette fonction n'a de sens que **lors de la phase d'ouverture**.


## `changer_papier_peint`

Cette fonction, utilisable **uniquement pendant la phase d'ouverture**, permet
de changer le fond d'écran de l'utilisateur qui se connecte.

Elle prend un argument qui correspond au chemin absolu (sur le client) du fichier image à
utiliser en guise de fond d'écran.

Un exemple de l'utilisation de cette fonction
sera donné dans la partie concernant [la personnalisation du script de `logon`](script_logon.md#changer-le-papier-peint-en-fonction-des-utilisateurs).


## `activer_pave_numerique`

Cette fonction, qui fait exactement ce à quoi on pense naturellement, sera
détaillée dans la partie concernant [la personnalisation du script de logon](script_logon.md#lactivation-du-pavé-numérique).


## `executer_a_la_fin`

Parfois certaines commandes nécessitent d'être exécutées **une fois le script de `logon` terminé** (c'est-à-dire une fois l'initialisation, l'ouverture ou la fermeture terminée). C'est ce que permet cette fonction.

Avec, par exemple :
```sh
executer_a_la_fin "5" "commande" "arg1" "arg2"
```
La commande `commande` (avec ses arguments) sera lancée 5 secondes après
que le script de logon ait terminé son exécution.

Un exemple de l'usage de cette fonction sera donné dans la partie concernant [la personnalisation du script de logon](script_logon.md#incruster-un-message-sur-le-bureau-des-utilisateurs-pour-faire-classe).


**Attention**, l'exécution
se faisant une fois le script de `logon` terminé, il n'y aura **aucune trace dans les fichiers de `log`** de l'exécution de la commande `commande`.

