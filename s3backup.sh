#!/usr/bin/env bash

BACKUP_FROM=$1
BACKUP_TO=$2
SLACK_WEBHOOK=$3

if [ -z "${BACKUP_FROM}" ] || [ ! -d "${BACKUP_FROM}" ]; then
    echo "Backup directory not found"
    exit 1
fi

if [ -z "${BACKUP_TO}" ]; then
    echo "Backup to directory is required"
    exit 1
fi

[[ "${BACKUP_FROM}" != */ ]] && BACKUP_FROM="${BACKUP_FROM}/"
[[ "${BACKUP_TO}" != */ ]] && BACKUP_TO="${BACKUP_TO}/"
[[ "${BACKUP_TO}" != s3://* ]] && BACKUP_TO="s3://${BACKUP_TO}"

BACKUP=`s3cmd --quiet sync ${BACKUP_FROM} ${BACKUP_TO}`

# Backup process errored
if [ $? -ne 0 ] || [ ! -z "${BACKUP}" ]; then
    # If Slack webhook is not provided simply show the backup output
    if [[ -z "$SLACK_WEBHOOK" ]]; then
        echo "${BACKUP}"
    # Otherwise send Slack notification
    else
        # Escape Slack special characters
        BACKUP=${BACKUP//&/&amp;}
        BACKUP=${BACKUP//</&lt;}
        BACKUP=${BACKUP//>/&gt;}

        # Prefix the output with a quote symbol
        BACKUP=`echo "${BACKUP}" | sed -e 's/^/>/'`

        curl -s -X POST \
            -H 'Content-type: application/json' \
            --data "{\"type\":\"mrkdwn\",\"text\":\"*Couldn't sync to backup storage*\n\n\$BACKUP\"}" \
            $SLACK_WEBHOOK  > /dev/null
    fi
fi
