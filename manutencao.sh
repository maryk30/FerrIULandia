#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 141820      Nome: Shreya Mary Kurien
## Nome do Módulo: manutencao.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##/**
## * @brief  s3_1_Manutencao Ler a descrição da tarefa S3.1 no enunciado
## */
s3_1_Manutencao () {

    # Check if materiais.txt exists
    so_debug "<"

    if [ -f materiais.txt ]; then
        if [ -r materiais.txt ] && [ -w materiais.txt ]; then
            :
        else
            so_error S3.1 "materiais.txt exists without read/write permissions."
            exit 1
        fi
    else
        so_error S3.1 "materiais.txt does not exist"
        exit 1
    fi

    so_debug ">"

    so_debug "<"

    if [ -f vendas.txt ]; then
        if [ -r vendas.txt ] && [ -w vendas.txt ]; then
            :
        else
            so_error S3.1 "vendas.txt exists without read/write permissions."
            exit 1
        fi
    fi

    so_debug ">"

    # Update daily limit
    daily_limit=$(awk -v mat="$material" '$1==mat {print $3; exit}' materiais.txt)

    yesterday=$(date -d "yesterday" +%F)

    weight_sold=$(awk -F ";" -v mat="$material" -v d="$yesterday" '
    $2==mat && substr($4,1,10)==d {sum+=$3}
    END {print sum+0}
    ' vendas.txt)

    while IFS=";" read -r material price daily_limit
    do
        # calculate total sold today for this material
        weight_sold=$(awk -F ";" -v mat="$material" -v d="$yesterday" '
        $2==mat && substr($4,1,10)==d {sum+=$3}
        END {print sum+0}
        ' vendas.txt)

        so_debug "< {material:$material;daily_limit:$daily_limit;weight_sold:$weight_sold}"

        if (( weight_sold == daily_limit )); then
            if [ -n "$daily_limit" ]; then
                new_limit=$((daily_limit + 100))

                # update the limit in materiais.txt
                awk -F ";" -v mat="$material" -v new="$new_limit" '
                BEGIN{OFS=";"}
                $1==mat {$3=new}
                {print}
                ' materiais.txt > temp && mv temp materiais.txt
            fi
        fi

    done < materiais.txt

}

main () {
    so_debug "<"

    s3_1_Manutencao

    so_success S3.1 "s3_1_Manutencao executed succesfully"

    so_debug ">"
}
main "$@" # This statement invokes the function main(), with all the arguments passed by the user

## S3.2. Invocação do script:
## • Altere o ficheiro cron.def fornecido, por forma a configurar o seu sistema para que o Script: manutencao.sh  seja executado todos os dias de segunda-feira a sábado (incluindo feriados), quando tiver passado um minuto da meia-noite (às 0h01). Nos comentários no início do ficheiro cron.def, explique a configuração realizada, e indique qual é o comando Shell associado a essa configuração que vai ser utilizado para despoletar essa configuração.
## • O ficheiro cron.def alterado deverá ser submetido para avaliação juntamente com os outros Shell scripts
## • Não deverá ser acrescentado nenhum código neste ficheiro manutencao.sh para responder a esta alínea, todas as respostas deverão ser realizadas no ficheiro cron.def.