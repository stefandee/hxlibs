package sec;

import sec.crypto.symmetric.XTeaKey;
import sec.util.Hex;
import flash.utils.ByteArray;

class SecureInt
{
  public var value (getValue, setValue) : Int;

  private var secureV1 : UInt;
  private var secureV2 : UInt;

  private var block : ByteArray;

  private var tea : XTeaKey;

  public function new(?defaultValue : Int = 0)
  {
    // generate a random key to use with this object
    // maybe we should use the Random class to generate this
    var key : ByteArray = new ByteArray();

    key.writeUnsignedInt(Std.random(0xFFFF));
    key.writeUnsignedInt(Std.random(0xFFFF));
    key.writeUnsignedInt(Std.random(0xFFFF));
    key.writeUnsignedInt(Std.random(0xFFFF));

    tea = new XTeaKey(key);

    block       = new ByteArray();

    value = defaultValue;
  }

  private function getValue() : Int
  {
    block.position = 0;

    block.writeUnsignedInt(secureV1);
    block.writeUnsignedInt(secureV2);

    tea.decrypt(block);

    block.position = 0;

    return block.readInt();
  }

  private function setValue(v : Int) : Int
  {
    block.position = 0;
    /*
    block.writeByte( v & 0x000000FF);
    block.writeByte((v & 0x0000FF00) >>> 8);
    block.writeByte((v & 0x00FF0000) >>> 16);
    block.writeByte((v & 0xFF000000) >>> 24);
    */
    block.writeUnsignedInt(v);
    block.writeUnsignedInt(0);

    tea.encrypt(block);

    block.position = 0;
    secureV1 = block.readInt();
    secureV2 = block.readInt();

    //trace(secureV1 + " " + secureV2);

    return v;
  }
}