# Fidget
A cross platform tool to prevent your computer from sleeping.


## Overview

Do you really dig `caffeinate` on OS X and wish that you could use it on
Windows? Are you building something that supports multiple platforms and
need the display to stay on without much fuss? Does the phrase "[Yes.
`gnome-screensaver` has a simple to use DBus API for this](https://wiki.gnome.org/Projects/GnomeScreensaver/FrequentlyAskedQuestions#I.27m_developing_an_application_that_has_a_fullscreen_mode.__Is_there_a_way_that_I_can_disable_the_screensaver.3F)"
make you irrationally angry?

If so, this might be the tool for you. Fidget provides both a commandline
tool and a library to simply and easily inhibit sleep on all major platforms.


## Usage

    $ fidget [-o <options>] [command]

Options should be passed as a comma-separated list.  Sleep options may very
between platforms. Each platform will include at least the following core
options:

  * `display` will prevent the display from sleeping.
  * `sleep` prevent the system from sleeping.
  * `all` to declare all known options.

Additional OS X options:

  * `idle` will prevent the system from idle sleeping.
  * `disk` will prevent the disk from sleeping.
  * 'user' will assert that the user is active. This keeps the display
           on and prevents idle sleep.

Additional Windows options:

  * `away` enables a low-power, but not sleeping, mode on Windows.
  * `simulate` will simulate a user keyboard action every few seconds.

Additional Linux options:

  * `blanking` disables terminal blanking on Linux.

Default options for each platform:
  * OS X: `user`
  * Linux: `display`
  * Windows: `display`,`sleep`

If you pass a command, then Fidget will execute that command and prevent the
system from sleeping until that command terminates. If you do not provide a
command, then Fidget will prevent sleeping until you press Ctrl-C to terminate.

### Examples

Simply keep the computer from sleeping until you press Ctrl-C

    $ fidget
    System has been prevented from sleeping.
    - Press Ctrl-C to resume normal power management.

Pass options and run a command

    $ fidget -o sleep,idle make


## Installation

    $ gem install fidget


## Library Usage

There are three methods you may use in your programs. The `options` parameter
should be either an array or just a list of options and can be passed as strings
or symbols.

* `Fidget.prevent_sleep(options)`
    * Stops the computer from sleeping.
    * Can accept a block, in which case sleep will be inhibited during the execution
    of the block and resumed after.
* `Fidget.allow_sleep`
    * Resume any previously inhibited sleep.
* `Fidget.current_process(options)`
    * Shortcut method to inhibit sleep during the execution of the current process.

### Examples

Default options, with a block:

    #! /usr/bin/env ruby
    require 'fidget'

    Fidget.prevent_sleep do
      100.times do
        print '.'
        sleep 1
      end
    end

Define sleep options to inhibit, with a block:

    #! /usr/bin/env ruby
    require 'fidget'

    Fidget.prevent_sleep(:display, :sleep) do
      100.times do
        print '.'
        sleep 1
      end
    end

No block, just calling methods:

    #! /usr/bin/env ruby
    require 'fidget'

    Fidget.prevent_sleep(:display, :sleep)

    100.times do
      print '.'
      sleep 1
    end

    Fidget.allow_sleep

Simply prevent the computer from sleeping while the current process is running:

    #! /usr/bin/env ruby
    require 'fidget'

    Fidget.current_process

    100.times do
      print '.'
      sleep 1
    end


## Limitations

This is super early in development and has not yet been battle tested. If you
discover a platform it doesn't work on, or a use case that it should cover,
please do [file an issue](https://github.com/binford2k/fidget/issues)


## Disclaimer

I take no liability for the use of this tool.

Contact
-------

binford2k@gmail.com

