# Dockerfile for Garry's Mod server
FROM debian

# Install deps
RUN apt update && apt install wget lib32gcc1 -y

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup steam && adduser -q --no-create-home --disabled-password --ingroup steam steam 

RUN mkdir /srv/steam && chown -R steam:steam /srv/steam

# create directory
RUN cd /srv/steam && su steam && mkdir content gmodds Steam content/css && cd Steam

# Get Steam cmd launcher
RUN su steam && cd /srv/steam/Steam && wget http://media.steampowered.com/client/steamcmd_linux.tar.gz && tar -xvzf steamcmd_linux.tar.gz

RUN su steam && chown -R steam:steam /srv/steam && chmod a+x /srv/steam/Steam/steamcmd.sh

# Update steam
RUN cd /srv/steam/Steam && su -c '/srv/steam/Steam/steamcmd.sh +login anonymous +quit' steam

# Download Garry's mod
RUN cd /srv/steam/Steam && su -c '/srv/steam/Steam/steamcmd.sh +login anonymous +force_install_dir "/srv/steam/gmodds" +app_update 4020 validate +quit' steam

# Donwload Counter Strike Source files
RUN su steam && cd /srv/steam/Steam && /srv/steam/Steam/steamcmd.sh +force_install_dir "/srv/steam/content/css" +login anonymous +app_update 232330 +quit

# Add mount config so GMod can find CSS files
RUN su steam && printf '"mountcfg"\n{\n"cstrike" "/srv/steam/content/css/cstrike"\n}\n' > /srv/steam/gmodds/garrysmod/cfg/mount.cfg

VOLUME /srv/steam/gmodds/garrysmod/cfg

RUN dpkg --add-architecture i386 && apt-get update

RUN apt-get install libc6:i386 libstdc++6:i386 -y

ADD run.sh /usr/bin/run.sh

RUN chmod a+x /usr/bin/run.sh

# Entrypoint
ENTRYPOINT ["run.sh"]
CMD ["-console -game garrysmod +maxplayers 16 +map gm_construct +gamemode terrortown"]
