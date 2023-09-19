#!/usr/bin/env bash
########################################################################################
#
# tooner.sh - Script feito para verificar o status do tooner das impressoras LEXMARK
#
# Desenvolvido por: Victor Pedro (victor.boas@fatec.sp.gov.br)
#
# Shell desenvolvido com o intuito de agilizar a verificação do status de tooner de impressoras lexmark.
#
# Data da ultima atualização: 19/09/23
#
#########################################################################################


#!/bin/bash

# Nome do arquivo de log
LOG_FILE="status_impressoras.log"

# Constantes para IPs das Impressoras
declare -a IP_IMPRESSORAS=("192.168.0.10" "192.168.0.11" "192.168.0.12" "192.168.0.13")

# Construir URLs das Impressoras
URLS=()
for ip in "${IP_IMPRESSORAS[@]}"; do
    URLS+=("http://$ip/cgi-bin/dynamic/printer/PrinterStatus.html")
done

# Função para mover cursor
movecursor() {
    tput cup "$1" "$2"
}

# Função para escrever no arquivo de log
log() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Verificar status dos toners
statuses=()
for url in "${URLS[@]}"; do
    status=$(curl -s "$url" | grep "Cartucho Preto" | cut -c 38-42 | tr -s ' ')
    statuses+=("$status")
done

# Imprimir resultados e registrar no arquivo de log
clear
movecursor 2 30; echo -e "\033[37;01mSTATUS DOS TONERS\033m"

for i in "${!statuses[@]}"; do
    echo "IMPRESSORA $((i+1)): ${statuses[i]}"
    log "Status da Impressora $((i+1)): ${statuses[i]}"
done

# Aguardar por entrada do usuário
movecursor 22 3; read -n1 -p "Pressione qualquer tecla para finalizar: "
clear
