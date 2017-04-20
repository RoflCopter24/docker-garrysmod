#!/bin/bash

su -c "/srv/steam/gmodds/srcds_run -console -game garrysmod +maxplayers ${MAX_PLAYERS} +map ${START_MAP} +gamemode ${GAME_MODE}" steam
