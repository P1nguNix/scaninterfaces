#!/bin/bash
#
# For Mac-Users Only !
#
# Created by Paul

listinterfaces=$(ifconfig | grep UP | cut -d':' -f1) # Permet de récupérer toutes les interfaces de la machine sous forme de liste
echo -e "\nInterface\tAdresse\t\t\tMasque\t\t\tAdresse MAC\t\tMTU\t\tLink-Local IPv6\t\t\tBroadcast IPv4\n" # Affichage et mise en forme des différentes caractéristiques
for i in $listinterfaces # Pour chaque Interface
do
	if [[ $(ifconfig $i | grep -w "inet" | wc -l) -eq 1 ]]
	# grep -w inet, force la recherche du motif qui correspond a une adresse IP si il y'en a une alors, s\'affiche les différents paramètres.
	# Il y'a possibilité de remplacer " -eq 1 " par " -ne 0 " si une interface possède plusieurs adresse IP (dans le cas d\'une machine virtuelle en bridge par exemple)
	then
		interface=$(ifconfig $i | grep UP | cut -d':' -f1)
		ipaddress=$(ifconfig $i | grep -w inet | cut -d ' ' -f2)
		subnetmask=$(ifconfig -f inet:dotted $i | grep netmask | cut -d ' ' -f4)
		macaddress=$(ifconfig $i | grep -w ether | cut -d ' ' -f2)
		mtu=$(ifconfig $i | grep mtu | cut -d ' ' -f4)
		linklv6=$(ifconfig $i | grep fe80 | grep 64 | cut -d ' ' -f2 | cut -d '%' -f1)
		brdctv4=$(ifconfig $i | grep -w inet | cut -d ' ' -f6)
		informations=("$interface" "$ipaddress" "$subnetmask" "$macaddress" "$mtu" "$linklv6" "$brdctv4")
		for information in "${!informations[@]}"
		do
			if [[ -z "${informations[$information]}" ]]
			then
				informations[$information]="\t\t"
			fi
		done
		echo -e "${informations[0]}:\t\t${informations[1]}\t\t${informations[2]}\t\t${informations[3]}\t${informations[4]}\t\t${informations[5]}\t${informations[6]}"
	fi
done
