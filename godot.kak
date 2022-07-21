# Author: Răzvan Cosmin Rădulescu (razcore-rad)
# Run Godot scene files for Kakoune.
# https://github.com/razcore-rad/godot.kak

declare-option \
  -docstring "name or path of Godot executable" \
  str godot_executable "godot"

declare-option \
  -docstring "arguments passed to the Godot executable" \
  str-list godot_arguments "--debug"


define-command \
  -docstring "run a Godot scene file from the completion list" \
  -params 1 \
  godot %{ evaluate-commands %sh{
    fifo=$(mktemp --directory --tmpdir godot.kak.XXXXXXXX)/fifo
    mkfifo $fifo
    ( "$(echo "$kak_opt_godot_executable" | envsubst)" $kak_opt_godot_arguments "$1" > $fifo 2>&1 ) < /dev/null > /dev/null 2>&1 &
    godot_pid=$!
    printf "%s\n" "edit! -fifo $fifo -scroll *godot*
                   info -title 'godot.kak' 'Running \`$(basename "$kak_opt_godot_executable") $kak_opt_godot_arguments ''$1''\`...'
                   hook buffer BufCloseFifo .* %{ nop %sh{
                     kill $godot_pid > /dev/null 2>&1
                     rm -r $(dirname $fifo)
                   } }"
  } }

complete-command -menu godot shell-script-candidates %{
  case "$kak_token_to_complete" in
    0) find -type f -regex ".*.tscn";;
  esac
}


define-command \
  -docstring "try runing a Godot scene file based on the current buffer file name" \
  -params 0 \
  godot-current %{ evaluate-commands %sh{
    godot_scene=$(realpath --relative-to=$(pwd) "${kak_buffile%.*}.tscn")
    [ -e "$godot_scene" ] && printf "godot '$godot_scene'" || printf "info -title 'godot.kak' '\`$godot_scene\` scene file doesn''t exist. Skipping...'"
  } }
