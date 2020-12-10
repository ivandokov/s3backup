# S3 Backup
Script to backup any folder to S3 compatible storage using [s3cmd](https://github.com/s3tools/s3cmd) which can be installed with your default software manager
```bash
sudo apt install s3cmd
```
Requires Bash 4.2 or later.

# Usage
```bash
s3backup.sh [DIRECTORY TO BACKUP] [BACKUP AT S3 DIRECTORY] [SLACK WEBHOOK] 
```

You can use this script in cron jobs to regularly backup. For example every 6h.
```bash
0 */6 * * * /path/to/s3backup.sh /var/www/html s3/backup/directory https://hooks.slack.com/services/A/B/C >> /dev/null 2>&1
```
