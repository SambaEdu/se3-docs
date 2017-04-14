# Solutions des exercices

Vous trouverez ci-dessous des propositions de solutions aux exercices du tutoriel concernant Ansible.

## Exercice 1

**Rappel de l'énoncé :**  
Vous avez quelques machines sur lesquelles sont installées des systèmes GNU/Linux : écrire un Playbook pour les mettre à jour.

**Une solution :**  
Voici le contenu d'un playbook ansible répondant au problème.
```yaml
---
- hosts: maison
  remote_user: root
  tasks:
    - name: mise à jour de la liste des paquets
      apt:
        name: apt
        update_cache: yes
    - name: mise à jour des paquets installés
      apt:
        upgrade: yes
```

**Remarque :**  
Le fichier hosts contiendra par exemple les lignes suivantes (les clients sont désignés par leur ip) :
```yaml
[maison]
192.168.75
192.168.1.22
localhost ansible_connection=local
```

Et la commande pour lancer ce playbook :
```sh
ansible-playbook update.yaml
```


