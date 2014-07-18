package modules.scene.views
{
	import flash.utils.setTimeout;
	
	import configs.GameInstance;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.GameUtil;
	import managers.ResManager;
	import managers.SoundManager;
	
	import starling.display.Quad;
	import starling.text.TextField;
	
	public class ScenePart extends SceneBase
	{
		private var bg:Quad;
		private var beyondMax:Boolean = false;
		private var maxScoreTxt:TextField;
		
		public function ScenePart($sceneHeight:int)
		{
			super($sceneHeight);
			
			bg = new Quad(GameInstance.instance.sceneWidth,$sceneHeight,0xffffff);
			bg.alpha = 0;
			this.addChild(bg);
			scoreTxt.y = 60;
			mainPlayer.y = 330 - mainPlayer.height;
			
			maxScoreTxt = new TextField(300,40,"","Verdana",24,0x89c997);
			this.addChild(maxScoreTxt);
			maxScoreTxt.x = GameInstance.instance.sceneWidth - maxScoreTxt.width >> 1;
			maxScoreTxt.y = 0;
			
			showMaxScore();
		}
		
		private function showMaxScore():void
		{
			var score:int = GameUtil.getMaxScore(GameInstance.instance.pattern);
			maxScoreTxt.text = Language.MAX_SCORE.replace("$SCORE",score);
		}
		
		protected function updateMaxScore(value:int):void
		{
			maxScoreTxt.text = Language.MAX_SCORE.replace("$SCORE",value);
		}
		
		override protected function isHit():void
		{
			super.isHit();
			if (!end)
				isBeyondMax();
		}
		
		private function isBeyondMax():void
		{
			if (GameUtil.getMaxScore(GameInstance.instance.pattern) < sceneScore)
			{
				//突破最高纪录
				GameUtil.setMaxScore(GameInstance.instance.pattern, sceneScore);
				updateMaxScore(sceneScore);
				if (!beyondMax){
					beyondMax = true;
					SoundManager.playSound(ResManager.BEYOND_MAX);
				}
			}
		}
		
		override protected function endGame():void
		{
			EventCenter.instance.dispatchGameEvent(GameEvent.PLAY_GAME_OVER_SOUND);
			setTimeout(function():void
			{
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE, {state:GameState.OVER});
			},1000);
		}
		
		override public function set sceneSpeed(value:int):void
		{
			super.sceneSpeed = value;
			GameInstance.instance.currentSpeed = value;
		}
		
	}
}