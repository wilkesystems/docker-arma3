#!/bin/bash
set -o pipefail
set -o errtrace
set -o nounset
set -o errexit

function main ()
{
    args=$(getopt -n "$(basename $0)" -o h --long help,debug,version -- "$@")
    eval set --"$args"
    while true; do
        case "$1" in
            -h | --help )
                print_usage
                shift
                ;;
            --debug )
                DEBUG=true
                shift
                ;;
            --version )
                print_version
                shift
                ;;
            --)
                shift
                break
                ;;
            * )
                break
                ;;
        esac
    done
    shift $((OPTIND-1))
    init
    for arg; do
        case "$arg" in
            arma3server )
                arma3server
                shift
                ;;
            import )
                import
                exit
                ;;
            install )
                install "${STEAM_LOGIN}" "${STEAM_PASSWORD}" "${STEAM_APP_ID}" "${ARMA3_PATH}"
                exit
                ;;
            restart )
                if [ -x $(which supervisorctl) ]; then
                    $(which supervisorctl) restart arma3server
                fi
                exit
                ;;
            start )
                if [ -x $(which supervisorctl) ]; then
                    $(which supervisorctl) start arma3server
                fi
                exit
                ;;
            stop )
                if [ -x $(which supervisorctl) ]; then
                    $(which supervisorctl) stop arma3server
                fi
                exit
                ;;
            status )
                if [ -x $(which supervisorctl) ]; then
                    $(which supervisorctl) status
                fi
                exit
                ;;
            supervisor )
                supervisor
                shift
                ;;
        esac
    done
    supervisor

    return
}

function init ()
{
    # Set Debug Mode
    : ${DEBUG:=false}

    [ "${DEBUG}" = "true" ] && set -x

    # Set Verbose Mode
    : ${VERBOSE:=false}

    # Set Steam Defaults
    : ${STEAM_LOGIN:=anonymous}
    : ${STEAM_PASSWORD:=anonymous}
    : ${STEAM_APP_ID:=233780}
    : ${STEAM_API_KEY:=}

    # Set Supervisor Defaults
    : ${SUPERVISOR_USERNAME:=admin}
    : ${SUPERVISOR_PASSWORD:=$(cat /dev/urandom | tr -d -c a-z0-9- | dd bs=1 count=$((RANDOM%(24-16+1)+16)) 2> /dev/null)}
    : ${SUPERVISOR_PORT:=9001}
    : ${SUPERVISOR_LOGTAIL:=false}

    # Set Arma3 Defaults
    : ${ARMA3_PATH:=/usr/games/arma3}
    : ${ARMA3_BIN:=$ARMA3_PATH/arma3server}
    : ${ARMA3_LOGFILE:=/dev/stdout}
    : ${ARMA3_CRON:=false}
    : ${ARMA3_CRON_RESTART:=}
    : ${ARMA3_MAIL:=false}
    : ${ARMA3_SYSLOG:=false}
    : ${ARMA3_RCON_PORT:=2301}
    : ${ARMA3_RCON_IP:=0.0.0.0}
    : ${ARMA3_RCON_PASSWORD:=$(cat /dev/urandom | tr -d -c a-z0-9- | dd bs=1 count=$((RANDOM%(24-16+1)+16)) 2> /dev/null)}
    : ${ARMA3_EXTDB3_SECTION:=Database}
    : ${ARMA3_EXTDB3_IP:=127.0.0.1}
    : ${ARMA3_EXTDB3_PORT:=3306}
    : ${ARMA3_EXTDB3_USERNAME:=changeme}
    : ${ARMA3_EXTDB3_PASSWORD:=changeme}
    : ${ARMA3_EXTDB3_DATABASE:=changeme}
    : ${ARMA3_OPTS:=}

    # Set Arma3 Options
    : ${ARMA3_PORT:=2302}
    : ${ARMA3_BEPATH:=$ARMA3_PATH/battleye}
    : ${ARMA3_PROFILES:=$ARMA3_PATH/profiles}
    : ${ARMA3_BASIC_CFG:=$ARMA3_PATH/basic.cfg}
    : ${ARMA3_SERVER_CFG:=$ARMA3_PATH/server.cfg}
    : ${ARMA3_NAME:=default}
    : ${ARMA3_MODS:=NULL}
    : ${ARMA3_SERVER_MODS:=NULL}
    : ${ARMA3_BANDWIDTH_ALG:=NULL}
    : ${ARMA3_IP:=NULL}
    : ${ARMA3_AUTOINIT:=NULL}
    : ${ARMA3_BANDWIDTH_ALG:=NULL}
    : ${ARMA3_LOAD_MISSION_TO_MEMORY:=NULL}
    : ${ARMA3_NOSOUND:=NULL}
    : ${ARMA3_NOSPLASH:=NULL}
    : ${ARMA3_PAR:=NULL}
    : ${ARMA3_SKIPINTRO:=NULL}
    : ${ARMA3_WORLD:=NULL}
    : ${ARMA3_WORLD_CFG:=NULL}

    ARMA3_OPTS="${ARMA3_OPTS} -port=${ARMA3_PORT}"
    ARMA3_OPTS="${ARMA3_OPTS} -bepath=${ARMA3_BEPATH}"
    ARMA3_OPTS="${ARMA3_OPTS} -cfg=${ARMA3_BASIC_CFG}"
    ARMA3_OPTS="${ARMA3_OPTS} -config=${ARMA3_SERVER_CFG}"
    ARMA3_OPTS="${ARMA3_OPTS} -profiles=${ARMA3_PROFILES}"
    ARMA3_OPTS="${ARMA3_OPTS} -name=${ARMA3_NAME}"

    if [ "${ARMA3_MODS}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -mod=${ARMA3_MODS}"
    fi

    if [ "${ARMA3_SERVER_MODS}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -serverMod=${ARMA3_SERVER_MODS}"
    fi

    if [ "${ARMA3_AUTOINIT}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -autoinit"
    fi

    if [ "${ARMA3_BANDWIDTH_ALG}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -bandwidthAlg=${ARMA3_BANDWIDTH_ALG}"
    fi

    if [ "${ARMA3_IP}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -ip=${ARMA3_IP}"
    fi

    if [ "${ARMA3_LOAD_MISSION_TO_MEMORY}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -loadMissionToMemory"
    fi

    if [ "${ARMA3_NOSOUND}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -noSound"
    fi

    if [ "${ARMA3_NOSPLASH}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -nosplash"
    fi

    if [ "${ARMA3_PAR}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -par=${ARMA3_PAR}"
    fi

    if [ "${ARMA3_SKIPINTRO}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -skipIntro"
    fi

    if [ "${ARMA3_WORLD}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -world=${ARMA3_WORLD}"
    fi

    if [ "${ARMA3_WORLD_CFG}" != "NULL" ]; then
        ARMA3_OPTS="${ARMA3_OPTS} -worldCfg=${ARMA3_WORLD_CFG}"
    fi

    ARMA3_OPTS="$(echo "${ARMA3_OPTS}" | sed -e 's/^[ ]*//')"

    return
}

function install ()
{
    if [ ! -d ${4} ]; then
        mkdir -m 770 -p ${4}
    fi

    chown -R steam: ${4}

    trap "error_handler" ERR

    if [ "${UID}" -eq 0 ]; then
        if [ "${VERBOSE}" = "true" ]; then
            echo "su -s /bin/bash steam -c \"steamcmd +login ${1} ${2} +force_install_dir ${4} +app_update ${3} validate +quit\""
            su -s /bin/bash steam -c "steamcmd +login ${1} ${2} +force_install_dir ${4} +app_update ${3} validate +quit"
        else
            su -s /bin/bash steam -c "steamcmd +login ${1} ${2} +force_install_dir ${4} +app_update ${3} validate +quit > /dev/null"
        fi
    else
        if [ "${VERBOSE}" = "true" ]; then
            echo "steamcmd +login ${1} ${2} +force_install_dir ${4} +app_update ${3} validate +quit"
            steamcmd +login ${1} ${2} +force_install_dir ${4} +app_update ${3} validate +quit
        else
            steamcmd +login ${1} ${2} +force_install_dir ${4} +app_update ${3} validate +quit > /dev/null
        fi
    fi

    trap "exit 0" ERR

    if [ ! -L "${4}/MPMissions" ]; then
        if [ "${UID}" -eq 0 ]; then
            su -s /bin/bash steam -c "ln -s mpmissions ${4}/MPMissions"
        else
            ln -s mpmissions ${4}/MPMissions
        fi
    fi

    import

    if [ "${UID}" -eq 0 -a -x /usr/bin/supervisord -a -f /etc/supervisor/conf.d/inet_http_server.conf -a -d /etc/supervisor/conf.d ]; then
        echo -e "[program:arma3server]" > /etc/supervisor/conf.d/arma3server.conf
        echo -e "command = ${ARMA3_BIN} ${ARMA3_OPTS}" >> /etc/supervisor/conf.d/arma3server.conf
        echo -e "directory = ${ARMA3_PATH}" >> /etc/supervisor/conf.d/arma3server.conf
        echo -e "autostart = true" >> /etc/supervisor/conf.d/arma3server.conf
        echo -e "autorestart = true" >> /etc/supervisor/conf.d/arma3server.conf
        echo -e "user = steam" >> /etc/supervisor/conf.d/arma3server.conf

        if [ "${SUPERVISOR_LOGTAIL}" = "false" ]; then
            echo -e "stdout_logfile = /var/log/supervisor/arma3server.log" >> /etc/supervisor/conf.d/arma3server.conf
            echo -e "stdout_logfile_maxbytes = 0" >> /etc/supervisor/conf.d/arma3server.conf
            echo -e "stderr_logfile = ${ARMA3_LOGFILE}" >> /etc/supervisor/conf.d/arma3server.conf
            echo -e "stderr_logfile_maxbytes = 0" >> /etc/supervisor/conf.d/arma3server.conf
        else
            echo -e "redirect_stderr=true" >> /etc/supervisor/conf.d/arma3server.conf
            echo -e "stdout_logfile = /var/log/supervisor/arma3server.log" >> /etc/supervisor/conf.d/arma3server.conf
            echo -e "stdout_logfile_maxbytes = 0" >> /etc/supervisor/conf.d/arma3server.conf
        fi

        echo "Starting Steam Server...OK."

        supervisorctl reread > /dev/null
        supervisorctl add arma3server > /dev/null
    fi

    return
}

function arma3server ()
{
    echo "Loading Steam API...OK."

    install "${STEAM_LOGIN}" "${STEAM_PASSWORD}" "${STEAM_APP_ID}" "${ARMA3_PATH}"

    echo "Starting Steam Server...OK."

    if [ "${UID}" -eq 0 ]; then
        exec su -s /bin/bash steam -c "${ARMA3_BIN} ${ARMA3_OPTS}"
    else
        if [ "$ARMA3_LOGFILE" != "/dev/stdout" ]; then
            exec ${ARMA3_BIN} ${ARMA3_OPTS} 2>&1 | tee -a $ARMA3_LOGFILE
        else
            exec ${ARMA3_BIN} ${ARMA3_OPTS}
        fi
    fi

    exit
}

function supervisor ()
{
    if [ "${UID}" -eq 0 -a -x /usr/bin/supervisord -a -f /etc/supervisor/supervisord.conf -a -d /etc/supervisor/conf.d ]; then
        echo "Loading Steam API...OK."

        ${0} install &

        if [ $(grep -c 'username = ' /etc/supervisor/supervisord.conf) -ne 1 ]; then
            sed -i "s/^\(\[unix_http_server\]\)$/\1\nusername = ${SUPERVISOR_USERNAME}\npassword = ${SUPERVISOR_PASSWORD}/" /etc/supervisor/supervisord.conf
            sed -i "s/^\(\[supervisorctl\]\)$/\1\nusername = ${SUPERVISOR_USERNAME}\npassword = ${SUPERVISOR_PASSWORD}/" /etc/supervisor/supervisord.conf
        else
            sed -i "s/^username = \(.*\)$/username = ${SUPERVISOR_USERNAME}/" /etc/supervisor/supervisord.conf
            sed -i "s/^password = \(.*\)$/password = ${SUPERVISOR_PASSWORD}/" /etc/supervisor/supervisord.conf
        fi

        # Supervisor Cron
        if [ "${ARMA3_CRON}" = "true" -a -x /usr/sbin/cron ]; then
            # Add Cronjob Restart
            if [ -n "$ARMA3_CRON_RESTART" ]; then
                echo -e "# /etc/cron.d/restart\nSHELL=/bin/sh\nPATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin\n" > /etc/cron.d/restart
                echo -e "${ARMA3_CRON_RESTART} root test -x ${ARMA3_BIN} && /usr/bin/supervisorctl restart arma3server; echo \"\$(date) Cron: Arma3 Restart\" >> /var/log/supervisor/cron.log" >> /etc/cron.d/restart
            fi
            echo -e "[program:cron]" > /etc/supervisor/conf.d/cron.conf
            echo -e "porcess_name = cron" >> /etc/supervisor/conf.d/cron.conf
            echo -e "command=cron -f" >> /etc/supervisor/conf.d/cron.conf
            echo -e "autostart=true" >> /etc/supervisor/conf.d/cron.conf
            echo -e "autorestart=true" >> /etc/supervisor/conf.d/cron.conf
            echo -e "redirect_stderr=true" >> /etc/supervisor/conf.d/cron.conf
            echo -e "startretries=3" >> /etc/supervisor/conf.d/cron.conf
            echo -e "startsecs=0" >> /etc/supervisor/conf.d/cron.conf
            echo -e "stdout_logfile=/var/log/supervisor/cron.log" >> /etc/supervisor/conf.d/cron.conf
            echo -e "stdout_logfile_maxbytes=0" >> /etc/supervisor/conf.d/cron.conf
        fi

        # Supervisor Exim4
        if [ "${ARMA3_MAIL}" = "true" -a -x /usr/sbin/exim4 ]; then
            sed -i -e "s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
            sed -i -e "s/dc_other_hostnames=.*/dc_other_hostnames='$(hostname --fqdn)'/" /etc/exim4/update-exim4.conf.conf
            sed -i -e "s/dc_local_interfaces=.*/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf

            echo $(hostname) > /etc/mailname
            update-exim4.conf

            echo -e "[program:exim4]" > /etc/supervisor/conf.d/exim4.conf
            echo -e "porcess_name = exim4" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "command=exim4 -bd -v" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "autostart=true" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "autorestart=true" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "redirect_stderr=true" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "startretries=3" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "startsecs=0" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "stdout_logfile=/var/log/supervisor/exim4.log" >> /etc/supervisor/conf.d/exim4.conf
            echo -e "stdout_logfile_maxbytes=0" >> /etc/supervisor/conf.d/exim4.conf
        fi

        # Supervisor Syslog
        if [ "${ARMA3_SYSLOG}" = "true" -a -x /usr/sbin/rsyslogd ]; then
            echo -e "[program:rsyslogd]" > /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "porcess_name = rsyslogd" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "command=rsyslogd -n" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "autostart=true" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "autorestart=true" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "redirect_stderr=true" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "startretries=3" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "startsecs=0" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "stdout_logfile=/var/log/supervisor/rsyslog.log" >> /etc/supervisor/conf.d/rsyslogd.conf
            echo -e "stdout_logfile_maxbytes=0" >> /etc/supervisor/conf.d/rsyslogd.conf
        fi

        # Supervisor HTTP Server
        echo -e "[inet_http_server]" > /etc/supervisor/conf.d/inet_http_server.conf
        echo -e "port = *:${SUPERVISOR_PORT}" >> /etc/supervisor/conf.d/inet_http_server.conf
        echo -e "username = ${SUPERVISOR_USERNAME}" >> /etc/supervisor/conf.d/inet_http_server.conf
        echo -e "password = ${SUPERVISOR_PASSWORD}" >> /etc/supervisor/conf.d/inet_http_server.conf

        # Execute Supervisor
        exec supervisord -c /etc/supervisor/supervisord.conf -e critical -n -u root
    else
        arma3server
    fi

    exit
}

function create_cfg ()
{
    # Create basic.cfg configuration file
    if [ ! -f "${1}" -a -d $(dirname ${1}) ]; then
        if [ ! -d $(dirname ${1}) ]; then
            mkdir -m 770 -p $(dirname ${1})
        fi

        chown steam: $(dirname ${1})

        echo -e "//" > ${1}
        echo -e "// Basic.cfg" >> ${1}
        echo -e "//\n" >> ${1}

        if [ -v ARMA3_LANGUAGE ]; then
            echo 'language="'$ARMA3_LANGUAGE'";' >> ${1}
        fi

        if [ -v ARMA3_ADAPTER ]; then
            echo "adapter=$ARMA3_ADAPTER;" >> ${1}
        fi

        if [ -v ARMA3_3D_PERFORMANCE ]; then
             echo "3D_Performance=$ARMA3_3D_PERFORMANCE;" >> ${1}
        fi

        if [ -v ARMA3_RESOLUTION_W ]; then
            echo "Resolution_W=$ARMA3_RESOLUTION_W;" >> ${1}
        fi

        if [ -v ARMA3_RESOLUTION_H ]; then
            echo "Resolution_H=$ARMA3_RESOLUTION_H;" >> ${1}
        fi

        if [ -v ARMA3_RESOLUTION_BPP ]; then
            echo "Resolution_Bpp=$ARMA3_RESOLUTION_BPP;" >> ${1}
        fi

        if [ -v ARMA3_MIN_BANDWIDTH ]; then
            echo "MinBandwidth=$ARMA3_MIN_BANDWIDTH;" >> ${1}
        fi

        if [ -v ARMA3_MAX_BANDWIDTH ]; then
            echo "MaxBandwidth=$ARMA3_MAX_BANDWIDTH;" >> ${1}
        fi

        if [ -v ARMA3_MAX_MSG_SEND ]; then
            echo "MaxMsgSend=$ARMA3_MAX_MSG_SEND;" >> ${1}
        fi

        if [ -v ARMA3_MAX_SIZE_GUARANTEED ]; then
            echo "MaxSizeGuaranteed=$ARMA3_MAX_SIZE_GUARANTEED;" >> ${1}
        fi

        if [ -v ARMA3_MAX_SIZE_NONGUARANTEED ]; then
            echo "MaxSizeNonguaranteed=$ARMA3_MAX_SIZE_NONGUARANTEED;" >> ${1}
        fi

        if [ -v ARMA3_MIN_ERROR_TO_SEND ]; then
            echo "MinErrorToSend=$ARMA3_MIN_ERROR_TO_SEND;" >> ${1}
        fi

        if [ -v ARMA3_MIN_ERROR_TO_SEND_NEAR ]; then
            echo "MinErrorToSendNear=$ARMA3_MIN_ERROR_TO_SEND_NEAR;" >> ${1}
        fi

        if [ -v ARMA3_MAX_CUSTOM_FILE_SIZE ]; then
            echo "MaxCustomFileSize=$ARMA3_MAX_CUSTOM_FILE_SIZE;" >> ${1}
        fi

        if [ -v ARMA3_MAX_PACKET_SIZE ]; then
            echo "class sockets{maxPacketSize=$ARMA3_MAX_PACKET_SIZE;};" >> ${1}
        fi

        if [ -v ARMA3_TERRAIN_GRID ]; then
            echo "terrainGrid=$ARMA3_TERRAIN_GRID;" >> ${1}
        fi

        if [ -v ARMA3_VIEW_DISTANCE ]; then
            echo "viewDistance=$ARMA3_VIEW_DISTANCE;" >> ${1}
        fi

        if [ -v ARMA3_WINDOWED ]; then
            echo "Windowed=$ARMA3_WINDOWED;" >> ${1}
        fi

        chown steam: ${1}
    fi

    return
}

function create_config ()
{
    # Create server.cfg configuration file
    if [ ! -f ${1} ]; then
        if [ ! -d $(dirname ${1}) ]; then
            mkdir -m 770 -p $(dirname ${1})
        fi

        chown steam: $(dirname ${1})

        echo -e "//" > ${1}
        echo -e "// Server.cfg" >> ${1}
        echo -e "//\n" >> ${1}

        if [ -v ARMA3_HOSTNAME ]; then
            echo 'hostname="'$ARMA3_HOSTNAME'";' >> ${1}
        fi

        if [ -v ARMA3_PASSWORD ]; then
            echo 'password="'$ARMA3_PASSWORD'";' >> ${1}
        fi

        if [ -v ARMA3_PASSWORD_ADMIN ]; then
            echo 'passwordAdmin="'$ARMA3_PASSWORD_ADMIN'";' >> ${1}
        fi

        if [ -v ARMA3_SERVER_COMMAND_PASSWORD ]; then
            echo 'serverCommandPassword="'$ARMA3_SERVER_COMMAND_PASSWORD'";' >> ${1}
        fi

        if [ -v ARMA3_SERVER_CONSOLE_LOG ]; then
            echo 'logFile="'$ARMA3_SERVER_CONSOLE_LOG'";' >> ${1}
        fi

        if [ -v ARMA3_MOTD ]; then
            echo 'motd[]={'$ARMA3_MOTD'};' >> ${1}
        fi

        if [ -v ARMA3_MOTD_INTERVAL ]; then
            echo 'motdInterval="'$ARMA3_MOTD_INTERVAL'";' >> ${1}
        fi

        if [ -v ARMA3_MAX_PLAYERS ]; then
            echo 'maxPlayers="'$ARMA3_MAX_PLAYERS'";' >> ${1}
        fi

        if [ -v ARMA3_KICK_DUPLICATE ]; then
            echo 'kickDuplicate="'$ARMA3_KICK_DUPLICATE'";' >> ${1}
        fi

        if [ -v ARMA3_VERIFY_SIGNATURES ]; then
            echo 'verifySignatures="'$ARMA3_VERIFY_SIGNATURES'";' >> ${1}
        fi

        if [ -v ARMA3_EQUAL_MOD_REQUIRED ]; then
            echo 'equalModRequired="'$ARMA3_EQUAL_MOD_REQUIRED'";' >> ${1}
        fi

        if [ -v ARMA3_ALLOWED_FILE_PATCHING ]; then
            echo 'allowedFilePatching="'$ARMA3_ALLOWED_FILE_PATCHING'";' >> ${1}
        fi

        if [ -v ARMA3_VOTE_MISSION_PLAYERS ]; then
            echo 'voteMissionPlayers="'$ARMA3_VOTE_MISSION_PLAYERS'";' >> ${1}
        fi

        if [ -v ARMA3_VOTE_THRESHOLD ]; then
            echo 'voteThreshold="'$ARMA3_VOTE_THRESHOLD'";' >> ${1}
        fi

        if [ -v ARMA3_DISABLE_VON ]; then
            echo 'disableVoN="'$ARMA3_DISABLE_VON'";' >> ${1}
        fi

        if [ -v ARMA3_VON_CODEC ]; then
            echo 'vonCodec="'$ARMA3_VON_CODEC'";' >> ${1}
        fi

        if [ -v ARMA3_VON_CODEC_QUALITY ]; then
            echo 'vonCodecQuality="'$ARMA3_VON_CODEC_QUALITY'";' >> ${1}
        fi

        if [ -v ARMA3_PERSISTENT ]; then
            echo 'persistent="'$ARMA3_PERSISTENT'";' >> ${1}
        fi

        if [ -v ARMA3_TIME_STAMP_FORMAT ]; then
            echo 'timeStampFormat="'$ARMA3_TIME_STAMP_FORMAT'";' >> ${1}
        fi

        if [ -v ARMA3_BATTLE_EYE ]; then
            echo 'BattlEye='$ARMA3_BATTLE_EYE';' >> ${1}
        fi

        if [ -v ARMA3_ALLOWED_LOAD_FILE_EXTENSIONS ]; then
            echo 'allowedLoadFileExtensions[]={'$ARMA3_ALLOWED_LOAD_FILE_EXTENSIONS'};' >> ${1}
        fi

        if [ -v ARMA3_ALLOWED_PREPROCESS_FILE_EXTENSIONS ]; then
            echo 'allowedPreprocessFileExtensions[]={'$ARMA3_ALLOWED_PREPROCESS_FILE_EXTENSIONS'};' >> ${1}
        fi

        if [ -v ARMA3_ALLOWED_HTML_LOAD_EXTENSIONS ]; then
            echo 'allowedHTMLLoadExtensions[]={'$ARMA3_ALLOWED_HTML_LOAD_EXTENSIONS'};' >> ${1}
        fi

        if [ -v ARMA3_ALLOWED_VOTE_CMDS ]; then
            echo 'allowedVoteCmds[]={'$ARMA3_ALLOWED_VOTE_CMDS'};' >> ${1}
        fi

        if [ -v ARMA3_ALLOWED_VOTED_ADMIN_CMDS ]; then
            echo 'allowedVotedAdminCmds[]={'$ARMA3_ALLOWED_VOTED_ADMIN_CMDS'};' >> ${1}
        fi

        if [ -v ARMA3_DISCONNECT_TIMEOUT ]; then
            echo 'disconnectTimeout="'$ARMA3_DISCONNECT_TIMEOUT'";' >> ${1}
        fi

        if [ -v ARMA3_ON_USER_CONNECTED ]; then
            echo 'onUserConnected="'$ARMA3_ON_USER_CONNECTED'";' >> ${1}
        fi

        if [ -v ARMA3_ON_USER_DISCONNECTED ]; then
            echo 'onUserDisconnected="'$ARMA3_ON_USER_DISCONNECTED'";' >> ${1}
        fi

        if [ -v ARMA3_DOUBLE_ID_DETECTED ]; then
            echo 'doubleIdDetected="'$ARMA3_DOUBLE_ID_DETECTED'";' >> ${1}
        fi

        if [ -v ARMA3_ON_UNSIGNED_DATA ]; then
            echo 'onUnsignedData="'$ARMA3_ON_UNSIGNED_DATA'";' >> ${1}
        fi

        if [ -v ARMA3_ON_HACKED_DATA ]; then
            echo 'onHackedData="'$ARMA3_ON_HACKED_DATA'";' >> ${1}
        fi

        if [ -v ARMA3_ON_DIFFERENT_DATA ]; then
            echo 'onDifferentData="'$ARMA3_ON_DIFFERENT_DATA'";' >> ${1}
        fi

        if [ -v ARMA3_FORCED_DIFFICULTY ]; then
            echo 'forcedDifficulty = '$ARMA3_FORCED_DIFFICULTY';' >> ${1}
        fi

        if [ -v ARMA3_MISSIONS ]; then
            echo 'class Missions {'$ARMA3_MISSIONS'};' >> ${1}
        fi

        if [ -v ARMA3_MISSIONS_WHITELIST ]; then
            echo 'missionWhitelist[] = {'$ARMA3_MISSIONS_WHITELIST'};' >> ${1}
        fi

        chown steam: ${1}
    fi

    return
}

function create_battleye ()
{
    # Create Battleye configuration file
    if [ ! -f ${1}/beserver.cfg ]; then
        if [ ! -d ${1} ]; then
            mkdir -m 770 -p ${1}
        fi

        chown steam: ${1}

        if [ -v ARMA3_RCON_PORT ]; then
            echo "RConPort $ARMA3_RCON_PORT" > ${1}/beserver.cfg
        fi

        if [ -v ARMA3_RCON_IP ]; then
            echo "RConIP $ARMA3_RCON_IP" >> ${1}/beserver.cfg
        fi

        if [ -v ARMA3_RCON_PASSWORD ]; then
            echo "RConPassword $ARMA3_RCON_PASSWORD" >> ${1}/beserver.cfg
        fi

        if [ -v ARMA3_BATTLEYE_MAX_PING ]; then
            echo "maxPing $ARMA3_BATTLEYE_MAX_PING" >> ${1}/beserver.cfg
        fi

        chown steam: ${1}/beserver.cfg
    fi

    return
}

function create_extdb3 ()
{
    # Create extDB3 configuration file
    if [ -f ${1}/@extDB3/extdb3-conf.ini ]; then
        if [ -v MYSQL_PORT_3306_TCP_ADDR ]; then
            ARMA3_EXTDB3_IP=$MYSQL_PORT_3306_TCP_ADDR
        fi

        if [ -v MYSQL_PORT_3306_TCP_PORT ]; then
            ARMA3_EXTDB3_PORT=$MYSQL_PORT_3306_TCP_PORT
        fi

        if [ -v MYSQL_ENV_MYSQL_USER ]; then
            ARMA3_EXTDB3_USERNAME=$MYSQL_ENV_MYSQL_USER
        fi

        if [ -v MYSQL_ENV_MYSQL_PASSWORD ]; then
            ARMA3_EXTDB_PASSWORD=${MYSQL_ENV_MYSQL_PASSWORD}
        fi

        if [ -v MYSQL_ENV_MYSQL_DATABASE ]; then
            ARMA3_EXTDB_DATABASE=${MYSQL_ENV_MYSQL_DATABASE}
        fi

        if [ -n "${ARMA3_EXTDB3_SECTION}" ]; then
            sed -i -e "s/\[Database\]/\[${ARMA3_EXTDB3_SECTION}\]/" ${1}/@extDB3/extdb3-conf.ini
        fi

        if [ -n "${ARMA3_EXTDB3_IP}" ]; then
            sed -i -e "s/IP = \(.*\)/IP = ${ARMA3_EXTDB3_IP}/" ${1}/@extDB3/extdb3-conf.ini
        fi

        if [ -n "${ARMA3_EXTDB3_PORT}" ]; then
            sed -i -e "s/Port = \(.*\)/Port = ${ARMA3_EXTDB3_PORT}/" ${1}/@extDB3/extdb3-conf.ini
        fi

        if [ -n "${ARMA3_EXTDB3_USERNAME}" ]; then
            sed -i -e "s/Username = \(.*\)/Username = ${ARMA3_EXTDB3_USERNAME}/" ${1}/@extDB3/extdb3-conf.ini
        fi

        if [ -n "${ARMA3_EXTDB3_PASSWORD}" ]; then
            sed -i -e "s/Password = \(.*\)/Password = ${ARMA3_EXTDB3_PASSWORD}/" ${1}/@extDB3/extdb3-conf.ini
        fi

        if [ -n "${ARMA3_EXTDB3_DATABASE}" ]; then
            sed -i -e "s/Database = \(.*\)/Database = ${ARMA3_EXTDB3_DATABASE}/" ${1}/@extDB3/extdb3-conf.ini
        fi
    fi
}

function import ()
{
    # Arma3 Configuration
    create_cfg "${ARMA3_BASIC_CFG}"
    create_config "${ARMA3_SERVER_CFG}"
    create_battleye "${ARMA3_BEPATH}"

    # Arma3 Packages
    if [ -d /etc/docker-entrypoint.d ]; then
        cd ${ARMA3_PATH} > /dev/null
        for ARMA3_PACKAGE in /etc/docker-entrypoint.d/*
        do
            case "$ARMA3_PACKAGE" in
                *.7z)
                    if [ -e "$(which 7zr)" ]; then
                        if [ "${UID}" -eq 0 ]; then
                            su -s /bin/bash steam -c "7zr x -y $ARMA3_PACKAGE > /dev/null"
                        else
                            7zr x -y $ARMA3_PACKAGE > /dev/null
                        fi
                    fi
                    ;;
                *.tar.bz2)
                    if [ -e "$(which tar)" ]; then
                        if [ "${UID}" -eq 0 ]; then
                            su -s /bin/bash steam -c "tar xfj $ARMA3_PACKAGE"
                        else
                            tar xfj $ARMA3_PACKAGE
                        fi
                    fi
                    ;;
                *.tar.gz)
                    if [ -e "$(which tar)" ]; then
                        if [ "${UID}" -eq 0 ]; then
                            su -s /bin/bash steam -c "tar xfz $ARMA3_PACKAGE"
                        else
                            tar xfz $ARMA3_PACKAGE
                        fi
                    fi
                    ;;
                *.tar.xz)
                    if [ -e "$(which tar)" ]; then
                        if [ "${UID}" -eq 0 ]; then
                            su -s /bin/bash steam -c "tar xfJ $ARMA3_PACKAGE"
                        else
                            tar xfJ $ARMA3_PACKAGE
                        fi
                    fi
                    ;;
                *.zip)
                    if [ -e "$(which unzip)" ]; then
                        if [ "${UID}" -eq 0 ]; then
                            su -s /bin/bash steam -c "unzip -o -q $ARMA3_PACKAGE"
                        else
                            unzip -o -q $ARMA3_PACKAGE
                        fi
                    fi
                    ;;
                *) ;;
            esac
        done
    fi

    # Arma3 Database Configuration
    create_extdb3 "${ARMA3_PATH}"

    return
}

function error_handler ()
{
    case "$?" in
        0) CODE="Success" ;;
        5) CODE="Login Failure" ;;
        *) CODE="Error $?" ;;
    esac
    echo "Steam $CODE...ERROR."
    sleep 15
    exec "$0" "install"
}

function print_usage ()
{
cat << EOF
Usage: "$(basename $0)" [Options]... [Command]...

  -h  --help     display this help and exit

      --debug    output debug information
      --version  output version information and exit

Commands:
  arma3server    start arma3server daemon
  import         import compressed achives
  install        install arma3server
  restart        restart arma3server
  start          start arma3server
  stop           stop arma3server

E-mail bug reports to: <developer@wilke.systems>.
EOF
exit
}

function print_version ()
{
cat << EOF

MIT License

Copyright (c) 2017 Wilke.Systems

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

EOF
exit
}

main "$@"

exit
