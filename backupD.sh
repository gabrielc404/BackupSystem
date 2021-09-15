#!/bin/bash

#Variaveis:
FOLDER="14eTJocCEbGxEg62MeWZbeGv00xUZEBMP" #ID do diretorio destino no drive;
FDBK="/var/log/backup.log" #Diretorio do arquivo de backup;
FILENEW=$(date '+%d%^B%ybk.tgz') #Nome e extensão do arquivo final; dia|mes|ano|bk.tgz
FILEOLD=$(date --date='-1month' '+%^B%y') #Nome antigo; mes|ano
F1LINE=$(grep $FILEOLD $FDBK | awk '{print $1}') #Pega o nome inteiro do bk anterior no arquivo de backup;
IDFILE=$(gdrive list | grep $F1LINE | awk '{print $1}') #Busca o id pelo nome;
HOUR=$(date '+%T') #Hora do momento;
SIZE=$(ls -lh $FILENEW | awk '{print $5}') #Define o tamanho do arquivo;
LOGSTRUC="$FILENEW | $HOUR | $SIZE" #Estrutura do log;

#Processo:
#Criação do arquivo de backup e alteração do arquivo de log.
echo "Convertendo arquivo..."
tar -cvzf ~/$FILENEW ~/BACKUP/
echo $LOGSTRUC>>$FDBK

#Subindo o arquivo para o drive.
echo "Fazendo backup..."
gdrive upload --parent $FOLDER ~/$FILENEW

#Remoção do backup antigo.[PRONTO]
echo "Removendo arquivo antigo..."
gdrive delete $IDFILE
rm ~/$FILENEW

#Encerrando o computador.[PRONTO]
echo "Backup finalizado, encerando..."
for count in {5..1}
do
	clear
	echo "desligando em: "$count"s."
	sleep 1
done
systemctl poweroff

#Pendencias:
#No crontab definir um horario(domingo 24h), perguntar algumas horas antes se deseja proceguir com o bk
# caso contrario cancelar e agendar para semana seguinte(adiar no maximo ate virar o mes)
