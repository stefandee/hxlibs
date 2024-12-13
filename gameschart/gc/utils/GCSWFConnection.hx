package gc.utils;

extern class GCSWFConnection extends flash.events.EventDispatcher {
	var clientVersion : String;
	var connected(default,never) : Bool;
	var id(default,never) : String;
	function new(p1 : String, p2 : Dynamic, ?p3 : String) : Void;
	function GC_utils_GCSWFConnection_init(p1 : String) : Void;
	function GC_utils_GCSWFConnection_receive(p1 : String, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic, ?p6 : Dynamic) : Void;
	function close() : Void;
	function send(p1 : String, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic, ?p6 : Dynamic) : Void;
	static var CONNECTED : String;
}
