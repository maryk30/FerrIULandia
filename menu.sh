#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº:       Nome:
## Nome do Módulo: menu.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

## Este script invoca os scripts restantes, não recebendo argumentos.
## Atenção: Não é suposto que volte a fazer nenhuma das funcionalidades dos scripts anteriores. O propósito aqui é simplesmente termos uma forma centralizada de invocar os restantes scripts.

##/**
## * @brief  s5_1_MostraMenu Ler a descrição da tarefa S5.1 no enunciado.
## *         Esta função preenche o valor da variável $opcao com a opção dada pelo utilizador
## */
s5_1_MostraMenu () {
    so_debug "<"

    cat menu.txt
    read -p "Option: " option

    s5_2_1_ValidaOpcao option

    so_debug ">"
}

##/**
## * @brief  s5_2_1_ValidaOpcao Ler a descrição da tarefa S5.2.1 no enunciado
## */
s5_2_1_ValidaOpcao () {
    so_debug "< {option:$option}"

    if [[ $option =~ ^[0-4]$ ]]; then
                so_success 4.2.0 "Argument "$option" valid"
            else
                so_error 4.2.0 "Invalid argument "$option""
                s5_1_MostraMenu
    fi

    s5_2_2_ProcessaOpcao

    so_debug ">"
}

##/**
## * @brief  s5_2_2_ProcessaOpcao Ler a descrição da tarefa S5.2.2 no enunciado
## */
s5_2_2_ProcessaOpcao () {
    so_debug "< {option:$option}"

    case $option in
            1)  # Register material
                s5_3_Opcao1
                ;;
            2)  # Register sale
                s5_4_Opcao2
                ;;
            3)  # Maintenance
                s5_5_Opcao3
                ;;
            4) # Statistics
                s5_6_Opcao4
                ;;
            0)  # Exit
                so_success 5.2.2 "Exiting successfully"
                return 0
                ;;
            *)  # In this case, returns 1 (failure) to the OS
                so_error 5.2.2 "Undefined option"
                return 1
                ;;
        esac

    so_debug ">"
}

##/**
## * @brief  s5_3_Opcao1 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_3_Opcao1 () {
    so_debug "<"

    echo "Register Material:"
    read -p "Input Material: " material
    read -p "Input Price per kg: " price_per_kg
    read -p "Input Daily limit: " daily_limit

    ./regista_material.sh "$material" $price_per_kg $daily_limit
    so_success 5.3 "Executed: Option 1"
    s5_1_MostraMenu

    so_debug ">"
}

##/**
## * @brief  s5_4_Opcao2 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_4_Opcao2 () {
    so_debug "<"

    echo "Register Sale:"
    read -p "Input name of seller: " name_of_seller
    read -p "Input Material: " material
    read -p "Input weight (in kg): " weight_in_kg

    if./regista_venda.sh "$name_of_seller" "$material" $weight_in_kg
    so_success 5.4 "Executed: Option 2"
    s5_1_MostraMenu

    so_debug ">"
}

##/**
## * @brief  s5_5_Opcao3 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_5_Opcao3 () {
    so_debug "<"

    echo "Maintenance"

    ./manutencao.sh
    so_success 5.5 "Executed: Option 3"
    s5_1_MostraMenu

    so_debug ">"
}

##/**
## * @brief  s5_6_Opcao4 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_6_Opcao4 () {
    so_debug "<"

    echo "Statistics:"
    cat stats_menu.txt

    read -p "Enter the options you wish to see, separated by spaces(eg. 1 4): " stats_option

    ./stats.sh $1 $2 $3 $4 $5
       
    echo "$stats_option" > stats_option.txt
    $1 = $(cut -d" " -f1 stats_option.txt)
    $2 = $(cut -d" " -f2 stats_option.txt)
    $3 = $(cut -d" " -f3 stats_option.txt)
    $4 = $(cut -d" " -f4 stats_option.txt)
    $5 = $(cut -d" " -f5 stats_option.txt)

    so_debug ">"

    so_success 5.6 "Success: Option 4"
    s5_1_MostraMenu
}

main () {
    so_debug "<"

    s5_1_MostraMenu

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user