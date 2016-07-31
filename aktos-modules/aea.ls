# lib functions
export sleep = (ms, func) !-> set-timeout func, ms
export after = sleep
export looop = (ms, f) -> set-interval f, ms


export pack = (x) ->
    JSON.stringify x

export unpack = (wire-data) ->
    try
        x = JSON.parse wire-data
        throw if x is void
        return x
    catch
        #console.log "Error on unpacking: ", e
        #console.log "Raw wire data: ", wire-data
        throw "Error on unpacking"

export repl =
    detach: !->
        console.log "Disabling REPL console!"
        # access it via LoopbackB
        LoopbackA.set-console!

    attach: !->
        ser.set-console!
        console.log "REPL console enabled!"



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
