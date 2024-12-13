package spill.localisation;

extern class PortalGroup {
	static var FAMILY : UInt;
	static var GIRL : UInt;
	static var HYVES : UInt;
	static var NONE : UInt;
	static var TEENS : UInt;
	static var YOUNG_ADULTS : UInt;
	static var ZAPAPA : UInt;
	static var backgroundColors : Array<Dynamic>;
	static var channelNames : Array<Dynamic>;
	static function exportXML() : flash.xml.XMLNode;
	static function getName(id : Int) : String;
}
