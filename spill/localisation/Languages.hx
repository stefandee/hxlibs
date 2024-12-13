package spill.localisation;

extern class Languages {
	static var languages : Dynamic;
	static function exportXML() : flash.xml.XMLNode;
	static function getLanguage(name : String) : Language;
	static function getLanguageByOldID(id : Int) : Language;
	static function getLanguagesArray() : Array<Dynamic>;
	static function initialize() : Void;
}
