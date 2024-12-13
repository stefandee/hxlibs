package spill.localisation;

extern class Language {
	var bwcId : Int;
	var displayAcronim(default,null) : String;
	var displayName : String;
	var dname : String;
	var embedFonts : Bool;
	var embedInputFonts : Bool;
	var forceFont : String;
	var id : UInt;
	var name : String;
	var p_family : String;
	var p_girl : String;
	var p_hyves : String;
	var p_teen : String;
	var p_tween : String;
	var p_zapapa : String;
	var portal_groups : Array<Dynamic>;
	var references : Array<Dynamic>;
	var textLanguage : String;
	function new(_name : String, ?_dname : String) : Void;
	function exportXML() : flash.xml.XMLNode;
}
