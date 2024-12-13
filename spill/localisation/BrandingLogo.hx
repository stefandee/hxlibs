package spill.localisation;

import flash.display.MovieClip;
import flash.events.Event;

class BrandingLogo extends MovieClip
{
  private var logos : MovieClip;
  
  public function new(logos : MovieClip)
  {
    super();

    stop();

    this.logos = logos;

    addChild(logos);
    logos.stop();

    //mouseEnabled = false;
    mouseChildren = false;			
    addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
    addEventListener(Event.REMOVED_FROM_STAGE, removed, false, 0, true);
    //if(stage != null) added();
    added();
    brandingChanged();
  }

  private function added(?e:Event = null)
  {
    SpilGame.addEventListener("brandingChanged", brandingChanged, false, 0, true);
    brandingChanged();
  }
  
  private function removed(e:Event)
  {
    SpilGame.removeEventListener("brandingChanged", brandingChanged);
  }
  
  public function brandingChanged(?e:Event = null)
  {			
    if (SpilGame.currentBranding != null)
    {
      trace("branding changed to: " + SpilGame.currentBranding.domain);
      
      logos.gotoAndStop(SpilGame.currentBranding.domain);
      //logos.cacheAsBitmap = true;
    }
  }
}