#!/usr/bin/env bash

# EASYCLI_TARGET="${BASH_SOURCE[0]}"
# EASYCLI_COMPACT=1
# EASYCLI_USAGE_ARGS="ACTION [--foo] [--bar]"
# EASYCLI_COLOR_ARG="\e[32m"
# EASYCLI_COLOR_CMD="\e[36m"
# EASYCLI_COLOR_ERROR="\e[31m"
# EASYCLI_COLOR_HEADING="\e[1;37m"
# EASYCLI_COLOR_RESET="\e[0m"


__DIR__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $__DIR__/_easycli


## Description of the `foo` command that can be very long and therefore
## defined on multiple lines.
## All the command doc lines will be merged into a single one.
## Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet nunc vitae neque
## eleifend vehicula nec vitae tortor. Pellentesque ligula elit, auctor vitae sodales eu,
## ullamcorper eu urna.
function foo() {
  echo "Output of the 'foo' function."
}


## Command names can be like `foo:bar` with an associated `foo__bar` function.
function foo__bar() {
  echo "Output of the 'foo__bar' function."
}


## Command functions can be prefixed with `command_`, for example if its a reserved word.
## @args COMMAND [--force]
function command_exec() {
  echo "Output of the 'command_exec' function."
}


## The famous "hello world" example.
## With a very long command description spreading on multiple lines.
## And with some lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet nunc
## vitae neque eleifend vehicula nec vitae tortor.
##
## @usage [name]
## @arg name: Optional. Your name. Default: "world".
function hello__world() {
  name=${1-world}
  echo "Hello $name"
}


## Gloups eats many args.
## Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet nunc vitae neque
## eleifend vehicula nec vitae tortor. Pellentesque ligula elit, auctor vitae sodales eu,
## ullamcorper eu urna. Quisque congue posuere dictum. Etiam dapibus malesuada auctor. Suspendisse
## potenti. Integer euismod, nisi at dignissim euismod, dui magna tristique arcu, non dictum augue
## eros eu arcu.
##
## @usage [alpha] [beta] [gamma]
## @arg alpha: Optional. Pellentesque quis eros id lacus aliquam feugiat in id libero. Integer
##   sollicitudin ipsum quis rhoncus facilisis. Integer blandit ante ut magna tincidunt, et auctor
##   erat ultrices. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac
##   turpis egestas.
## @arg beta: Optional. Fusce porttitor magna in sapien malesuada dapibus. Proin dignissim viverra
##   diam ut tristique. Suspendisse sagittis facilisis sapien, lobortis pharetra nunc pharetra quis.
##   Praesent facilisis bibendum lorem non ornare.
## @arg gamma: Optional. Aenean pellentesque non risus eget laoreet. Default: `sollicitudin`.
function gloups() {
  echo "Gloups $1 $2 $3"
}


function this_is_not_a_command() {
  echo "This function is not detected as available command."
}


## Show the commands table.
function command_commands() {
  easycli_display_commands
}


## Show the different outputs available.
function outputs() {
  echo "--- REGULAR USAGE ------------------------------------------"
  EASYCLI_USAGE_ARGS=
  easycli_display_usage
  echo "--- /REGULAR USAGE -----------------------------------------"
  echo
  echo "--- USAGE WITH CUSTOM USAGE ARGS ---------------------------"
  EASYCLI_USAGE_ARGS="ACTION [--foo] [--bar]"
  easycli_display_usage
  echo "--- /USAGE WITH CUSTOM USAGE ARGS --------------------------"
  echo
  echo "--- COMMANDS TABLE -----------------------------------------"
  easycli_display_commands
  echo "--- /COMMANDS TABLE ----------------------------------------"
}


# /!\ Must be executed after the definition of command functions.
easycli_exec_command "$@"
