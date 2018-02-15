#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'

gs="git status | grep 'new file:' | grep -v 'Pods' | awk 'NF>1{print \$NF}' | sed -e 's-.*/--g' | sed -e 's/\"//g'"

# Récupération de la liste des nouveaux fichiers

fichiers=`eval $gs`

echo

while read -r fichier; do
    if [[ $fichier != *"Test"* ]] && [[ $fichier != *".h"* ]]
    then
        regex="'print if m{(?!Test)"$fichier"}'"

        regex=`echo $regex | sed -e 's/+/\\\\+/g'`

        command="cat "$1"project.pbxproj | perl -nle $regex | grep -Eiv \"Test\" | wc -l"

        nb=`eval $command`

        if [ $nb -lt 10 ]
        then
            echo "${RED}Fichier $fichier non valide"
        else
            echo "${GREEN}Fichier $fichier valide"
        fi
    fi
done <<< "$fichiers"
echo
