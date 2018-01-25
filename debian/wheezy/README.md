# Supported tags and respective `Dockerfile` links

-	[`artful` (*/ubuntu/artful/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/ubuntu/artful/Dockerfile)
-	[`buster` (*/debian/buster/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/buster/Dockerfile)
-	[`buster-slim` (*/debian/buster-slim/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/buster-slim/Dockerfile)
-	[`centos7`, `centos` (*centos/7/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/centos/7/Dockerfile)
-	[`fedora24` (*fedora/24/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/fedora/24/Dockerfile)
-	[`fedora25` (*fedora/25/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/fedora/25/Dockerfile)
-	[`fedora26`, `fedora` (*fedora/26/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/fedora/26/Dockerfile)
-	[`jessie` (*/debian/jessie/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/jessie/Dockerfile)
-	[`jessie-slim` (*/debian/jessie-slim/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/jessie-slim/Dockerfile)
-	[`stretch`, `debian` (*/debian/stretch/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/stretch/Dockerfile)
-	[`stretch-slim`, `mainline`, `latest` (*/debian/stretch-slim/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/stretch-slim/Dockerfile)
-	[`trusty` (*/ubuntu/trusty/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/ubuntu/trusty/Dockerfile)
-	[`xenial`, `ubuntu` (*/ubuntu/xenial/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/ubuntu/xenial/Dockerfile)
-	[`wheezy` (*/debian/wheezy/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/wheezy/Dockerfile)
-	[`wheezy-slim` (*/debian/wheezy-slim/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/debian/wheezy-slim/Dockerfile)
-	[`zesty` (*/ubuntu/zesty/Dockerfile*)](https://github.com/wilkesystems/docker-arma3/blob/master/ubuntu/zesty/Dockerfile)

----------------

![Arma3](https://github.com/wilkesystems/docker-arma3/raw/master/docs/logo.png)

# Description
ARMA 3 is an open world, military tactical shooter video game developed and published by Bohemia Interactive. ARMA 3's storyline takes place in the mid-2030s during the fictional Operation Magnitude, a military operation launched by NATO forces fighting in Europe against "Eastern armies" referred to as Canton-Protocol Strategic Alliance Treaty (CSAT), led by a resurgent Iranian military with a coalition of other Middle Eastern and Asian nations.

----------------

# Get Image
[Docker hub](https://hub.docker.com/r/wilkesystems/arma3)

```bash
docker pull wilkesystems/arma3
```

----------------

# How to use this image
```bash
docker run -d \
        -e STEAM_LOGIN=<username> \
        -e STEAM_PASSWORD=<password> \
        -p 2301:2301 \
        -p 2302:2302 \
        -p 2303:2303 \
        -p 2304:2304 \
        -p 2305:2305 \
        -p 2306:2306 \
        wilkesystems/arma3
```

----------------

# Required Ports for Arma3
Which ports do I need to open for Arma3?

**Incoming:**

| Port            | Description                      |
|-----------------|----------------------------------|
| UDP 2301        | Arma3 rcon port                  |
| UDP 2302        | Arma3 game port + voice over net |
| UDP 2303        | Steam query port                 |
| UDP 2304        | Steam port                       |
| UDP 2306        | BattlEye port                    |

**Outgoing:**

| Port            | Description          |
|-----------------|----------------------|
| TCP 2345        | BattlEye port        |
| UDP 2302-2305   | Client traffic       |
| UDP 2303        | Steam query port     |
| UDP 2304        | Steam master traffic |

----------------

# Environment Variables

**Steam Configuration**

| Variable        | Function                       |
|-----------------|--------------------------------|
| STEAM_LOGIN     | Steam account login (required) |
| STEAM_PASSWORD  | Steam password (required)      |
| STEAM_APP_ID    | Steam App ID                   |
| STEAM_API_KEY   | Steam API Key                  |

**Arma 3 Startup Parameters**

| Variable                     | Function                                                                                                                                                                       |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ARMA3_PORT                   | Port to have dedicated server listen on                                                                                                                                        |
| ARMA3_BEPATH                 | By default BattlEye will create BattlEye folder inside server profile folder. With bepath param it is possible to specify a custom folder                                      |
| ARMA3_PROFILES               | Path to the folder containing server profile. By default, server logs are written to server profile folder. If folder doesn't exist, it will be automatically created          |
| ARMA3_BASIC_CFG              | Selects the Server Basic Config file. Config file for server specific settings like network performance tuning                                                                 |
| ARMA3_SERVER_CFG             | Selects the Server Config File. Config file for server specific settings like admin password and mission selection                                                             |
| ARMA3_WORLD_CFG              | Init Landscape by the given world config                                                                                                                                       |
| ARMA3_NAME                   | Profile name                                                                                                                                                                   |
| ARMA3_MODS                   | Loads the specified sub-folders for different mods. Separated by semi-colons. Absolute path and multiple stacked folders are possible                                          |
| ARMA3_SERVER_MODS            | Loads the specified sub-folders for different server-side (not broadcasted to clients) mods. Separated by semi-colons. Absolute path and multiple stacked folders are possible |
| ARMA3_BANDWIDTH_ALG          | Uses a new experimental networking algorithm that might be better than the default one                                                                                         |
| ARMA3_IP                     | Command to enable support for Multihome servers. Allows server process to use defined available IP address                                                                     |
| ARMA3_AUTOINIT               | Automatically initialize mission just like first client does                                                                                                                   |
| ARMA3_LOAD_MISSION_TO_MEMORY | Server will load mission into memory on first client downloading it. Then it keeps it pre-processed pre-cached in memory for next clients, saving some server CPU cycles       |
| ARMA3_NOSOUND                | Disables sound output                                                                                                                                                          |
| ARMA3_NOSPLASH               | Disables splash screens                                                                                                                                                        |
| ARMA3_PAR                    | Command to read startup parameters from a file.                                                                                                                                |
| ARMA3_SKIPINTRO              | Disables world intros in the main menu permanently                                                                                                                             |
| ARMA3_WORLD                  | Select a world loaded by default                                                                                                                                               |

**Basic Configuration**

| Variable                     | Function                                                                                                                                                                                                                                                   |
|------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ARMA3_LANGUAGE               | Language settings                                                                                                                                                                                                                                          |
| ARMA3_ADAPTER                | Adapter settings                                                                                                                                                                                                                                           |
| ARMA3_3D_PERFORMANCE         | 3D Performance settings                                                                                                                                                                                                                                    |
| ARMA3_RESOLUTION_W           | Resolution width settings                                                                                                                                                                                                                                  |
| ARMA3_RESOLUTION_H           | Resolution height settings                                                                                                                                                                                                                                 |
| ARMA3_RESOLUTION_BPP         | Resolution BPP settings                                                                                                                                                                                                                                    |
| ARMA3_MIN_BANDWIDTH          | Bandwidth the server is guaranteed to have (in bps). This value helps server to estimate bandwidth available. Increasing it to too optimistic values can increase lag and CPU load, as too many messages will be sent but discarded. Default: 131072       |
| ARMA3_MAX_BANDWIDTH          | Bandwidth the server is guaranteed to never have. This value helps the server to estimate bandwidth available.                                                                                                                                             |
| ARMA3_MAX_MSG_SEND           | Maximum number of messages that can be sent in one simulation cycle. Increasing this value can decrease lag on high upload bandwidth servers. Default: 128                                                                                                 |
| ARMA3_MAX_SIZE_GUARANTEED    | Maximum size of guaranteed packet in bytes (without headers). Small messages are packed to larger frames. Guaranteed messages are used for non-repetitive events like shooting. Default: 512                                                               |
| ARMA3_MAX_SIZE_NONGUARANTEED | Maximum size of non-guaranteed packet in bytes (without headers). Non-guaranteed messages are used for repetitive updates like soldier or vehicle position. Increasing this value may improve bandwidth requirement, but it may increase lag. Default: 256 |
| ARMA3_MIN_ERROR_TO_SEND      | Minimal error to send updates across network. Using a smaller value can make units observed by binoculars or sniper rifle to move smoother. Default: 0.001                                                                                                 |
| ARMA3_MIN_ERROR_TO_SEND_NEAR | Minimal error to send updates across network for near units. Using larger value can reduce traffic sent for near units. Used to control client to server traffic as well. Default: 0.01                                                                    |
| ARMA3_MAX_CUSTOM_FILE_SIZE   | Users with custom face or custom sound larger than this size (bytes) are kicked when trying to connect.                                                                                                                                                    |
| ARMA3_MAX_PACKET_SIZE        | Maximal size of packet sent over network                                                                                                                                                                                                                   |
| ARMA3_TERRAIN_GRID           | Terrain Grid                                                                                                                                                                                                                                               |
| ARMA3_VIEW_DISTANCE          | View Distance                                                                                                                                                                                                                                              |
| ARMA3_WINDOWED               | Windowed                                                                                                                                                                                                                                                   |

**Server Configuration**

| Variable                                 | Function                                                                                                                                                         |
|------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ARMA3_HOSTNAME                           | Servername visible in the game browser                                                                                                                           |
| ARMA3_PASSWORD                           | Password required to connect to server.                                                                                                                          |
| ARMA3_PASSWORD_ADMIN                     | Password to protect admin access.                                                                                                                                |
| ARMA3_SERVER_COMMAND_PASSWORD            | Password required by alternate syntax of serverCommand server-side scripting.                                                                                    |
| ARMA3_LOGFILE                            | Enables output of dedicated server console into textfile. Default location of log is same as crash dumps and other logs.                                         |
| ARMA3_MOTD                               | Welcome message of the Day. Comma is the 'new line' separator.                                                                                                   |
| ARMA3_MOTD_INTERVAL                      | Time interval (seconds) between each message                                                                                                                     |
| ARMA3_MAX_PLAYERS                        | Maximum amount of players. Civilians and watchers, beholder, bystanders and so on also count as player.                                                          |
| ARMA3_KICK_DUPLICATE                     | Each ArmA version has its own ID. If kickDuplicate is set to 1, a player will be kicked when he joins a server where another player with the same ID is playing. |
| ARMA3_VERIFY_SIGNATURES                  | Enables or disables the signature verification for addons. Default = 0, Weak protection = 1, Full protection = 2                                                 |
| ARMA3_EQUAL_MOD_REQUIRED                 | If set to 1, player has to use exactly the same -mod= startup parameter as the server. (Outdated)                                                                |
| ARMA3_ALLOWED_FILE_PATCHING              | Allow or prevent client using -filePatching to join the server. 0, is disallow, 1 is allow HC, 2 is allow all clients (since Arma 3 1.49+)                       |
| ARMA3_VOTE_MISSION_PLAYERS               | Percentage of votes needed to confirm a vote. 33% in this example                                                                                                |
| ARMA3_DISABLE_VON                        | If set to 1, Voice over Net will not be available                                                                                                                |
| ARMA3_VON_CODEC                          | If set to 1 then it uses IETF standard OPUS codec, if to 0 then it uses SPEEX codec (since Arma 3 update 1.58+)                                                  |
| ARMA3_VON_CODEC_QUALITY                  | Since 1.62.95417 supports range 1-20 //since 1.63.x will supports range 1-30 //8kHz is 0-10, 16kHz is 11-20, 32kHz(48kHz) is 21-30                               |
| ARMA3_PERSISTENT                         | If 1, missions still run on even after the last player disconnected. Default = 0                                                                                 |
| ARMA3_TIME_STAMP_FORMAT                  | Set the timestamp format used on each report line in server-side RPT file. Possible values are "none" (default),"short","full".                                  |
| ARMA3_BATTLE_EYE                         | Server to use BattlEye system                                                                                                                                    |
| ARMA3_ALLOWED_LOAD_FILE_EXTENSIONS       | Only allow files with those extensions to be loaded via loadFile command (since Arma 3 build 1.19.124216)                                                        |
| ARMA3_ALLOWED_PREPROCESS_FILE_EXTENSIONS | Only allow files with those extensions to be loaded via preprocessFile/preprocessFileLineNumber commands (since Arma 3 build 1.19.124323)                        |
| ARMA3_ALLOWED_HTML_LOAD_EXTENSIONS       | Only allow files with those extensions to be loaded via HTMLLoad command (since Arma 3 build 1.27.126715)                                                        |
| ARMA3_ALLOWED_VOTE_CMDS                  | Alowed Vote commands.                                                                                                                                            |
| ARMA3_ALLOWED_VOTED_ADMIN_CMDS           | Definition of available commands for voted-in admins.                                                                                                            |
| ARMA3_DISCONNECT_TIMEOUT                 | Server wait time before disconnecting client, default 90 seconds, range 5 to 90 seconds. (since Arma 3 update 1.56+)                                             |
| ARMA3_ON_USER_CONNECTED                  | User has connected                                                                                                                                               |
| ARMA3_ON_USER_DISCONNECTED               | User has disconnected                                                                                                                                            |
| ARMA3_DOUBLE_ID_DETECTED                 | 2nd user with the same ID detected                                                                                                                               |
| ARMA3_ON_UNSIGNED_DATA                   | Unsigned data detected                                                                                                                                           |
| ARMA3_ON_HACKED_DATA                     | Modification of signed pbo detected                                                                                                                              |
| ARMA3_ON_DIFFERENT_DATA                  | Signed pbo detected with a valid signature, but a different version than a server has                                                                            |
| ARMA3_FORCED_DIFFICULTY                  | Enforces the selected difficulty on the server.                                                                                                                  |
| ARMA3_MISSIONS                           | An empty Missions class means there will be no mission rotation                                                                                                  |
| ARMA3_MISSIONS_WHITELIST                 | An empty whitelist means there is no restriction on what missions' available                                                                                     |

**Battleye Configuration**

| Variable            | Function            |
|---------------------|---------------------|
| ARMA3_RCON_PORT     | Arma3 RCon Port     |
| ARMA3_RCON_IP       | Arma3 RCon IP       |
| ARMA3_RCON_PASSWORD | Arma3 RCon Password |

----------------

# Auto Builds
New images are automatically built by each new wilkesystems/steamcmd push.

[![Docker build](https://dockeri.co/image/wilkesystems/arma3)](https://hub.docker.com/r/wilkesystems/arma3/)