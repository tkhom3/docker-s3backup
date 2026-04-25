# Local Docker Testing Guide

## Building the Image

```bash
# Build the Docker image
docker build -t docker-s3backup:latest .
```

## Running the Container Locally

### Running with Interactive Shell (for debugging)

```bash
docker run -it --rm --entrypoint sh docker-s3backup:latest
```

## Environment Variables

- `ACCESS_KEY`: AWS IAM Access Key
- `SECRET_KEY`: AWS IAM Secret Key
- `S3PATH`: S3 bucket and path (e.g., `s3://my-bucket/backups`)
- `CRON_SCHEDULE`: Cron schedule (default: `0 3 * * 6` - Saturdays at 3 AM)
- `LOG_LEVEL`: Logging level (default: `INFO`)

## Volume Mounts

- `/backup`: Directory to backup (mount as read-only `:ro`)
- `/config`: Directory for cache and log files (write access needed)

## Useful Docker Commands

```bash
# List built images
docker images | grep docker-s3backup

# View container logs
docker logs <container_id>

# Clean up
docker image rm docker-s3backup:latest
```
