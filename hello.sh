#!/usr/bin/env bash

__DIR__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $__DIR__/_easycli


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


# /!\ Must be executed after the definition of command functions.
easycli_exec_command "$@"
