#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº:141820       Nome:Shreya Mary Kurien
## Nome do Módulo: regista_venda.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##/**
## * @brief  s2_1_ValidaArgumentos Ler a descrição da tarefa S2.1 no enunciado
## */
s2_1_ValidaArgumentos () {
    #Declaration of arguments
    no_arguments=$#; name_of_seller="$1"; material="$2"; weight_in_kg="$3"

    # Validate number of arguments is exactly 3
    so_debug "< {no_arguments:$no_arguments; name_of_seller:$name_of_seller; material:$material; weight_in_kg:$weight_in_kg}"

    if [[ $no_arguments != 3 ]]; then
        so_error 2.1.1 "No. of arguments is invalid."
        exit 1
    else
        so_success 1.1.1 "Valid no. of arguments!"
    fi

    so_debug ">"

    #Validate variable "weight_in_kg"
    so_debug "< {weight_in_kg:$weight_in_kg}"

    if [[ $weight_in_kg =~ ^[0-9]+$ ]]; then
        so_success 2.1.2 "weight_in_kg is a positive integer."
    else
        so_error 2.1.2 "weight_in_kg has an invalid value."
        exit 1
    fi

    so_debug ">"

    # Validate variables 'name_of_seller' and 'material'
    so_debug "< {name_of_seller:$name_of_seller;material:$material}"

        if [[ "$name_of_seller" =~ [^a-zA-Z\ ] ]]; then
            so_error 2.1.3 "STR: 'name_of_seller' is invalid."
            exit 1
        else
            so_success 2.1.3 "STR: 'name_of_seller' is valid!"
        fi

        if [[ "$material" =~ [^a-zA-Z\ ] ]]; then
            so_error 2.1.3 "STR: 'material' is invalid."
            exit 1
        else
            so_success 2.1.3 "STR: 'material' is valid!"
        fi

    so_debug ">"

}

##/**
## * @brief  s2_2_ValidaVenda Ler a descrição da tarefa S2.2 no enunciado
## */
s2_2_ValidaVenda () {
   #Declaration of arguments
    no_arguments=$#; name_of_seller="$1"; material="$2"; weight_in_kg="$3"

    # Validate vendas.txt
    so_debug "< vendas.txt"

    if [ -f vendas.txt ]; then
        so_success 2.2.1 "File vendas.txt exists!"
        if [ -r vendas.txt ] && [ -w vendas.txt ]; then
            so_success 2.2.1 "vendas.txt has read/write permissions."
        else
            so_error 2.2.1 "vendas.txt does not have read/write permissions."
            exit 1
        fi
    else
        touch vendas.txt
        so_success 2.2.1 "vendas.txt has been created!"
    fi

    so_debug ">"

    # Validate whether 'material' exists in materiais.txt
    so_debug "< {no_arguments:$no_arguments;material:$material}"

    if grep -q "$material" materiais.txt; then
        so_success 2.2.2 "$material exists in materiais.txt"
    else
        so_error 2.2.2 "$material does not exist in materiais.txt"
        exit 1
    fi

    so_debug ">"

    # Validate weight against daily_limit
    daily_limit=$(awk -F ";" -v mat="$material" '$1==mat {print $3; exit}' materiais.txt | xargs)

    today=$(date +%F)

    weight_sold=$(awk -F ";" -v mat="$material" -v d="$today" '
    $2==mat && substr($4,1,10)==d {sum+=$3}
    END {print sum+0}
    ' vendas.txt)

    so_debug "< {material:$material;daily_limit:$daily_limit;weight_sold:$weight_sold;weight_in_kg:$weight_in_kg}"

    if (( $weight_sold + $weight_in_kg > $daily_limit )); then
        remaining=$((daily_limit - weight_sold))

        so_error 2.2.3 "weight_in_kg exceeds daily_limit"
        exit 1
    fi

    so_success 2.2.3 "weight_in_kg is valid!"

    so_debug ">"

    # Validate name_of_seller

    first_name=$(echo "$name_of_seller" | awk '{print $1}')
    last_name=$(echo "$name_of_seller" | awk '{print $NF}')
    so_debug "< {name_of_seller:$name_of_seller;first_name=$first_name;last_name=$last_name}"

    if awk -F ":" -v f="$first_name" -v l="$last_name" '

    {
        gsub(/,/, "", $5)
        n = split($5, a, " ")
        if (a[1]==f && a[n]==l)
            found=1
    }
    END {exit !found}

    ' /etc/passwd; then

        so_success 2.2.4 "Name of seller is valid!"
    else
        so_error 2.2.4 "Name of seller does not correspond with registered users."
        exit 1
    fi

    so_debug ">" 
}

##/**
## * @brief  s2_3_AdicionaVenda Ler a descrição da tarefa S2.3 no enunciado
## */
s2_3_AdicionaVenda () {
    # Declaration of arguments
    no_arguments=$#; name_of_seller="$1"; material="$2"; weight_in_kg="$3"

    #Add to vendas.txt
    timestamp=$(date +"%Y-%m-%d""T""%H-%M")

    so_debug "< {no_arguments:$no_arguments; name_of_seller:$name_of_seller; material:$material; weight_in_kg:$weight_in_kg}"

    echo "$name_of_seller"";""$material"";"$weight_in_kg";"$timestamp >> vendas.txt

    if [[ $? == 0 ]]; then
        so_success 2.3 "Sale recorded successfully in vendas.txt"
    else
        so_error 2.3 "Failed to write sale to vendas.txt"
        exit 1
    fi

    so_debug ">"
}

main () {
    name_of_seller="$1"; material="$2"; weight_in_kg=$3

    so_debug "< main"

    s2_1_ValidaArgumentos "$name_of_seller" "$material" $weight_in_kg
    s2_2_ValidaVenda "$name_of_seller" "$material" $weight_in_kg
    s2_3_AdicionaVenda "$name_of_seller" "$material" $weight_in_kg

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user