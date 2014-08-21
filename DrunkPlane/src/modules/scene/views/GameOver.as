package modules.scene.views
{
	import com.mike.utils.AirUtil;
	import com.mike.utils.ShareManager;
	
	import configs.GameInstance;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.GameUtil;
	import managers.ResManager;
	
	import starling.display.Image;
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
		public var img:Image;
		
		
		public function GameOver()
		{
			var ratio:Number = 1;
			img = new Image(ResManager.assetsManager.getTexture("swing_base_score.png"));
			this.addChild(img);
			
			maxScoreTxt = new TextField(240*ratio,AirUtil.getHeightByFontSize(30),"","Verdana",30,0x000000);
			this.addChild(maxScoreTxt);
			maxScoreTxt.hAlign = HAlign.CENTER;
			maxScoreTxt.x = img.width - maxScoreTxt.width >> 1;
			maxScoreTxt.y = img.y + 290;
//			maxScoreTxt.filter = GameUtil.getTextFieldFIlter();
			
			scoreTxt = new TextField(240*ratio,AirUtil.getHeightByFontSize(30),"","Verdana",30,0x000000);
			this.addChild(scoreTxt);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.x = img.width - scoreTxt.width >> 1;
			scoreTxt.y = img.y + 166;
//			scoreTxt.filter = GameUtil.getTextFieldFIlter();
			
			
			var rw:Number = 160*ratio;
			var f:Number = 50*ratio;
			returnBtn = new TextField(rw,AirUtil.getHeightByFontSize(f),Language.getString("FANHUI"),"Verdana",f,0);
			this.addChild(returnBtn);
			returnBtn.y = 430;
//			returnBtn.filter = GameUtil.getTextFieldFIlter();
			
			againBtn = new TextField(rw,AirUtil.getHeightByFontSize(f),Language.getString("CHONGLAI"),"Verdana",f,0);
			this.addChild(againBtn);
			againBtn.x = img.width - rw;
			againBtn.y = returnBtn.y ;
//			againBtn.filter = GameUtil.getTextFieldFIlter();
			
			xuanYaoBtn = new TextField(rw,AirUtil.getHeightByFontSize(f),Language.getString("XUANYAO"),"Verdana",f,0xff0000);
			this.addChild(xuanYaoBtn);
			xuanYaoBtn.x = img.width - rw >> 1;
			xuanYaoBtn.y = returnBtn.y ;
//			xuanYaoBtn.filter = GameUtil.getTextFieldFIlter();
			
			this.returnBtn.addEventListener(TouchEvent.TOUCH, onReturn);
			this.againBtn.addEventListener(TouchEvent.TOUCH, onPlayAgain);
			this.xuanYaoBtn.addEventListener(TouchEvent.TOUCH, onXuanYao);
			
		}
		
		
		
		private function onXuanYao(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				ShareManager.instance.xuanYao();
			}
		}
		
		
		
		private function onPlayAgain(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				this.removeFromParent();
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.RUNNING, pattern:GameInstance.instance.pattern});
			}
		}
		
		private function onReturn(e:TouchEvent):void
		{
			var touch:Touch = e.touches[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				this.removeFromParent();
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE,{state:GameState.BEGIN});
			}
		}
	}
}