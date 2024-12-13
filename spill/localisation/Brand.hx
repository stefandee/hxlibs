package spill.localisation;

extern class Brand {
	var backgroundColor(default,null) : UInt;
	var domain : String;
	var emailLink : String;
	var emailPage : String;
	var hasSendToFriendLink : Bool;
	var hostingDomain : String;
	var id : Float;
	var isExternal : Bool;
	var moreLink : String;
	var name : String;
	var portalGroup : UInt;
	var preferedLanguage : String;
	var site_id : UInt;
	var useGoogleAnalitics : Bool;
	function new() : Void;
	function exportXML() : flash.xml.XML;
	function getMoreGamesLink(gameName : String, isExternal : Bool, ?externalDomain : String, ?term : String) : String;
	function getPromotionLink(gameName : String, emailPage : String, isExternal : Bool, ?externalDomain : String, ?term : String) : String;
	function getSendToFriendLink(gameName : String, emailPage : String, isExternal : Bool, ?externalDomain : String) : String;
	function importXML(xml : flash.xml.XMLNode) : Void;
}
