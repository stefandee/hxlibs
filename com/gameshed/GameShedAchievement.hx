package com.gameshed;

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
class GameShedAchievement 
{
  static private var NOT_INITIALIZED:String = "-2";
  static private var USER_ID_NOT_FOUND:String = "-1";
  static private var _userId:String = "-2";
  static private var _crypto:String = "4i26_4_8du";
  static private var GAME_SHED_ACHIEVEMENT_URL:String = "http://www.gameshed.com/_a_a/ach_ord.php";
  static private var _locked (getLocked, setLocked) : Bool;

  static public function Init(loaderInfo : LoaderInfo, encryptoKey:String) : Void
  {
    _crypto = encryptoKey;
    Security.allowDomain("http://www.gameshed.com");
    var paramObj = loaderInfo.parameters;
    
    if (paramObj.user == null)  
    {
      _userId = USER_ID_NOT_FOUND;	
    } 
    else 
    {
      try
      {
        _userId = paramObj.user;
      }
      catch(e : Dynamic)
      {
        _userId = USER_ID_NOT_FOUND;        
      }
    }

    _locked = false;
  }
  
  static public function ActivateAchievement(achievementId : Float) : Void
  {
    SendStuff(achievementId);	
  }
  
  static private function SendStuff(achievementId : Float) : Void
  {
    if(_locked) return ;
    
    if(_userId == NOT_INITIALIZED) 
    {
      throw new flash.Error("GameShedAchievement API hasn't been initialized.  You must call GameShedAchievement.Init(this.root) before sending achievements."); 
    } 
    else if(_userId == USER_ID_NOT_FOUND) 
    {
      trace("GameShedAchievementAPI.ActivateAchievement() :: User Id not found, please contact a developer from gameshed.com for further infos.");
      return ;
    }
    
    var user_id:String = "user_id=" + GetGameShedUserId();
    var achievment:String = "achievement_id=" + achievementId;
    var strKey:String = achievementId + _crypto + GetGameShedUserId();
    var key : String = "key=" + haxe.Md5.encode(strKey);
    var postParams:URLVariables = new URLVariables(user_id + "&" + achievment + "&" + key);         //variable storing Post Params
    var request:URLRequest = new URLRequest(GAME_SHED_ACHIEVEMENT_URL);
    request.data = postParams;                   
    request.method = URLRequestMethod.POST;
    var loader:URLLoader = new URLLoader();
    loader.load(request);
  }
  
  static public function GetGameShedUserId() : String 
  {
    return _userId;
  } 
      
  static public function getLocked() : Bool 
  {
    return _locked;
  }
  
  static public function setLocked(locked : Bool) : Bool 
  {
    _locked = locked;

    return _locked;
  }
}
