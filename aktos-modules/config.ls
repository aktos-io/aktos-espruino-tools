require! 'aea': {merge, pack, unpack}

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
