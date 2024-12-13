package sec;

import sec.crypto.symmetric.XTeaKey;
import sec.util.Hex;
import flash.utils.ByteArray;

class SecureFloat
{
  public var value (getValue, setValue) : Float;

  private var secureV1 : UInt;
  private var secureV2 : UInt;

  private var block : ByteArray;

  private var tea : XTeaKey;

  public function new(?defaultValue : Float = 0)
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

  private function getValue() : Float
  {
    block.position = 0;

    block.writeUnsignedInt(secureV1);
    block.writeUnsignedInt(secureV2);

    tea.decrypt(block, 0);

    block.position = 0;

    return block.readDouble();
  }

  private function setValue(v : Float) : Float
  {
    block.position = 0;
    block.writeDouble(v);

    tea.encrypt(block, 0);

    block.position = 0;
    secureV1 = block.readInt();
    secureV2 = block.readInt();

    //trace(secureV1 + " " + secureV2);

    return v;
  }
}