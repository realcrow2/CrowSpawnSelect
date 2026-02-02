# Crow Spawn Select

A FiveM spawn selector resource for vMenu standalone servers. This resource displays a beautiful interactive map when players first join the server, allowing them to choose their spawn location.

## Features

- Interactive map with clickable spawn locations
- 18 pre-configured spawn locations across Los Santos
- Beautiful UI with day/night mode
- Smooth camera transitions
- Click to spawn functionality
- List view of all spawn locations

## Installation

1. Place the `crow_spawnselect` folder in your `resources` directory
2. Add `ensure crow_spawnselect` to your `server.cfg`
3. Restart your server

## Configuration

Edit `configs/config.lua` to customize:
- Spawn locations and coordinates
- Framework settings (set to 'none' for standalone)
- Notification types
- Day/night hours

## Spawn Locations

The resource includes 18 spawn locations:
- The Kortz Center
- Maze Bank Arena
- Sandy Shores Sheriff's Station
- Bolingbroke Penitentiary
- Luxury Autos
- Vinewood Motel
- Mission Row Police Department
- Paleto Bay Troopers Office
- Paleto Garage
- Grapeseed Store
- Airport - LSIA
- Del Perro Pier
- Eastern Motel
- Stab City
- Sandy Shores Airport
- Vinewood Casino
- Grove Street Garage
- Mirror Park Garage

## How It Works

1. When a player joins the server, the spawn selector UI automatically appears
2. Players can click on spawn locations on the map or select from the list
3. Clicking "Spawn" teleports the player to the selected location
4. The UI closes automatically after spawning

## Requirements

- FiveM Server
- No framework required (works with standalone/vMenu)

## Notes

- The resource is configured for standalone/vMenu servers by default
- All spawn coordinates match the original HTML map data
- The UI will appear automatically when players join

