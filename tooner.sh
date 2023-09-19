#!/usr/bin/env bash
########################################################################################
#
# tooner.sh - Script feito para verificar o status do tooner das impressoras LEXMARK 
#
#
# Desenvolvido por: Victor Pedro (victor.boas@fatec.sp.gov.br)
#
# Shell desenvolvido com o intuito de agilizar a verificação do status de tooner de impressoras lexmark.
# Data da ultima atualização: 19/09/23
#
# Utilização: sh tooner.sh
#
#########################################################################################


movecursor() {                   # Função para mover cursor
    tput cup $1 $2 ;
}

IP_IMP_001="192.168.0.10"        # Variaveis que definem o IP das Impressoras
IP_IMP_002="192.168.0.11"
IP_IMP_003="192.168.0.12"
IP_IMP_004="192.168.0.13"

IMP_001="http://$IP_IMP_001/cgi-bin/dynamic/printer/PrinterStatus.html"
IMP_002="http://$IP_IMP_002/cgi-bin/dynamic/printer/PrinterStatus.html"
IMP_003="http://$IP_IMP_003/cgi-bin/dynamic/printer/PrinterStatus.html"
IMP_004="http://$IP_IMP_004/cgi-bin/dynamic/printer/PrinterStatus.html"

var1=$(curl -s $IMP_001 | grep "Cartucho Preto" | cut -c 38-42 | tr -s ' ')
var2=$(curl -s $IMP_002 | grep "Cartucho Preto" | cut -c 38-42 | tr -s ' ')
var3=$(curl -s $IMP_003 | grep "Cartucho Preto" | cut -c 38-42 | tr -s ' ')
var4=$(curl -s $IMP_004 | grep "Cartucho Preto" | cut -c 38-42 | tr -s ' ')

# Imprimindo resultado #

clear

movecursor 2 30; echo -e "\033[37;01mSTATUS DOS TOONERS\033m"

echo IMPRESSORA 001: $var1
echo IMPRESSORA 002: $var2
echo IMPRESSORA 003: $var3
echo IMPRESSORA 004: $var4

    movecursor 22 3; read -n1 -p "Aperte qualquer tecla para finalizar: "
clear

