#!/usr/bin/env bash
#
########################################################################################
#
# realiza_backup.sh - Script para realização de backups.
#
# Desenvolvido por: Victor Pedro (victor.boas@fatec.sp.gov.br)
#
# Shell desenvolvido com o intuito de realizar backups/ programar backups e enviá-los por e-mail
# Data da ultima atualização: 21/09/23
#
#
#########################################################################################

# Arquivo de log
arquivo_log="/var/log/backup.log"

# Obtem o email para caso deseje enviar o backup
email="meuemail@email.com"

# Obtém a data atual
data_atual=$(date +"%Y-%m-%d %H:%M:%S")

# Obtém o nome de usuário que está executando o script
nome_usuario=$(whoami)

# Define o diretório de a ser feito backup
diretorio_origem="/home"

# Define o diretório de destino para o backup
pasta_backup="/bck"

# Carimbo de data e hora / Altere para sua preferência ou descomente.
#data_hora=$(date +"%Y%m%d%H%M%S")      # backup_home_AAMMDDHHMMSS
#data_hora=$(date +"%d%m%Y")            # backup_home_DDMMAA.tar.gz
data_hora=$(date +"%d_%m_%Y")           # backup_home_DD_MM_AA.tar.gz

# Nome atribuido para o arquivo de backup
nome_arquivo_backup="backup_home_$data_hora.tar.gz"

# Funções
root_only(){
  if [ "$USER" != "root" ]; then
    echo "Você não tem permissão para executar este arquivo! \nEntre em contato com o administrador."
    exit 1
  fi
}

enable_cron(){
  # Define o intervalo do cron para execução diária às 2 da manhã
  intervalo_cron="0 2 * * *"
  # Configura o trabalho cron para o backup
  (crontab -l; echo "$intervalo_cron /bin/bash $PWD/$0") | crontab -
}

create_backup(){
  # Verifica se a pasta de backup existe; caso não exista, cria com permissões exclusivas de root
    if [ ! -d "$pasta_backup" ]; then
    sudo mkdir -p "$pasta_backup"
    sudo chown root:root "$pasta_backup"
    sudo chmod 700 "$pasta_backup"
  fi

  # Cria o arquivo de backup e redireciona as saídas ok para /dev/null (Lixeira) e os erros para o arquivo de log.
  tar -czvf "$pasta_backup/$nome_arquivo_backup" "$diretorio_origem" >> /dev/null 2>>/var/log/backup.log

  # Verifica se o backup foi criado com sucesso e envia a saída para o arquivo de log.
  if [ $? -eq 0 ]; then
    echo "$data_atual - Backup de todos os diretórios em $diretorio_origem foi criado com sucesso em $pasta_backup/$nome_arquivo_backup pelo usuário $nome_usuario" >> "/var/log/backup.log"
  else
    echo "$data_atual - Ocorreu um erro ao criar o backup de todos os diretórios em $diretorio_origem pelo usuário $nome_usuario. Consulte /var/log/backup.log para detalhes." >> "/var/log/backup.log"
  fi
}

send_email(){
    # Envia o arquivo de backup por email
    mail -s "Backup do diretório $diretorio_origem" $email < "$pasta_backup/$nome_arquivo_backup"
  
    echo "$data_atual - Backup enviado por email para seu_email." >> "/var/log/backup.log"
}

# Habilita verificação se o script está sendo executado como root (descomente a próxima linha caso deseje utilizar)
root_only

# Habilita a utilização do cron para agendar backups (descomente a próxima linha caso deseje utilizar))
#enable_cron

# Função principal para realizar o backup
create_backup

# Habilia o envio por email do backup (descomente a próxima linha caso deseje utilizar)
#send_email