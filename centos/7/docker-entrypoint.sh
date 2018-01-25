#!/bin/bash
set -euo pipefail

function main {
    # Set Steam Login
    : ${STEAM_LOGIN:=anonymous}

    # Set Steam Password
    : ${STEAM_PASSWORD:=anonymous}

    # Install or Update Arma3
    steamcmd +login $STEAM_LOGIN $STEAM_PASSWORD +force_install_dir /usr/games/arma3 +app_update 233780 +quit

    # Create MPMission link
    if [ ! -L "/usr/games/arma3/MPMissions" ]; then
        ln -s mpmissions /usr/games/arma3/MPMissions
    fi

    # Create basic.cfg configuration file
    if [ ! -f "/usr/games/arma3/basic.cfg" ]; then
        echo -e "//" > /usr/games/arma3/basic.cfg
        echo -e "// Basic.cfg" >> /usr/games/arma3/basic.cfg
        echo -e "//\n" >> /usr/games/arma3/basic.cfg

        if [ -v ARMA3_LANGUAGE ]; then
            echo 'language="'$ARMA3_LANGUAGE'";' >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_ADAPTER ]; then
            echo "adapter=$ARMA3_ADAPTER;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_3D_PERFORMANCE ]; then
             echo "3D_Performance=$ARMA3_3D_PERFORMANCE;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_RESOLUTION_W ]; then
            echo "Resolution_W=$ARMA3_RESOLUTION_W;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_RESOLUTION_H ]; then
            echo "Resolution_H=$ARMA3_RESOLUTION_H;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_RESOLUTION_BPP ]; then
            echo "Resolution_Bpp=$ARMA3_RESOLUTION_BPP;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MIN_BANDWIDTH ]; then
            echo "MinBandwidth=$ARMA3_MIN_BANDWIDTH;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MAX_BANDWIDTH ]; then
            echo "MaxBandwidth=$ARMA3_MAX_BANDWIDTH;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MAX_MSG_SEND ]; then
            echo "MaxMsgSend=$ARMA3_MAX_MSG_SEND;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MAX_SIZE_GUARANTEED ]; then
            echo "MaxSizeGuaranteed=$ARMA3_MAX_SIZE_GUARANTEED;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MAX_SIZE_NONGUARANTEED ]; then
            echo "MaxSizeNonguaranteed=$ARMA3_MAX_SIZE_NONGUARANTEED;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MIN_ERROR_TO_SEND ]; then
            echo "MinErrorToSend=$ARMA3_MIN_ERROR_TO_SEND;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MIN_ERROR_TO_SEND_NEAR ]; then
            echo "MinErrorToSendNear=$ARMA3_MIN_ERROR_TO_SEND_NEAR;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MAX_CUSTOM_FILE_SIZE ]; then
            echo "MaxCustomFileSize=$ARMA3_MAX_CUSTOM_FILE_SIZE;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_MAX_PACKET_SIZE ]; then
            echo "class sockets{maxPacketSize=$ARMA3_MAX_PACKET_SIZE;};" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_TERRAIN_GRID ]; then
            echo "terrainGrid=$ARMA3_TERRAIN_GRID;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_VIEW_DISTANCE ]; then
            echo "viewDistance=$ARMA3_VIEW_DISTANCE;" >> /usr/games/arma3/basic.cfg
        fi

        if [ -v ARMA3_WINDOWED ]; then
            echo "Windowed=$ARMA3_WINDOWED;" >> /usr/games/arma3/basic.cfg
        fi
    fi

    # Create server.cfg configuration file
    if [ ! -f /usr/games/arma3/server.cfg ]; then
        echo -e "//" > /usr/games/arma3/server.cfg
        echo -e "// Server.cfg" >> /usr/games/arma3/server.cfg
        echo -e "//\n" >> /usr/games/arma3/server.cfg

        if [ -v ARMA3_HOSTNAME ]; then
            echo 'hostname="'$ARMA3_HOSTNAME'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_PASSWORD ]; then
            echo 'password="'$ARMA3_PASSWORD'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_PASSWORD_ADMIN ]; then
            echo 'passwordAdmin="'$ARMA3_PASSWORD_ADMIN'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_SERVER_COMMAND_PASSWORD ]; then
            echo 'serverCommandPassword="'$ARMA3_SERVER_COMMAND_PASSWORD'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_LOGFILE ]; then
            echo 'logFile="'$ARMA3_LOGFILE'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_MOTD ]; then
            echo 'motd[]={'$ARMA3_MOTD'};' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_MOTD_INTERVAL ]; then
            echo 'motdInterval="'$ARMA3_MOTD_INTERVAL'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_MAX_PLAYERS ]; then
            echo 'maxPlayers="'$ARMA3_MAX_PLAYERS'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_KICK_DUPLICATE ]; then
            echo 'kickDuplicate="'$ARMA3_KICK_DUPLICATE'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_VERIFY_SIGNATURES ]; then
            echo 'verifySignatures="'$ARMA3_VERIFY_SIGNATURES'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_EQUAL_MOD_REQUIRED ]; then
            echo 'equalModRequired="'$ARMA3_EQUAL_MOD_REQUIRED'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ALLOWED_FILE_PATCHING ]; then
            echo 'allowedFilePatching="'$ARMA3_ALLOWED_FILE_PATCHING'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_VOTE_MISSION_PLAYERS ]; then
            echo 'voteMissionPlayers="'$ARMA3_VOTE_MISSION_PLAYERS'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_VOTE_THRESHOLD ]; then
            echo 'voteThreshold="'$ARMA3_VOTE_THRESHOLD'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_DISABLE_VON ]; then
            echo 'disableVoN="'$ARMA3_DISABLE_VON'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_VON_CODEC ]; then
            echo 'vonCodec="'$ARMA3_VON_CODEC'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_VON_CODEC_QUALITY ]; then
            echo 'vonCodecQuality="'$ARMA3_VON_CODEC_QUALITY'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_PERSISTENT ]; then
            echo 'persistent="'$ARMA3_PERSISTENT'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_TIME_STAMP_FORMAT ]; then
            echo 'timeStampFormat="'$ARMA3_TIME_STAMP_FORMAT'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_BATTLE_EYE ]; then
            echo 'BattlEye='$ARMA3_BATTLE_EYE';' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ALLOWED_LOAD_FILE_EXTENSIONS ]; then
            echo 'allowedLoadFileExtensions[]={'$ARMA3_ALLOWED_LOAD_FILE_EXTENSIONS'};' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ALLOWED_PREPROCESS_FILE_EXTENSIONS ]; then
            echo 'allowedPreprocessFileExtensions[]={'$ARMA3_ALLOWED_PREPROCESS_FILE_EXTENSIONS'};' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ALLOWED_HTML_LOAD_EXTENSIONS ]; then
            echo 'allowedHTMLLoadExtensions[]={'$ARMA3_ALLOWED_HTML_LOAD_EXTENSIONS'};' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ALLOWED_VOTE_CMDS ]; then
            echo 'allowedVoteCmds[]={'$ARMA3_ALLOWED_VOTE_CMDS'};' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ALLOWED_VOTED_ADMIN_CMDS ]; then
            echo 'allowedVotedAdminCmds[]={'$ARMA3_ALLOWED_VOTED_ADMIN_CMDS'};' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_DISCONNECT_TIMEOUT ]; then
            echo 'disconnectTimeout="'$ARMA3_DISCONNECT_TIMEOUT'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ON_USER_CONNECTED ]; then
            echo 'onUserConnected="'$ARMA3_ON_USER_CONNECTED'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ON_USER_DISCONNECTED ]; then
            echo 'onUserDisconnected="'$ARMA3_ON_USER_DISCONNECTED'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_DOUBLE_ID_DETECTED ]; then
            echo 'doubleIdDetected="'$ARMA3_DOUBLE_ID_DETECTED'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ON_UNSIGNED_DATA ]; then
            echo 'onUnsignedData="'$ARMA3_ON_UNSIGNED_DATA'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ON_HACKED_DATA ]; then
            echo 'onHackedData="'$ARMA3_ON_HACKED_DATA'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_ON_DIFFERENT_DATA ]; then
            echo 'onDifferentData="'$ARMA3_ON_DIFFERENT_DATA'";' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_FORCED_DIFFICULTY ]; then
            echo 'forcedDifficulty = '$ARMA3_FORCED_DIFFICULTY';' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_MISSIONS ]; then
            echo 'class Missions {'$ARMA3_MISSIONS'};' >> /usr/games/arma3/server.cfg
        fi

        if [ -v ARMA3_MISSIONS_WHITELIST ]; then
            echo 'missionWhitelist[] = {'$ARMA3_MISSIONS_WHITELIST'};' >> /usr/games/arma3/server.cfg
        fi
    fi

    # Create Battleye configuration file
    if [ ! -f "/usr/games/arma3/battleye/beserver.cfg" -a -d /usr/games/arma3/battleye ]; then
        # Set RCon Port
        : ${ARMA3_RCON_PORT:=2301}
        echo "RConPort $ARMA3_RCON_PORT" > /usr/games/arma3/battleye/beserver.cfg

        # Set RCon IP
        : ${ARMA3_RCON_IP:=0.0.0.0}
        echo "RConIP $ARMA3_RCON_IP" >> /usr/games/arma3/battleye/beserver.cfg

        # Set RCon Password
        : ${ARMA3_RCON_PASSWORD:=$(cat /dev/urandom | tr -d -c a-z0-9- | dd bs=1 count=16 2> /dev/null)}
        echo "RConPassword $ARMA3_RCON_PASSWORD" >> /usr/games/arma3/battleye/beserver.cfg

        # Set Battleye max Ping
        if [ -v ARMA3_BATTLEYE_MAX_PING ]; then
            echo "maxPing $ARMA3_BATTLEYE_MAX_PING" >> /usr/games/arma3/battleye/beserver.cfg
        fi
    fi

    # Arma3 Packages Import
    if [ -d /etc/docker-entrypoint.d ]; then
        for ARMA3_PACKAGE in /etc/docker-entrypoint.d/*
        do
            case "$ARMA3_PACKAGE" in
                *.7z)
                    if [ -e "$(which 7za)" ]; then
                        7za x -y $ARMA3_PACKAGE > /dev/null
                    fi
                    ;;
                *.tar.gz)
                    if [ -e "$(which tar)" ]; then
                        tar xfz $ARMA3_PACKAGE
                    fi
                    ;;
                *.zip)
                    if [ -e "$(which unzip)" ]; then
                        unzip -o -q $ARMA3_PACKAGE
                    fi
                    ;;
                *) ;;
            esac
        done
    fi

    if [ "${UID}" -eq 0 ]; then
        exec su -s /bin/bash steam -c "$@"
    else
        exec "$@"
    fi
}

main "$@"

exit
