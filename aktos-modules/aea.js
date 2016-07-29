// Generated by LiveScript 1.4.0
var sleep, after, pack, unpack, repl, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
out$.sleep = sleep = function(ms, func){
  setTimeout(func, ms);
};
out$.after = after = sleep;
out$.pack = pack = function(x){
  return JSON.stringify(x);
};
out$.unpack = unpack = function(wireData){
  var x, e;
  try {
    x = JSON.parse(wireData.trim());
    if (x === void 8) {
      throw null;
    }
    return x;
  } catch (e$) {
    e = e$;
    console.log("Error on unpacking: ", e);
    console.log("Raw wire data: ", wireData);
    throw "Error on unpacking";
  }
};
out$.repl = repl = {
  detach: function(){
    console.log("Disabling REPL console!");
    LoopbackA.setConsole();
  },
  attach: function(){
    ser.setConsole();
    console.log("REPL console enabled!");
  }
};
out$.merge = merge;
function merge(obj1){
  var sources, i$, len$, obj2, p, e;
  sources = slice$.call(arguments, 1);
  for (i$ = 0, len$ = sources.length; i$ < len$; ++i$) {
    obj2 = sources[i$];
    for (p in obj2) {
      try {
        if (!(obj2[p] instanceof Object)) {
          throw null;
        }
        obj1[p] = merge(obj1[p], obj2[p]);
      } catch (e$) {
        e = e$;
        if (obj2[p] !== void 8) {
          obj1[p] = obj2[p];
        } else {
          delete obj1[p];
        }
      }
    }
  }
  return obj1;
}
