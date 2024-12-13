package com.mindjolt.api.as3;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.net.URLRequest;
import flash.events.Event;

class MindjoltAPI
{
  //
  // You'll use this variable to access the API
  //   (make sure you can access it from wherever you will later call submitScore)
  public var api : Dynamic;

  //
  // All of this code should be executed at the very beginning of the game
  //

  public function new()
  {
    // get the parameters passed into the game
    var gameParams = flash.Lib.current.loaderInfo.parameters;

    var url : String = gameParams.mjPath;

    if (url == null)
    {
      url = "http://static.mindjolt.com/api/as3/scoreapi_as3_local.swf";
    }

    // manually load the API
    var urlLoader:Loader = new Loader();
    urlLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadFinished);
    urlLoader.load(new URLRequest(url));

    flash.Lib.current.addChild(urlLoader);
  }

  private function onLoadFinished (e : Event)
  {
      try
      {
        api = e.currentTarget.content;
        api.service.connect();
      }
      catch(msg : Dynamic)
      {
        api = null;

        trace("Could not load the MindJolt score service!");
      }

      trace ("[MindJoltAPI] service manually loaded");
  }

  public function submitScore(score : Int) : Bool
  {
    if (api != null)
    {
      api.service.submitScore(score);

      return true;
    }

    return false;
  }

  public function submitScoreWithMode(score : Int, mode : String) : Bool
  {
    if (api != null)
    {
      api.service.submitScore(score, mode);

      return true;
    }

    return false;
  }  
}