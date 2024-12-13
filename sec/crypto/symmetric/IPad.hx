/**
 * IPad
 * 
 * An interface for padding mechanisms to implement.
 * Copyright (c) 2007 Henri Torgemane
 * 
 * See LICENSE.txt for full license information.
 */
package sec.crypto.symmetric;

import flash.utils.ByteArray;

/**
 * Tiny interface that represents a padding mechanism.
 */
public interface IPad
{
  /**
   * Add padding to the array
   */
  function pad(a:ByteArray):Void;
  /**
   * Remove padding from the array.
   * @throws Error if the padding is invalid.
   */
  function unpad(a:ByteArray):Void;
  /**
   * Set the blockSize to work on
   */
  function setBlockSize(bs:UInt):Void;
}
