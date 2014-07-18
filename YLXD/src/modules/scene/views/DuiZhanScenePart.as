package modules.scene.views
{
	import configs.GameInstance;
	
	import events.GameEvent;
	
	import starling.display.Quad;

	public class DuiZhanScenePart extends SceneBase
	{
		
		private var bg:Quad;
		
		public function DuiZhanScenePart($sceneHeight:int)
		{
			super($sceneHeight);
			bg = new Quad(GameInstance.instance.sceneWidth,$sceneHeight,0xffffff);
			bg.alpha = 0;
			this.addChild(bg);
			scoreTxt.y = 30;
			mainPlayer.y = $sceneHeight *0.5;
		}
		
		override protected function endGame():void
		{
			gameOver.visible = true;
			EventCenter.instance.dispatchGameEvent(GameEvent.CHECK_RACE_END);
		}
		
		
	}
}