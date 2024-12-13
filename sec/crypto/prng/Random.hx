/**
 * Random
 * 
 * An ActionScript 3 implementation of a Random Number Generator
 * Copyright (c) 2007 Henri Torgemane
 * 
 * Derived from:
 * 		The jsbn library, Copyright (c) 2003-2005 Tom Wu
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.prng;

import flash.utils.ByteArray;
//import com.hurlant.util.Memory;
import flash.system.System;
import flash.system.Capabilities;
import flash.accessibility.AccessibilityProperties;
import flash.display.SWFVersion;
import flash.display.Stage;
//import flash.utils.getTimer;
import flash.text.Font;

class Random
{
  private var state:IPRNG;
  private var ready:Bool;
  private var pool:ByteArray;
  private var psize:Int;
  private var pptr:Int;
  private var seeded:Bool;
  
  public function new(prng:Class<Dynamic> = null) {
    ready = false;
    seeded = false;

    if (prng == null) prng = ARC4;

    state = Type.createInstance(prng, []);//new prng as IPRNG;

    psize= state.getPoolSize();
    pool = new ByteArray();
    pptr = 0;
    while (pptr <psize) {
      var t:UInt = Std.int(65536*Math.random());
      pool[pptr++] = t >>> 8;
      pool[pptr++] = t&255;
    }
    pptr=0;
    seed();
  }
  
  public function seed(x:Int = 0):Void {
    if (x==0) {
      x = Std.int(Date.now().getTime());
    }
    pool[pptr++] ^= x & 255;
    pool[pptr++] ^= (x>>8)&255;
    pool[pptr++] ^= (x>>16)&255;
    pool[pptr++] ^= (x>>24)&255;
    pptr %= psize;
    seeded = true;
  }
  
  /**
   * Gather anything we have that isn't entirely predictable:
   *  - memory used
   *  - system capabilities
   *  - timing stuff
   *  - installed fonts
   */
  public function autoSeed():Void {
    var b:ByteArray = new ByteArray();
    b.writeUnsignedInt(System.totalMemory);
    b.writeUTF(Capabilities.serverString);
    b.writeUnsignedInt(flash.Lib.getTimer());
    b.writeUnsignedInt(Std.int(Date.now().getTime()));
    var a = Font.enumerateFonts(true);
    for (f in a) {
      b.writeUTF(f.fontName);
      b.writeUTF("" + f.fontStyle);
      b.writeUTF("" + f.fontType);
    }
    b.position=0;
    while (b.bytesAvailable>=4) {
      seed(b.readUnsignedInt());
    }
  }
  
  
  public function nextBytes(buffer:ByteArray, length:Int):Void {
    while (length > 0) 
    {
      buffer.writeByte(nextByte());

      length--;
    }
  }
  public function nextByte():Int {
    if (!ready) {
      if (!seeded) {
        autoSeed();
      }
      state.init(pool);
      pool.length = 0;
      pptr = 0;
      ready = true;
    }
    return state.next();
  }
  public function dispose():Void {

    //for (var i:uint=0;i<pool.length;i++) 
    for(i in 0...pool.length)
    {
      pool[i] = Std.int(Math.random()*256);
    }

    pool.length=0;
    pool = null;
    state.dispose();
    state = null;
    psize = 0;
    pptr = 0;
    //Memory.gc();
  }
  public function toString():String {
    return "random-"+state.toString();
  }
}
