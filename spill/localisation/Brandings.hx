package spill.localisation;

extern class Brandings {
	static function exportXML() : XML;
	static function getBrandByDomain(domain : String) : Brand;
	static function getBrandByID(id : Float) : Brand;
	static function getBrandsArray() : Array<Dynamic>;
	static function hasDomain(domain : String) : Bool;
	static function initialize() : Void;
}
