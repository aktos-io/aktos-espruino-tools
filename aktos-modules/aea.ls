# lib functions
export sleep = (ms, func) !-> set-timeout func, ms
export after = sleep

export pack = (x) ->
    JSON.stringify x

export unpack = (wire-data) ->
    x = JSON.parse wire-data
    throw if x is void
    return x

export repl =
    detach: !->
        console.log "Disabling REPL console!"
        # access it via LoopbackB
        LoopbackA.set-console!

    attach: !->
        ser.set-console!
        console.log "REPL console enabled!"


get-file = ->
    f = new (require "FlashEEPROM")(0x076000)
    f.endAddr = f.addr+1024
    return f

config-file = null
config-init = !->
    if config-file is null
        config-file := get-file!

export config =
    write: (file-no, data) !->
        config-init!
        config-file.write file-no, pack data

    read: (file-no) ->
        config-init!
        data = config-file.read file-no
        data = E.to-string data
        try
            unpack data
        catch
            config.write file-no, pack {}
            return {}

export !function Led pin
    self = this
    @pin = pin
    pin-mode @pin, \output
    @mode = \turn-off
    @on-time = 1000ms
    @off-time = 1000ms

    @write = (val) ->
        digital-write @pin, val

    @base-blink = ->
        if self.mode isnt \blink
            self.mode = \blink
            <- :lo(op) ->
                self.write on if self.mode is \blink
                <- sleep self.on-time
                self.write off if self.mode is \blink
                <- sleep self.off-time
                return lo(op) if self.mode is \blink
                return op!
        console.log "blink ended..."

    @blink = ->
        @on-time = 1000ms
        @off-time = 1000ms
        @base-blink!

    @att-blink = ->
        @on-time = 300ms
        @off-time = 300ms
        @base-blink!

    @info-blink = ->
        # aircraft blink
        @on-time = 80ms
        @off-time = 2000ms
        @base-blink!

    @turn-off = ->
        @mode = \turn-off
        @write off

    @turn-on = ->
        self.mode = \turn-on
        self.write on

    @turn = (s) ->
        self.mode = \digital
        self.write s

    @wink = ->
        self.mode = \wink
        self.write on
        <- sleep 50ms
        self.write off


