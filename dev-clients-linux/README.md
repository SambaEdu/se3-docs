# Documentation pour le (futur ?) contributeur/développeur

* [Devenir contributeur/développeur du projet](#devenir-contributeurdéveloppeur-du-projet)
* [Memo sur Git et le formatage markdow](#memo-sur-git-et-le-formatage-markdow)
* [Le channel IRC `#se3`](#le-channel-irc-#se3)
* [Envoyer une notification de ses commits sur la liste `gnu-linux_et_se3`](#envoyer-une-notification-de-ses-commits-sur-la-liste-gnu-linux_et_se3)
* [Points annexes spécifiques au package `se3-clients-linux`](#points-annexes-spécifiques-au-package-se3-clients-linux)
    * [Comment construire le package `se3-clients-linux.deb` ?](#comment-construire-le-package-se3-clients-linux-deb?)
    * [Dépôt APT de test pour le paquet `se3-clients-linux` et branche Git](#dépôt-APT-de-test-pour-le paquet-se3-clients-linux-et-branche-git)
    * [La boîte à outils `lib.sh`](#la-boîte-à-outils-lib.sh)


## Devenir contributeur/développeur du projet

Vous voulez devenir contributeur du projet ? Ou bien vous ne
vous sentez pas apte à modifier le code mais vous souhaitez
participer à l'élaboration de la documentation en ligne ?
Rien de plus simple, il suffit de suivre les deux étapes
suivantes :

1. Vous vous créez un compte [Github](https://github.com).
L'inscription se fait [à cette page](https://github.com/join).
Cela prend 5 minutes, c'est une inscription on ne peut plus
classique : on fournit un identifiant, un mot de passe et
une adresse email, on reçoit un mail de confirmation pour
activer son compte Github etc. Si vous êtes inscrit(e) sur
la liste de diffusion `gnu-linux_et_se3`, choisissez comme
adresse email sur Github l'adresse email sur laquelle vous
recevez les messages de la liste de diffusion (voir plus
bas les explications sur ce point).

2. Faites savoir que vous voulez devenir membre du projet
`SambaEdu` en écrivant à l'adresse mail indiquée dans
[ce fichier](https://github.com/SambaEdu/se3-clients-linux/blob/master/src/DEBIAN/control#L7)
au niveau du champ `Maintainer:`. Dans votre mail, indiquez
bien le login de votre compte Github afin que l'on sache le
nom du compte qui doit être intégré au projet. Nous vous
répondrons par mail dès que possible pour vous indiquer que
vous êtes bien désormais habilité(e) à contribuer au projet.


## Memo sur Git et le formatage markdow

Maintenant que vous avez bien procédé aux deux étapes
ci-dessus, vous êtes apte à contribuer au projet. Mais
comment contribuer en pratique ? Comme vous pouvez le
constater, le projet est géré par Git (un logiciel de «
gestion de code source », on dit aussi de « versionning de
code source »). Github, lui, n'est qu'un site web permettant
surtout de *visualiser* le projet (et de lui donner une
visibilité publique). Mais la *modification* du projet,
elle, se fait sur votre machine en local avec le logiciel
Git (donc on utilise Git pour gérer un projet sous Github,
jusqu'ici ça se tient). L'utilisation de Git pour des tâches
courantes (typiquement modifier/ajouter un fichier) est
beaucoup plus simple qu'il n'y paraît. Il existe de nombreux
tutoriels sur Git dans le Web. Nous vous proposons également
un [petit memo ici](memo-git.md) qui devrait vous permettre
de bien débuter.


## Le channel IRC `#se3`

Si vous êtes motivé(e)s pour contribuer mais que rencontrez
des difficultés techniques, n'hésitez pas à demander de
l'aide sur IRC (protocole de communication par messages
instantanés). Une discussion en directe est parfois plus
rapide et plus efficace qu'un échange par mails pour
dépanner quelqu'un. Un channel `#se3` est disponible sur le
serveur `irc.crdp.ac-versailles.fr` (port 6667).

Pour vous connecter, il faut d'abord que vous installiez un
client IRC sur votre machine. Voici un guide très rapide
pour y arriver si vous êtes sur un système d'exploitation de
type Debian ou Ubuntu. D'abord vous installez le client IRC
`pidgin` (il existe plein d'autres clients IRC) en lançant
les deux commandes suivantes :

```sh
# Soit en tant que root ou alors avec sudo devant chaque commande.
apt-get update
apt-get install pidgin
```

Vous pouvez alors lancer alors le programme pidgin
fraîchement installé et ensuite il vous suffira de suivre
les instructions indiquées dans la vidéo ci-dessous (qui
dure 1 minute environ) :

- la vidéo est [disponible ici](irc-one-minute.mp4) au format
mp4. Vous pouvez la télécharger (la vidéo ne fait que 4 Mo
environ) en faisant un clic droit + "enregistrer sous" au
niveau du bouton `Raw` (à droite de la page).
- la vidéo est [disponible ici](irc-one-minute.ogv) au format
ogv. Vous pouvez la télécharger (la vidéo ne fait que 1 Mo
environ) en faisant un clic droit + "enregistrer sous" au
niveau du bouton `Raw` (à droite de la page).


## Envoyer une notification de ses commits sur la liste `gnu-linux_et_se3`

Vous trouverez toutes les explications nécessaires à [cette page](notification.md).




## Points annexes spécifiques au package `se3-clients-linux`

### Comment construire le package `se3-clients-linux.deb` ?

Vous trouverez toutes les explications nécessaires à [cette page](build-package.md).

### Dépôt APT de test pour le paquet `se3-clients-linux` et branche Git

Il existe un dépôt Debian APT de test qui vous permet de
tester le paquet `se3-clients-linux` dans sa dernière
version. Le dépôt est mis à jour toutes les 5 minutes.
Évidemment c'est pour du test, aucune stabilité n'est
garantie. Vous trouverez toutes les explications nécessaires
à [cette page](apt-repository.md).

### La boîte à outils `lib.sh`

C'est un fichier qui contient toute une série de fonctions
shell qui peuvent être réutilisables dans différents scripts
du paquet `se3-clients-linux`. Vous trouverez plus
d'explications à [cette page](libsh.md).



