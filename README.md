# dfs-bot

A brute-force, cron-friendly container to steer a wandering radio back to the trail.

Requirements:
- UISP installation
- UISP API token
- Device ID for access point
- Target frequency to determine deviations

## Usage
Configure cron job in `cronjobs`:
```shell
0 */4 * * * /dfs_bot.sh

```

Build image:
```shell
docker build dfs-bot:latest .
```

Run container:
```shell
docker run \
-e UISP_API_TOKEN=<api_token> \
-e DEVICE_ID=<device_id> \
-e TARGET_FREQ=<target_frequency> \
dfs-bot:latest
```

Docker Compose:
```shell
# Paste in UISP API token at the prompt (may only work in swarm mode)
read -s "?Token: "; echo $REPLY | docker secret create dfs_bot_uisp_api_token -
docker-compose up -d
```