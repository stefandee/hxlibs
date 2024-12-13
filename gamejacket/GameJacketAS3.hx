//*********************************************************************************************************
// Port to HaXe by Karg - karg@pirongames.com
// File: GameJacketAS3.hx
// Platform: ActionScript 3 code
// Version: 0.7.1
// Copyright (C) 2007-2008 GameJacket Limited. All rights reserved.
//*********************************************************************************************************
package gamejacket;

import flash.display.Sprite;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.text.TextField;
import flash.system.Security;

class GameJacketAS3 extends Sprite {
  private var _AS3Version:String;
  private var _gameVar:String;
  private var _s:String;
  private var _GJID:String;
  private var _gameHost:String;
  private var _gameDomain:String;
  private var _gameExclude:String;
  private var _nNumberSecurity:Int;
  private var _adOptions:Dynamic;
  private var _IDataLoader:Loader;
  private var _IDataHolder:Dynamic;

  public function new() {
    super();

    _AS3Version      = "0.7.1";
    _s               = "";
    _GJID            = "";
    _gameHost        = "";
    _gameDomain      = "";
    _gameExclude     = "";
    _nNumberSecurity = 0;
    _adOptions       = null;
    _IDataLoader     = new Loader();
    //_IDataHolder     = new Object;

    flash.system.Security.allowDomain('app5.gamejacket.net','app6.gamejacket.net','app7.gamejacket.net','app8.gamejacket.net','app9.gamejacket.net');
    flash.system.Security.allowDomain('app.gamejacket.net','app1.gamejacket.net','app2.gamejacket.net','app3.gamejacket.net','app4.gamejacket.net');
  }
  
  //**********************************************************************************************************
  // Function: GJVersion()
  // Returns: The SDK version
  //**********************************************************************************************************
  public function GJVersion():String {
    return _AS3Version;
  }

  //**********************************************************************************************************
  // Function: GJHost()
  // Returns: The raw Host URL e.g. http://www.gamejacket.com/games/GJ00002.swf
  //**********************************************************************************************************
  public function GJHost():String {
    return _gameHost;
  }
  
  //**********************************************************************************************************
  // Function: GJHost()
  // Returns: The Host URL just the domain e.g. www.gamejacket.com
  //**********************************************************************************************************
  public function GJHostDomain():String {
    return _gameDomain;
  }

  //**********************************************************************************************************
  // Function: setVariables(param:LoaderInfo)
  // Returns: none
  //**********************************************************************************************************
  public function setVariables(param:LoaderInfo):Void {

    var vParams : Dynamic = param.parameters;

    /*
    var keyStr : String;
    for (keyStr in vParams) {
      var valueStr:String = String(vParams[keyStr]);
      if (keyStr == 'gameVar') {
        _gameVar = valueStr;
      } else if (keyStr == 's') {
        _s = valueStr;
      } else if (keyStr == 'GJID') {
        _GJID = valueStr;
      } else if (keyStr == 'gameHost') {
        _gameHost = valueStr;
      } else if (keyStr == 'gameDomain') {
        _gameDomain = valueStr;
      } else if (keyStr == 'gameExclude') {
        _gameExclude = valueStr;
      }
    }
    */

    // karg: puah?
    if (vParams == null)
    {
      return;
    }

    if (vParams.gameVar != null)
    {
      _gameVar = cast(vParams.gameVar, String);
    }
    
    if (vParams.s != null)
    {
      _s = cast(vParams.s, String);
    }

    if (vParams.GJID != null)
    {
      _GJID = cast(vParams.GJID, String);
    }

    if (vParams.gameHost != null)
    {
      _gameHost = cast(vParams.gameHost, String);
    }

    if (vParams.gameDomain != null)
    {
      _gameDomain = cast(vParams.gameDomain, String);
    }

    if (vParams.gameExclude != null)
    {
      _gameExclude = cast(vParams.gameExclude, String);
    }

    checkNumber();
  }
  
  //**********************************************************************************************************
  // Depreciated: Since 0.6b this was used to check if the security code had been added to the game
  // Function: checkMe()
  // Returns: number
  //**********************************************************************************************************
  public function checkMe():Int {
    return 1;
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function dispatchSecurityEvent():Void {
    if (_nNumberSecurity == 1) {
      dispatchEvent(new Event("GameJacketPass"));
    } else {
      dispatchEvent(new Event("GameJacketFail"));
    }
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function checkNumber():Void {
    var checkLoader:URLLoader=new URLLoader();
    checkLoader.addEventListener(Event.COMPLETE,checkLoaded);
    checkLoader.addEventListener(IOErrorEvent.IO_ERROR,checkIOError);

    var checkRequest:URLRequest=new URLRequest(_s + "gameCheck.asp?gameVar="+_gameVar+"&random="+Math.random());
    checkLoader.load(checkRequest);
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function checkLoaded(e:Event):Void {
    var myXML:flash.xml.XML=new flash.xml.XML(e.currentTarget.data);

    // karg: looks like fun!
    _nNumberSecurity = Std.parseInt(myXML.child("game").child("r").toString());/*myXML.game.r*/

    trace("_nNumberSecurity :" + _nNumberSecurity);

    dispatchSecurityEvent();
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function checkIOError(e:IOErrorEvent):Void {
    dispatchSecurityEvent();
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  public function showAd(?options : Dynamic):Void
  {
    _adOptions = options;
    
    if (_gameExclude!='pass')
    {
      callEndFunction();
    }
    else
    {
      if (_IDataLoader.contentLoaderInfo.contentType == null)
      {
        // load the swf in as it doesnt exist
        _IDataLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeIDataSWF);
        _IDataLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorIDataSWF);

        var newRequest:URLRequest = new URLRequest(_s + "GJIDataAS3.swf");	
        _IDataLoader.load(newRequest);

      }
      else
      {
        initiateAdvert();
      }
    }
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function completeIDataSWF(e:Event):Void {
    initiateAdvert(e);
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function ioErrorIDataSWF(e:IOErrorEvent):Void {
    advertError();
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function initiateAdvert(?e:Event):Void {
    if (e != null) {
      _IDataHolder = e.target;
    }

    //if (_adOptions.bgAlpha == undefined){
    if (Reflect.hasField(_adOptions, "bgAlpha")) {
      _adOptions.bgAlpha = 1;
    }
    
    _IDataHolder.loader.content.loadDetails(_GJID, _adOptions.bgColour, _adOptions.bgAlpha, _s, this.root.stage);
    _IDataHolder.loader.content.addEventListener("GameJacketAdError", advertError);
    _IDataHolder.loader.content.addEventListener("GameJacketAdEnd", advertEnd);

    _adOptions.adDisplayObject.addChild(_IDataLoader);
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function advertError(?e : Event):Void
  {
    //if (_adOptions.errorFunction is Function)
    if (Reflect.isFunction(_adOptions.errorFunction))
    {
      _adOptions.adDisplayObject.removeChild(_IDataLoader);

      //if (_adOptions.errorParameters is Object)
      if (Reflect.isObject(_adOptions.errorParameters))
      {
        _adOptions.errorFunction(_adOptions.errorParameters);
      }
      else
      {
        _adOptions.errorFunction();
      }
    }
    else
    {
      advertEnd(new Event(""));
    }
  }
  
  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function advertEnd(e:Event):Void
  {
    _adOptions.adDisplayObject.removeChild(_IDataLoader);			
    callEndFunction();
  }

  //**********************************************************************************************************
  // Function: ()
  // Returns: 
  //**********************************************************************************************************
  private function callEndFunction():Void {
    //if (_adOptions.endFunction is Function) {
    if (Reflect.isFunction(_adOptions.endFunction)) {
      //if (_adOptions.endParameters is Object) {
        if (Reflect.isObject(_adOptions.endParameters)) {
        _adOptions.endFunction(_adOptions.endParameters);
      } else {
        _adOptions.endFunction();
      }
    } else {
      // no end function
    }
  }
}
