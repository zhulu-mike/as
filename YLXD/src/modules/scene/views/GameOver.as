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
			var ratio:Number = GameInstance.instance.scaleRatio;
			var f:Number = 80 * ratio;
			patternTxt = new TextField(640*ratio,AirUtil.getHeightByFontSize(f),"","Verdana",f,0xffffff,true);
			patternTxt.hAlign = HAlign.CENTER;
			this.addChild(patternTxt);
			patternTxt.x = GameInstance.instance.sceneWidth - patternTxt.width >> 1;
			patternTxt.filter = GameUtil.getTextFieldFIlter();
			
			img = new Image(ResManager.assetsManager.getTexture("duizhan_bg"));
			this.addChild(img);
			img.scaleX = img.scaleY = ratio;
			img.x = GameInstance.instance.sceneWidth - img.width >> 1;
			img.y = patternTxt.y + patternTxt.height;
			
			maxScoreTxt = new TextField(960*ratio,AirUtil.getHeightByFontSize(f),"","Verdana",f,0x00ffff);
			this.addChild(maxScoreTxt);
			maxScoreTxt.hAlign = HAlign.CENTER;
			maxScoreTxt.x = GameInstance.instance.sceneWidth - maxScoreTxt.width >> 1;
			maxScoreTxt.y = img.y + img.height + 20;
			maxScoreTxt.filter = GameUtil.getTextFieldFIlter();
			
			scoreTxt = new TextField(960*ratio,AirUtil.getHeightByFontSize(f),"","Verdana",f,0xffffff);
			this.addChild(scoreTxt);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.x = GameInstance.instance.sceneWidth - scoreTxt.width >> 1;
			scoreTxt.y = maxScoreTxt.y + maxScoreTxt.height + 32*ratio;
			scoreTxt.filter = GameUtil.getTextFieldFIlter();
			
			
			var rw:Number = 320*ratio;
			f = 100*ratio;
			returnBtn = new TextField(rw,AirUtil.getHeightByFontSize(f),Language.FANHUI,"Verdana",f,0xffffff);
			this.addChild(returnBtn);
			returnBtn.x = (GameInstance.instance.sceneWidth >> 1) - 600*ratio;
			returnBtn.y = scoreTxt.y + scoreTxt.height + 94*ratio;
			returnBtn.filter = GameUtil.getTextFieldFIlter();
			
			againBtn = new TextField(rw,AirUtil.getHeightByFontSize(f),Language.CHONGLAI,"Verdana",f,0xffffff);
			this.addChild(againBtn);
			againBtn.x = (GameInstance.instance.sceneWidth >> 1) + 600*ratio-rw;
			againBtn.y = returnBtn.y ;
			againBtn.filter = GameUtil.getTextFieldFIlter();
			
			xuanYaoBtn = new TextField(rw,AirUtil.getHeightByFontSize(f),Language.XUANYAO,"Verdana",f,0xffffff);
			this.addChild(xuanYaoBtn);
			xuanYaoBtn.x = GameInstance.instance.sceneWidth - xuanYaoBtn.width >> 1;
			xuanYaoBtn.y = returnBtn.y ;
			xuanYaoBtn.filter = GameUtil.getTextFieldFIlter();
			
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