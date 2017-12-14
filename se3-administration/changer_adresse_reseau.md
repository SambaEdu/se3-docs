
# Changer l'adresse du réseau

* [Position du problème](#position-du-problème)
* [Étapes du changement](#étapes-du-changement)
* [Vérifications](#vérifications)
* [Problèmes éventuels](#problèmes-éventuels)


## Position du problème

Votre réseau a un adressage ne pouvant gérer qu'un nombre très limité de machines. C'est le cas d'un réseau ayant pour adresse `192.168.1.0/24` (le masque s'occupant des 3 premiers octets : 3×8 = 24 est donc `255.255.255.0`).

Pour augmenter nettement le nombre d'IP disponible, on peut envisager de passer à une adresse telle que `172.16.0.0/16` ou bien `192.168.0.0/16` (le masque s'occupant des 2 premiers octets : 2×8 = 16 est donc `255.255.0.0`).

Nous vous proposons ici les principales étapes à suivre pour mener à bien cette opération de changement de l'adresse du réseau.

**Important :** À noter qu'il faudra coordonner les changements concernant le réseau pédagogique, les changements au niveau des différents switchs et celui concernant la passerelle de votre réseau : cela doit être fait par l'administrateur de cette passerelle (souvent c'est un `Amon`) et de ces switchs (souvent ce sont des `VLAN`), administrateur qui est sans doute la `DSI` de votre académie.


## Étapes du changement

- le script chg_ip_se3.sh en indiquant la nouvelle IP, masque, passerelle, DNS.

- contacter la `DSI` pour faire changer l'IP pédagogique du SE3 et les adresses au niveau des switchs/VLAN.

- modifir le service `DHCP` du SE3 avec les nouveaux paramètres.

- modifier le proxy firefox et la page de démarrage firefox personnalisée.

- supprimer les anciennes réservations d'adresses IP et renseigner les nouvelles. pour cela, on pourra s'aider des possibilités de l'interface web du se3 : http://wwdeb.crdp.ac-caen.fr/mediase3/index.php/Le_module_DHCP#Modifier_le_plan_d.27adressage_des_machines_clientes  
Le principe consiste à exporter les données de l'annuaire dans un fichier au format csv avant de les envoyer dans cette page qui se charge de faire un remplacement automatique des adresses.

- modifier les `IP` des machines en `IP fixes` : serveur antivirus, NAS pédagogique, imprimantes, bornes Wi-Fi…


## Vérifications

La vérification est simple : dans chaque parc de machines, ouvrir une session sur une des machines de ce parc. Tout doit fonctionner.


## Problèmes éventuels

**Problème 1 :** aucun compte n'arrive à se connecter au serveur, j'obtiens le fameux : "aucun serveur d'accès disponible".

**Solution :** vérifier s'il n'y a pas une *coquille* dans le masque de sous-réseau (ou un autre paramètre) lors de la procédure de changement d'adresse ip…


