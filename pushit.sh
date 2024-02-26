#!/bin/bash

# Couleurs
rouge='\e[1;31m'
jaune='\e[1;33m'
bleu='\e[1;34m'
violet='\e[1;35m'
vert='\e[1;32m'
neutre='\e[0;m'
DEF_COLOR='\033[0;39m'
BLACK='\033[0;30m'
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[0;93m'
BLUE='\033[0;94m'
MAGENTA='\033[0;95m'
CYAN='\033[0;96m'
GRAY='\033[0;90m'
WHITE='\033[0;97m'

echo -e "${bleu}"
echo -e "██████╗ ██╗   ██╗███████╗██╗  ██╗    ██╗████████╗"
echo -e "██╔══██╗██║   ██║██╔════╝██║  ██║    ██║╚══██╔══╝"
echo -e "██████╔╝██║   ██║███████╗███████║    ██║   ██║   "
echo -e "██╔═══╝ ██║   ██║╚════██║██╔══██║    ██║   ██║   "
echo -e "██║     ╚██████╔╝███████║██║  ██║    ██║   ██║   "
echo -e "╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝   ╚═╝   "
echo -e "${neutre}"

echo -e "${bleu} ---------------------- ${vert}SELECT TEST ${bleu}----------------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} --------------- ${vert}Test Général : Type G/g ${bleu}-----------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} ----------------- ${vert}Mass Tests : Type M/m ${bleu}-----------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} ----------------- ${vert}Visualizer : Type V/v ${bleu}-----------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} -------------------- ${vert}All : Type A/a ${bleu}---------------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${vert}"
read -p "                [m/g/v/a]" rep
echo -e "${bleu}"
case $rep in
M)
	mode=1
	;;
m)
	mode=1
	;;
V)
	mode=2
	;;
v)
	mode=2
	;;
G)
	mode=3
	;;
g)
	mode=3
	;;
A)
	mode=4
	;;
a)
	mode=4
	;;
*)
	mode=5
	;;
esac

if [ $mode -eq 1 ] || [ $mode -eq 4 ]; then

	# set best scores limits
	lim3=3
	lim5=12
	lim100=700
	lim500=5500

	make >/dev/null
	cd push_swap_tester
	make >/dev/null

	./complexity 3 500 $lim3 ../checker_linux
	./complexity 5 500 $lim5 ../checker_linux
	./complexity 100 500 $lim100 ../checker_linux
	./complexity 500 100 $lim500 ../checker_linux

	make fclean >/dev/null
	cd ..
	make fclean >/dev/null
fi
if [ $mode -eq 2 ] || [ $mode -eq 4 ]; then

	make >/dev/null
	if [ ! -d "./push_swap_visualizer" ]; then
		git clone https://github.com/o-reo/push_swap_visualizer.git
		cd push_swap_visualizer
		mkdir build
		cd build
		cmake ..
		make
	else
		cd push_swap_visualizer/build/
	fi
	./bin/visualizer
	cd ../..

	make fclean >/dev/null
fi
if [ $mode -eq 3 ] || [ $mode -eq 4 ]; then

	make >/dev/null
	rm -rf traces.txt
	rm -rf 0

	FILE=$PWD/push_swap
	FICHERO=test_check.txt

	ARG=(
		"a"
		"111a11"
		"hello world"
		"0 0"
		"-01 -001"
		"111-1 2 -3"
		"-3 -2 -2"
		"\n"
		"-2147483649"
		"-2147483650"
		"2147483648"
		"8 008 12"
		"10 -1 -2 -3 -4 -5 -6 90 99 10"
		"1 +1 -1"
		"3333-3333 1 4"
		"111a111 -4 3"
		"111111 -4 3 03"
		"2147483649"
		"2147483647+1"
		"0 1 2 3 4 5 0"
		"3 +3"
		"3+3"
		"42 42"
		"42 -42 -42 "
		"4222-4222"
		"99999999999999999999999999"
		"-99999999999999999999999999"
		"0 -0 1 -1"
		"0 +0 1 -1"
		"111+111 -4 3"
		"-"
		"+"
		"--123 1 321"
		"++123 1 321"
		"0000000000000000000000009 000000000000000000000009"
		"00000001 1 9 3"
		"00000003 003 9 1"
		"--21345"
		"1 01"
		"-000 -0000"
		"-00042 -000042"
		""
	)
	printf ${BLUE}"\n-------------------------------------------------------------\n"${DEF_COLOR}
	printf ${BLUE}"\n\t\t\tCONTROL ERRORS\t\n"${DEF_COLOR}
	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}
	n=1
	for i in "${ARG[@]}"; do # on parcours la liste d'argument ARG
		./push_swap "$i" >/dev/null 2>test_check.txt
		if [ -s "$FICHERO" ]; then
			while IFS= read -r line; do
				if [[ $line == "Error" ]]; then
					printf "${GREEN}$n.[OK] ${DEF_COLOR}"
				else
					printf "${RED}$n.[KO] ${DEF_COLOR}"
					break
				fi
			done <test_check.txt
		else
			printf "${RED}$n.[KO] ${DEF_COLOR}"
		fi
		((n = n + 1))
		rm -rf test_check.txt
	done
	./push_swap "" >/dev/null 2>test_check.txt
	if [ -s "$FICHERO" ]; then
		while IFS= read -r line; do
			if [[ $line == "Error" ]]; then
				printf "${GREEN}$n.[OK] ${DEF_COLOR}\n"
			else
				printf "${RED}$n.[KO] ${DEF_COLOR}\n"
				break
			fi
		done <test_check.txt
	else
		printf "${RED}$n.[KO] ${DEF_COLOR}\n"
	fi
	((n = n + 1))
	rm -rf test_check.txt
	rm -rf 0
	ARG2=(
		"2 1"
		"1 3 2"
		"2 3 1"
		"2 1 3"
		"3 1 2"
		"3 2 1"
	)
	ARG3=(
		"1 2 4 3"
		"1 3 2 4"
		"1 3 4 2"
		"1 4 3 2"
		"1 4 2 3"
		"2 3 4 1"
		"2 4 3 1"
		"2 1 4 3"
		"2 1 3 4"
		"2 3 1 4"
		"2 4 1 3"
		"3 4 1 2"
		"3 4 2 1"
		"3 2 1 4"
		"3 1 2 4"
		"3 1 2 4"
		"3 2 4 1"
		"3 1 4 2"
		"4 1 2 3"
		"4 1 3 2"
		"4 2 1 3"
		"4 2 3 1"
		"4 3 1 2"
		"4 3 2 1"
	)

	printf ${BLUE}"\n-------------------------------------------------------------\n"${DEF_COLOR}
	printf ${BLUE}"\n\t\t\tBasic input\t\t\n"${DEF_COLOR}
	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}

	n=1
	for i in "${ARG2[@]}"; do # on parcours la liste d'argument ARG
		N=$(./push_swap $i | wc -l)
		if [ $N -lt 4 ]; then
			printf "${GREEN}$n.[OK] ${DEF_COLOR}"
		else
			printf "${RED}$n.[KO]${DEF_COLOR}"
			printf "${WHITE} TEST: "
			echo -n "$i "
		fi
		((n = n + 1))
		S=$(./push_swap $i | ./checker_linux $i)
		if [ $S == "OK" ]; then
			printf "${GREEN}$n.[OK] ${DEF_COLOR}"
		else
			printf "${RED}$n.[KO]${DEF_COLOR}"
		fi
		rm -rf test_check.txt
		rm -rf 0
		((n = n + 1))
	done

	for i in "${ARG3[@]}"; do # on parcours la liste d'argument ARG
		N=$(./push_swap $i | wc -l)
		if [ $N -lt 13 ]; then
			printf "${GREEN}$n.[OK] ${DEF_COLOR}"
		else
			printf "${RED}$n.[KO]${DEF_COLOR}"
			printf "${WHITE} TEST: "
			echo -n "$i "
		fi

		((n = n + 1))
		S=$(./push_swap $i | ./checker_linux $i)
		if [ $S == "OK" ]; then
			printf "${GREEN}$n.[OK] ${DEF_COLOR}"
		else
			printf "${RED}$n.[KO]${DEF_COLOR}"
		fi
		((n = n + 1))
	done

	ARG4=(
		"1 2 3 5 4"
		"1 2 4 3 5"
		"1 2 4 5 3"
		"1 2 5 3 4"
		"1 2 5 4 3"
		"1 3 2 4 5"
		"1 3 2 5 4"
		"1 3 4 2 5"
		"1 3 4 5 2"
		"1 3 5 2 4"
		"1 3 5 4 2"
		"1 4 2 3 5"
		"1 4 2 5 3"
		"1 4 3 2 5"
		"1 4 3 5 2"
		"1 4 5 2 3"
		"1 4 5 3 2"
		"1 5 2 3 4"
		"1 5 2 4 3"
		"1 5 3 2 4"
		"1 5 3 4 2"
		"1 5 3 4 2"
		"1 5 4 2 3"
		"1 5 4 3 2"
		"2 1 3 4 5"
		"2 1 3 5 4"
		"2 1 4 5 3"
		"2 1 5 3 4"
		"2 1 5 4 3"
		"2 3 1 4 5"
		"2 3 1 5 4"
		"2 3 4 1 5"
		"2 3 4 5 1"
		"2 3 5 1 4"
		"2 3 5 4 1"
		"2 4 1 3 5"
		"2 4 1 5 3"
		"2 4 3 1 5"
		"2 4 3 5 1"
		"2 4 5 1 3"
		"2 4 5 3 1"
		"2 5 1 3 4"
		"2 5 1 4 3"
		"2 5 3 1 4"
		"2 5 3 4 1"
		"2 5 4 1 3"
		"2 5 4 3 1"
		"3 1 2 4 5"
		"3 1 2 5 4"
		"3 1 4 2 5"
		"3 1 4 5 2"
		"3 1 5 2 4"
		"3 1 5 4 2"
		"3 2 1 4 5"
		"3 2 1 5 4"
		"3 2 4 1 5"
		"3 2 4 5 1"
		"3 2 5 1 4"
		"3 2 5 4 1"
		"3 4 1 2 5"
		"3 4 1 5 2"
		"3 4 2 1 5"
		"3 4 2 5 1"
		"3 4 5 1 2"
		"3 4 5 2 1"
		"3 5 1 2 4"
		"3 5 2 1 4"
		"3 5 2 4 1"
		"3 5 4 1 2"
		"3 5 4 2 1"
		"4 1 2 3 5"
		"4 1 2 5 3"
		"4 1 3 2 5"
		"4 1 3 5 2"
		"4 1 5 2 3"
		"4 1 5 3 2"
		"4 2 1 3 5"
		"4 2 1 5 3"
		"4 2 3 1 5"
		"4 2 3 5 1"
		"4 2 5 1 3"
		"4 2 5 3 1"
		"4 3 1 2 5"
		"4 3 1 5 2"
		"4 3 2 1 5"
		"4 3 2 5 1"
		"4 3 5 1 2"
		"4 3 5 2 1"
		"4 5 1 2 3"
		"4 5 1 3 2"
		"4 5 2 1 3"
		"4 5 2 3 1"
		"4 5 3 1 2"
		"4 5 3 2 1"
		"5 1 2 3 4"
		"5 1 2 4 3"
		"5 1 3 2 4"
		"5 1 3 4 2"
		"5 1 4 2 3"
		"5 1 4 3 2"
		"5 1 4 3 2"
		"5 2 3 1 4"
		"5 2 3 4 1"
		"5 2 4 1 3"
		"5 2 4 3 1"
		"5 3 1 2 4"
		"5 3 1 4 2"
		"5 3 2 1 4"
		"5 3 2 4 1"
		"5 3 4 1 2"
		"5 3 4 2 1"
		"5 4 1 2 3"
		"5 4 1 3 2"
		"5 4 2 1 3"
		"5 4 2 3 1"
		"5 4 3 1 2"
		"5 4 3 2 1"
	)
	printf ${BLUE}"\n\n-------------------------------------------------------------\n\n"${DEF_COLOR}
	printf ${BLUE}"\n\t\t\tSize 5\t\t\n"${DEF_COLOR}
	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}

	n=1
	for i in "${ARG4[@]}"; do # on parcours la liste d'argument ARG
		N=$(./push_swap $i | wc -l)
		if [ $N -lt 13 ]; then
			printf "${GREEN}$n.[OK] ${DEF_COLOR}"
		else
			printf "${RED}$n.[KO]${DEF_COLOR}"
			printf "${WHITE} TEST: "
			echo -n "$i "
		fi
		((n = n + 1))
		S=$(./push_swap $i | ./checker_linux $i)
		if [ $S == "OK" ]; then
			printf "${GREEN}$n.[OK] ${DEF_COLOR}"
		else
			printf "${RED}$n.[KO]${DEF_COLOR}"
		fi
		((n = n + 1))
	done

	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}
	printf ${BLUE}"\n\t\t  Multiple size <= 100\t\t\n"${DEF_COLOR}
	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}

	echo Multiple size '<'= 100 >>traces.txt

	res_1=0
	res_2=0
	res_3=0
	res_4=0
	res_5=0
	res_err=0
	control=1
	val=201
	media=0
	alta=0
	baja=2147483647
	if [ $1 ] >0; then
		val=$1
	fi
	((val++))
	cont=1
	while [ $cont -lt $val ]; do
		ARG=$(ruby -e "puts (00..99).to_a.shuffle.join(' ')")
		S=$(./push_swap $ARG | ./checker_linux $ARG)
		if [ $S == "OK" ]; then
			printf "${GREEN}$cont .[OK]${DEF_COLOR}"
			control=2
		else
			printf "${RED}$cont .[KO]${DEF_COLOR}"
			control=3
		fi
		N=$(./push_swap $ARG | wc -l)
		if [ $N -gt $alta ]; then
			alta=$(($N))
		fi
		if [ $N -lt $baja ]; then
			baja=$(($N))
		fi
		if [ $N -gt 700 ] || [ $N -eq 700 ]; then
			echo TEST $cont ARG:"$ARG" >>traces.txt
		fi
		if [ $N -lt 700 ] && [ $control -eq 2 ]; then
			printf "${GREEN}[OK][5/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			media=$(($media + $N))
			((res_1++))
		elif [ $N -gt 700 ] || [ $N -eq 700 ] && [ $N -lt 900 ] && [ $control -eq 2 ]; then
			printf "${YELLOW}[OK][4/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_2++))
		elif [ $N -gt 900 ] || [ $N -eq 900 ] && [ $N -lt 1100 ] && [ $control -eq 2 ]; then
			printf "${RED}[KO][3/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_3++))
		elif [ $N -gt 1100 ] || [ $N -eq 1100 ] && [ $N -lt 1300 ] && [ $control -eq 2 ]; then
			printf "${RED}[KO][2/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_4++))
		elif [ $N -gt 1300 ] || [ $N -eq 1300 ] && [ $control -eq 2 ]; then
			printf "${RED}[KO][1/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_5++))
		elif [ $control -eq 3 ]; then
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			echo TEST $cont ARG:"$ARG" >>traces.txt
			((res_err++))
		fi
		((cont++))
	done

	((val--))
	media=$(($media / $val))
	printf "${CYAN}\n\nMax: $alta${DEF_COLOR}\n"
	printf "${CYAN}Min: $baja${DEF_COLOR}\n"
	printf "${CYAN}Average: $media${DEF_COLOR}\n"
	printf "${WHITE}\n\nTest ${DEF_COLOR}${GREEN}[5/5] ${WHITE}$res_1/$val"
	if [ $res_1 == $val ]; then
		printf "${GREEN} Congrats , all tests have been completed successfully 🥳✅"
		echo OK >>traces.txt
	fi
	if [ $res_2 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${YELLOW}[4/5] ${WHITE}$res_2/$val"
	fi
	if [ $res_3 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[3/5] ${WHITE}$res_3/$val"
	fi
	if [ $res_4 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[2/5] ${WHITE}$res_4/$val"
	fi
	if [ $res_5 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[1/5] ${WHITE}$res_5/$val\n"
	fi
	if [ $res_err != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[NO SORTED] ${WHITE}$res_err/$val\n"
	fi
	if [ $res_1 != $val ]; then
		printf "${CYAN}\nCheck traces $PWD/traces.txt\n"
	fi

	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}
	printf ${BLUE}"\n\t\t  Multiple size <= 500\t\t\n"${DEF_COLOR}
	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}

	echo Multiple size '<'= 500 >>traces.txt

	res_1=0
	res_2=0
	res_3=0
	res_4=0
	res_5=0
	val=201
	media=0
	control=1
	alta=0
	baja=2147483647
	if [ $2 ] >0; then
		val=$2
	fi
	((val++))
	cont=1
	while [ $cont -lt $val ]; do
		ARG=$(ruby -e "puts (-250..249).to_a.shuffle.join(' ')")
		S=$(./push_swap $ARG | ./checker_linux $ARG)
		if [ $S == "OK" ]; then
			printf "${GREEN}$cont .[OK]${DEF_COLOR}"
			control=2
		else
			printf "${RED}$cont .[KO]${DEF_COLOR}"
			control=3
		fi
		N=$(./push_swap $ARG | wc -l)
		if [ $N -gt $alta ]; then
			alta=$(($N))
		fi
		if [ $N -lt $baja ]; then
			baja=$(($N))
		fi
		if [ $N -gt 700 ] || [ $N -eq 700 ]; then
			echo TEST $cont ARG:"$ARG" >>traces.txt
		fi
		if [ $N -lt 5500 ] && [ $control -eq 2 ]; then
			printf "${GREEN}[OK][5/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			media=$(($media + $N))
			((res_1++))
		elif [ $N -gt 5500 ] || [ $N -eq 5500 ] && [ $N -lt 7000 ] && [ $control -eq 2 ]; then
			printf "${YELLOW}[OK][4/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_2++))
		elif [ $N -gt 7000 ] || [ $N -eq 7000 ] && [ $N -lt 8500 ] && [ $control -eq 2 ]; then
			printf "${RED}[OK][3/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_3++))
		elif [ $N -gt 8500 ] || [ $N -eq 8500 ] && [ $N -lt 10000 ] && [ $control -eq 2 ]; then
			printf "${RED}[KO][2/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_4++))
		elif [ $N -gt 11500 ] || [ $N -eq 11500 ] && [ $control -eq 2 ]; then
			printf "${RED}[KO][1/5]${DEF_COLOR}"
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			if [ $N -gt $alta ]; then
				alta=$(($N))
			fi
			if [ $N -lt $baja ]; then
				baja=$(($N))
			fi
			media=$(($media + $N))
			((res_5++))
		elif [ $control -eq 3 ]; then
			printf "${CYAN} Moves:$N${DEF_COLOR}\n"
			echo TEST $cont ARG:"$ARG" >>traces.txt
		fi
		((cont++))
	done

	((val--))
	media=$(($media / $val))
	printf "${CYAN}\n\nMax move: $alta${DEF_COLOR}\n"
	printf "${CYAN}Min move: $baja${DEF_COLOR}\n"
	printf "${CYAN}Average: $media${DEF_COLOR}\n"
	printf "${WHITE}\n\nTest ${DEF_COLOR}${GREEN}[5/5] ${WHITE}$res_1/$val"
	if [ $res_1 == $val ]; then
		printf "${GREEN} Congrats , all tests have been completed successfully 🥳✅"
		echo OK >>traces.txt
	fi
	if [ $res_2 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${YELLOW}[4/5] ${WHITE}$res_2/$val"
	fi
	if [ $res_3 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[3/5] ${WHITE}$res_3/$val"
	fi
	if [ $res_4 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[2/5] ${WHITE}$res_4/$val"
	fi
	if [ $res_5 != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[1/5] ${WHITE}$res_5/$val\n"
	fi
	if [ $res_err != 0 ]; then
		printf "${WHITE}\nTest ${DEF_COLOR}${RED}[NO SORTED] ${WHITE}$res_err/$val\n"
	fi
	if [ $res_1 != $val ]; then
		printf "${CYAN}\nCheck traces $PWD/traces.txt\n"
	fi

	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}
	printf ${BLUE}"\n\t\t  Order nums\t\t\n"${DEF_COLOR}
	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}

	ARG5=(
		""
		"1 2 3 4 5 6 7 8 9"
		"1 2 3"
		"1"
		"0 1 2 3 4"
		"1 2"
		"1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30"
		"6 7 8"
		"2147483645 2147483646 2147483647"
		"-2147483648 -2147483647 -2147483646"
		"1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50"
		"1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77"
	)
	n=1
	for i in "${ARG5[@]}"; do # on parcours la liste d'argument ARG
		N=$(./push_swap $i | wc -l)
		if [ $N -eq 0 ]; then
			printf "${GREEN}$n. [OK]${DEF_COLOR}"
		else
			printf "${RED}$n. [KO]${DEF_COLOR}"
		fi
		R=$(valgrind --log-fd=1 ./push_swap $i | grep -Ec 'no leaks are possible|ERROR SUMMARY: 0')
		if [[ $R == 2 ]]; then
			printf "${GREEN}[MOK] ${DEF_COLOR}\n"
		else
			printf "${RED} [KO LEAKS] ${DEF_COLOR}\n"
		fi
		((n = n + 1))
	done

	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}
	printf ${BLUE}"\n\t\t  Random test with big nums\t\t\n"${DEF_COLOR}
	printf ${BLUE}"\n-------------------------------------------------------------\n\n"${DEF_COLOR}

	ARG6=(
		"puts (-2147483648..-2147483149).to_a.shuffle.join(' ')"
		"puts (-2147483648..-2147483149).to_a.shuffle.join(' ')"
		"puts (0..499).to_a.shuffle.join(' ')"
		"puts (0..499).to_a.shuffle.join(' ')"
		"puts (0..498).to_a.shuffle.join(' ')"
		"puts (0..498).to_a.shuffle.join(' ')"
		"puts (0..497).to_a.shuffle.join(' ')"
		"puts (0..497).to_a.shuffle.join(' ')"
		"puts (-1..498).to_a.shuffle.join(' ')"
		"puts (5000..5499).to_a.shuffle.join(' ')"
		"puts (50000..50499).to_a.shuffle.join(' ')"
		"puts (500000..500499).to_a.shuffle.join(' ')"
		"puts (5000000..5000499).to_a.shuffle.join(' ')"
		"puts (50000000..50000499).to_a.shuffle.join(' ')"
		"puts (500000000..500000499).to_a.shuffle.join(' ')"
		"puts (0..450).to_a.shuffle.join(' ')"
		"puts (250..720).to_a.shuffle.join(' ')"
		"puts (10000..10460).to_a.shuffle.join(' ')"
		"puts (100..250).to_a.shuffle.join(' ')"
		"puts (90000..90460).to_a.shuffle.join(' ')"
		"puts (-500..-9).to_a.shuffle.join(' ')"
		"puts (-50000..-49510).to_a.shuffle.join(' ')"
	)
	for i in "${ARG6[@]}"; do # on parcours la liste d'argument ARG
		TMP=$(ruby -e "$i")
		N=$(./push_swap $TMP | wc -l)
		if [ $N -lt 5500 ]; then
			printf "${GREEN}[OK][5/5]${DEF_COLOR}"
		elif [ $N -gt 5500 ] && [ $N -lt 7000 ]; then
			printf "${YELLOW}[OK][4/5]${DEF_COLOR}"
		elif [ $N -gt 7000 ] && [ $N -lt 8500 ]; then
			printf "${RED}[KO][3/5]${DEF_COLOR}"
		elif [ $N -gt 8500 ] && [ $N -lt 10000 ]; then
			printf "${RED}[KO][2/5]${DEF_COLOR}"
		elif [ $N -gt 11500 ]; then
			printf "${RED}[KO][1/5]${DEF_COLOR}"
		fi
		S=$(./push_swap $TMP | ./checker_linux $TMP)
		if [ $S == "OK" ]; then
			printf "${GREEN} [OK]${DEF_COLOR}\n"
		else
			printf "${RED} [KO]${DEF_COLOR}\n"
		fi
	done
	rm -rf 0
	make fclean >/dev/null
fi
