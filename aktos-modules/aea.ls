# lib functions
export sleep = (ms, func) !-> set-timeout func, ms
export after = sleep
export looop = (ms, f) -> set-interval f, ms

export pack = (x) ->
    JSON.stringify x

export unpack = (wire-data) ->
    JSON.parse wire-data

export repl =
    detach: !->
        console.log "Disabling REPL console!"
        # access it via LoopbackB
        LoopbackA.set-console!

    attach: !->
        ser.set-console!
        console.log "REPL console enabled!"

export function merge obj1, obj2
    for p of obj2
        t-obj1 = typeof! obj1[p]
        if typeof! obj2[p] is \Object
            if t-obj1 is \Object
                obj1[p] `merge` obj2[p]
            else
                obj1[p] = obj2[p]
        else
            if t-obj1 is \Array
                # array, merge with current one
                for i, j of obj2[p]
                    if obj1[p].index-of(j) is -1
                        obj1[p] ++= j
            else if obj2[p] isnt void
                obj1[p] = obj2[p]
            else
                delete obj1[p]
    console.log "merge, free: #{process.memory!free}"
    obj1


export !function Led pin
    @pin = pin
    pin-mode @pin, \output
    @i = null

Led::turn = (val) ->
    @stop!
    digital-write @pin, val

Led::stop = ->
    try clear-interval @i

Led::osc = (m) ->
    __ = @
    cnt = 0
    @stop!
    @i = set-interval (!->
        digital-write __.pin, on
        <- sleep m.t.0
        digital-write __.pin, off
        __.stop! if ++cnt >= m.c
        ), (m.t.0 + m.t.1)

Led::wink = ->
    pin = @pin
    @stop!
    digital-write pin, on
    <- sleep 50ms
    digital-write pin, off

Led::warn = ->
    @osc do
        c: Infinity
        t: [300ms, 5000ms]

Led::upps = ->
    @osc do
        c: 3
        t: [50ms, 100ms]



/*
How to calculate start addres for FlashEEPROM:

http://www.espruino.com/Reference#l_Flash_getFree

require("Flash").getFree()
=[
  { "addr": 487424, "length": 4096 },
  { "addr": 524288, "length": 4096 },
  { "addr": 1011712, "length": 36864 },
  { "addr": 1048576, "length": 3129344 }
 ]
*/
mem = new (require 'FlashEEPROM')! # 487424  # Something little bit more than Espruino size
mem.endAddr = mem.addr + 1024  # TODO: Understand why this is 1024!
/*
mem =
    write: ->
    read: ->
*/

export !function Config file-no
    @f-no = file-no
    Config.f = mem
    @ram = {}

Config::flush = !->
    #console.log "flushing to eeprom..."
    Config.f.write @f-no, pack @ram
    0


Config::read = ->
    try
        @ram `merge` unpack E.to-string Config.f.read @f-no
        @ram
    catch
        #console.log "ERROR CONFIG READ(#{@file-no}): #{e}, raw: #{data}"
