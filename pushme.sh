#!/bin/bash

# Couleurs
rouge='\e[1;31m'
jaune='\e[1;33m'
bleu='\e[1;34m'
violet='\e[1;35m'
vert='\e[1;32m'
neutre='\e[0;m'

echo -e "${bleu}"
echo -e "██████╗ ██╗   ██╗███████╗██╗  ██╗    ██╗████████╗"
echo -e "██╔══██╗██║   ██║██╔════╝██║  ██║    ██║╚══██╔══╝"
echo -e "██████╔╝██║   ██║███████╗███████║    ██║   ██║   "
echo -e "██╔═══╝ ██║   ██║╚════██║██╔══██║    ██║   ██║   "
echo -e "██║     ╚██████╔╝███████║██║  ██║    ██║   ██║   "
echo -e "╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝   ╚═╝   "
echo -e "${neutre}"

n=1
for i in "${ARG[@]}"; do # on parcours la liste d'argument ARG
	./push_swap "$i" >/dev/null 2>test_check.txt
	if [ -s "$FICHERO" ]; then
		while IFS= read -r line; do
			if [[ $line == "Error" ]]; then
				printf "${vert}$n.[OK] ${DEF_COLOR}"
			else
				printf "${rouge}$n.[KO] ${DEF_COLOR}"
				break
			fi
		done <test_check.txt
	else
		printf "${rouge}$n.[KO] ${DEF_COLOR}"
	fi
	((n = n + 1))
	rm -rf test_check.txt
done
