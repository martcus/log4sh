# log4.sh [![Shellcheck](https://github.com/martcus/log4sh/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/martcus/log4sh/actions/workflows/shellcheck.yml)

**log4.sh** is a lightweight and easy-to-use logging framework for Bash scripts. It provides a simple and flexible way to add logging to your shell scripts, making them easier to debug and maintain.

## Features

*   **Multiple Log Levels:** Supports `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, and `TRACE` log levels.
*   **Simple Inclusion:** Easily include `log4.sh` in your scripts with a single `source` command.
*   **Runtime Configuration:** Change the log level and time format at runtime.
*   **File Logging:** Redirect log output to a file.
*   **Pipe Support:** Pipe output from other commands directly to the logger.

## Installation

There are two main ways to use `log4.sh` in your projects:

### 1. Sourcing the Script

The most common method is to source the `log4.sh` script directly in your Bash script. This will load all the logging functions into your current shell session.

```bash
source /path/to/log4.sh [OPTIONS]
```

**Example:**

```bash
#!/usr/bin/env bash

# Source log4.sh from the same directory
source ./script/log4.sh -v INFO

INFO "This is an informational message."
WARN "This is a warning."
```

### 2. Adding to Your PATH

For easier access, you can add the `script` directory to your `PATH` environment variable. This allows you to call `log4.sh` from anywhere on your system.

Add the following line to your `.bashrc` or `.zshrc` file:

```bash
export PATH=$PATH:/path/to/log4sh/script
```

## Usage

`log4.sh` provides a set of simple functions for logging messages at different levels.

### Log Levels

*   `FATAL`: For severe errors that will cause the script to exit.
*   `ERROR`: For errors that might not be fatal but should be addressed.
*   `WARN`: For potential issues or warnings.
*   `INFO`: For general informational messages.
*   `DEBUG`: For detailed debugging information.
*   `TRACE`: For the most granular level of logging.

### Examples

Here's how to use the logging functions in your scripts:

```bash
#!/usr/bin/env bash

source ./script/log4.sh -v TRACE

INFO "Starting the script."
DEBUG "This is a debug message."
WARN "Something looks a bit off."
ERROR "An error occurred!"
FATAL "A fatal error occurred. Exiting."
```

### Piping Output

You can pipe the output of other commands directly to the logging functions:

```bash
# Log the output of the 'ls' command
ls -l | INFO "Directory listing:"

# Log a message from 'echo'
echo "Hello, World!" | WARN
```

## Configuration

`log4.sh` can be configured both when sourcing the script and at runtime.

### Command-Line Options

You can pass the following options when sourcing `log4.sh`:

*   `-v, --verbosity [LEVEL]`: Sets the initial log level.
    *   **Levels:** `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`, `OFF`
*   `-d, --dateformat [FORMAT]`: Sets the time format for log messages. (e.g., `"+%Y-%m-%d %H:%M:%S"`)
*   `-f, --file [FILE]`: Redirects all log output to the specified file.

**Example:**

```bash
# Set the log level to DEBUG, use a custom time format, and log to a file
source ./script/log4.sh -v DEBUG -d "+%T" -f /var/log/myscript.log
```

### Runtime Configuration

You can also change the configuration at any point in your script using the following functions:

*   `SET_LEVEL [LEVEL]`: Changes the current log level.
*   `SET_TIME_FORMAT [FORMAT]`: Changes the time format for subsequent log messages.

**Example:**

```bash
#!/usr/bin/env bash

source ./script/log4.sh -v INFO

INFO "The script is running in INFO mode."

# Switch to DEBUG mode
SET_LEVEL DEBUG
DEBUG "Now we're in DEBUG mode."

# Change the time format
SET_TIME_FORMAT "+%H:%M:%S"
INFO "The time format has been changed."
```

## Included Files

*   `script/log4.sh`: The core logging script.
*   `script/template4.sh`: A basic template for creating new Bash scripts with `log4.sh`.
*   `test/test.sh`: A script for testing the functionality of `log4.sh`.

## Contributing

Contributions are welcome! If you find a bug or have an idea for a new feature, please open an issue or submit a pull request.

## License

`log4.sh` is licensed under the [GNU General Public License v3.0](LICENSE).
