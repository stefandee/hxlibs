package com.badgegames;

	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
  import flash.external.ExternalInterface;
	//import flash.external.*;

	class BadgeGamesAPI extends MovieClip{

		private var _root:MovieClip;
		private var debugMode:Bool;//whether or not the API is running in debug mode
		private var validated : Bool;//has the game's id/key been validated yet?
		private var gameName:String;
		private var gameKey:String;
		private var gameId:Int;
		private var badges:Array<String>;//[name 1][description 1][points 1][name 2][description 2][points 2]...
		private var badgeImages:Array<flash.display.DisplayObject>;//[image 1],[image 1]...
		private var badgesUnlocked:Array<Bool>;
		private var achievements:Array<Int>; //an array of achieved badges
		private var username:String;
		private var sessionKey:String;
		
		//FUNCTIONS:
		
		//unlock a badge by id
		public function unlockById(unlockId:Int):Void{
			//for (var i:int=0;i<achievements.length;i++)
      for(i in 0...achievements.length)
				if (achievements[i]==unlockId)
					return;
			achievements.push(unlockId);							
		}
		/*//does not allow for later name changes
		//unlock a badge by name. Does nothing if the name is invalid.
		public function unlockByName(unlockName:String):void{
			var unlockId:int=-1;
			for (var i:int=0;i<badges.length/3;i++)
				if (badges[i*3]==unlockName){
					unlockById(i);
					return;
				}
			
			error("Could not unlock the badge '"+unlockName+"' (no badge with that name could be found)!");
		}
		*/
		//constructor
		public function new(id:Int,key:String,_r:MovieClip){
			
			super();
      
      validated = false;
			
      //save the id and root variables
			_root=_r;
			gameId=id;
			gameKey=key;
			
			//make the popup invisible to start
			//_root.badgeGamesPopup.visible=false;
			
			//position the popup in the top right corner of the stage
			//positionPopup();
			
			
			trace("[BadgeGamesApi] Hello World!");

			//if on badgegames, set debug mode to false,
			//otherwise run in debug mode.
			var domain:String = _root.loaderInfo.url.split("/")[2];
			if (domain.indexOf("badgegames.com") != (domain.length - "badgegames.com".length))
				debugMode=true;
			else
				debugMode=false;
				
			badgeImages=new Array();
			badgesUnlocked=new Array();
			achievements=new Array();
			
			//if not in debug mode, make sure they're logged in
			if (!debugMode){
				if (ExternalInterface.call("APIisLogged")==true){
					username=ExternalInterface.call("APIgetUsername");
					loadUrl(url()+"a=GSK&u="+username+"&i="+gameId,getSessionKey);
					return;
				}else{
					debugNote("Not logged in - user is a guest");
					username="guest";
					loadUrl(url()+"a=GSK&u="+username+"&i="+gameId,getSessionKey);
					return;
				}
			}
			debugNote("Attempting to validate the game Id/Key...");		
			loadUrl(url()+"a=verifyGameId&i="+gameId+"&k="+key,verifyGameId);
			
		}
		
		//enterframe event
		private function enterframe(e:Event){

			if (achievements.length > 0)
      {
        trace(achievements.length + " - " + _root.badgeGamesPopup.visible + " - " + _root.badgeGamesPopup.currentFrame);
      }
      
      //if there is an achievement to show and we can show it, do so
			//otherwise return
			if (achievements.length==0 || _root.badgeGamesPopup.visible==true || _root.badgeGamesPopup.currentFrame!=1)
				return;

  		trace("unlocking a badge!");
      
      var badgeId:Int=achievements.shift();
			
			//check to make sure badge exists
			if (badgesUnlocked.length==0 || badgeId<0 || badgeId>badgesUnlocked.length)
      {
        trace("Badge Unlock attempted on inexistant badge!");
				error("Badge Unlock attempted on inexistant badge!");
			}
			
			debugNote("Attempting to unlock the badge '"+badges[badgeId*3]+"' ...");
			
			
			if (badgesUnlocked[badgeId]){
				debugNote("'"+badges[badgeId*3]+"'  is already unlocked.");
			}else{
				badgesUnlocked[badgeId]=true;
				if (debugMode){//if in debug mode, just show the achievment
					
					debugNote("'"+badges[badgeId*3]+"' has been unlocked!");
					showPopup(badgeId);
					
				}else{//release mdoe
					if (username!="guest")//logged-in user
						loadUrl(url()+"a=achieve&secureCode="+md5(username+sessionKey+gameId+badgeId)+md5(sessionKey).substr(0,3),serverAchieve);
					else{//the user is a guest
						debugNote("Guest is attempting to achieve a badge...");
						if (ExternalInterface.call("APIGuestAchieved",badgeId)==false){
							showPopup(badgeId);
							ExternalInterface.call("APIGuestAchieve",badgeId,url()+"a=guestAchieve&secureCode="+md5(username+sessionKey+gameId+badgeId)+md5(sessionKey).substr(0,3)+"&g="+gameId);
						}
						//else already achieved earlier by the guest
							
					}
						
				}
			}
		}
		function serverAchieve(e:Event){
			
			var r:String=e.target.data;
			debugNote(r);
			if (r=="*"){//already achieved or error
				debugNote("A badge that was sent to the server for verification was returned as already unlocked.");
			}else if (r=="-" || r==""){//already achieved or error
				error("An invalid response was received from the server after a badge-unlock request was sent!!");
			}else{
				badgesUnlocked[Std.parseInt(r)]=true;
				debugNote("'"+badges[Std.parseInt(r)*3]+"' has been unlocked!");
				showPopup(Std.parseInt(r));
				ExternalInterface.call("APIachieve",Std.parseInt(r));
			}
			
		}
		function getSessionKey(e:Event){
			sessionKey=e.target.data;
			debugNote("Session Verified: "+e.target.data);
			loadUrl(url()+"a=verifyGameId&i="+gameId+"&k="+gameKey,verifyGameId);
		}

		private function positionPopup(){
			_root.badgeGamesPopup.x=_root.stage.stageWidth-_root.badgeGamesPopup.width-10;
			_root.badgeGamesPopup.y=10;
			_root.badgeGamesPopup.help.visible=false;
		}
		
		//data loader function
		private function loadUrl(url:String,callBack:Dynamic -> Void){
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, callBack);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(url));
		 	
		}
		private function ioErrorHandler(event:IOErrorEvent):Void {
            error("Couldn't load data! (Input/Output Error when contacting the BadgeGames server)");
        }

		//data loader function
		private function error(errorDescription:String){
			if (debugMode){
				trace("[BadgeGamesApi: Error] "+errorDescription);
			}else{
				
				//display the error visually in a popup box?
				//_root.debug.text+="[BadgeGamesApi: Error] "+errorDescription+"\n";
				
			}
		 	
		}
		
		//displays a debug notice (only if in debug mode - otherwise does nothing)
		private function debugNote(output:String){
			if (debugMode){
				trace("[BadgeGamesApi] "+output);
			}else{
				//_root.debug.text+="[BadgeGamesApi] "+output+"\n";
			}
		}
		
		//gives us a no-cache badgegames url to use for api access:
		private function url():String{
			if (debugMode)
				return "http://www.badgegames.com/api.php?t="+ Date.now().getTime()+"&";
			else
				return "api.php?t="+ Date.now().getTime()+"&";
		}
		
		private function verifyGameId(e:Event){
			var r:String=e.target.data;
			if (r=="0" || r=="")
				error("Invalid Game Id or Game Key - couldn't validate!");
			else{
				validated=true;
				badges=r.split(';');
				gameName=badges[0];
				debugNote("Game Validated as '"+gameName+"'!");
				debugNote("Loading Badge Icons...");
				badges.shift();//remove the game name from the badges array
				//load in badge bitmaps...
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, badgeImageLoader);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.load(new URLRequest(url()+"a=getImage"+"&i="+gameId+"&b=0"));
			}
		}
		
		private function badgeImageLoader(e:Event){
			var loader:Loader = cast e.target.loader;
			badgeImages.push(loader.content);//save the loaded image
			badgesUnlocked.push(false);
			//trace a success message
			if (badges[(badgeImages.length-1)*3]!='')
				debugNote("Badge Icon for '"+badges[(badgeImages.length-1)*3]+"' loaded successfully");
			
			//are there still images to load? If so load the next one...
			if (badgeImages.length+1<badges.length/3){
				var L:Loader=new Loader();
				L.contentLoaderInfo.addEventListener(Event.COMPLETE, badgeImageLoader);
				L.load(new URLRequest(url()+"a=getImage"+"&i="+gameId+"&b="+badgeImages.length));
			}else{//all images has loaded - add the event listener
        trace("[BadgeAPI]: Event listener added!");
				this.addEventListener(Event.ENTER_FRAME,enterframe);
			}
		}
		
		
		
		private function showPopup(badgeId:Int){
			positionPopup();
			
			_root.badgeGamesPopup.inside.txtName.text=badges[badgeId*3];
			_root.badgeGamesPopup.inside.txtPoints.text=badges[badgeId*3+2];
			
			if (_root.badgeGamesPopup.inside.txtName.textHeight>28)
				_root.badgeGamesPopup.inside.txtName.y=-3;
			else
				_root.badgeGamesPopup.inside.txtName.y=5;
			
			_root.badgeGamesPopup.inside.iconHolder.removeChildAt(0);//remove previous icon
			_root.badgeGamesPopup.inside.iconHolder.addChild(badgeImages[badgeId]);//add this one
			_root.badgeGamesPopup.visible=true;
			_root.badgeGamesPopup.gotoAndPlay(1);
		}
	
	
	/**
	* MD5 FUNCTIONS
	* Calculates the MD5 checksum.
	* @authors Mika Palmu
	* @version 2.0
	*/
		/**
		* Calculates the MD5 checksum.
		*/
		private static function md5(src:String):String {
			return hex_md5(src);
		}
	
		/**
		* Private methods.
		*/
		private static function hex_md5(src:String):String {
			return binl2hex(core_md5(str2binl(src), src.length*8));
		}
		private static function core_md5(x:Array<Int>, len:Int):Array<Int> {
			x[len >> 5] |= 0x80 << ((len)%32);
			x[(((len+64) >>> 9) << 4)+14] = len;
			var a:Int = 1732584193, b:Int = -271733879;
			var c:Int = -1732584194, d:Int = 271733878;
			//for (var i:Number = 0; i<x.length; i += 16) {

      var i : Int = 0;

      do
      {
				var olda:Int = a, oldb:Int = b;
				var oldc:Int = c, oldd:Int = d;
				a = md5_ff(a, b, c, d, x[i+0], 7, -680876936);
				d = md5_ff(d, a, b, c, x[i+1], 12, -389564586);
				c = md5_ff(c, d, a, b, x[i+2], 17, 606105819);
				b = md5_ff(b, c, d, a, x[i+3], 22, -1044525330);
				a = md5_ff(a, b, c, d, x[i+4], 7, -176418897);
				d = md5_ff(d, a, b, c, x[i+5], 12, 1200080426);
				c = md5_ff(c, d, a, b, x[i+6], 17, -1473231341);
				b = md5_ff(b, c, d, a, x[i+7], 22, -45705983);
				a = md5_ff(a, b, c, d, x[i+8], 7, 1770035416);
				d = md5_ff(d, a, b, c, x[i+9], 12, -1958414417);
				c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
				b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
				a = md5_ff(a, b, c, d, x[i+12], 7, 1804603682);
				d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
				c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
				b = md5_ff(b, c, d, a, x[i+15], 22, 1236535329);
				a = md5_gg(a, b, c, d, x[i+1], 5, -165796510);
				d = md5_gg(d, a, b, c, x[i+6], 9, -1069501632);
				c = md5_gg(c, d, a, b, x[i+11], 14, 643717713);
				b = md5_gg(b, c, d, a, x[i+0], 20, -373897302);
				a = md5_gg(a, b, c, d, x[i+5], 5, -701558691);
				d = md5_gg(d, a, b, c, x[i+10], 9, 38016083);
				c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
				b = md5_gg(b, c, d, a, x[i+4], 20, -405537848);
				a = md5_gg(a, b, c, d, x[i+9], 5, 568446438);
				d = md5_gg(d, a, b, c, x[i+14], 9, -1019803690);
				c = md5_gg(c, d, a, b, x[i+3], 14, -187363961);
				b = md5_gg(b, c, d, a, x[i+8], 20, 1163531501);
				a = md5_gg(a, b, c, d, x[i+13], 5, -1444681467);
				d = md5_gg(d, a, b, c, x[i+2], 9, -51403784);
				c = md5_gg(c, d, a, b, x[i+7], 14, 1735328473);
				b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);
				a = md5_hh(a, b, c, d, x[i+5], 4, -378558);
				d = md5_hh(d, a, b, c, x[i+8], 11, -2022574463);
				c = md5_hh(c, d, a, b, x[i+11], 16, 1839030562);
				b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
				a = md5_hh(a, b, c, d, x[i+1], 4, -1530992060);
				d = md5_hh(d, a, b, c, x[i+4], 11, 1272893353);
				c = md5_hh(c, d, a, b, x[i+7], 16, -155497632);
				b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
				a = md5_hh(a, b, c, d, x[i+13], 4, 681279174);
				d = md5_hh(d, a, b, c, x[i+0], 11, -358537222);
				c = md5_hh(c, d, a, b, x[i+3], 16, -722521979);
				b = md5_hh(b, c, d, a, x[i+6], 23, 76029189);
				a = md5_hh(a, b, c, d, x[i+9], 4, -640364487);
				d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
				c = md5_hh(c, d, a, b, x[i+15], 16, 530742520);
				b = md5_hh(b, c, d, a, x[i+2], 23, -995338651);
				a = md5_ii(a, b, c, d, x[i+0], 6, -198630844);
				d = md5_ii(d, a, b, c, x[i+7], 10, 1126891415);
				c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
				b = md5_ii(b, c, d, a, x[i+5], 21, -57434055);
				a = md5_ii(a, b, c, d, x[i+12], 6, 1700485571);
				d = md5_ii(d, a, b, c, x[i+3], 10, -1894986606);
				c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
				b = md5_ii(b, c, d, a, x[i+1], 21, -2054922799);
				a = md5_ii(a, b, c, d, x[i+8], 6, 1873313359);
				d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
				c = md5_ii(c, d, a, b, x[i+6], 15, -1560198380);
				b = md5_ii(b, c, d, a, x[i+13], 21, 1309151649);
				a = md5_ii(a, b, c, d, x[i+4], 6, -145523070);
				d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
				c = md5_ii(c, d, a, b, x[i+2], 15, 718787259);
				b = md5_ii(b, c, d, a, x[i+9], 21, -343485551);
				a = safe_add(a, olda); b = safe_add(b, oldb);
				c = safe_add(c, oldc); d = safe_add(d, oldd);

        i+=16;
			}
      while(i < x.length);

			return [a, b, c, d];
		}
		private static function md5_cmn(q:Int, a:Int, b:Int, x:Int, s:Int, t:Int):Int {
			return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b);
		}
		private static function md5_ff(a:Int, b:Int, c:Int, d:Int, x:Int, s:Int, t:Int):Int {
			return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
		}
		private static function md5_gg(a:Int, b:Int, c:Int, d:Int, x:Int, s:Int, t:Int):Int {
			return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
		}
		private static function md5_hh(a:Int, b:Int, c:Int, d:Int, x:Int, s:Int, t:Int):Int {
			return md5_cmn(b ^ c ^ d, a, b, x, s, t);
		}
		private static function md5_ii(a:Int, b:Int, c:Int, d:Int, x:Int, s:Int, t:Int):Int {
			return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
		}
		private static function bit_rol(num:Int, cnt:Int):Int {
			return (num << cnt) | (num >>> (32-cnt));
		}
		private static function safe_add(x:Int, y:Int):Int {
			var lsw:Int = (x & 0xFFFF)+(y & 0xFFFF);
			var msw:Int = (x >> 16)+(y >> 16)+(lsw >> 16);
			return (msw << 16) | (lsw & 0xFFFF);
		}
		private static function str2binl(str:String):Array<Int> {
			var bin:Array<Int> = new Array();
			var mask:Int = (1 << 8)-1;

      var i : Int = 0;

			//for (var i:Number = 0; i<str.length*8; i += 8) {
      do
      {
				bin[i >> 5] |= (str.charCodeAt(Std.int(i/8)) & mask) << (i%32);

        i+=8;
			}
      while(i < str.length*8);

			return bin;
		}
		private static function binl2hex(binarray:Array<Int>):String {
			var str:String = new String("");
			var tab:String = new String("0123456789abcdef");
			//for (var i:Number = 0; i<binarray.length*4; i++) {
      for(i in 0...binarray.length*4)
      {
				str += tab.charAt((binarray[i >> 2] >> ((i%4)*8+4)) & 0xF) + tab.charAt((binarray[i >> 2] >> ((i%4)*8)) & 0xF);
			}
			return str;
		}
	}
