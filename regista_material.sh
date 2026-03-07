#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº:       Nome:
## Nome do Módulo: regista_material.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##/**
## * @brief  s1_1_ValidaArgumentos Ler a descrição da tarefa S1.1 no enunciado
## */
s1_1_ValidaArgumentos () {
    
    #Declaration of arguments
    no_arguments=$#; material=$1; price_per_kg=$2; daily_limit=$3

    # Validate number of arguments is either 2 or 3
    so_debug "< {no_arguments:$no_arguments; material:$material; price_per_kg:$price_per_kg; daily_limit:$daily_limit}"

    if [[ $no_arguments < 2 || $no_arguments > 3 ]]; then
        so_error 1.1.1 "No. of arguments is invalid."
        exit 1
    else
        so_success 1.1.1 "No. of arguments is valid!"
    fi

    so_debug ">"

    #Validate variable "material"
    material_str_len=${#material}
    so_debug "< {material:$material; material_str_len:$material_str_len}"

        if [[ $material_str_len < 2 || $material =~ [^a-zA-Z] ]]; then
            so_error 1.1.2 "STR: 'material' is invalid."
            exit 1
        else
            so_success 1.1.2 "STR: 'material' is valid!"
        fi

    so_debug ">"

    #Validare variable "price_per_kg"
    so_debug "< {price_per_kg:$price_per_kg}"

    if [[ $price_per_kg =~ ^[0-9]+$ ]]; then
        so_success 1.1.3 "INT: 'price_per_kg' is valid!"
    else
        so_error 1.1.3 "INT: 'price_per_kg' is invalid."
        exit 1
    fi

    so_debug ">"

    #Validate variable "daily_limit"
    so_debug "< {daily_limit:$daily_limit}"

    if [ -z "$daily_limit" ]; then
        so_debug "daily_limit does not exist >"
    else
        so_debug "< daily_limit exists"
        if [[ $daily_limit =~ ^[0-9]+$ ]]; then
            so_success 1.1.4 "INT: 'daily_limit' is valid!"
        else
            so_error 1.1.4 "INT: 'daily_limit' is invalid."
        fi
    fi

    so_debug ">"
}

##/**
## * @brief  s1_2_ValidaMaterial Ler a descrição da tarefa S1.2 no enunciado
## */
s1_2_ValidaMaterial () {
    # Declaration of Arguments
    no_arguments=$#; material=$1

    # Check whether materiais.txt exists
    so_debug "< materiais.txt"

    if [ -f materiais.txt ]; then
        so_success 1.2.1 "materiais.txt exists!"
    else
        so_error 1.2.1 "materiais.txt does not exist."
        touch materiais.txt
        so_success 1.2.1 "materiais.txt has been created!"
    fi

    # Check permissions for materiais.txt

    if [ -r materiais.txt ] && [ -w materiais.txt ]; then
        so_success 1.2.1 "Permissions valid!"
    else
        so_error 1.2.1 "materiais.txt does not have read/write permissions. Terminating..."
        exit 1
    fi

    so_debug ">"

    #Check whether variable 'material' exists in materiais.txt

    so_debug "< {no_arguments:$no_arguments; material:$material}"

    if grep -q $material materiais.txt; then
        so_success 1.2.2 "$material exists in materiais.txt"
        s1_4_ListaMaterial
    else
        so_error 1.2.2 "$material does not exist in materiais.txt"
        s1_3_AdicionaMaterial $material $price_per_kg $daily_limit
    fi

    so_debug ">"
}

##/**
## * @brief  s1_3_AdicionaMaterial Ler a descrição da tarefa S1.3 no enunciado
## */
s1_3_AdicionaMaterial () {
    #Declaration of arguments
    no_arguments=$#; material=$1; price_per_kg=$2; daily_limit=$3

    # Add material to materiais.txt
    so_debug "< material:$material"
    echo $material";"$price_per_kg";"$daily_limit>> materiais.txt

    if grep -q $material materiais.txt; then 
        so_success 1.3 "$material added to materiais.txt"
        s1_4_ListaMaterial
    else
        so_error 1.3 "Addition of $material failed."
    fi

    so_debug ">"
}

##/**
## * @brief  s1_4_ListaMaterial Ler a descrição da tarefa S1.4 no enunciado
## */
s1_4_ListaMaterial () {
    #Declaration of Arguments
    no_arguments=$#

    so_debug "< {no_arguments:$no_arguments}"

    #Create file materiais-ordenados-preco.txt
    cp materiais.txt materiais-ordenados-preco.txt 
    sort -n -k2 materiais-ordenados-preco.txt -o materiais-ordenados-preco.txt

    if [ -f materiais-ordenados-preco.txt ]; then
        so_success 1.4 "materiais-ordenados-preco.txt created succesfully"
    else
        so_error 1.4 "failed to create file materiais-ordenados-preco.txt"

    so_debug ">"
    fi
}

main () {
    no_arguments=$#; material=$1; price_per_kg=$2; daily_limit=$3

    so_debug "<"

    s1_1_ValidaArgumentos $material $price_per_kg $daily_limit
    s1_2_ValidaMaterial $material

    so_debug ">"
}
main $@