# OctoPrint

## Setup

- OctoPrint
  - https://octoprint.org/download/
  - flash to SD card with Balena Etcher
  - no WiFi setup, using ethernet
- Ender3 Pro
  - `form factor: rectangular`
  - `origin: lower left`
  - `heated bed: yes`
  - `heated chamber: no`
  - `dimensions: 220 x 220 x 250mm`
  - `nozzle diameter: 0.4mm`
  - `number of extruders: 1`
  - `serial port: /dev/ttyUSB0`
  - `baud rate: AUTO`

Plugin needed to fix SD card issue:

```python
# https://gist.github.com/foosel/9ca02e8a3ea0cb748f4b220981eab12d/raw/convert_TF_SD.py

# coding=utf-8
from __future__ import absolute_import

def convert_TF_SD(comm, line, *args, **kwargs):
    if "TF" not in line:
        return line
    return line.replace("TF","SD")

__plugin_name__ = "Convert TF to SD"
__plugin_version__ = "1.0.2"
__plugin_author__ = "@b-morgan"
__plugin_description__ = "Convert TF to SD in printer responses"
__plugin_pythoncompat__ = ">=2.7,<4"
__plugin_hooks__ = {
    "octoprint.comm.protocol.gcode.received": (convert_TF_SD, 1)
}
```

## Powering Pi from Ender3 PSU

- Install plugins
  - https://github.com/kantlivelong/OctoPrint-PSUControl/archive/master.zip
  - https://github.com/kantlivelong/OctoPrint-PSUControl-RPiGPIO/archive/master.zip
- PSU Control config
  - `GPIO Mode: BOARD`
  - `GPIO Pin: 16`
- USB from Ender3 to Pi - Cover power pins with electrical tape
- TODO: block diagram of relay, Pi, buck converter


## Test Prints

- [Benchy](https://www.thingiverse.com/thing:763622)
- [Bed Level Helpers](https://www.thingiverse.com/thing:3235018)
