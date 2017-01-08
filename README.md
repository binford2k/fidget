# Fidget
A cross platform tool to prevent your computer from sleeping.

## Overview

Usage : `fidget [-o <options>] [command]`

Sleep options may very between platforms. Each platform will include at least
the following core options:

  * `display` will prevent the display from sleeping.
  * `sleep` prevent the system from sleeping.
  * `all` to declare all known options.

Additional OS X options:

  * `idle` will prevent the system from idle sleeping.
  * `disk` will prevent the disk from sleeping.

Additional Windows options:

  * `away` enables a low-power, but not sleeping, mode on Windows.

Additional Linux options:

  * `blanking` disables terminal blanking on Linux.

If you pass the a command, then Fidget will execute that command and prevent
the system from sleeping until that command terminates. If you do not provide a
command, then Fidget will prevent sleeping until you press Ctrl-C to terminate.

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

### Example usages:

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

This is super early in development and has not yet been battle tested.

## Disclaimer

I take no liability for the use of this tool.

Contact
-------

binford2k@gmail.com

