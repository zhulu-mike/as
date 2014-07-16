package modules.scene.views
{
	import configs.GameInstance;
	import configs.GameState;
	
	import events.GameEvent;
	
	import so.cuo.platform.baidu.BaiDu;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class GameOver extends Sprite
	{
		
		public var patternTxt:TextField;
		public var maxScoreTxt:TextField;
		public var scoreTxt:TextField;
		public var returnBtn:TextField;
		public var againBtn:TextField;
		public var xuanYaoBtn:TextField;
		
		
		public function GameOver()
		{
			patternTxt = new TextField(200,40,"","Verdana",30,0,true);
			this.addChild(patternTxt);
			patternTxt.x = GameInstance.instance.sceneWidth - patternTxt.width >> 1;
			patternTxt.y = 10;
			
			maxScoreTxt = new TextField(300,40,"","Verdana",30,0xff0000);
			this.addChild(maxScoreTxt);
			maxScoreTxt.hAlign = HAlign.CENTER;
			maxScoreTxt.x = GameInstance.instance.sceneWidth - maxScoreTxt.width >> 1;
			maxScoreTxt.y = (GameInstance.instance.sceneHeight - maxScoreTxt.height >> 1) - 100;
			
			scoreTxt = new TextField(300,40,"","Verdana",30,0);
			this.addChild(scoreTxt);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.x = GameInstance.instance.sceneWidth - scoreTxt.width >> 1;
			scoreTxt.y = maxScoreTxt.y + 50;
			
			returnBtn = new TextField(100,40,Language.FANHUI,"Verdana",30,0);
			this.addChild(returnBtn);
			returnBtn.x = (GameInstance.instance.sceneWidth >> 1) - 250;
			returnBtn.y = scoreTxt.y + 100;
			
			againBtn = new TextField(100,40,Language.CHONGLAI,"Verdana",30,0);
			this.addChild(againBtn);
			againBtn.x = (GameInstance.instance.sceneWidth >> 1) + 150;
			againBtn.y = returnBtn.y ;
			
			xuanYaoBtn = new TextField(100,40,Language.XUANYAO,"Verdana",30,0);
			this.addChild(xuanYaoBtn);
			xuanYaoBtn.x = GameInstance.instance.sceneWidth - xuanYaoBtn.width >> 1;
			xuanYaoBtn.y = returnBtn.y ;
			
			this.returnBtn.addEventListener(TouchEvent.TOUCH, onReturn);
			this.againBtn.addEventListener(TouchEvent.TOUCH, onPlayAgain);
			
		}
		
		private function onPlayAgain(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				this.removeFromParent();
				BaiDu.getInstance().hideBanner();
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.RUNNING, pattern:GameInstance.instance.pattern});
			}
		}
		
		private function onReturn(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				this.removeFromParent();
				BaiDu.getInstance().hideBanner();
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.BEGIN});
			}
		}
	}
}