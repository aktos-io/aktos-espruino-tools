require! 'aea': {merge, pack, unpack}

mem = new (require 'FlashEEPROM') 0x087000  # Something little bit more than Espruino size
mem.endAddr = mem.addr + 1024

export !function Config file-no
    @f-no = file-no
    Config.f = mem
    @ram = {}

Config::flush = !->
    #console.log "flushing to eeprom..."
    Config.f.write @f-no, pack @ram

Config::read = ->
    try
        @ram `merge` unpack E.to-string Config.f.read @f-no
        @ram
    catch
        #console.log "ERROR CONFIG READ(#{@file-no}): #{e}, raw: #{data}"
