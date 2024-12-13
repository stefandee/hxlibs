/**
 * ICipher
 * 
 * A generic interface to use symmetric ciphers
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.symmetric;

import flash.utils.ByteArray;

interface ICipher
{
  function getBlockSize():UInt;
  function encrypt(src:ByteArray):Void;
  function decrypt(src:ByteArray):Void;
  function dispose():Void;
  function toString():String;
}
