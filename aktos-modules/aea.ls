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

# https://github.com/ceremcem/merge-ls
export function merge (obj1, obj2)
    # merge rest one by one
    for p of obj2
        if typeof obj2[p] is \object
            if obj1[p]
                obj1[p] `merge` obj2[p]
            else
                obj1[p] = obj2[p]
        else
            if obj1[p] isnt void
                obj1[p] = obj2[p]
            else
                delete obj1[p]
    obj1


/*
a = {x: 1, y: 2}
b = {z: 3}

a `merge` b

console.log "a is: ", a
# expected a is:  { x: 1, y: 2, z: 3 }
*/
