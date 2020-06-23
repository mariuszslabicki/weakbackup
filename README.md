make build
make deploy
make start
make backup_now

To restore using mount:
https://restic.readthedocs.io/en/latest/050_restore.html#restore-using-mount
Tip: need to install fuse in restic container to be able to mount it.

Based on:
- https://github.com/djmaze/resticker
- https://github.com/lobaro/restic-backup-docker