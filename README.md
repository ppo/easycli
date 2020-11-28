# Easy CLI

Helper to easily create multi-commands shell scripts.

**Features:**
- Simply write functions and add docstring comments.
- Handling of commands execution.
- Generation of a usage screen with commands description.
- Self-contained code (no dependencies, no install).


## Quickstart

Check the content of [`demo.sh`](demo.sh) for examples of everything.

**Hello World:** `hello.sh`
```bash
#!/usr/bin/env bash
__DIR__="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $__DIR__/_easycli

## The famous "hello world" example.
## With a very long command description spreading on multiple lines.
## And with some lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet nunc
## vitae neque eleifend vehicula nec vitae tortor.
##
## @usage [name]
## @arg name Optional.: Your name. Default: "world".
function hello__world() {
    name=${1-world}
    echo "Hello $name"
}

# /!\ Must be executed after the definition of command functions.
easycli_exec_command "$@"
```

**Executing `hello.sh` displays:** (on a 80-column terminal)
```bash
USAGE: demo.sh COMMAND [ARGS]...

COMMANDS:

  hello:world  The famous "hello world" example. With a very long command
               description spreading on multiple lines. And with some lorem
               ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit
               amet nunc vitae neque eleifend vehicula nec vitae tortor.

      Usage: [name]
      name: Your name. Default: "world".
```


## Conventions

### Command Functions

- Must be defined as `function command_name()`.
- `function` must start at the beginning of the line.
- Its name must match the command name.
- For command names like `group:action`, the function must be named `group__action` (i.e. replacing
  `:` with `__`).


### Command Doc

- Must start with `## ` (two # and a space).
- `## ` must start at the beginning of the line.
- Must be defined immediately above the command function.
- Can be defined on multiple lines, all starting with `## `.


### Command Doc Tags

**Short version:**  
`@args STRING`: A short list of available args without description.

Example: `## @args COMMAND [--force]`  
Output: `Args: COMMAND [--force]`

**Full version:**  
`@usage STRING`: Define the general usage of the command usage.
`@arg STRING`: Define a command argument.

Example:
```
## @usage [type] [--raw]
## @arg type: Optional. Define the type of items to display. Values: `files` (default),
##   `directories`.
## @arg --raw: Optional. List items without formatting.
```

Output:
```
Usage: [mode] [--raw]
type: Optional. Define the type of items to be displayed. Values: `files`
      (default) `directories`.
--raw: Optional. List items without formatting.
```


## Settings

- `EASYCLI_TARGET`: Path to your script, to be able to parse it. Default: `$0`.
- `EASYCLI_COMPACT`: Whether to display in compact mode. Default: `0` (false). Set it to `1` to
  active compact mode.
- `EASYCLI_USAGE_ARGS`: Text to display in the main `USAGE:` line. Default: `COMMAND [ARGS]...`.
- `EASYCLI_COLOR_ARG`: The color for argument names. Default: `\e[32m` (green).
- `EASYCLI_COLOR_CMD`: The color for command names. Default: `\e[36m` (cyan).
- `EASYCLI_COLOR_ERROR`: The color for errors. Default: `\e[31m` (red).
- `EASYCLI_COLOR_HEADING`: The color for headings. Default: `\e[1;37m` (white bold).
- `EASYCLI_COLOR_RESET`: The code to reset colors. Default: `\e[0m`.

**Remark:** To disable color output, you can set all `EASYCLI_COLOR_*` to an empty string.


## Sed command explained

This command generates a 2-column list of command names with their description.

```bash
sed -E -n \
  -e "/^## / \                        # Find command doc lines.
      { \                             # Group multiple commands.
      h; \                            # Copy pattern space to hold space.
      s/.*//; \                       # Purge line.
      :loop" \                        # Start a loop, labeled `loop`.
  -e "H; \                            # Append pattern space to hold space.
      n; \                            # Print pattern space.
      s/^##( |$)//; \                 # Strip command doc prefix (allowing
                                      # empty ones).
      t loop" \                       # Go to label `loop` (only if previous
                                      # substitute command succeeded).
  -e "s/^function ([^\(]+).*$/\1/; \  # Keep only the function name.
      s/^command_//; \                # Strip function name prefix.
      s/__/:/; \                      # Convert function name into command
                                      # name (i.e. replace `__` with `:`).
      G; \                            # Append hold space to pattern space.
      s/\\n## /\\\t/; \               # Add `\t` as column delimiter.
      s/\\n/ /g; \                    # Remove new lines (i.e merge lines).
      p; \                            # Print the resulting line.
      }" \                            # End of commands grouping.
  "$EASYCLI_TARGET" \                 # Path to the script file.
| LC_ALL=C \                          # Force sorting to be byte-wise.
  sort -f                             # Sort lines (ignoring case).
```

**sed options:**
- `-E`: Interpret regular expressions as extended (modern) regular expressions rather than basic
  regular expressions (BRE's).
- `-n`: By default, each line of input is echoed to the standard output after all of the commands
  have been applied to it.  This suppresses this behavior.
- `-e COMMAND`: Append the editing commands specified by `COMMAND` to the list of commands.

**Remark:** Multiple expressions (`-e`) are necessary because labels/loops cannot be delimited by
semicolon.


## Credits

Inspired by:

- [François Zaninotto](https://github.com/fzaninotto)'s
  [Self-Documented Makefile](http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
- [Konrad Rudolph](https://gist.github.com/klmr)'s
  [Gist](https://gist.github.com/klmr/575726c7e05d8780505a)


## License

Licensed under the [MIT License](LICENSE).
