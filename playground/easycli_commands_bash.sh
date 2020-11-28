# Much slower than the awk version!

function easycli_commands_bash() {
  easycli_init_commands

  cmd_max_length=0
  for cmd in $(echo -e "$EASYCLI_COMMANDS"); do
    l=${#cmd}
    [ $l -gt $cmd_max_length ] && cmd_max_length=$l
  done

  num_cols=$(tput cols)
  left_pad="  "
  col_pad=" "
  col1_length=$((${#left_pad} + cmd_max_length + ${#col_pad}))
  line_length=0
  prev_word=

  function print_col1() {
    [ -z "$1" ] && echo
    printf "$left_pad"
    if [ -z "$indent" ]; then
      printf "${EASYCLI_COLOR_CMD}%-${cmd_max_length}s\e[0m${col_pad}" "$1"
      line_length=$col1_length
    else
      printf "$indent"
      line_length=$((${#left_pad} + ${#indent}))
    fi
  }
  function update_line_length() {
    line_length=$((line_length + 1 + ${#1}))
  }
  function process_args() {
    case "$1" in
      "@usage" | "@args")
        prefix="${1:1:1}"
        prefix="${prefix^^}${1:2}: "
        output="${EASYCLI_COLOR_HEADING}${prefix}\e[0m${EASYCLI_COLOR_ARG}${2}"
        indent2=$(printf "%-${#prefix}s" "")
        ;;
      "@arg")
        prefix=""
        output="${EASYCLI_COLOR_ARG}${2}\e[0m"
        indent2=$(printf "%-${#2}s" "")
        ;;
      *) return;;
    esac

    [ -z "$indent" ] && [ "$EASYCLI_COMPACT" = 0 ] && echo
    indent="   "
    print_col1
    printf " ${output}"
    line_length=$((line_length + 1 + ${#prefix} + ${#2}))
    indent="${indent}${indent2}"
  }

  echo -e "$EASYCLI_COMMANDS_TABLE" \
  | while read cmd || [[ -n $line ]]; do
    # Not on first line.
    [ "$EASYCLI_COMPACT" = 0 ] && [ -n "$cmd_name" ] && echo

    cmd_name=$(cut -f 1 <<< "$cmd")
    cmd_doc=$(cut -f 2 <<< "$cmd")
    indent=""
    indent2=""

    print_col1 "$cmd_name"
    for word in $cmd_doc; do
      if [ "${word:0:1}" = "@" ]; then
        tag="$word"
        continue
      fi
      if [ -n "$tag" ]; then
        process_args "$tag" "$word"
        tag=
        continue
      fi
      update_line_length "$word"
      if [ $line_length -gt $num_cols ]; then
        print_col1
        update_line_length "$word"
      fi
      printf " $word"
    done
    echo -e "\e[0m"
  done
}
