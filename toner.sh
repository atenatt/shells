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

# Função para mover o cursor
move_cursor() {
    tput cup $1 $2
}

# Função para obter o status do toner
obter_status_toner() {
    local url="$1"
    curl_output=$(curl -s "$url" | grep "Cartucho Preto" | cut -c 38-42 | tr -s ' ')
    echo "$curl_output"
}

# Função para enviar e-mail
enviar_email() {
    local destinatario="$1"
    local assunto="$2"
    local mensagem="$3"
   
    echo "$mensagem" | mail -s "$assunto" "$destinatario"
}

# Array de URLs das impressoras
declare -a IMPRESSORAS=(
    "http://10.122.168.21/cgi-bin/dynamic/printer/PrinterStatus.html"
    "http://10.122.168.24/cgi-bin/dynamic/printer/PrinterStatus.html"
    "http://10.122.168.23/cgi-bin/dynamic/printer/PrinterStatus.html"
    "http://10.122.168.22/cgi-bin/dynamic/printer/PrinterStatus.html"
)

# Imprimir resultado
clear
move_cursor 2 32
echo -e "\033[37;01mSTATUS DOS TONERS\033[m"

# Obter e imprimir o status de cada impressora
mensagem="STATUS DOS TONERS:"
for ((i = 0; i < ${#IMPRESSORAS[@]}; i++)); do
    status=$(obter_status_toner "${IMPRESSORAS[i]}")
    move_cursor $((i + 8)) 30
    mensagem+="\nIMPRESSORA $(printf "%03d" $((i + 1))): $status"
    echo "IMPRESSORA $(printf "%03d" $((i + 1))): $status"
done

# Perguntar ao usuário se deseja receber por e-mail
move_cursor 22 3
read -n1 -p "Deseja receber por e-mail? (s/n): " opcao
clear

if [ "$opcao" = "s" ] || [ "$opcao" = "S" ]; then
    # Solicitar o endereço de e-mail do destinatário
    read -p "Informe o endereço de e-mail do destinatário: " destinatario
    enviar_email "$destinatario" "Status dos Toners" "$mensagem"
fi
