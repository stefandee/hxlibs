extern class GCBrainInterface {
	function new(p1 : flash.display.Stage) : Void;
	function begin(p1 : String) : Void;
	function onGCEvent(p1 : String, p2 : Dynamic) : Void;
	function sendNotification(p1 : String, p2 : Dynamic, ?p3 : String) : Void;
	static var apiType : String;
}
