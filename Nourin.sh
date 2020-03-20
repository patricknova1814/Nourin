#!/usr/bin/env bash

declare -rg CACertificateFile="${HOME}/Nourin/certificates/cacert.pem"
declare -rg CACertificateDirectory="${HOME}/Nourin/certificates"
declare -rg DatabasePath="${HOME}/Nourin/databases/data.db"

declare -r BotToken='SEU_TOKEN_AQUI'

source "${HOME}/Nourin/functions/nourin.sh"
source "${HOME}/Nourin/functions/shell_bot.sh"

if ! [ -s "${DatabasePath}" ]; then
	mkdir -p "${HOME}/Nourin/databases"
	sqlite3 "${DatabasePath}" 'CREATE TABLE data (
		user_id TEXT,
		user_type TEXT,
		remaining_consultas_numero TEXT,
		remaining_ativacao_plano TEXT,
		membership_start_date TEXT );'
fi

init --token "${BotToken}"

while true; do

	getUpdates --limit '1' --offset "$(OffsetNext)" --timeout '60'

	(

		if [ -z "${message_text}" ]; then
			exit '0'
		elif [ -n "${message_reply_to_message_message_id}" ]; then
			exit '0'
		fi
		
		if [[ "${message_text}" =~ ^(\!|/)'start'$ ]]; then
			check_user_status
			sendMessage --reply_to_message_id "${message_message_id}" \
				--chat_id "${message_chat_id}" \
				--text "$(start_text)" \
				--parse_mode 'markdown' \
				--disable_web_page_preview 'true' \
				--disable_notification 'true'
		elif [[ "${message_text}" =~ ^(\!|/)'help'$ ]]; then
			sendMessage --reply_to_message_id "${message_message_id}" \
				--chat_id "${message_chat_id}" \
				--text "$(help_text)" \
				--parse_mode 'markdown' \
				--disable_web_page_preview 'true' \
				--disable_notification 'true'
		elif [[ "${message_text}" =~ ^(\!|/)'about'$ ]]; then
			sendMessage --reply_to_message_id "${message_message_id}" \
				--chat_id "${message_chat_id}" \
				--text "$(about_text)" \
				--parse_mode 'markdown' \
				--disable_web_page_preview 'true' \
				--disable_notification 'true'
		elif [[ "${message_text}" =~ ^(\!|/)'flood'$ ]]; then	
			sendMessage --reply_to_message_id "${message_message_id}" \
				--chat_id "${message_chat_id}" \
				--text "$(flood_help_text)" \
				--parse_mode 'markdown' \
				--disable_notification 'true'
		elif [[ "${message_text}" =~ ^(\!|/)'plano'$ ]]; then	
			sendMessage --reply_to_message_id "${message_message_id}" \
				--chat_id "${message_chat_id}" \
				--text "$(plano_help_text)" \
				--parse_mode 'markdown' \
				--disable_notification 'true'
		elif [[ "${message_text}" =~ ^(\!|/)'flood'\ .+$ ]]; then
			declare -r telephone=$(sed -r 's/^(\!|\/)flood\s(.*)/\2/g' <<< "${message_text}")
			check_if_number_is_valid
			flood_number
		elif [[ "${message_text}" =~ ^(\!|/)'plano'\ .+$ ]]; then
			check_user_status
			declare -r telephone=$(sed -r 's/^(\!|\/)plano\s(.*)/\2/g' <<< "${message_text}")
			check_if_number_is_valid
			place_order
		elif [[ "${message_text}" =~ ^(\!|/)'status'$ ]]; then
			sendMessage --reply_to_message_id "${message_message_id}" \
				--chat_id "${message_chat_id}" \
				--text "$(user_info_text)" \
				--parse_mode 'markdown' \
				--disable_notification 'true'
		elif [[ "${message_text}" =~ ^[0-9]{11}$ ]]; then
			check_user_status
			declare -r telephone="${message_text}"
			declare -r formatted_telephone=$(sed -r 's/^([0-9]{2})/(\1)/g; s/([0-9]{4})$/-\1/g; s/([0-9]{5})/+\1/g' <<< "${telephone}")
			query_number
		fi

		exit '0'
		
	) &

done
