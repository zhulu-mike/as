package modules.scene.views
{
	
	import configs.GameInstance;
	import configs.GamePattern;
	import configs.GameState;
	
	import events.GameEvent;
	
	import managers.GameUtil;
	import managers.ResManager;
	import managers.SoundManager;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.RelationPosition;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class GameScene extends Sprite
	{
		private var maxScoreTxt:TextField;
		[Embed(source="../../../assets/background.jpg")]
		private var BackGroundBG:Class;
		
		private var middleLayer:Sprite;
		public function GameScene()
		{
			
			EventCenter.instance.addEventListener(GameEvent.CHECK_RACE_END, checkRaceEnd);
			EventCenter.instance.addEventListener(GameEvent.PLAY_GAME_OVER_SOUND, playGameOverSound);
			var bg:Image = new Image(Texture.fromEmbeddedAsset(BackGroundBG));
			this.addChild(bg);
			bg.width = GameInstance.instance.sceneWidth;
			bg.height = GameInstance.instance.sceneHeight;
			middleLayer = new Sprite();
			this.addChild(middleLayer);
			maxScoreTxt = new TextField(300,40,"","Verdana",24,0x89c997);
			this.addChild(maxScoreTxt);
			maxScoreTxt.visible = false;
			maxScoreTxt.x = GameInstance.instance.sceneWidth - maxScoreTxt.width >> 1;
			maxScoreTxt.y = 0;
		}
		
		
		
		public var sceneList:Vector.<ScenePart> = new Vector.<ScenePart>();
		
		public function start(pattern:int):void
		{
			destory();
			switch (pattern)
			{
				case GamePattern.PUTONG:
				case GamePattern.NIXIANG:
					makePuTong();
					showMaxScore(pattern);
					BaiDu.getInstance().showBanner(BaiDu.BANNER,RelationPosition.BOTTOM_CENTER);
					break;
				case GamePattern.FIGHT:
					makeDuiZhan();
					hideMaxScore();
					break;
			}
		}
		
		/**
		 * 先销毁之前的
		 * 
		 */		
		private function destory():void
		{
			var s:ScenePart;
			for each (s in sceneList)
			{
				s.destroy();
				middleLayer.removeChild(s);
			}
			sceneList.length = 0;
		}
		/**
		 * 普通模式
		 * 
		 */		
		private function makePuTong():void
		{
			var scene:ScenePart = new ScenePart(GameInstance.instance.sceneHeight);
			middleLayer.addChild(scene);
			sceneList.push(scene);
		}
		
		
		/**
		 * 对战
		 * 
		 */		
		private function makeDuiZhan():void
		{
			var h:int = GameInstance.instance.sceneHeight >> 1;
			var scene:ScenePart = new ScenePart(h);
			middleLayer.addChild(scene);
			sceneList.push(scene);
			scene = new ScenePart(h);
			middleLayer.addChild(scene);
			scene.y = h;
			sceneList.push(scene);
		}
		
		private function showMaxScore(pattern:int):void
		{
			maxScoreTxt.visible = true;
			var score:int = GameUtil.getMaxScore(pattern);
			maxScoreTxt.text = Language.MAX_SCORE.replace("$SCORE",score);
			EventCenter.instance.addEventListener(GameEvent.UPDATE_MAX_SCORE, updateMaxScore);
		}
		
		protected function updateMaxScore(event:GameEvent):void
		{
			var score:int = GameUtil.getMaxScore(GameInstance.instance.pattern);
			maxScoreTxt.text = Language.MAX_SCORE.replace("$SCORE",score);
		}
		
		private function hideMaxScore():void
		{
			maxScoreTxt.visible = false;
			EventCenter.instance.removeEventListener(GameEvent.UPDATE_MAX_SCORE, updateMaxScore);
		}
		
		public function update():void
		{
			var s:ScenePart;
			for each (s in sceneList)
			{
				s.update();
			}
		}
		
		private function checkRaceEnd(event:GameEvent):void
		{
			if (sceneList[0].end && sceneList[1].end)
			{
				if (sceneList[0].score > sceneList[1].score)
				{
					sceneList[0].gameOver.text = Language.YINGLE;
					sceneList[1].gameOver.text = Language.WOSHULE;
				}else if (sceneList[0].score == sceneList[1].score)
				{
					sceneList[0].gameOver.text = Language.PINGJU;
					sceneList[1].gameOver.text = Language.PINGJU;
				}else{
					sceneList[0].gameOver.text = Language.WOSHULE;
					sceneList[1].gameOver.text = Language.YINGLE;
				}
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touchs:Vector.<Touch> = event.touches;
			var touch:Touch = touchs[0];
			if (touch.phase == TouchPhase.ENDED)
			{
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
				EventCenter.instance.dispatchGameEvent(GameEvent.GAME_STATE_CHANGE, {state:GameState.OVER});
			}
		}
		
		private function playGameOverSound(e:GameEvent):void
		{
			SoundManager.playSound(ResManager.GAME_OVER);
		}
	}
}