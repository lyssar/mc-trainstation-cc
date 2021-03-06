<p align="center">
    <img src="logo.svg" width="25%">
</p>

# Minecraft CC - Trainstation
![stability-wip](https://img.shields.io/badge/stability-work_in_progress-lightgrey.svg)
[![get-cc-tweaked](http://cf.way2muchnoise.eu/title/282001_Get_Today!.svg)](https://minecraft.curseforge.com/projects/282001)
[![available-for](http://cf.way2muchnoise.eu/versions/282001_latest.svg)](https://www.minecraft.net/)

## Description

This repository contains a set of server/client logic written in lua to handle switches on selecting a station from a touchscreen Monitor with Computer Craft Tweaked in Minecraft.

## Usage

### Installing

Run the installer via the `pastebin` command:
    
`pastebin run PL6H7aqe lystrain` 

### Folder structure
```
lystrain                # Root directory.
 ┣ client/              # Client logic
 ┣ modem/               # Wireless modem logic
 ┣ monitor/             # Touchscreen logic
 ┣ server/              # Server logic
 ┣ .craftos.sh          # Script for craftof-pc local developing
 ┣ .env.dist            # ENV for local development
 ┣ _*                   # General gelper files
 ┣ client.lua           # Actual client
 ┣ config.lua           # Application config
 ┣ installer.lua        # Installer, which is hosted on gist.github.com
 ┣ pastebin.lua         # Pastebin wrapper for easier usage in minecraft
 ┗ server.lua           # Actual server
```

### Setup you stations

Edit the *config.lua* file to set configuration data:

```lua
config = {
    -- Can be anything of ["off", "error", "notice", "info", "debug", "all"]
    LOG_LEVEL="error",
    -- List of available stations
    stations = {
        {
            -- Internal name
            name="",
            -- Dispatched event, no spaces
            dispatcher="",
            -- Displayed label (required for server)
            station_label=""
            -- Switch position on|off (required for clients)
            switch_state=true
        }
    }
}
```

This file needs to be on every client and server. Make sure to change "switch_state" accordingly to the needed switch position.

### Contributing

To contirbute you need to install [CraftOS PC](https://www.craftos-pc.cc/) and checkout the repository.
Before starting copy `.env.dist` to `.env` and change 

    CRAFT_OS to the craftos executable
    MOUNT to the checked out repository

After that execute `./.craftos.sh` and boot every needed monitor with `lystrain/_local.lua`

...happy contributing :)