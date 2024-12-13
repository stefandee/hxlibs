//*********************************************************************************************************
// File: GameJacketAS3.as
// Platform: ActionScript 3 code
// Version: 0.7.1
// Copyright (C) 2007-2008 GameJacket Limited. All rights reserved.
//*********************************************************************************************************
package {
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

	public class GameJacketAS3 extends Sprite {
		private var _AS3Version:String = '0.7.1';
		private var _gameVar:String;
		private var _s:String = '';
		private var _GJID:String = '';
		private var _gameHost:String = '';
		private var _gameDomain:String = '';
		private var _gameExclude:String = '';
		private var _nNumberSecurity:Number = 0;
		private var _adOptions:Object = null;
		private var _IDataLoader:Loader = new Loader();
		private var _IDataHolder:Object = new Object();

		public function GameJacketAS3() {
			flash.system.Security.allowDomain('app.gamejacket.net','app1.gamejacket.net','app2.gamejacket.net','app3.gamejacket.net','app4.gamejacket.net','app5.gamejacket.net','app6.gamejacket.net','app7.gamejacket.net','app8.gamejacket.net','app9.gamejacket.net');
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
		public function setVariables(param:LoaderInfo):void {

			var vParams:Object = param.parameters;

			for (var keyStr:String in vParams) {
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
			
			checkNumber();
		}
		
		//**********************************************************************************************************
		// Depreciated: Since 0.6b this was used to check if the security code had been added to the game
		// Function: checkMe()
		// Returns: number
		//**********************************************************************************************************
		public function checkMe():Number {
			return 1;
		}
		
		//**********************************************************************************************************
		// Function: ()
		// Returns: 
		//**********************************************************************************************************
		private function dispatchSecurityEvent():void {
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
		private function checkNumber():void {
			var checkLoader:URLLoader=new URLLoader;
			checkLoader.addEventListener(Event.COMPLETE,checkLoaded);
			checkLoader.addEventListener(IOErrorEvent.IO_ERROR,checkIOError);

			var checkRequest:URLRequest=new URLRequest(_s + "gameCheck.asp?gameVar="+_gameVar+"&random="+Math.random());
			checkLoader.load(checkRequest);
		}
		
		//**********************************************************************************************************
		// Function: ()
		// Returns: 
		//**********************************************************************************************************
		private function checkLoaded(e:Event):void {
			var myXML:XML=new XML(e.currentTarget.data);
			_nNumberSecurity = Number(myXML.game.r);

			dispatchSecurityEvent();
		}
		
		//**********************************************************************************************************
		// Function: ()
		// Returns: 
		//**********************************************************************************************************
		private function checkIOError(e:IOErrorEvent):void {
			dispatchSecurityEvent();
		}
		
		//**********************************************************************************************************
		// Function: ()
		// Returns: 
		//**********************************************************************************************************
		public function showAd(options:Object = null):void
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
		private function completeIDataSWF(e:Event):void {
			initiateAdvert(e);
		}
		
		//**********************************************************************************************************
		// Function: ()
		// Returns: 
		//**********************************************************************************************************
		private function ioErrorIDataSWF(e:IOErrorEvent):void {
			advertError();
		}
		
		//**********************************************************************************************************
		// Function: ()
		// Returns: 
		//**********************************************************************************************************
		private function initiateAdvert(e:Event = null):void {
			if (e != null) {
				_IDataHolder = e.target;
			}
			if (_adOptions.bgAlpha == undefined){
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
		private function advertError(e:Event = null):void
		{
			if (_adOptions.errorFunction is Function)
			{
				_adOptions.adDisplayObject.removeChild(_IDataLoader);
				if (_adOptions.errorParameters is Object)
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
		private function advertEnd(e:Event):void
		{
			_adOptions.adDisplayObject.removeChild(_IDataLoader);			
			callEndFunction();
		}

		//**********************************************************************************************************
		// Function: ()
		// Returns: 
		//**********************************************************************************************************
		private function callEndFunction():void {
			if (_adOptions.endFunction is Function) {
				if (_adOptions.endParameters is Object) {
					_adOptions.endFunction(_adOptions.endParameters);
				} else {
					_adOptions.endFunction();
				}
			} else {
				// no end function
			}
		}
	}
}