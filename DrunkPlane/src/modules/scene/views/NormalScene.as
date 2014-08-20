package modules.scene.views
{
	import com.components.ArrowGriphic;
	import com.mike.utils.AirUtil;
	import com.mike.utils.MathUtil;
	
	import flash.geom.Point;
	
	import configs.FlyDirection;
	import configs.GameConfig;
	import configs.GameInstance;
	import configs.PipeDirection;
	
	import managers.GameUtil;
	import managers.ResManager;
	import managers.SoundManager;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class NormalScene extends Sprite implements ISceneBase
	{
		protected var sceneWidth:int = 0;
		private var bg:BackGroundSprite;
		
		public var mainPlayer:MainPlayer;
		private var pipeLayer:Sprite;
		private var scoreTxt:TextField;
		public var end:Boolean = false;
		/**
		 * 是否开始画
		 */		
		private var isBeginDraw:Boolean = false;
		/**
		 * 是否结束画
		 */		
		private var isEndDraw:Boolean = true;
		
		protected var pipeList:Array;
		protected var hammerList:Array = [];
		private var baseY:Number = 0;
		private var _mainSpeed:int = 5;
		private var nextPipeDis:int = 0;
		private var currentDis:int = 0;
		private var _score:int = 0;
		private var drawRoads:Array = [];
		
		private var hammerLayer:Sprite;
		private var cloudBatch:QuadBatch;
		private var cloudItem:Image;
		private var cloudWidth:int;
		private var cloudList:Array = [];
		
		public function NormalScene($sceneWidth:int)
		{
			this.touchGroup = true;
			var ratio:Number = GameInstance.instance.scaleRatio;
			sceneWidth = $sceneWidth;
			
			
			bg = new BackGroundSprite($sceneWidth);
			this.addChild(bg);
			
			cloudBatch = new QuadBatch();
			this.addChild(cloudBatch);
			cloudItem = new Image(ResManager.assetsManager.getTexture("swing_cloud.png"));
			cloudItem.scaleX = ratio;
			cloudItem.scaleY = ratio;
			cloudItem.blendMode = BlendMode.SCREEN;
			cloudWidth = cloudItem.width;
			
			pipeLayer = new Sprite();
			this.addChild(pipeLayer);
			
			hammerLayer = new Sprite();
			this.addChild(hammerLayer);
			
			
			mainPlayer = new MainPlayer();
			this.addChild(mainPlayer);
			mainPlayer.x = $sceneWidth - mainPlayer.width >> 1;
			mainPlayer.y = GameInstance.instance.sceneHeight - ResManager.assetsManager.getTexture("swing_floor.png").height*ratio;
			mainPlayer.originy = mainPlayer.y;
			currentDis = nextPipeDis = mainPlayer.y - GameConfig.verticalGap ;
			
			baseY = $sceneWidth * 0.6875;
			
			scoreTxt = new TextField(480*ratio,AirUtil.getHeightByFontSize(45*ratio),Language.getString("DEFEN").replace("$SCORE",0),"Verdana",45*ratio,0xffffff,true);
			scoreTxt.hAlign = HAlign.CENTER;
			scoreTxt.vAlign = VAlign.CENTER;
			this.addChild(scoreTxt);
			scoreTxt.filter = GameUtil.getTextFieldFIlter();
			scoreTxt.x = GameInstance.instance.sceneWidth - scoreTxt.width-200 >> 1;
			scoreTxt.y = 10;
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			pipeList = [];
			makeClouds();
			makePipess();
			bg.update(0);
		}
		
		private var currentArrowGrapich:ArrowGriphic;
		private var beginPoint:Point;
		private var endPoint:Point;
		
		protected function onTouch(event:TouchEvent):void
		{
			var touchs:Vector.<Touch> = event.touches;
			var touch:Touch = touchs[0];
			if (touch.target == this && !this.end && !GameInstance.isPause() && touch.phase == TouchPhase.ENDED)
			{
				if (!mainPlayer.begin)
					mainPlayer.begin = true;
				jump();
			}
		}
		
		/**
		 * 跳跃
		 * 
		 */		
		private function jump():void
		{
			trace("jump");
			mainPlayer.direct = mainPlayer.direct == FlyDirection.LEFT ? FlyDirection.RIGHT : FlyDirection.LEFT;
		}
		
		public function update():void
		{
			if (!mainPlayer.begin)
				return;
			if (end)
				return;
			mainPlayer.update();
			if (mainPlayer.x >= sceneWidth){
				mainPlayer.x = sceneWidth;
			}
			updaetPipes();
			updaetHammers();
			updaetClouds();
			isHitIce();
			movePipes();
			makeClouds();
			makePipess();
			bg.update(mainSpeed);
		}
		
		/**
		 * 删除已经无效的冰块
		 * 
		 */		
		private function updaetPipes():void
		{
			var pipe:Pipe;
			var i:int = 0,j:int=0,len:int = pipeList.length, len2:int = 0;
			for (;i<len;i++)
			{
				pipe = pipeList[i];
				if (pipe.y-GameConfig.pipeHeight >= GameInstance.instance.sceneHeight)
				{
					pipe.destroy();
					pipeList.splice(i,1);
					len--;
					i--;
				}
			}
		}
		/**
		 * 删除已经无效的锤子
		 * 
		 */		
		private function updaetHammers():void
		{
			var hammer:Hammer;
			var i:int = 0,j:int=0,len:int = hammerList.length, len2:int = 0;
			for (;i<len;i++)
			{
				hammer = hammerList[i];
				if (hammer.y >= GameInstance.instance.sceneHeight)
				{
					hammer.removeFromParent(true);
					hammerList.splice(i,1);
					len--;
					i--;
				}else{
					hammer.y += mainSpeed;
					if (!hammer.isPassed && hammer.y >= mainPlayer.y)
					{
						hammer.isPassed = true;
					}
				}
			}
		}
		
		/**
		 * 删除已经无效的云朵
		 * 
		 */		
		private function updaetClouds():void
		{
			var cloud:Object;
			var i:int = 0,j:int=0,len:int = cloudList.length;
			for (;i<len;i++)
			{
				cloud = cloudList[i];
				if (cloud.y-cloud.height >= GameInstance.instance.sceneHeight)
				{
					cloudList.splice(i,1);
					len--;
					i--;
				}
			}
			cloudBatch.reset();
			len = cloudList.length;
			for (i=0;i<len;i++)
			{
				cloud = cloudList[i];
				cloud.y += mainSpeed;
				cloudItem.x = cloud.x;
				cloudItem.y = cloud.y;
				cloudBatch.addImage(cloudItem);
			}
		}
		
		
		
		/**
		 * 是否撞到冰块上了
		 * 
		 */		
		private function isHitIce():void
		{
			var pipe:Pipe;
			for each (pipe in pipeList)
			{
				if (pipe.isPassed)
					continue;
				if (pipe.contentRect.intersects(mainPlayer.contentRect))
				{
					gameOver();
				}
			}
		}
		
		/**
		 * 移动冰块的坐标
		 * 
		 */		
		private function movePipes():int
		{
			var pipe:Pipe;
			var i:int = 0,j:int=0,len:int = pipeList.length;
			var moveDis:int = 0;
			if (moveDis <= 0)
				moveDis = mainSpeed;
			var s:int= 0;
			for (i=0;i<len;i++)
			{
				pipe = pipeList[i];
				pipe.y += moveDis;
				if (!pipe.isPassed && pipe.y-GameConfig.pipeHeight >= mainPlayer.y)
				{
					pipe.isPassed = true;
					s = 1;
				}
			}	
			if (s > 0)
			{
				score += s;
				SoundManager.playSound(ResManager.PASS_SOUND);
			}
			currentDis += moveDis;
			return moveDis;
		}
		
		private function makeClouds():void
		{
			var totalH:int = 0;
			var half:int = (sceneWidth-cloudWidth*2)>>1;
			while (true)
			{
				if (cloudList.length < 1)
				{
					totalH = mainPlayer.y - GameConfig.cloudGap - cloudItem.height;
					makeCloud(half, totalH,0);
				}else{
					var cloud:Object = cloudList[cloudList.length- 1];
					if (cloud.y - cloud.height-GameConfig.cloudGap>=-50)
					{
						totalH = cloud.y - cloud.height-GameConfig.cloudGap;
						var dir:int = cloud.dir==0?1:0;
						makeCloud(dir==0?half:half+cloudWidth,totalH,dir);
					}else{
						return;
					}
				}
			}
		}
		
		private function makeCloud(xx:int, yy:int,dir:int):void
		{
			cloudList.push({x:xx,y:yy,height:cloudItem.height,dir:dir});
			cloudItem.x = xx;
			cloudItem.y = yy;
			cloudBatch.addImage(cloudItem);
		}
		
		/**
		 * 检测是否需要生成管道
		 * 
		 */		
		private function makePipess():void
		{
			while (true)
			{
				if (pipeList.length < 1)
				{
					nextPipeDis = mainPlayer.y - GameConfig.verticalGap - GameConfig.pipeHeight;
					makePipe();
				}else{
					var pipe:Pipe = pipeList[pipeList.length- 1];
					if (pipe.y - GameConfig.pipeHeight-GameConfig.verticalGap>=-50)
					{
						nextPipeDis = pipe.y - GameConfig.pipeHeight-GameConfig.verticalGap;
						makePipe();
					}else{
						return;
					}
				}
			}
		}
		
		/**
		 * 根据规则随机创造管道
		 * 
		 */		
		private function makePipe():void
		{
			var h:int = MathUtil.random(GameConfig.minWidth, GameConfig.maxWidth);
			var pipe:Pipe = new Pipe(PipeDirection.LEFT, h);
			pipeLayer.addChild(pipe);
			pipe.y = nextPipeDis;
			pipeList.push(pipe);
			
			var hammer:Hammer = new Hammer();
			hammer.x = h - 7;
			hammer.y = pipe.y + GameConfig.pipeHeight;
			hammerLayer.addChild(hammer);
			hammerList.push(hammer);
			
			pipe = new Pipe(PipeDirection.RIGHT, sceneWidth-h-GameConfig.horizalGap);
			pipeLayer.addChild(pipe);
			pipe.y = nextPipeDis;
			pipe.x = h+GameConfig.horizalGap;
			pipeList.push(pipe);
			hammer = new Hammer();
			hammer.x = pipe.x + 7;
			hammer.y = pipe.y + GameConfig.pipeHeight;
			hammerLayer.addChild(hammer);
			hammerList.push(hammer);
		}
		
		
		private function gameOver():void
		{
			end = true;
			mainPlayer.playDead();
		}
		
		public function destroy():void
		{
		}

		/**
		 * 主角速度
		 */
		public function get mainSpeed():int
		{
			return _mainSpeed;
		}

		/**
		 * @private
		 */
		public function set mainSpeed(value:int):void
		{
			_mainSpeed = value;
		}
		
		/**
		 * 暂停
		 * 
		 */		
		public function pauseGame():void
		{
			
		}
		
		/**
		 * 继续
		 * 
		 */		
		public function restart():void
		{
			
		}

		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score = value;
			scoreTxt.text = Language.getString("DEFEN").replace("$SCORE",value);
		}


	}
}