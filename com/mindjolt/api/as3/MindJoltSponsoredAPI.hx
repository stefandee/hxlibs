package com.mindjolt.api.as3;

	import flash.net.URLLoader;
  import flash.net.URLVariables;
  import flash.net.URLRequest;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
  import flash.net.URLRequestMethod;
  import flash.net.URLLoaderDataFormat;
  import flash.system.Security;
	import flash.external.ExternalInterface;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.DisplayObject;
	import com.meychi.ascrypt3.RC4;

	class MindJoltSponsoredAPI
	{
		private static  var gameId:String;
		private static  var key:String;
		private static  var flashCookie:SharedObject;
		private static  var connected:Bool = false;
		private static  var displayObject : Dynamic;
		//
		// method for connecting
		//
		public static  function connect (_gameId:String,_key:String,_displayObject : Dynamic)
		{
			//if (Type.getClass(_displayObject) == flash.display.MovieClip) {
			//if (_displayObject is DisplayObject) {
				if (!connected) {
					flashCookie=SharedObject.getLocal("com.mindjolt","/");
					flashCookie.objectEncoding = flash.net.ObjectEncoding.AMF0;
			
					gameId=_gameId.toUpperCase();
					key=_key.toUpperCase();
					displayObject = /*_displayObject;*/flash.Lib.current;
					trace(displayObject.loaderInfo.loaderURL);
					
					connected = true;
				} else
					trace("already connected!");
			//} 
      //else 
      //{
			//	trace("Error: MindJoltSponsoredAPI requires a displayobject.  Try passing in root.");
			//}
		}

		// method for posting scores
		public static  function submitScore (name:String, score : Int,mode:String=null)
		{
			//
			// DO we have a flash cookie already?  if so, retrieve it
			//
			var userToken:String = null;
			
			trace("testing if we have a userToken in shared object yet");
			if (flashCookie.data.userToken != null)
			{
				userToken=flashCookie.data.userToken;
				trace("FOUND [" + userToken + "]");
			}
			else
			{
				userToken=null;
				trace("no userToken set");
			}

			var rc4:RC4 = new RC4();

			var session:String=rc4.encrypt("score=" + score 
										   + "&name=" + StringTools.htmlEscape(name)/*escape(name)*/ 
										   + (mode != null ? "&mode=" + StringTools.htmlEscape(mode)/*escape(mode)*/ : "")
										   + (userToken != null ? "&userToken=" + StringTools.htmlEscape(userToken)/*escape(userToken)*/ : "")
										   , key);
			//
			//
			// creating URLLoader object
			//
			var send_lv:URLVariables=new URLVariables();
			send_lv.gameId=gameId;
			send_lv.session=session;

			var request:URLRequest=new URLRequest();
			request.url="http://game.mindjolt.com/servlet/GameScore";
			request.method=URLRequestMethod.POST;
			request.data=send_lv;

			var loader:URLLoader=new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE,finishedSubmitScore);
			loader.addEventListener(IOErrorEvent.IO_ERROR,failedSubmitScore);
			try
			{
				loader.load (request);
			}
			catch (e:Dynamic)
			{
				trace ("SubmitScore send data Error: " + e);
			}
		}

		private static function failedSubmitScore(event:Event) : Void
		{
			trace("IOError in SubmitScore");
		}

		private static function finishedSubmitScore(event:Event) : Void
		{
			var session:String = event.target.data.session;

			if (session != null) {
				trace("got back session");
				var rc4:RC4 = new RC4();

				// decrypt the session variable, and then split it into separate variables
				var sessionVars:URLVariables = new URLVariables();
				sessionVars.decode(rc4.decrypt(session, key));
				//
				// we can now give the var token a value
				//
				var userToken:String = sessionVars.userToken;
				trace("result [" + sessionVars.result + "]");
				if (userToken != null) {
					trace("we are being told to set userToken [" + userToken + "]");
					//
					// response will be a userToken.  store this in the flash cookie, so we'll remember it for next time
					//
					flashCookie.data.userToken = userToken;
					flashCookie.flush();
				}
			}
		}
		//
		// method for opening a link
		//
		public static  function openLink (linkId : Int, ?mode : String) : Void
		{
			var url:String="http://game.mindjolt.com/servlet/GameLink?key=" + gameId + "&link=" + linkId  
			+ ((mode != null) ? "&mode=" + StringTools.htmlEscape(mode)/*escape(mode)*/ : "")
			+ "&httpref=" + StringTools.htmlEscape(displayObject.loaderInfo.loaderURL)/*escape(displayObject.loaderInfo.loaderURL)*/;

			// if browserAgent ends up null, we will use navigateToUrl
			var browserAgent:String = null;
			try {
				if (ExternalInterface.available)
					browserAgent = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			} catch (e:Dynamic) {
				browserAgent = null;
			}
			//
			// have to do it this way, because of the way some popup-blockers work
			//
			if ((browserAgent != null)
				&& ExternalInterface.available
				&& ((browserAgent.indexOf("Firefox") >= 0) 
					|| (browserAgent.indexOf("MSIE") >= 0))) {
				trace("window.open");
				ExternalInterface.call("window.open",url);
			} else {  
				trace("navigatetourl");

        // karg: replaced with the haxe version
				//navigateToURL (new URLRequest(url),"_blank");
        flash.Lib.getURL(new URLRequest(url),"_blank");
			}
		}
	}
