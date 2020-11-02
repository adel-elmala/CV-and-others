# Text adventure game

When the engine starts, the interface prompts for the name of an adventure file to play (e.g "ho_plaza.json"),

Before prompting for a command, the interface always prints the description of the room in which the player is currently located. 

If the player attempts to move illegally (that is, to an exit that does not exist in the current room), then the interface displays an error message of your choice, then prompts for a new command.

If the player issues the quit command, the interface will just Quit :D


# How to play 
1. Run 

```sh 
    make play
```

2. Will launch the game in the Terminal 
3. Enter a Valid Adventure JSON file (e.g ho_plaza.json)
4. There are only 2 option Commands and The General Format is `<verb> <object>`
    - `go`: The player moves from one room to another by with the verb “go” followed by the name of an exit. (e.g `go clock tower`)
    - `quit`: The player exits the game engine with this verb, which takes no object.
5. Available Adventure Files are 
   1. ho_plaza.json
   2. lonely_room.json
   3. wrong.json (which is an INVALID FILE Format to domenstrate the point) 