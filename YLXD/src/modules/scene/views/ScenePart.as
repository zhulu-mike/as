package modules.scene.views
{
	import com.mike.utils.AirUtil;
	
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	import configs.PlayerStatus;
	
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
		private var ratio:Number = GameInstance.instance.scaleRatio;
		
		public function ScenePart($sceneHeight:int)
		{
			super($sceneHeight);
			
//			bg = new Quad(GameInstance.instance.sceneWidth,$sceneHeight,0xffffff);
//			bg.alpha = 0;
//			this.addChildAt(bg,0);
//			mainPlayer.y = 330 - mainPlayer.height;
			
			maxScoreTxt = new TextField(500*ratio,AirUtil.getHeightByFontSize(76*ratio),"","Verdana",76*ratio,0x89c997);
			this.addChild(maxScoreTxt);
			maxScoreTxt.x = 10;
			maxScoreTxt.y = 10;
			maxScoreTxt.touchable = false;
			maxScoreTxt.filter = GameUtil.getTextFieldFIlter();
			
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
		
		override protected function doWhenpass(door:Door):void
		{
			super.doWhenpass(door);
			if (door.isReverse && mainPlayer.playerStatus == PlayerStatus.COMMON && GameInstance.instance.pattern != GamePattern.NIXIANG)
			{
				//加速
				addSpeed = 0;
				mainPlayer.playerStatus = PlayerStatus.WUDI;
				lastWuDiTime = getTimer();
//				sceneSpeed += GameInstance.WUDISPEED;
//				mainPlayer.setSpeed(sceneSpeed);
			}
		}
		
	}
}