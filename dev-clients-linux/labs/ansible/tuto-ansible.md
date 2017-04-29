# Petit tutoriel sur `Ansible`

* [Introduction](#introduction)
    * [Le logiciel `Ansible`](#le-logiciel-ansible)
    * [Pré-requis](#pré-requis)
    * [Remarque importante sur la notion de clients/serveur](#remarque-importante-sur-la-notion-de-clientsserveur)
    * [Pourquoi ça peut être intéressant pour `SambaÉdu` ?](#pourquoi-ça-peut-être-intéressant-pour-sambaÉdu-)
* [Mise en place d'un petit laboratoire pour faire les manipulations](#mise-en-place-dun-petit-laboratoire-pour-faire-les-manipulations)
    * [Un réseau minimal](#un-réseau-minimal)
    * [Hypothèses pour ce réseau minimal](#hypothèses-pour-ce-réseau-minimal)
    * [Installation et échanges des clés `ssh`](#installation-et-échanges-des-clés-ssh)
        * [Installation d'Ansible](#installation-dansible)
        * [Échanges des clés `ssh`](#Échanges-des-clés-ssh)
    * [Mise en place du fichier « d'inventaire » des clients ansible](#mise-en-place-du-fichier--dinventaire--des-clients-ansible)
    * [Vérification de bon fonctionnement](#vérification-de-bon-fonctionnement)
        * [Envoyer un Ping sur les clients](#envoyer-un-ping-sur-les-clients)
        * [Informations sur les clients](#informations-sur-les-clients)
        * [Une commande shell sur les clients](#une-commande-shell-sur-les-clients)
* [Un petit playbook simple comme premier exemple](#un-petit-playbook-simple-comme-premier-exemple)
    * [Un playbook, qu'est-ce que c'est ?](#un-playbook-quest-ce-que-cest-)
    * [Un playbook pour comprendre le principe](#un-playbook-pour-comprendre-le-principe)
    * [Les modules `Ansible`](#les-modules-ansible)
    * [Un fichier de configuration `template`](#un-fichier-de-configuration-template)
    * [Utilisons notre playbook](#utilisons-notre-playbook)
* [La bonne pratique des rôles pour l'organisation des fichiers](#la-bonne-pratique-des-rôles-pour-lorganisation-des-fichiers)
    * [Un rôle, qu'est-ce que c'est ?](#un-rôle-quest-ce-que-cest-)
    * [Le répertoire `/etc/ansible/`](#le-répertoire-etcansible)
    * [Création du rôle `ntp`](#création-du-rôle-ntp)
        * [Création de l'arborescence pour le rôle `ntp`](#création-de-larborescence-pour-le-rôle-ntp)
        * [Création de la clé `tasks` du rôle `ntp`](#création-de-la-clé-tasks-du-rôle-ntp)
        * [Création du fichier de `template` du rôle `ntp`](#création-du-fichier-de-template-du-rôle-ntp)
        * [Création de la clé `handlers` du rôle `ntp`](#création-de-la-clé-handlers-du-rôle-ntp)
        * [Les valeurs par défaut des variables du rôle `ntp`](#les-valeurs-par-défaut-des-variables-du-rôle-ntp)
        * [Quelques précisions sur le rôle `ntp`](#quelques-précisions-sur-le-rôle-ntp)
    * [Mais comment on utilise notre rôle `ntp` maintenant ?](#mais-comment-on-utilise-notre-rôle-ntp-maintenant-)
* [Utilisation des variables d'hôtes et de groupes](#utilisation-des-variables-dhôtes-et-de-groupes)
    * [La bonne pratique pour les variables](#la-bonne-pratique-pour-les-variables)
    * [Complément de l'arborescence](#complément-de-larborescence)
    * [Les variables pour le rôle `ntp`](#les-variables-pour-le-rôle-ntp)
    * [Abandon de la clé `vars` pour le rôle `ntp`](#abandon-de-la-clé-vars-pour-le-rôle-ntp)
    * [Utilisation des playbooks](#utilisation-des-playbooks)
* [Petite astuce pour appliquer un playbook en le limitant à un seul client](#petite-astuce-pour-appliquer-un-playbook-en-le-limitant-à-un-seul-client)
* [Résumé des bonnes pratiques « Ansible »](#résumé-des-bonnes-pratiques--ansible-)
* [Exercices](#exercices)
    * [Exercice 1](#exercice-1)
* [Références](#références)



## Introduction

### Le logiciel `Ansible`

`Ansible` est un **logiciel de déploiement de configurations**.

On installe `Ansible` sur une machine qui
fera office de « *serveur ansible* » et avec une commande
(accompagnée de code ansible), on déploie de la configuration
sur un ensemble de machines qu'on peut appeler du coup des
« *clients ansible* ».

### Pré-requis

Au niveau installation il faut :

* installer `Ansible` sur une machine qui fera office de « serveur ansible » (normal).
* installer un serveur `SSH` et `Python` sur les machines du réseau qui seront alors des « clients ansible » (ce qui est assez faible comme contrainte).

### Remarque importante sur la notion de clients/serveur

Les appellations de « serveur ansible » et « clients ansible »
sont incorrectes d'un point de vue réseau.

En effet, d'un point de vue réseau,
un serveur est une application qui tourne en
tant que service et qui écoute sur un port, comme par
exemple `Apache2` qui est un service qui écoute sur le port 80.
Ici ce n'est pas le cas : `Ansible` n'est pas un service et
donc il n'écoute a fortiori sur aucun port. C'est un
programme qu'on lance à la demande (sur le « serveur ansible »)
comme on pourrait lancer un wget en ligne de commandes par exemple.

Mieux, en vérité, le programme `Ansible` est un
client d'un point de vue réseau : en effet lorsqu'on lance
`Ansible` sur le « serveur ansible », le programme `Ansible`
contacte les « clients ansible » en `SSH` pour déployer les
configurations.

Donc, en vérité, d'un point de vue réseau :

* le « serveur ansible » est un client SSH,
* les « clients ansible » sont des serveurs SSH.

Toutefois, bien que pas tout à fait correctes, les
expressions « serveur ansible » (l'hôte sur lequel Ansible
est installé) et « clients ansible » (les hôtes sur lesquels
on déploie de la configuration) sont quand même bien
pratiques pour signifier de qui on parle.


### Pourquoi ça peut être intéressant pour `SambaÉdu` ?

On peut imaginer que ça puisse être très utile dans le
management des clients-Linux où le serveur `SambaÉdu` serait
le serveur ansible et les clients-Linux seraient les clients
ansible. L'intégration (qui est typiquement une mise en
place de configuration) pourrait par exemple se faire via
`Ansible`.

**Remarque :** domaine inconnu pour moi, mais il semble que `Ansible` puisse
aussi manager du `Windows`.

`Ansible` pourrait sans doute aussi s'avérer utile dans la
gestion de configuration du serveur `SambaÉdu` lui-même.
L'installation complète d'un serveur `SambaÉdu` pourrait très
bien se résumer à l'installation de l'OS Debian puis à
l'exécution d'un playbook ansible (c'est le nom qu'on donne
à du code ansible) pour installer et configurer toute la
couche `SambaÉdu`.

Cela pourrait aussi être l'intermédiaire
**unique** de l'interface d'administration Web du serveur
`SambaÉdu` dès que la configuration du serveur est modifiée :
une modification de la configuration du serveur via
l'interface Web déclencherait automatiquement un playbook
ansible.


## Mise en place d'un petit laboratoire pour faire les manipulations

### Un réseau minimal

On va se donner 3 machines sous Debian Jessie
(mais on pourrait prendre des distributions différentes),
toutes les 3 sur le même réseau IP :

* se3.athome.priv
* client1.athome.priv
* client2.athome.priv

Cela constitue un réseau minimal pour ce tutoriel :

```
+----------------------+                                              +------------------------+
|                      |    Déploiement de configuration via SSH      |                        |
|   se3.athome.priv    |-------------------------------------------->>|  client1.athome.priv   |
|                      |                                              |                        |
| Ansible est installé |                                              +------------------------+
|  sur cette machine   |
|                      |---------------------+                        +------------------------+
+----------------------+                     |                        |                        |
            |       |                        +---------------------->>|  client2.athome.priv   |
            |       |                                                 |                        |
            +--<<---+                                                 +------------------------+
    Le « serveur ansible » peut très bien avoir lui-même
    comme « client ansible » (ce sera le cas dans ce tutoriel).
```

### Hypothèses pour ce réseau minimal

On supposera que :

1. Quitte à mettre en place un serveur DNS ou alors en éditant
   le fichier `/etc/hosts` du serveur `se3`, l'hôte `se3` sera capable de
   résoudre correctement en adresse IP les fqdn ci-dessus.
2. Sur les trois hôtes, un serveur ssh est en place et
   python est installé.


### Installation et échanges des clés `ssh`

#### Installation d'`Ansible`

C'est sur le serveur `se3`
(mais ce pourrait être une autre machine du réseau)
qu'on installe `Ansible` :

```sh
# Oui, c'est curieux il faut mettre "trusty" alors qu'on est sur Jessie.
# C'est marqué dans la doc Ansible :
#
#   http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-apt-debian
#
# Cependant, en utilisant le dépôt jessie-backports,
# on peut obtenir une version qui pourrait convenir (à confirmer),
# même si ce n'est pas la dernière version comme avec le dépôt ci-dessous…
#
echo deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main > /etc/apt/sources.list.d/ansible.list

# Il nous faut la clé GPG du dépôt.
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

apt-get update && apt-get install ansible
```

#### Échanges des clés `ssh`

Il faut créer une paire de clés `SSH` sur le serveur`se3` et échanger la clé
publique sur tous les « clients » ansible. En clair, sur le serveur`se3`,
il faut être en mesure de se connecter sur les « clients » ansible
de manière non-interactive.


```sh
# Génération d'une paire de clés SSH sans passphrase.
ssh-keygen

# On envoie la clé publique dans le fichier /root/.ssh/authorized_key
# de nos 3 « clients » ansible.
ssh-copy-id root@client1.athome.priv
ssh-copy-id root@client2.athome.priv
ssh-copy-id root@se3.athome.priv
```

Bien vérifier ensuite que, sur le serveur`se3`, on peut se « ssher » sur
les 3 fqdn sans mot de passe.



### Mise en place du fichier « d'inventaire » des clients ansible

Il faut éditer le fichier `/etc/ansible/hosts` et y placer
nos clients.

Entre crochets, on définit des groupes de clients.
Par exemple le groupe `sambaedu` qui ne contient que le le serveur`se3`
et le groupe `linuxclients` qui contient les clients-Linux.

```ini
# Une adresse IP est possible à la place d'un fqdn.
[sambaedu]
se3.athome.priv

[linuxclients]
# De 1 à 2, on économise peu de lignes mais de 1 à 20 par exemple, c'est différent.
# À noter que la syntaxe [01:20] est possible aussi pour aller de 01, 02, etc. à 20.
client[1:2].athome.priv
```

### Vérification de bon fonctionnement

On peut maintenant vérifier que ça fonctionne bien avec les actions suivantes :


#### Envoyer un Ping sur les clients

```sh
# "all" est un groupe pré-défini qui contient tous les clients.
ansible all -m ping

ansible linuxclients -m ping

ansible 'client1*' -m ping
```


#### Informations sur les clients

```sh
# On peut afficher des informations sur un ou plusieurs clients.
#
# Toutes les variables affichées par cette commande seront
# utilisables dans le « code » ansible. Par exemple, il y a
# la variable "ansible_distribution_release" qui indique le
# nom de code de la distribution du client cible. Par
# exemple, si le client cible est une Debian Jessie cette
# variable sera égale à "jessie", si le client cible est une
# Ubuntu Xenial, cette variable sera égale à "xenial" etc.
# On utilisera plus loin cette variable.
ansible 'client1.athome.priv' -m setup
```


#### Une commande shell sur les clients

Et, au passage, on est en mesure d'exécuter n'importe quelle commande shell
sur un ou plusieurs clients. Par exemple :

```sh
ansible all -a 'ls -al --color /tmp'
```


## Un petit playbook simple comme premier exemple

### Un playbook, qu'est-ce que c'est ?

Un **playbook** est un fichier `YAML` utilisé par Ansible pour
mettre en place des configurations sur un ou plusieurs clients.


### Un playbook pour comprendre le principe

**Attention :** ceci est un exemple simple pour commencer
et comprendre les principes de base mais il ne correspond pas
aux bonnes pratiques au niveau de l'organisation des fichiers ;
la bonne pratique est d'[utiliser des « rôles » ansible](#la-bonne-pratique-des-rôles-pour-lorganisation-des-fichiers).

Créons ce fichier pour notre premier exemple `~/myplaybook.yaml` :

```yaml
--- # <=================== Un fichier `yaml` commence toujours par 3 tirets.
# Cette entrée ici (avec le tiret en début de ligne) marque
# le début d'un « play » dans le langage ansible, ie un
# machin qui va configurer des trucs sur un ensemble de
# clients.
#
# Un fichier playbook peut contenir autant de « plays » que
# l'on souhaite. Ici, on n'en met qu'un seul.
#
- hosts: linuxclients # <= Signifie que les clients du groupe linuxclients seront la cible de ce play.
  vars:               # <= Ici on définit des variables (voir plus bas).
    ntp_servers:
      - '0.debian.pool.ntp.org'
      - '1.debian.pool.ntp.org'
      - '2.debian.pool.ntp.org'
    admin_email: 'flaf@domain.tld' # Variable dont l'existence est artificielle ; ici, c'est pour l'exemple.
  remote_user: root # <=== 
  tasks: # <============================= Les tasks sont toujours appliquées dans l'ordre où elles sont écrites.
    - name: ensure NTP installation # <== On installe le paquet `ntp` à l'aide du module `apt`.
      apt:
        name: ntp
        state: latest
    - name: write NTP config file /etc/ntp.conf # <== on configure le serveur de temps à l'aide du module `template`.
      template:
        src: ntp.conf.j2 # <== Ici on utilise un template `Jinja2` (la syntaxe est très simple).
        dest: /etc/ntp.conf
        owner: root
        group: root
        mode: '0644'
      notify: # <========== meta-rôle servant à jouer un rôle conditionnel (= handlers)
        - restart ntp # <== On redémarre le service (à lier avec les handlers, voir ci-dessous).
    - name: ensure ntp is running (and enable it at boot) # <== on s'assure que le service `ntp` est en fonction, y compris au boot, à l'aide du module `service`.
      service:
        name: ntp
        state: started
        enabled: yes
  handlers:
    - name: restart ntp # <== un rôle conditionnel joué en fonction des changement de conf
      service:
        name: ntp
        state: restarted
```


### Les modules `Ansible`

`template`, `service`, `apt` s'appellent des **modules
ansibles**. Ce sont des mini-programmes pour exécuter des
actions sur les clients ansible.

Chaque module admet des options ;
par exemple `mode` est une option du module ansible `template`.

Et tout cela est documenté ; ainsi vous pourrez consulter [la documentation pour le module `template`](http://docs.ansible.com/ansible/template_module.html).

`Ansible` possède toute
[une panoplie de modules](http://docs.ansible.com/ansible/list_of_all_modules.html)
mise à la disposition des utilisateurs de Ansible
(il existe par exemple un module `mount` pour assurer un montage,
un autre module `shell` pour exécuter une commande shell, etc.).


### Un fichier de configuration `template`

Et voici notre fichier `~/ntp.conf.j2`
qu'il faut créer au même en endroit que notre playbook
car on a mis le chemin relatif `src: ntp.conf.j2` dans le playbook :

```cfg
# Ce fichier est managé par Ansible. Merci de ne pas
# l'éditer manuellement.
#
# Si vous avez un souci, merci d'envoyer un message à
# cette adresse : {{ admin_email }}.

driftfile  /var/lib/ntp/ntp.drift
statistics loopstats peerstats clockstats
filegen    loopstats  file loopstats  type day enable
filegen    peerstats  file peerstats  type day enable
filegen    clockstats file clockstats type day enable

{% for ntp_server in ntp_servers %}
server {{ ntp_server }} iburst
{% endfor %}

restrict -4 default kod notrap nomodify nopeer noquery
restrict -6 default kod notrap nomodify nopeer noquery

restrict 127.0.0.1
restrict ::1

{% if ansible_distribution_release == 'jessie' %}
# Configuration spécifique si on est sur une Jessie…
{% elif ansible_distribution_release == 'xenial' %}
# Configuration spécifique si on est sur une Xenial…
{% else %}
# Configuration si on n'est ni sur une Xenial, ni sur une Jessie…
{% endif %}
# Configuration par defaut dans tous les cas…
```

**Remarque 1 :** ce fichier de configuration a été copié à partir du fichier de configuration **ntp.conf** du paquet `ntp` ; certaines parties ont été adaptées pour tenir compte des spécificités de notre réseau (par exemple la liste des serveurs de temps avec un `{% for %}`).

**Remarque 2 :** on peut donc adapter un template en fonction du
client et de son `OS` par exemple (si c'est une Xenial ou une
Jessie, etc.) avec des `{% if %}` (entre autres). Mais si le template
devient trop complexe et illisible, alors il est plus sage de
créer des fichiers templates différents, par exemple avec :

```cfg
# Il faut reconnaître que ntp n'est pas un bon exemple pour
# ça car la configuration est plutôt stable d'une distribution
# à l'autre.
~/ntp.conf_jessie.j2
~/ntp.conf_xenial.j2
```

Et dans le playbook mettre quelque chose comme ça :

```yaml
# […]
    - name: write NTP config file /etc/ntp.conf
      template:
        src: 'ntp.conf_{{ansible_distribution_release}}.j2' # <= Changement ici.
        dest: /etc/ntp.conf
        owner: root
        group: root
        mode: '0644'
      notify:
        - restart ntp
# […]
```


### Utilisons notre playbook

On va pouvoir lancer notre playbook *myplaybook.yaml* avec la commande :

```sh
# L'option --diff permet de voir les lignes supprimées/ajoutées losqu'un
# fichier texte (un fichier de configuration) est modifié par ansible.
ansible-playbook ./myplaybook.yaml --diff
```

Vous pourrez ensuite vérifier que les clients ansible ont été configurés
pour que leur base de temps soit le serveur `se3`.

```sh
# Pour vérifier notamment que la synchronisation ntp des clients
# Linux se fait bien sur l'IP du se3
ansible linuxclients -a 'ntpq -pn4'
```


## La bonne pratique des rôles pour l'organisation des fichiers

### Un rôle, qu'est-ce que c'est ?

L'idée des rôles c'est de rendre un playbook autonome et
générique, comme un « module » ou une sorte de
lib, afin qu'il puisse être utilisable ensuite dans d'autres
playbooks avec un système « d'include ».

Un rôle est donc un module perso.


### Le répertoire `/etc/ansible/`

Par défaut (lors de l'installation du paquet Ansible),
le répertoire `/etc/ansible/` contient ceci :

```
/etc/ansible/
├── ansible.cfg
├── hosts
└── roles/
```


### Création du rôle `ntp`

#### Création de l'arborescence pour le rôle `ntp`

On va utiliser le répertoire `/etc/ansible/roles/` pour stocker
notre playbook de l'exemple précédent (qui configure `ntp`) sous
la forme d'un rôle qu'on appellera `ntp`.

On va créer cette arborescence :

```cfg
# On va retrouver, éclaté dans plusieurs fichiers dans
# /etc/ansible/roles/ntp/, le code qu'on avait dans notre
# playbook précédent.
/etc/ansible/
├── ansible.cfg
├── hosts
└── roles
    └── ntp # <================= Notre role `ntp`. Le dossier roles/ est amené à contenir plusieurs rôles bien sûr.
        ├── defaults
        │   └── main.yaml   # <= Sert à définir les valeurs par défaut de nos variables (quand c'est pertinent).
        ├── handlers
        │   └── main.yaml   # <= Le (ou les) handler(s).
        ├── tasks
        │   └── main.yaml   # <= Les tasks de notre playbook d'exemple précédent.
        └── templates
            └── ntp.conf.j2 # <= Le template de notre playbook d'exemple précédent.
```

Créons l'arborescence :

```sh
mkdir -p /etc/ansible/roles/ntp/defaults/
touch    /etc/ansible/roles/ntp/defaults/main.yaml
mkdir -p /etc/ansible/roles/ntp/handlers/
touch    /etc/ansible/roles/ntp/handlers/main.yaml
mkdir -p /etc/ansible/roles/ntp/tasks/
touch    /etc/ansible/roles/ntp/tasks/main.yaml
mkdir -p /etc/ansible/roles/ntp/templates/
touch    /etc/ansible/roles/ntp/templates/ntp.conf.j2
```


#### Création de la clé `tasks` du rôle `ntp`

Voici le contenu du fichier `/etc/ansible/roles/ntp/tasks/main.yaml` :

```yaml
---
# On met le contenu de la clé `tasks` de notre playbook précédent
# mais on ne met pas la clé `tasks` elle-même (juste le contenu).
- name: ensure NTP installation
  apt:
    name: ntp
    state: latest
- name: write NTP config file /etc/ntp.conf
  template:
    src: ntp.conf.j2 # <== Le nom du template est relatif au dossier "templates/" de notre rôle ntp.
    dest: /etc/ntp.conf
    owner: root
    group: root
    mode: '0644'
  notify:
    - restart ntp
- name: ensure ntp is running (and enable it at boot)
  service:
    name: ntp
    state: started
    enabled: yes
```


#### Création du fichier de `template` du rôle `ntp`

Le contenu de notre template `/etc/ansible/roles/ntp/templates/ntp.conf.j2`
va être légèrement modifié car une bonne pratique dans un rôle
est de **préfixer le nom des variables d'un rôle par le nom du rôle**.
On va donc procéder aux changements suivants :

```cfg
ntp_servers => ntp_servers     # Lui reste inchangé, coup de chance.
admin_email => ntp_admin_email
```

Voici donc le contenu du fichier `/etc/ansible/roles/ntp/templates/ntp.conf.j2` :

```cfg
# Ce fichier est managé par Ansible. Merci de ne pas
# l'éditer manuellement.
#
# Si vous avez un souci, merci d'envoyer un message à
# cette adresse : {{ ntp_admin_email }}.

driftfile  /var/lib/ntp/ntp.drift
statistics loopstats peerstats clockstats
filegen    loopstats  file loopstats  type day enable
filegen    peerstats  file peerstats  type day enable
filegen    clockstats file clockstats type day enable

{% for ntp_server in ntp_servers %}
server {{ ntp_server }} iburst
{% endfor %}

restrict -4 default kod notrap nomodify nopeer noquery
restrict -6 default kod notrap nomodify nopeer noquery

restrict 127.0.0.1
restrict ::1

{% if ansible_distribution_release == 'jessie' %}
# Configuration spécifique si on est sur une Jessie…
{% elif ansible_distribution_release == 'xenial' %}
# Configuration spécifique si on est sur une Xenial…
{% else %}
# Configuration par defaut…
{% endif %}
```


#### Création de la clé `handlers` du rôle `ntp`

Pas de surprise pour le fichier `/etc/ansible/roles/ntp/handlers/main.yaml` :

```yaml
---
# Là aussi, on ne met pas la clé `handlers` mais juste le contenu de cette clé.
- name: restart ntp
  service:
    name: ntp
    state: restarted
```


#### Les valeurs par défaut des variables du rôle `ntp`

Il nous reste le fichier `/etc/ansible/roles/ntp/defaults/main.yaml`.
Il sert à définir des valeurs par défaut pertinentes pour
certaines variables… quand c'est possible (par exemple
pour une variable `password` il vaut mieux éviter d'en
définir une sachant que par défaut ansible provoque une
erreur si une variable se retrouve non définie).

Ici, notre rôle `ntp` ne contient que deux variables
`ntp_servers` et `ntp_admin_email`. A priori, seule la
première peut avoir une valeur par défaut raisonnable, d'où :

```yaml
---
# Ce fichier correspond au contenu de la clé `vars` dans
# notre playbook précédent mais là encore sans la clé `vars`
# elle-même.
ntp_servers:
  - '0.debian.pool.ntp.org'
  - '1.debian.pool.ntp.org'
  - '2.debian.pool.ntp.org'

# Pas de valeur par défaut pertinente pour cette variable a priori.
#
#ntp_admin_email: 'foo@bar.tld'
```


#### Quelques précisions sur le rôle `ntp`

Et voilà, on a créé notre rôle ansible `ntp`.

Si Ansible était un langage de programmation
(ce qu'il n'est pas réellement), on pourrait considérer notre rôle `ntp`
comme une sorte de « fonction » générique qui admet
ici deux variables (`ntp_servers` et `ntp_admin_email`),
qui permet de mettre en place une configuration du service
ntp et, surtout, qui sera réutilisable dans différents playbooks
tout en évitant la duplication de code ansible.

```cfg
# Il faut vraiment voir le rôle `ntp` comme une sorte de fonction autonome à
# deux variables qui pourra être appelée (utilisée) dans différents playbooks,
# sachant que dans cet exemple la variable ntp_servers admet une valeur par
# défaut (utilisée si la variable n'est pas explicitement définie) mais la
# variable ntp_admin_email, elle, n'admet pas de valeur par défaut (et devra
# donc être systématiquement définie explicitement dès que le rôle est utilisé).
#
+---------------------+
|     rôle `ntp`      |
+---------------------+
| Variables du rôle : |
|                     |
| * ntp_servers       |
| * ntp_admin_email   |
|                     |
+---------------------+
```


### Mais comment on utilise notre rôle `ntp` maintenant ?

Et bien, avec un playbook qui, comme on va le voir, va se retrouver
très réduit en taille, l'essentiel du code étant *encapsulé* dans
notre rôle (ici on n'a qu'un rôle mais, dans la pratique, un playbook
appliquera toute une série de rôles).

On va créer nos playbooks à la racine du répertoire `/etc/ansible/`
à côté du répertoire `./roles/`.

Par exemple on va créer un playbook
`sambaedu.yaml` qui s'appliquera au groupe `sambaedu` (qui
ne contient que le serveur`se3`) comme ceci :

```sh
touch /etc/ansible/sambaedu.yaml
```

ce qui donne ceci :

```
/etc/ansible/
├── ansible.cfg
├── hosts
├── sambaedu.yaml
└── roles
    └── ntp
```

Voici un exemple pour notre fichier `/etc/ansible/sambaedu.yaml` :

```yaml
---
- hosts: sambaedu # Ici c'est le groupe `sambaedu` (réduit à un seul hôte).
  vars:
    # On pourrait laisser non définie la variable ntp_servers et c'est sa
    # valeur par défaut dans le rôle "ntp" qui serait utilisée. Par contre,
    # on doit fournir une valeur à la variable ntp_admin_email car elle n'a
    # pas de valeur par défaut, elle.
    ntp_servers:
      - '0.debian.pool.ntp.org'
      - '1.debian.pool.ntp.org'
      - '2.debian.pool.ntp.org'
    ntp_admin_email: 'flaf@domain.tld'
  roles:
    - ntp
#   - roleA <= dans la vraie vie, on appliquera toute une série de rôles.
#   - roleB
#   - … 
```

Créons également le playbook `/etc/ansible/linuxclients.yaml` comme ceci :

```yaml
---
- hosts: linuxclients
  vars:
    ntp_servers:
      - '192.168.0.10' # <= mettons l'IP du serveur`se3` dans le cas des clients-Linux.
    ntp_admin_email: 'flaf@domain.tld'
  roles:
    - ntp
#   - … <= dans la vraie vie, on appliquera toute une série de rôles.
```

**Remarque :** dans les deux playbooks ci-dessus, on a indiqué des clés `vars`
mais ce n'est pas une bonne pratique ; [La bonne pratique pour les variables](#utilisation-des-variables-dhôtes-et-de-groupes) est d'utiliser des **variables de groupes** ou des **variables d'hôtes**.

On pourra lancer nos playbooks comme ceci :

```sh
ansible-playbook /etc/ansible/sambaedu.yaml --diff
ansible-playbook /etc/ansible/linuxclients.yaml --diff
# Pour vérifier notamment que la synchronisation ntp des clients
# Linux se fait bien sur l'IP du se3
ansible linuxclients -a 'ntpq -pn4'
```


## Utilisation des variables d'hôtes et de groupes

### La bonne pratique pour les variables

En fait, mettre les variables directement dans les playbooks n'est
pas non plus une bonne pratique.

On voit, par exemple, que la valeur
de la variable `ntp_admin_email` est présente à deux endroits
différents (la duplication de données, *c'est le mal*).

On va utiliser les **variables de groupes** qui sont définies dans
des fichiers YAML (encore et toujours), fichiers de
la forme :

```cfg
# Le nom du groupe est celui qui est indiqué dans le fichier
# /etc/ansible/hosts (entre crochets).
/etc/ansible/group_vars/<non-du-groupe>.yaml
```

On peut aussi définir des **variables pour un hôte en particulier**
avec des fichiers de la forme :

```cfg
# Le nom de l'hôte tel qu'indiqué dans le fichier /etc/ansible/hosts.
/etc/ansible/host_vars/<non-de-l-hôte>.yaml
```


### Complément de l'arborescence

Il faut d'abord créer les fichiers et répertoires qui n'existent
pas par défaut :

```sh
mkdir /etc/ansible/host_vars/
mkdir /etc/ansible/group_vars/
touch /etc/ansible/group_vars/all.yaml
touch /etc/ansible/group_vars/linuxclients.yaml
touch /etc/ansible/group_vars/sambaedu.yaml
touch /etc/ansible/host_vars/client1.athome.priv.yaml
```

On a alors :

```
/etc/ansible/
├── group_vars
│   ├── all.yaml
│   ├── linuxclients.yaml
│   └── sambaedu.yaml
├── host_vars
│   └── client1.athome.priv.yaml
├── roles
│   └── ntp/…
├── ansible.cfg
├── hosts
├── linuxclients.yaml
└── sambaedu.yaml
```


### Les variables pour le rôle `ntp`

Dans le fichier `/etc/ansible/group_vars/all.yaml`, on va
définir des variables suivantes :

```yaml
---
# Cette variable par exemple, il faut s'attendre à en avoir besoin ici ou là.
# Ces deux variables ne concernent pas directement le rôle ntp.
sambaedu_ip: '192.168.0.10'
admin_email: 'flaf@domain.tld'

# A priori, la valeur de la variable ntp_admin_email doit être
# la même pour tous les clients et on prend la valeur de admin_email
# ci-dessus.
#
# Peut-être qu'un autre rôle aura aussi besoin de cette
# valeur là. En procédant ainsi, la valeur est définie une
# seule fois en haut du fichier.
ntp_admin_email: '{{ admin_email }}'
```

En revanche, la variable `ntp_servers` n'est pas encore définie.
On veut que cela soit les serveurs NTP du pool Debian pour le serveur`se3` mais que
ce soit l'IP du se3 pour client1 et client2 (et pour tous les
clients-Linux en somme).

Du coup, on a, pour le fichier `/etc/ansible/group_vars/sambaedu.yaml` :

```yaml
---
ntp_servers:
  - '0.debian.pool.ntp.org'
  - '1.debian.pool.ntp.org'
  - '2.debian.pool.ntp.org'
```

En fait,
on pourrait même ne rien mettre car la valeur par défaut du
rôle `ntp` nous conviendrait parfaitement.

Et enfin pour le
fichier `/etc/ansible/group_vars/linuxclients.yaml` :

```yaml
---
# Là aussi, ne pas écrire ici l'IP de se3 en dur une
# deuxième fois, il faut utiliser la variable sambaedu_ip
# définie plus haut.
ntp_servers:
  - '{{ sambaedu_ip }}'
```


### Abandon de la clé `vars` pour le rôle `ntp`

On peut alors rééditer nos playbooks car nous n'avons plus
besoin du tout de la clé `vars`. On peut se contenter de :

```yaml
---
# Pour le fichier /etc/ansible/linuxclients.yaml.
- hosts: linuxclients
  roles:
    - ntp

# Pour le fichier /etc/ansible/sambaedu.yaml.
- hosts: sambaedu
  roles:
    - ntp

# La clé `vars` a été supprimée dans les deux fichiers.
```

Dans notre exemple simpliste, les deux playbooks contiennent
les mêmes rôles, mais on peut imaginer que, dans le cas de
`sambaedu`, il y aura des rôles supplémentaires propres au serveur `SambaÉdu` qu'on
ne retrouvera pas dans le playbook des clients-Linux.


### Utilisation des playbooks

On peut à nouveau lancer nos playbooks,
normalement on devrait avoir le résultat souhaité :

```sh
ansible-playbook /etc/ansible/sambaedu.yaml --diff
ansible-playbook /etc/ansible/linuxclients.yaml --diff
# on vérifie :
ansible linuxclients -a 'ntpq -pn4'
```

Mais imaginons que, pour une raison particulière (peu importe
laquelle), il faut que *client1* utilise lui aussi les
serveurs `NTP` du *pool Debian* pour sa synchronisation (juste
lui, on imagine que c'est une exception parmi les clients-Linux)
alors on peut utiliser le fichier `/etc/ansible/host_vars/client1.athome.priv.yaml`
et y mettre :

```yaml
---
ntp_servers:
  - '0.debian.pool.ntp.org'
```

Avec `ansible-playbook /etc/ansible/linuxclients.yaml --diff`, on
verra que seul *client1* va changer son serveur `ntp` de référence.

L'idée ici est que, pour l'hôte *client1*, la variable `ntp_servers`
est définie dans plusieurs fichiers mais c'est le fichier le
plus « précis » qui l'emporte.

En fait, pour l'hôte *client1*,
`Ansible` lit dans cette ordre :

1. Les assignations de variables dans `./group_vars/all.yaml`,
2. Les assignations de variables dans `./group_vars/linuxclients.yaml`,
3. Les assignations de variables dans `./host_vars/client1.athome.priv.yaml`,

du plus général au plus précis et c'est la dernière assignation
qui l'emporte.


## Petite astuce pour appliquer un playbook en le limitant à un seul client

En fait, dans notre cas pratique, on imagine mal les clients-Linux
tous allumés en même temps et, par exemple, dans le cas d'une intégration
d'un client, on voudra sans doute lancer le playbook sur un seul
client (celui qu'on veut intégrer).

Pour limiter notre playbook à un client en particulier,
on va utiliser l'astuce suivante :  
on va utiliser **une variable `target`** qui ne sera définie nulle part et
qu'on définira en ligne de commandes directement.

Dans le fichier `/etc/ansible/linuxclients.yaml`, changer la valeur
de la clé `hosts` et mettre :

```yaml
---
# Petite astuce supplémentaire ici. Au lieu de mettre "{{ target }}",
# la syntaxe ci-dessous permet de définir la valeur sur `linuxclients`
# par défaut si target n'est pas définie.
- hosts: "{{ target | default('linuxclients' }}"
  roles:
    - ntp
```

Désormais on peut faire :

```sh
# Le playbook lancé sur tous les clients du groupe linuxclients car target est non définie.
ansible-playbook /etc/ansible/linuxclients.yaml --diff

# Le playbook est lancé ici seulement sur le client client1.athome.priv.
ansible-playbook /etc/ansible/linuxclients.yaml --diff --extra-vars target='client1.athome.priv'
```


## Résumé des bonnes pratiques « Ansible »

* Utiliser [des rôles](#la-bonne-pratique-des-rôles-pour-lorganisation-des-fichiers) pour structurer vos playbooks
* Préfixer [le nom des variables](#création-du-fichier-de-template-du-rôle-ntp) d'un rôle par le nom du rôle
* Utiliser [des variables d'hôtes et des variables de groupes](#utilisation-des-variables-dhôtes-et-de-groupes)


## Exercices

Voici quelques exercices qui pourront vous être utiles pour la gestion de clients-Linux.

### Exercice 1

Vous avez quelques machines sur lesquelles sont installées des systèmes GNU/Linux : écrire un Playbook pour les mettre à jour.

**Solution :** avant de regarder [une proposition de solution](solutions.md#exercice-1), cherchez un peu…


## Références

* Article sur [Ansible et les inventaires php et mysql](https://ancel1.fr/2016/04/20/ansible-inventaire-dynamique/)



