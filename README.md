[![Build and Deploy Image](https://github.com/tkhom3/docker-s3backup/actions/workflows/build-and-deploy.yml/badge.svg)](https://github.com/tkhom3/docker-s3backup/actions/workflows/build-and-deploy.yml)
[![Security Scans](https://github.com/tkhom3/docker-s3backup/actions/workflows/security-scans-pr.yml/badge.svg)](https://github.com/tkhom3/docker-s3backup/actions/workflows/security-scans-pr.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/5ea01db5c81a4898815f0c57c4472b67)](https://www.codacy.com/gh/tkhom3/docker-s3backup/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=tkhom3/docker-s3backup&amp;utm_campaign=Badge_Grade)

# docker-s3backup

Sync files and directories to S3 using the s3cmd sync tool. Leverage a cache file for MD5 hash calculations of local files to speed up performance.

## Setup

Mount the directories you would like to backup to the `/backup` directory.
Mount a second directory to `/config` for the cache file.

## Environment Variables

| **Variable**  | **Default**          | **Description**                             |
|---------------|----------------------|---------------------------------------------|
| ACCESS_KEY    |                      | AWS IAM Access Key                          |
| SECRET_KEY    |                      | AWS IAM Secret Key                          |
| S3PATH        |                      | S3 bucket and path                          |
| S3CMDPARAMS   |                      | Custom S3cmd parameters                     |
| CRON_SCHEDULE |`0 3 * * 6`           | How often a backup should be run using CRON |
| LOG_LEVEL     |`INFO`                | Logging Level                               |
| CACHE_FILE    |`/tmp/s3cmd_cache.txt`| Location to write the file cache            |
| LOG_FILE      |`/tmp/s3backup.log`   | Location to write the log file              |
