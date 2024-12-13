package gamelib.api;

class KongAPI 
{ 
  var kongregate: Dynamic; 
  
  public function new() 
  { 
    kongregate = null; 
    
    var parameters = flash.Lib.current.loaderInfo.parameters; 
    var url: String; 
    
    url = parameters.api_path; 
    
    if(url == null) url = "http://www.kongregate.com/flash/API_AS3_Local.swf"; 
    
    var request = new flash.net.URLRequest(url); 
    var loader = new flash.display.Loader(); 
    
    loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, OnLoadComplete); 
    loader.load(request); 
    flash.Lib.current.addChild(loader); 
  } 
  
  function OnLoadComplete(e: flash.events.Event) 
  { 
    try 
    { 
      kongregate = e.target.content; 
      kongregate.services.connect(); 
    } 
    catch(msg: Dynamic) 
    { 
      kongregate = null; 
    } 
  } 
  
  public function SubmitScore(score: Float, mode: String) 
  { 
    if(kongregate != null) 
    { 
      kongregate.scores.submit(score, mode); 
    } 
  } 
  
  public function SubmitStat(name: String, stat: Float) 
  { 
    if(kongregate != null) 
    { 
      kongregate.stats.submit(name, stat); 
    } 
  } 
} 