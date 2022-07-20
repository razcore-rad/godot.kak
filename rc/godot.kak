declare-option \
  -docstring "Name or path of Godot executable." \
  str godot_executable "godot"

declare-option \
  -docstring "Arguments passed to the Godot executable." \
  str-list godot_arguments "--debug"

define-command \
  -docstring "Run Godot scene." \
  -params 1 \
  godot %{ evaluate-commands %sh{
      fifo=$(mktemp --directory --tmpdir godot.kak.XXXXXXXX)/fifo
      mkfifo $fifo
      ( $(echo $kak_opt_godot_executable | envsubst) $kak_opt_godot_arguments "$1" > $fifo 2>&1 ) < /dev/null > /dev/null 2>&1 &
      godot_pid=$!
      infomsg="Running Godot with $([ -n \"$kak_opt_godot_arguments\" ] && printf -- $kak_opt_godot_arguments || printf no) arguments..."
      printf %s\\n "edit! -fifo $fifo -scroll *godot*
                    info -title godot '$infomsg'
                    hook buffer BufCloseFifo .* %{ nop %sh{
                      kill $godot_pid > /dev/null 2>&1
                      rm -r $(dirname $fifo)
                    } }"
    }
  }

complete-command -menu godot shell-script-candidates %{
  case "$kak_token_to_complete" in
    0) find -type f -regex '.*.tscn';;
  esac
}
