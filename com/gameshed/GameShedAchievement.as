package com.gameshed {
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;	

	/**
	 * @author GameShed
	 */
	public class GameShedAchievement {
		static private const NOT_INITIALIZED:String = "-2";
		static private const USER_ID_NOT_FOUND:String = "-1";
		static private var _userId:String = "-2";
		static private var _crypto:String = "4i26_4_8du";
		static private const GAME_SHED_ACHIEVEMENT_URL:String = "http://www.gameshed.com/_a_a/ach_ord.php";
		static private var _locked:Boolean = false;

		static public function Init(d : DisplayObject, encryptoKey:String) : void {
			_crypto = encryptoKey;
			Security.allowDomain("http://www.gameshed.com");
			var paramObj:Object = d.root.loaderInfo.parameters;
			
			if(paramObj.user == null)  {
				_userId = USER_ID_NOT_FOUND;	
			} else {
				_userId = String(paramObj.user);
			}
		}
		
		static public function ActivateAchievement(achievementId:Number) : void {
			SendStuff(achievementId);	
		}
		
		static private function SendStuff(achievementId:Number):void {
			if(_locked) return ;
			if(_userId == NOT_INITIALIZED) {
				throw new Error("GameShedAchievement API hasn't been initialized.  You must call GameShedAchievement.Init(this.root) before sending achievements."); 
			} else if(_userId == USER_ID_NOT_FOUND) {
				trace("GameShedAchievementAPI.ActivateAchievement() :: User Id not found, please contact a developer from gameshed.com for further infos.");
				return ;
			}
			
			var user_id:String = "user_id=" + GetGameShedUserId();
			var achievment:String = "achievement_id=" + achievementId;
			var strKey:String = achievementId + _crypto + GetGameShedUserId();
			var key : String = "key=" + MD5.calcMD5(strKey);
			var postParams:URLVariables = new URLVariables(user_id + "&" + achievment + "&" + key);         //variable storing Post Params
			var request:URLRequest = new URLRequest(GAME_SHED_ACHIEVEMENT_URL);
			request.data = postParams;                   
			request.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			loader.load(request);
		}
		
		static public function GetGameShedUserId():String {
			return _userId;
		} 
				
		static public function get locked() : Boolean {
			return _locked;
		}
		
		static public function set locked(locked : Boolean) : void {
			_locked = locked;
		}
	}
}
