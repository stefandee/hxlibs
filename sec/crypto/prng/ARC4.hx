/**
 * ARC4
 * 
 * An ActionScript 3 implementation of RC4
 * Copyright (c) 2007 Henri Torgemane
 * 
 * Derived from:
 * 		The jsbn library, Copyright (c) 2003-2005 Tom Wu
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.prng;

import sec.crypto.symmetric.IStreamCipher;
import sec.util.Hex;
//import com.hurlant.util.Memory;

import flash.utils.ByteArray;

class ARC4 implements IPRNG, implements IStreamCipher {
  private var i:Int;
  private var j:Int;
  private var S:ByteArray;
  private static var psize : UInt = 256;

  public function new(key:ByteArray = null){
    S = new ByteArray();
    if (key != null) {
      init(key);
    }
  }
  public function getPoolSize():UInt {
    return psize;
  }
  public function init(key:ByteArray):Void {
    this.i = 0;
    this.j = 0;
    
    var i:Int;
    var j:Int;
    var t:Int;
    
    //for (i=0; i<256; ++i) 
    for(i in 0...256)
    {
      S[i] = i;
    }

    j=0;
    
    //for (i=0; i<256; ++i) 
    for(i in 0...256)
    {
      j = (j + S[i] + key[i%key.length]) & 255;
      t = S[i];
      S[i] = S[j];
      S[j] = t;
    }

    this.i=0;
    this.j=0;
  }
  public function next():UInt {
    var t:Int;
    i = (i+1)&255;
    j = (j+S[i])&255;
    t = S[i];
    S[i] = S[j];
    S[j] = t;

    //trace(S[(t+S[i])&255]);

    return S[(t+S[i])&255];
  }

  public function getBlockSize():UInt {
    return 1;
  }
  
  public function encrypt(block:ByteArray):Void {
    var i:UInt = 0;
    while (i<block.length) {
      block[i++] ^= next();
    }
  }
  public function decrypt(block:ByteArray):Void {
    encrypt(block); // the beauty of XOR.
  }

  // "shorthand" encrypt/decrypt methods
  public function encrypt2(message : String, key : String) : String
  {
    var k = Hex.toArray(Hex.fromString(key));
    var m = Hex.toArray(Hex.fromString(message));

    init(k);

    encrypt(m);

    return (Hex.fromArray(m)).toLowerCase();
  }

  // message is in hex string format
  public function decrypt2(message : String, key : String) : String
  {
    var k = Hex.toArray(Hex.fromString(key));
    var m = Hex.toArray(message);

    init(k);

    decrypt(m);

    return Hex.toString(Hex.fromArray(m));
  }

  public function dispose():Void {
    var i:UInt = 0;
    if (S!=null) {
      //for (i=0;i<S.length;i++) 
      for(i in 0...S.length)
      {
        S[i] = Std.int(Math.random()*256);
      }
      S.length=0;
      S = null;
    }
    this.i = 0;
    this.j = 0;

    //Memory.gc();
  }
  public function toString():String {
    return "rc4";
  }
}
