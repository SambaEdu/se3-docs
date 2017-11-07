# Configurer la messagerie du `se3`

* [Des infos à recueillir](#des-infos-à-recueillir)
* [Configuration via l'interface `web`](#configuration-via-linterface-web)
* [Vérification](#vérification)

## Des infos à recueillir

Pour que votre `se3` vous envoie quelques messages d'informations de son fonctionnement, il s'agit de lui communiquer quelques paramètres qui vont permettre le bon fonctionnement de la messagerie. Notamment si vous la passerelle est un `Amon`.

Contrairement au `Slis`, le serveur `Amon` ne peut pas servir de relais `SMTP` pour envoyer des courriels vers l’extérieur.

Il faut donc utiliser un serveur `SMTP externe` : celui du `FAI` (Fournisseur d'Accès à Internet) du réseau de l'établissement peut convenir, même s'il nécessite une authentification.

Vous avez besoin de connaître les paramètres suivants :

* **Domaine** : saisir un domaine qui existe et se termine par exemple par **.ac-versailles.fr** (si vous êtes dans l'académie de Versailles). Si vous disposez d’un nom fourni par la `DSI` pour accéder à votre réseau depuis l’extérieur, celui-ci peut convenir.
* **Serveur SMTP** : saisir l’adresse de votre serveur `SMTP` externe. Ce peut être celui de votre `FAI`, ou un serveur `SMTP` externe, suivi du port utilisé s’il est différent du port 25 par défaut (bloqué chez de nombreux `FAI`).
* **Boîte de réception** : une adresse mail valide, à laquelle le SE3 écrira ;-). Ce peut-être votre adresse de messagerie académique mais ce n'est pas une obligation.

Éventuellement, si c'est nécessaire, vous aurez aussi besoin de connaître l'Identifiant de connexion au serveur `SMTP` de votre `FAI` et si vous utilisez le mode sécurisé `TLS` ou `STARTTLS`.

Dans ce qui suit, nous supposons que, d'une part, le `FAI` est **completel.com** (son `SMTP` est **smtp.completel.net**, information que l'on peut trouver via un moteur de recherche), et d'autre part, que la boîte de réception est celle de votre adresse de messagerie académique. Vous adapterez en fonction de votre situation.


## Configuration via l'interface `web`

Tout se passe dans l'interface web du se3 avec l'entrée `Configuration générale/Paramètres serveur`. Il suffit de cliquer sur la ligne correspondant à "Expédition des messages système". On obtient un tableau à renseigner.
![messagerie_01](images/messagerie_01.png)

Avec les informations réunies (voir ci-dessus), vous complétez les champs de configuration de la messagerie dans l'interface web du `se3`.
![messagerie_03](images/messagerie_03.png)

Vous validez et vous devriez recevoir un message de confirmation de la part du `se3`.


## Vérification

Le test d’envoi de message de l’interface web devrait fonctionner : dans la page diagnostic, vous cliquez sur le bouclier vert correspondant à la ligne "Configuration de l'expédition des mails" et un menu contextuel permettra d'envoyer un message de test.
![messagerie_02](images/messagerie_02.png)

Pour recevoir un mail immédiatement à une adresse donnée, on pourra aussi lancer la commande suivante, via un terminal en ssh sur le `se3` :

```sh
echo "test" | mail mon@dresse.tld
```

