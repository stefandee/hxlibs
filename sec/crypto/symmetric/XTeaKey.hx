/**
 * XTeaKey
 * 
 * An ActionScript 3 implementation of the XTea algorithm
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.symmetric;

import sec.crypto.prng.Random;
//import gamelib.sec.util.Memory;

import flash.utils.ByteArray;
  
class XTeaKey implements ISymmetricKey
{
  public static var NUM_ROUNDS : UInt = 64;	
  private var k : Array<UInt>;

  public function new(a:ByteArray) {
    a.position=0;
    k = [a.readUnsignedInt(),a.readUnsignedInt(),a.readUnsignedInt(),a.readUnsignedInt()];
  }
  /**
   * K is an hex string with 32 digits.
   */
  public static function parseKey(K:String):XTeaKey {
    var a:ByteArray = new ByteArray();
    a.writeUnsignedInt(Std.parseInt("0x" + K.substr(0,8)));
    a.writeUnsignedInt(Std.parseInt("0x" + K.substr(8,8)));
    a.writeUnsignedInt(Std.parseInt("0x" + K.substr(16,8)));
    a.writeUnsignedInt(Std.parseInt("0x" + K.substr(24,8)));
    a.position = 0;
    return new XTeaKey(a);
  }
  
  public function getBlockSize() : UInt {
    return 8;
  }

  public function encrypt(block:ByteArray, index:UInt=0):Void {
    block.position = index;
    var v0:UInt = block.readUnsignedInt();
    var v1:UInt = block.readUnsignedInt();
    var i:UInt;
    var sum:UInt =0;
    var delta:UInt = 0x9E3779B9;
    //for (i=0; i<NUM_ROUNDS; i++) 
    for(i in 0...NUM_ROUNDS)
    {
      v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + k[sum & 3]);
      sum += delta;
          v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + k[(sum>>11) & 3]);
    }
    block.position-=8;
    block.writeUnsignedInt(v0);
    block.writeUnsignedInt(v1);
  }
  
  public function decrypt(block:ByteArray, index:UInt=0):Void {
    block.position = index;
    var v0:UInt = block.readUnsignedInt();
    var v1:UInt = block.readUnsignedInt();
    var i:UInt;
    var delta:UInt = 0x9E3779B9;
    var sum:UInt = delta*NUM_ROUNDS;
    //for (i=0; i<NUM_ROUNDS; i++) 
    for(i in 0...NUM_ROUNDS)
    {
      v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + k[(sum>>11) & 3]);
      sum -= delta;
      v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + k[sum & 3]);
    }
    block.position-=8;
    block.writeUnsignedInt(v0);
    block.writeUnsignedInt(v1);
  }

  public function dispose() : Void {
    var r:Random = new Random();

    for(i in 0...k.length)
    {
      k[i] = r.nextByte();
    }

    k = null;
    
    /*
    for (var i:uint=0;i<k.length;i++) {
      k[i] = r.nextByte();
      delete k[i];
    }
    k = null;
    Memory.gc();
    */
  }

  public function toString():String {
    return "xtea";
  }
}
