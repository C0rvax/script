#!/bin/bash

# Couleurs
rouge='\e[1;31m'
jaune='\e[1;33m'
bleu='\e[1;34m'
violet='\e[1;35m'
vert='\e[1;32m'
neutre='\e[0;m'

echo -e "${bleu} ---------------------- ${vert}SELECT TEST ${bleu}----------------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} ----------------- ${vert}Test 1${bleu}-----------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} ----------------- ${vert}Test 2${bleu}-----------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} ----------------- ${vert}Test 3${bleu}-----------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${bleu} ----------------- ${vert}Test 4${bleu}-----------------"
echo -e "${bleu}-----------------------------------------------------------${neutre}"
echo -e "${vert}"
read -p "                [1/2/3/A]" rep
echo -e "${bleu}"
case $rep in
1)
	mode=1
	;;
2)
	mode=2
	;;
3)
	mode=3
	;;
A)
	mode=4
	;;
a)
	mode=4
	;;
esac

if [ $mode -eq 1 ] || [ $mode -eq 4 ]; then
	function check_outfile {
		diff --brief outfile outfile2 >/dev/null
		comp_value=$?

		if [ $comp_value -eq 1 ]; then
			echo -e "${rouge}[KO]${neutre}"
		else
			echo -e "${vert}[OK]${neutre}"
		fi
		rm outfile outfile2
	}

	make >/dev/null

	echo -e "${bleu} TEST : grep la | wc -w PIPEX"
	valgrind --leak-check=full --trace-children=yes --track-fds=yes ./pipex infile "grep la" "wc -w" outfile
	echo -e "${jaune} TEST : grep la | wc -w BASH"
	valgrind --leak-check=full --trace-children=yes --track-fds=yes grep 'la' <infile | wc -w >outfile2
	check_outfile
	echo -e "------------------------------------------------------------------------"

	echo -e "${bleu} TEST : grep la | grep - PIPEX"
	valgrind --leak-check=full --trace-children=yes ./pipex infile "grep la" "grep -" outfile
	echo -e "${jaune} TEST : grep la | grep - BASH"
	valgrind --leak-check=full --trace-children=yes grep 'la' <infile | grep '-' >outfile2
	check_outfile
	echo -e "------------------------------------------------------------------------"

	echo -e "${bleu} TEST : grep la | wc -w | wc -w PIPEX"
	valgrind --leak-check=full --trace-children=yes ./pipex infile "grep la" "grep -" "wc -w" outfile
	echo -e "${jaune} TEST : grep la | wc -w | wc -w BASH"
	valgrind --leak-check=full --trace-children=yes grep 'la' <infile | grep '-' | wc -w >outfile2
	check_outfile
	echo -e "------------------------------------------------------------------------"

	echo -e "${bleu} TEST : grep la | cat | wc -w PIPEX"
	valgrind --leak-check=full --trace-children=yes ./pipex infile "grep la" "cat" "wc -w" outfile
	echo -e "${jaune} TEST : grep la | cat | wc -w BASH"
	valgrind --leak-check=full --trace-children=yes grep 'la' <infile | cat | wc -w >outfile2
	check_outfile
	echo -e "------------------------------------------------------------------------"

	echo -e "${bleu} TEST : grep la | cat | wc -w ${neutre}"
	./pipex infile "grep la" "cat" "wc -w" outfile
	grep 'la' <infile | cat | wc -w >outfile2
	check_outfile
	make fclean >/dev/null
fi
if [ $mode -eq 2 ] || [ $mode -eq 4 ]; then
	make >/dev/null
	if [ ! -d "./pipex-tester" ]; then
		git clone https://github.com/vfurmane/pipex-tester
	fi
	chmod 777 ./pipex-tester/run.sh
	./pipex-tester/run.sh
	rm -rf ./pipex-tester
	make fclean >/dev/null
fi
if [ $mode -eq 3 ] || [ $mode -eq 4 ]; then
	make >/dev/null
	if [ ! -d "./42_pipex_tester" ]; then
		git clone git@github.com:michmos/42_pipex_tester.git
	fi
	cd 42_pipex_tester
	chmod 777 run.sh
	./run.sh
	chmod 777 infiles/infile_without_permissions
	cd ..
	rm -rf 42_pipex_tester last_err_log.txt outfiles
	make fclean >/dev/null
fi
