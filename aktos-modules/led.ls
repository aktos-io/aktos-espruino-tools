export !function Led pin
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
