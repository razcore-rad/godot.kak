# godot.kak

Prototype and develop [Godot](//godotengine.org) projects from [Kakoune](//kakoune.org).

With this plugin we can run Godot scene files (`*.tscn`) directly from Kakoune.

## Example Configuration

```kak
# Change the `godot_executable` option with a custom path or name
# Default: godot
set-option global godot_executable "$HOME/.steam/steam/steamapps/common/Godot Engine/godot.x11.opt.tools.64"

# Change the arguments passed to the Godot executable
# Default: --debug
set-option global godot_arguments "--debug" "--profiling"

# Mapping the commands for easy access
map -docstring "run a Godot scene file from the completion list" global user g ": godot "
map -docstring "try runing a Godot scene file based on the current buffer file name" global user G ": godot-current<ret>"

# We can also pass extra arguments to the `:godot` command. They come after the scene file path.
:godot ./dbg.tscn --debug-collisions
```

## Example Workflow

https://user-images.githubusercontent.com/1177508/180198888-d77418f7-ed52-49a2-a10b-82e13c786af4.mp4

## Documentation

For a look at what this plugin has to offer check out [its documentation](godot.kak.asciidoc).

