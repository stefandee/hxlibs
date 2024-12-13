package spill.localisation;

import flash.display.MovieClip;
import flash.events.Event;

class BrandingFlag extends MovieClip
{
  public var language (default, setLanguage) : String;
  
  private var flags : MovieClip;
  
  public function new(flags : MovieClip)
  {
    super();

    stop();

    this.flags = flags;

    addChild(flags);
    flags.stop();

    //mouseEnabled = false;
    mouseChildren = false;    
  }

  public function setLanguage(v : String) : String
  {
	  // check if the language is a valid string
    var language = Languages.getLanguage(v);

    if (language == null)
    {
      return this.language;
    }
    
    this.language = v;
    
    flags.gotoAndStop(v);

    return this.language;
  }
}