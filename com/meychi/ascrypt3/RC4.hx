/**
* * Encrypts and decrypts an alleged RC4 hash.
*
* Haxe port by Stefan Dicu, https://www.pirongames.com
* modified by Jeff Houser, DotComIt 12/7/06
* http://www.jeffryhouser.com
* Converted from ActionSCript 2.0 code to ActionScript 3.0 code for use in a Flex 2 Application
* @Version 3.0
* Released under the same license as the previous code-bases
* That means there is no license, use it as you see fit for whatever reason you want

* @author Mika Palmu
* @version 1.0
*
* Orginal Flash port by:
* Gabor Penoff - http://www.fns.hu
* Email: fns@fns.hu
*/

// JH DotComIt 11/1/06 added package definition 
package com.meychi.ascrypt3;

	class RC4 
  {

		/**
		* Variables
		* @exclude
		*/
		/*
    private static var sbox = new Array(255);
		private static var mykey = new Array(255);
    */
		private var sbox : Array<Int>;
		private var mykey : Array<Int>;

    public function new()
    {
      sbox = new Array();
      mykey = new Array();

      for(i in 0...255)
      {
        sbox.push(0);
        mykey.push(0);
      }
    }
		
		/**
		* Encrypts a string with the specified key.
		*/
		// JH DotComIT 12/6/06 removed static static 
		public function encrypt(src:String, key:String):String {
			var mtxt = strToChars(src);
			var mkey = strToChars(key);
			var result = calculate(mtxt, mkey);
			return charsToHex(result);
		}
		
		/**
		* Decrypts a string with the specified key.
		*/
		// JH DotComIT 12/6/06 removed static static 
		public function decrypt(src:String, key:String):String {
			var mtxt = hexToChars(src);
			var mkey = strToChars(key);
			var result = calculate(mtxt, mkey);
			return charsToStr(result);
		}
		
		/**
		* Private methods.
		*/
		private /*static */function initialize(pwd : Array<Int>) : Void {
			var b:Int = 0;
			var tempSwap:Int;
			var intLength:Int = pwd.length;
			
			// JH DotComIt 12/6/06 moved var a outside of loops
			var a = 0;
			
			//for (a = 0; a <= 255; a++) {
      for(a in 0...256) {
				mykey[a] = pwd[(a%intLength)];
				sbox[a] = a;
			}

			//for (a =0; a<=255; a++) {
			for (a in 0...256) {
				b = (b+sbox[a]+mykey[a]) % 256;
				tempSwap = sbox[a];
				sbox[a] = sbox[b];
				sbox[b] = tempSwap;
			}
		}
		private /*static */function calculate(plaintxt:Array<Int>, psw:Array<Int>):Array<Int> {
			initialize(psw);
			var i = 0; 
      var j = 0;
			var cipher = new Array();
			var k:Int, temp:Int, cipherby:Int, a:Int;

			//for (a = 0; a<plaintxt.length; a++) {
      for(a in 0...plaintxt.length) {
				i = (i+1) % 256;
				j = (j+sbox[i])%256;
				temp = sbox[i];
				sbox[i] = sbox[j];
				sbox[j] = temp;
				var idx:Int = (sbox[i]+sbox[j]) % 256;
				k = sbox[idx];
				cipherby = plaintxt[a]^k;
				cipher.push(cipherby);
			}
			return cipher;
		}
		public /*static */function charsToHex(chars:Array<Int>):String {
			var result:String = new String("");
			var hexes = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
			//for (var i:Number = 0; i<chars.length; i++) {
			for (i in 0...chars.length) {
				result += hexes[chars[i] >> 4] + hexes[chars[i] & 0xf];
			}
			return result;
		}
		public /*static */function hexToChars(hex:String):Array<Int> {
			var codes = new Array();

      //var i = (hex.substr(0, 2) == "0x") ? 2 : 0;
      var i = 0;

      while(i < hex.length)
      {
				codes.push(Std.parseInt("0X" + hex.substr(i, 2)));
        i += 2;
      }

			/*
      for (var i:Number = (hex.substr(0, 2) == "0x") ? 2 : 0; i<hex.length; i+=2) {
				codes.push(parseInt(hex.substr(i, 2), 16));
			}
      */
			return codes;
		}
		public /*static */function charsToStr(chars:Array<Int>):String {
			var result:String = new String("");
			//for (var i:Number = 0; i<chars.length; i++) {
			for (i in 0...chars.length) {
				result += String.fromCharCode(chars[i]);
			}
			return result;
		}
		public /*static */function strToChars(str:String):Array<Int> {
			var codes = new Array();
			//for (var i:Number = 0; i<str.length; i++) {
			for (i in 0...str.length) {
				codes.push(str.charCodeAt(i));
			}
			return codes;
		}	
	}
