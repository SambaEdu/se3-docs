Pxe allant être abandonné au profit de Ipxe, il est possible d'utiliser ipxe pour l'instant en gardant un menu similaire au menu classique.

* [Installation du dispositif](#installation_du_dispositif)
* [Utilisation du nouveau menu ipxe](#utilisation_du_nouveau_menu_ipxe)
* [Modification du menu IPXE](#modification_du_menu_ipxe)


## Installation du dispositif##

On renomme l'ancien dispositif
```
mv /var/www/se3/ipxe  /var/www/se3/ipxe.sav
```
On va copier le dispositif expérimental dans un répertoire comme /var/se3, puis on fera un lien symbolique vers /var/www/se3/ipxe
```
cd /var/se3
git clone https://github.com/SambaEdu/sambaedu-ipxe.git
cd /var/www/se3
ln -s /var/se3/sambaedu-ipxe/sources/ipxe ipxe
```
On désactive ensuite l'interface graphique du menu pxe (partie tftp de l'interface admin du se3).
Actuellellement, le se3 lance le boot en PXE, puis ipxe est lancé ensuite si on appuie sur "i".

Le nouveau menu est lancé à partir d'un fichier php appelé boot-base.php. Il faut donc modidier le fichier /tftpboot/pxelinux.cfg/default
```
nano /tftpboot/pxelinux.cfg/default
```
On ajoute à la fin du fichier (en indiquant la bonne ip du se3)
```
label b
    kernel ipxe.lkrn
    append dhcp && chain http://172.20.0.2:909/ipxe/boot-base.php

```
Il faut aussi modifier le choix par défaut en haut du fichier.
```
default b
```

On peut également réduire le timeout pour que le menu ipxe soit lancé le plus vite possible, et surppimer toutes les autres entrées du fichier default pour être sur qu'aucun utilisateur ne lance une commande .

## Utilisation du nouveau menu ipxe
Lors du boot, le nouveau menu va apparaitre (comme l'ancien menu pxe)
![01](images/menu1.png)
Sans action de l'utilisateur,l'ordinateur va booter sur le disque dur de façon traditionnelle.

Pour aller dans le menu avancé, il faut indiquer un login *adminse3* et le mot de passe qui est l'ancien mot de passe du menu pxe. 
On peut retrouver/changer ce mot de passe dans l'interface du se3.

On arrive alors dans la partie avancée. On a plus qu'à aller dans la partie souhaitée et valider.
![02](images/menu2.png)
![03](images/menu3.png)
![04](images/menu4.png)
![05](images/menu5.png)
![06](images/menu6.png)

## Modification du menu IPXE

 
 
