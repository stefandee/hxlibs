/**
 * IPRNG
 * 
 * An interface for classes that can be used a pseudo-random number generators
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.prng;

import flash.utils.ByteArray;
  
interface IPRNG {
  function getPoolSize():UInt;
  function init(key:ByteArray):Void;
  function next():UInt;
  function dispose():Void;
  function toString():String;
}
