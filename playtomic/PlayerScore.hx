﻿//  This file is part of the official Playtomic API for HaXe games.  //  Playtomic is a real time analytics platform for casual games //  and services that go in casual games.  If you haven't used it //  before check it out://  http://playtomic.com/////  Created by ben at the above domain on 10/5/11.//  Copyright 2011 Playtomic LLC. All rights reserved.////  Documentation is available at://  http://playtomic.com/api/haxe//// PLEASE NOTE:// You may modify this SDK if you wish but be kind to our servers.  Be// careful about modifying the analytics stuff as it may give you // borked reports.//// If you make any awesome improvements feel free to let us know!//// -------------------------------------------------------------------------// THIS SOFTWARE IS PROVIDED BY PLAYTOMIC, LLC "AS IS" AND ANY// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.package playtomic;class PlayerScore{	public function new(name:String = "", ?points:haxe.Int64 = null)	{		Name = name;		Points = (points == null) ? haxe.Int64.ofInt(0) : points;		SubmittedOrBest = false;    CustomData = new Hash();	}		public var Name:String;	public var FBUserId:String;	public var Points:haxe.Int64;	public var Rank:Int;	public var Website:String;	public var SDate:Date;	public var RDate:String;	public var CustomData:Hash<String>;	public var SubmittedOrBest:Bool;		public function toString():String	{		return "Playtomic.PlayerScore:" + 				"\nRank: " + Rank +				"\nName: " + Name + 				"\nPoints: " + Points;	}		public function toStringAll():String	{		var str:String = "Playtomic.PlayerScore:" + 						"\nRank: " + Rank +						"\nName: " + Name + 						"\nFBUserId: " + FBUserId +						"\nPoints: " + Points + 						"\nWebsite: " + Website + 						"\nSDate: " + SDate + 						"\nRDate: " + RDate + 						"\nCustomData: " + CustomData.toString();						//for(value in CustomData.fields)		//	str += "\n  " + value + ": " + Reflect.field(CustomData, value);		return str;	}  // TODO: karg: it's not the most accurate conversion way because of float usage  public static function scoreFromStr(s : String) : haxe.Int64  {    var score : Null<Float> = Std.parseFloat(s);    if (score == null)    {      return haxe.Int64.ofInt(0);    }    score = Math.floor(score);    var sign : Int = (score > 0) ? 1 : -1;        var high32 : Float = score >= 4294967296.0 ? 1 : 0;    var low32 : Float = score >= 4294967296.0 ? (Math.abs(score) - 4294967296.0) : Math.abs(score);    var value = haxe.Int64.make(haxe.Int32.ofInt(Std.int(high32)), haxe.Int32.ofInt(Std.int(low32)));    value = haxe.Int64.mul(value, haxe.Int64.ofInt(Std.int(sign)));    return value;  }}