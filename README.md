[![Build and Deploy Image](https://github.com/tkhom3/docker-s3backup/actions/workflows/build-and-deploy.yml/badge.svg)](https://github.com/tkhom3/docker-s3backup/actions/workflows/build-and-deploy.yml)
[![Codacy Security Scan](https://github.com/tkhom3/docker-s3backup/actions/workflows/codacy-analysis.yml/badge.svg)](https://github.com/tkhom3/docker-s3backup/actions/workflows/codacy-analysis.yml)
[![Scan with Trivy](https://github.com/tkhom3/docker-s3backup/actions/workflows/scan-with-trivy-pr.yaml/badge.svg)](https://github.com/tkhom3/docker-s3backup/actions/workflows/scan-with-trivy-pr.yaml)

# docker-s3backup

Sync files and directories to S3 using the s3cmd sync tool.

## Setup
Mount the directories you would like to backup to the `/backup` directory.

## Environment Variables
- ACCESS_KEY - AWS IAM access key
- SECRET_KEY - AWS IAM secret key
- S3PATH - S3 bucket and path
- S3CMDPARAMS - s3cmd custom parameters
- CRON_SCHEDULE - set to `0 * * * *` by default, which means every hour.
 
