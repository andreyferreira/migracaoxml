#!/bin/bash

echo -n "$(date +%F,%H:%M:%S) - Migração Inicializada!"
cd /var/www


for cliente in $@
do
    migracao_xml(){

    local CHKRUNPID=$(ps axu | grep migrar | grep -v grep)
    if [ $CHKRUNPID ]
    then
        echo "MIGRAÇÃO EM EXECUÇÃO"
    else
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/migrar movimentacao_nfe && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/migrar movimentacao_nfe_protocolo && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/migrar movimentacao_nfe_recibo && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/migrar distribuicao_dfe && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/migrar faixa_inutil_entidade

    fi

    }

    limpeza_xml(){

    local CHKRUNPID=$(ps axu | grep limpar | grep -v grep)
    if [ $CHKRUNPID ]
    then
        echo "LIMPEZA EM EXECUÇÃO"
    else
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/limpar movimentacao_nfe && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/limpar movimentacao_nfe_protocolo && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/limpar movimentacao_nfe_recibo && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/limpar distribuicao_dfe && \
        /usr/bin/sudo -u www-data /usr/bin/php $cliente/index.php bibliotecas/35a060d2-515e-4abe-9221-6c529ca64969/migracao_base_xml/limpar faixa_inutil_entidade

    fi

    }

    validacao_migrar(){
        CHKLIMPEZA=$(cat /var/log/limpeza_xml.log | grep -c 'motivo: 4')
        if [ $CHKLIMPEZA -ne 5 ]
        then
            echo -n "Migração em andamento. " > /var/log/migracao_xml.log
            echo $(date +%F,%H:%M:%S) >> /var/log/migracao_xml.log
            migracao_xml
            limpeza_xml 1>/var/log/limpeza_xml.log
            validacao_migrar
        else
            echo -n "$(date +%F,%H:%M:%S) - Migração e limpeza Finalizada!" >> /var/log/migracao_xml.log
            echo -n "$(date +%F,%H:%M:%S) - Migração e limpeza Finalizada!"
            break
    fi

    }

    migracao_xml
    limpeza_xml 1>/var/log/limpeza_xml.log
    validacao_migrar
    

done
