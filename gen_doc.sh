#!/bin/bash

# Script de création d'un doc pdf à partir des .md de github
# Il faut créer, dans le dossier doc_LaTeX, un lien symbolique
# vers le répertoire images
# ln -s ../se3-clients-linux/images/ images 

repertoire_courant=`pwd`
# On récupère la liste des fichiers .md de tous les sous-répertoires
liste_fichiers=`find $repertoire_courant/ -name "*.md"`
# Répertoire de création de la doc LaTeX
ch_docs='doc_LaTeX'
# Répertoire de stockage de chaque fichier .tex
ch_src='src'
#echo $liste_fichiers
for i in $liste_fichiers; do
    #echo $i
    # On récupère le nombre d'occurences du caractère / dans
    # le nom de fichier 
    separateur_dossier=`echo $i | tr -dc '/' | wc -c`
    # Le nombre obtenu est incrémenté de 1
    separateur_fichier=$((separateur_dossier + 1))
    #echo $separateurs
    # On récupère le nom du fichier seul sans le chemin qui est
    # à la position $separateurs_dossier
    nom=`echo $i | cut -d / -f$separateurs`
    # On récupère le nom du fchier seul sans l'extension md
    nom=`echo $nom | cut -d . -f1`
    # Conversion de chaque .md en .tex
    echo "Conversion de $i"
    pandoc -f markdown_github -t latex -o $ch_docs/$ch_src/$nom.tex $i
    #exit
done


cd $ch_docs

# Création du fichier doc .tex
# Le preambule peut être modifié indépendamment de ce script 
echo "
\input{preambule}
\begin{document}
\maketitle
\tableofcontents

" > doc.tex
#On récupère la liste des fichiers .tex
#***TODO*** trouver un moyen d'ordonner les fichiers
liste_tex=`ls $ch_src/`
for i in $liste_tex; do
    # On récupère le nom du fichier sans extension
    nom=`echo $i | cut -d . -f1`
    # Ajout d'une ligne include avec le nom du fichier
    echo "\include{$ch_src/$nom}" >> doc.tex
done
echo "

\end{document}
" >> doc.tex
# Création du pdf
pdflatex doc.tex -output-directory build -interaction batchmode doc.pdf
# Nettoyage
rm src/*
cd ..

