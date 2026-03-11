#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 141820      Nome: Shreya Mary Kurien
## Nome do Módulo: stats.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##/**
## * @brief  s4_1_Validacoes Ler a descrição da tarefa S4.1 no enunciado
## */


date=$(date +%Y":"%m":"%d)
time=$(date +%T)
month=$(date +%m)
year=$(date +%Y)

s4_1_Validacoes () {
    so_debug "<"

    # Check materiais.txt
    if [ ! -f materiais.txt ]; then
        so_error S4.1 "materiais.txt does not exist."
    elif [ ! -r materiais.txt ]; then
        so_error S4.1 "materiais.txt cannot be read."
    fi

    # Check vendas.txt
    if [ ! -f vendas.txt ]; then
        so_error S4.1 "vendas.txt does not exist."
    elif [ ! -r vendas.txt ]; then
        so_error S4.1 "vendas.txt cannot be read."
    fi

    so_debug ">"

    # Arguments
    no_arguments=$#
    so_debug "< {no_arguments:$no_arguments;1:$1;2:$2;3:$3;4:$4}"

    if [[ $no_arguments -eq 0 ]]; then
        # No arguments → run all stats
        s4_3_1_Processamento 0
    elif [[ $no_arguments -le 4 ]]; then
        # Loop over each argument
        for ((i=1;i<=no_arguments;i++)); do
            arg="${!i}"
            if [[ $arg =~ ^[0-9]+$ ]]; then
                s4_3_1_Processamento "$arg"
            else
                so_error S4.2 "Invalid argument $arg"
            fi
        done
    else
        so_error S4.2 "Too many arguments"
    fi

    so_debug ">"
}

##/**
## * @brief  s4_2_1_Stat_Preco Ler a descrição da tarefa S4.2.1 no enunciado
## */
s4_2_1_Stat_Preco () {
    #Declaration of arguments
    material_highest_price=$(tail -1 materiais-ordenados-preco.txt | cut -d";" -f1)
    daily_limit1=$(tail -1 materiais-ordenados-preco.txt | cut -d";" -f3)

    so_debug "< {material_highest_price:$material_highest_price;daily_limit1:$daily_limit1}"

    if [[ $daily_limit1 =~ [\d\D] ]]; then
        echo "<h2>Stats1:</h2>" >> stats.html
        echo "A bitcoin da sucata é: "$material_highest_price", com limite diário de: $daily_limit1." >> stats.html
    else
        echo "<h2>Stats1:</h2>" >> stats.html
        echo "A bitcoin da sucata é: "$material_highest_price", sem limite diário." >> stats.html 
    fi

    so_debug ">"
}

##/**
## * @brief  s4_2_2_Stat_Top3 Ler a descrição da tarefa S4.2.2 no enunciado
## */
s4_2_2_Stat_Top3 () {
    so_debug "<"

    # Generate top materials for the current month
    top=$(awk -F';' -v month="$month" '
    {
        split($4,d,"-")
        if (d[2]==month)
            sum[$2] += $3
    }
    END {
        for (m in sum)
            print m ";" month ";" sum[m]
    }
    ' vendas.txt | sort -t';' -k3,3nr)

    # Read top 3 materials from the variable using a here-string
    echo "<h2>Stats2:</h2>" >> stats.html
    echo "<ul>" >> stats.html

    i=1
    while IFS=";" read -r material _ sum; do
        echo "<li>Top material $i: <b>$material</b>, com <b>Σ $sum kg</b> transacionados.</li>" >> stats.html
        i=$((i+1))
        [[ $i -gt 3 ]] && break
    done <<< "$top"

    echo "</ul>" >> stats.html

    so_debug ">"
}

##/**
## * @brief  s4_2_3_Stat_Rei_Sucata Ler a descrição da tarefa S4.2.3 no enunciado
## */
s4_2_3_Stat_Rei_Sucata () {
    so_debug "<"

    awk -F';' -v month="$month" -v year="$year" '

    FNR==NR { price[$1]=$2; next }
    {
        split($4,d,"-")

        if (d[2]==month && d[1]==year) {
            seller=$1
            mat=$2
            kg=$3

            sum[seller] += kg
            money[seller] += kg * price[mat]
        }
    }
    END {
        for (s in sum)
            printf "%s;%s;%s\n", s, sum[s], money[s]
    }

    ' materiais.txt vendas.txt > scrap_king.txt

    scrap_king=$(sort -t';' -k2,2n -k3,3nr scrap_king.txt | head -1 | cut -d";" -f1)

    echo "<h2>Stats3:</h2>" >> stats.html
    echo "O rei das sucatas do mês de <b>$year-$month</b> é: <b>$scrap_king</b>." >> stats.html

    so_debug ">"
}

##/**
## * @brief  s4_2_4_Stat_TopVendedores Ler a descrição da tarefa S4.2.4 no enunciado
## */
s4_2_4_Stat_TopVendedores () {
    so_debug "<"

    top_sellers=$(awk -F';' -v year="$year" '
    {
        split($4,d,"-")
        if(d[1]==year) count[$1]++
    }
    END {
        for(s in count) print s ";" count[s]
    }
    ' vendas.txt | sort -t';' -k2,2nr | head -3)

    echo "<h2>Stats4:</h2>" >> stats.html
    echo "<ul>" >> stats.html

    i=1
    while IFS=";" read -r seller num; do
        echo "<li>Top vendedor $i: <b>$seller</b> com <b>$num</b> vendas.</li>" >> stats.html
        i=$((i+1))
    done <<< "$top_sellers"

    echo "</ul>" >> stats.html
    so_debug ">"
}

##/**
## * @brief  s4_3_1_Processamento Ler a descrição da tarefa S4.3.1 no enunciado
## */
s4_3_1_Processamento () {
    arg="$1"
    case "$arg" in
        1) s4_2_1_Stat_Preco ;;
        2) s4_2_2_Stat_Top3 ;;
        3) s4_2_3_Stat_Rei_Sucata ;;
        4) s4_2_4_Stat_TopVendedores ;;
        0) 
           s4_2_1_Stat_Preco
           s4_2_2_Stat_Top3
           s4_2_3_Stat_Rei_Sucata
           s4_2_4_Stat_TopVendedores ;;
        *) so_error 5.2.2 "Undefined option"; return 1 ;;
    esac
}

main () {
    so_debug "<"

    echo "<html><head><meta charset="UTF-8"><title>FerrIULândia: Estatísticas</title></head>" > stats.html
    echo "<body><h1>Lista atualizada em $date $time</h1>" >> stats.html

    s4_1_Validacoes $@

    echo "</body></html>" >> stats.html

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user