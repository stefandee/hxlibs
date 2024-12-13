package com.spilgames.localization;

class SpilGamesLink extends gamelib.microvcl.Control
{
  public function new(parentControl : gamelib.microvcl.Control, name : String, displayTactics : gamelib.microvcl.DisplayTactics, autoAdd : Bool)
  {
    super(parentControl, name, displayTactics, autoAdd);
  }

  public function createUI()
  {
    this.onClickEvent = onCustomClick;
    this.buttonMode = true;
  }

  private function onCustomClick(e : flash.events.MouseEvent)
  {
    gamelib.Utils.openLink(SpilGame.getSpilCompanyLink());    
  }
}
