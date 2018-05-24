#!/bin/bash

# Script de modification des ip sur les postes clients GNU/Linux.
# Ce script est à utiliser si le réseau change de plan d'adressage
# 2 paramètres : ancienne_ip et nouvelle_ip
# Utilisation : /bin/bash change_ip ancienne_ip nouvelle_ip

function erreur ()
{
    echo "Erreur"
}


ancienneIp=$1
nouvelleIp=$2

if [ -z $ancienneIp ] || [ -z $nouvelleIp ]
then erreur
fi

rep="/"
liste_fichiers=`grep -rl --binary-files=without-match $ancienneIP $rep `
for i in $liste_fichiers
do
    echo "Modifier $ancienneIp dans $i par $nouvelleIp"
    sed -i -e "s/$ancienneIp/$nouvelleIp/g" $i
done 
