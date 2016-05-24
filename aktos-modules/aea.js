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
function Config(fileNo){
  var self;
  self = this;
  this.fileNo = fileNo;
  Config.f = new (require("FlashEEPROM"))();
  Config.f.endAddr = Config.f.addr + 1024;
  this.writeCount = 0;
  this.periodicSync();
}
Config.prototype.flush = function(){
  console.log("flushing to eeprom...");
  this.write(this.ram);
};
Config.prototype.periodicSync = function(){
  var self;
  self = this;
  (function lo(op){
    return sleep(3600 * 1000, function(){
      self.flush();
      return lo(op);
    });
  })(function(){});
};
Config.prototype.write = function(data){
  if (this.writeCount++ > 10) {
    Config.f.cleanup();
    this.writeCount = 0;
  }
  Config.f.write(this.fileNo, pack(data));
  this.ram = data;
};
Config.prototype.read = function(){
  var data, e;
  try {
    data = E.toString(Config.f.read(this.fileNo));
    this.ram = unpack(data);
    return this.ram;
  } catch (e$) {
    e = e$;
    return console.log("ERROR CONFIG READ(" + this.fileNo + "): " + e + ", raw: " + data);
  }
};
function Led(pin){
  this.pin = pin;
  pinMode(this.pin, 'output');
  this.mode = 'turn-off';
  this.onTime = 1000;
  this.offTime = 1000;
}
Led.prototype.turn = function(val){
  this.mode = val ? 'on' : 'off';
  return digitalWrite(this.pin, val);
};
Led.prototype.baseBlink = function(){
  var self;
  self = this;
  if (this.mode !== 'blink') {
    this.mode = 'blink';
    return function lo(op){
      if (self.mode === 'blink') {
        digitalWrite(self.pin, true);
      }
      return sleep(self.onTime, function(){
        if (self.mode === 'blink') {
          digitalWrite(self.pin, false);
        }
        return sleep(self.offTime, function(){
          if (self.mode === 'blink') {
            return lo(op);
          }
          return op();
        });
      });
    }(function(){
      return console.log("blink ended, mode: ", self.mode);
    });
  }
};
Led.prototype.blink = function(){
  this.onTime = 1000;
  this.offTime = 1000;
  return this.baseBlink();
};
Led.prototype.attBlink = function(){
  this.onTime = 300;
  this.offTime = 300;
  return this.baseBlink();
};
Led.prototype.infoBlink = function(){
  this.onTime = 80;
  this.offTime = 2000;
  return this.baseBlink();
};
Led.prototype.wink = function(){
  var self;
  self = this;
  self.mode = 'wink';
  self.turn(true);
  return sleep(50, function(){
    return self.turn(false);
  });
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
out$.Config = Config;
out$.Led = Led;
