package modules.scene.views
{
	import flash.utils.getTimer;
	
	import configs.GameInstance;
	import configs.PlayerStatus;
	
	import events.GameEvent;
	
	import managers.BackGroundFactory;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;

	public class DuiZhanScenePart extends SceneBase
	{
		
		private var bg:QuadBatch;
		private var bgItem:Image;
		private var bgItemWidth:int;
		
		public function DuiZhanScenePart($sceneHeight:int)
		{
			super($sceneHeight);
			bg = new QuadBatch();
			this.addChildAt(bg,0);
			bg.blendMode = BlendMode.NONE;
			bgItem = BackGroundFactory.getInstance().getShape();
			bgItem.height = sceneHeight;
			bgItemWidth = bgItem.width-1;
			scoreTxt.y = 30;
//			createBackground();
		}
		
		override protected function doUpdate():void
		{
			backgroundUpdate();
		}
		
		override protected function endGame():void
		{
			gameOver.visible = true;
			EventCenter.instance.dispatchGameEvent(GameEvent.CHECK_RACE_END);
		}
		
		override protected function doWhenpass(door:Door):void
		{
			super.doWhenpass(door);
			if (door.isReverse && mainPlayer.playerStatus == PlayerStatus.COMMON)
			{
				//加速
				mainPlayer.playerStatus = PlayerStatus.WUDI;
				lastWuDiTime = getTimer();
				sceneSpeed += GameInstance.WUDISPEED;
				mainPlayer.setSpeed(sceneSpeed);
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			bg.reset();
			bg.removeFromParent();
			bgImages.length = 0;
			BackGroundFactory.getInstance().recycleShape(bgItem);
		}
		
		private function backgroundUpdate():void
		{
			bg.reset();
			var i:int = 0, len:int = bgImages.length;
			var img:Object;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = bgImages[i];
				if (img.x+img.width-sceneSpeed <= 0)
				{
					bgImages.splice(i,1);
					len--;
					i--;
				}else{
					img.x -= sceneSpeed;
					bgItem.x = img.x;
					bg.addImage(bgItem);
				}
			}
			createBackground();
		}
		
		private var bgImages:Array = [];
		private function createBackground():void
		{
			
//			bgItem.x = -400;
//			bg.addImage(bgItem);
//			bgItem.x = 399;
//			bg.addImage(bgItem);
//			return;
			var i:int = 0, len:int = bgImages.length;
			var img:Object;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = bgImages[i];
				if (img.x < 0)
					totalWidth += (img.width + img.x);
				else
					totalWidth += img.width;
			}
			while (GameInstance.instance.sceneWidth > totalWidth)
			{
				bgItem.x = totalWidth;
				bg.addImage(bgItem);
				bgImages.push({x:totalWidth,width:bgItemWidth});
				totalWidth += bgItemWidth;
			}
		}
	}
}