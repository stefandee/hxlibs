package spill.localisation;

extern class SpilGame {
	static var BRANDING_CHANGED : String;
	static var LANGUAGE_CHANGED : String;
	static var cookieLanguage : Language;
	static var currentBranding : Brand;
	static var currentLanguage : Language;
	static var debugEmbedDomain : String;
	static var debugHostDomain : String;
	static var emailPage : String;
	static var embedDomain(default,null) : String;
	static var gameName : String;
	static var hostingDomain(default,null) : String;
	static var isExternal(default,null) : Bool;
	static var isStagingDomain(default,null) : Bool;
	static var portalGroup : UInt;
	static var systemLanguage(default,null) : Language;
	static function addEventListener(type : String, listener : Dynamic, ?useCapture : Bool, ?priority : Int, ?useWeakReference : Bool) : Void;
	static function changeLanguage(langid : String) : Void;
	static function chooseBranding() : Void;
	static function chooseLanguage() : Void;
	static function dispatchEvent(event : flash.events.Event) : Void;
	static function exportXML() : flash.xml.XML;
	static function getMoreGamesLink(?term : String) : String;
	static function getPromotionLink(?term : String) : String;
	static function getSendToFriendLink() : String;
	static function getSpilCompanyLink() : String;
	static function getString(identifier : String) : String;
	static function importXML(data : flash.xml.XML) : Void;
	static function importXMLv2(data : flash.xml.XML) : Void;
	static function initTextField(txt : flash.text.TextField) : Void;
	static function initialize(_gameName : String, _portalGroup : Int, _emailPage : String, s : flash.display.Sprite, ?_channelLock : Bool) : Void;
	static function outputAllBrands() : String;
	static function removeEventListener(type : String, listener : Dynamic, ?useCapture : Bool) : Void;
	static function traceAllBrands() : Void;
}
