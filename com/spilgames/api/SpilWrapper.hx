package com.spilgames.api;

import flash.events.ErrorEvent;
import flash.events.Event;

class SpilWrapper extends flash.display.Sprite
{
  public function new()
  {
  }

  public function connect()
  {
    var spilGamesServices:SpilGamesServices = SpilGamesServices.getInstance();
    spilGamesServices.addEventListener("servicesReady", onServicesReady);
    spilGamesServices.addEventListener("servicesFailed", onServicesFailed);
    spilGamesServices.connect(this);
  }

  private function onServicesReady(e:Event):void
  {
    trace("SpilGamesServices are ready\n");
  }
  
  private function onServicesFailed(e:ErrorEvent):void
  {
    trace("SpilGamesServices failed: " + e.text + "\n");
  }
}