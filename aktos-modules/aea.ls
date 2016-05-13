# lib functions
export sleep = (ms, func) !-> set-timeout func, ms
export after = sleep

export pack = (x) ->
    JSON.stringify x

export unpack = (wire-data) ->
    try
        x = JSON.parse wire-data
        throw if x is void
        return x
    catch
        console.log "Error on unpacking: ", e
        console.log "wire data: ", wire-data
        throw "Error on unpacking"

export repl =
    detach: !->
        console.log "Disabling REPL console!"
        # access it via LoopbackB
        LoopbackA.set-console!

    attach: !->
        ser.set-console!
        console.log "REPL console enabled!"



!function Config file-no
    self = this
    @file-no = file-no
    Config.f = new (require "FlashEEPROM")(0x076000)
    Config.f.endAddr = Config.f.addr + 1024
    @write-count = 0
    @periodic-sync!

Config::flush = !->
    console.log "flushing to eeprom..."
    @write @ram

Config::periodic-sync = !->
    self = this
    <- :lo(op) ->
        <- sleep 3600*1000ms
        self.flush!
        lo(op)

Config::write = (data) !->
    if @write-count++ > 10
        Config.f.cleanup!
        @write-count = 0
    Config.f.write @file-no, pack data
    @ram = data

Config::read = ->
    try
        data = E.to-string Config.f.read @file-no
        @ram = unpack data
        @ram
    catch
        console.log "ERROR CONFIG READ(#{@file-no}): #{e}, raw: #{data}"



!function Led pin
    @pin = pin
    pin-mode @pin, \output
    @mode = \turn-off
    @on-time = 1000ms
    @off-time = 1000ms


Led::turn = (val) ->
    @mode = if val then \on else \off
    digital-write @pin, val

Led::base-blink = ->
    self = this
    if @mode isnt \blink
        @mode = \blink
        <- :lo(op) ->
            digital-write self.pin, on if self.mode is \blink
            <- sleep self.on-time
            digital-write self.pin, off if self.mode is \blink
            <- sleep self.off-time
            return lo(op) if self.mode is \blink
            return op!
        console.log "blink ended, mode: ", self.mode

Led::blink = ->
    @on-time = 1000ms
    @off-time = 1000ms
    @base-blink!

Led::att-blink = ->
    @on-time = 300ms
    @off-time = 300ms
    @base-blink!

Led::info-blink = ->
    # aircraft blink
    @on-time = 80ms
    @off-time = 2000ms
    @base-blink!

Led::wink = ->
    self = this
    self.mode = \wink
    self.turn on
    <- sleep 50ms
    self.turn off




# https://github.com/ceremcem/merge-ls
export function merge (obj1, ...sources)
  for obj2 in sources
    for p of obj2
      try
        throw unless obj2[p] instanceof Object
        obj1[p] = obj1[p] `merge` obj2[p]
      catch
        if obj2[p] isnt void
            obj1[p] = obj2[p]
        else
            delete obj1[p]
  obj1


# Exports
export Config
export Led
