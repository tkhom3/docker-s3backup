[![Build and Deploy Image](https://github.com/tkhom3/docker-s3backup/actions/workflows/build-and-deploy.yml/badge.svg)](https://github.com/tkhom3/docker-s3backup/actions/workflows/build-and-deploy.yml)

# docker-s3backup

Sync files and directories to S3 using the s3cmd sync tool. Leverage a cache file for MD5 hash calculations of local files to speed up performance.

## Setup

Mount the directories you would like to backup to the `/backup` directory.
Mount a second directory to `/config` for the cache file.

Photos mounted at `/backup-photos` are synced to the `photos/` S3 prefix using the `GLACIER_IR` storage class (S3 Glacier Instant Retrieval). These objects can be used for server-side copies without restoring them first. Existing objects stored as `GLACIER` are not changed by this setting and may still need to be restored before they can be copied. Storage and retrieval costs differ from `GLACIER`.

## Environment Variables

| **Variable**  | **Default**            | **Description**                             |
|---------------|------------------------|---------------------------------------------|
| ACCESS_KEY    |                        | AWS IAM Access Key                          |
| SECRET_KEY    |                        | AWS IAM Secret Key                          |
| S3PATH        |                        | S3 bucket and path                          |
| S3CMDPARAMS   |                        | Custom S3cmd parameters                     |
| CRON_SCHEDULE | `0 3 * * 6`            | How often a backup should be run using CRON |
| LOG_LEVEL     | `INFO`                 | Logging Level                               |
| CACHE_FILE    | `/tmp/s3cmd_cache.txt` | Location to write the file cache            |
| LOG_FILE      | `/tmp/s3backup.log`    | Location to write the log file              |

redeploy: 0
