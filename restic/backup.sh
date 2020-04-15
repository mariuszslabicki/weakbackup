#!/bin/sh

backupLogFile="/var/log/restic/backup.log"

printAndLog() {
  echo `date "+%T %F"` "${1}" 2>&1 | tee -a ${backupLogFile}
}

printAndLog "Starting backup script ..."

restic snapshots &>/dev/null
status=$?
printAndLog "Check Repo status $status"

if [ $status != 0 ]; then
    printAndLog "Restic repository '${RESTIC_REPOSITORY}' does not exists. Running restic init."
    restic init 2>&1 | tee -a ${backupLogFile}

    init_status=$?
    printAndLog "Repo init status $init_status"

    if [ $init_status != 0 ]; then
        printAndLog "Failed to init the repository: '${RESTIC_REPOSITORY}'"
        exit 1
    fi
else
    printAndLog "Repository exists"
fi

PREFIX=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 4 | head -n 1)

backupLogFile="/var/log/restic/backup.log"

start=`date +%s`

printAndLog "Starting Backup"
printAndLog "RESTIC_BACKUP_TAGS: ${RESTIC_BACKUP_TAGS}"
printAndLog "RESTIC_FORGET_ARGS: ${RESTIC_FORGET_ARGS}"
printAndLog "RESTIC_REPOSITORY: ${RESTIC_REPOSITORY}"

# Do not save full backup log to logfile but to backup-last.log
restic backup /mnt --tag=${RESTIC_BACKUP_TAGS} 2>&1 | tee -a ${backupLogFile}
rc=$?
printAndLog "Finished backup at $(date)"
if [ $rc != 0 ]; then
    printAndLog "Backup Failed with Status ${rc}"
    restic unlock
    kill 1
else
    printAndLog "Backup Successfull" 
fi

if [ -n "${RESTIC_FORGET_ARGS}" ]; then
    printAndLog "Forget about old snapshots based on RESTIC_FORGET_ARGS = ${RESTIC_FORGET_ARGS}"
    restic forget ${RESTIC_FORGET_ARGS} 2>&1 | tee -a ${backupLogFile}
    rc=$?
    printAndLog "Finished forget at $(date)"
    if [ $rc != 0 ]; then
        printAndLog "Forget Failed with Status ${rc}"
        restic unlock
    else
        printAndLog "Forget Successfull"
    fi
fi

end=`date +%s`
printAndLog "Finished Backup at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
