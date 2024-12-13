package com.spilgames.api;

extern class SpilGamesServices extends flash.display.MovieClip {
	var connecting(default,null) : Bool;
	var connection(default,null) : Dynamic;
	var version(default,null) : String;
	private function new(?access : Dynamic) : Void;
	function allowDomain(domain : String) : Void;
	function bringToFront(?e : flash.events.Event) : Void;
	function connect(clip : flash.display.DisplayObjectContainer) : Void;
	function disconnect() : Void;
	function getChannelID() : Int;
	function getItemID() : Int;
	function getSiteID() : Int;
	function isDomainAllowed() : Bool;
	function isReady() : Bool;
	function send(serviceID : String, functionName : String, cback : Dynamic, ?args : Dynamic) : Int;
	static var INVALID_ID : Int;
	static function getInstance() : SpilGamesServices;
}
