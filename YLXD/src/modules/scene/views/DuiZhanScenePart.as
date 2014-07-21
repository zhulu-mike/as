package modules.scene.views
{
	import flash.utils.getTimer;
	
	import configs.GameInstance;
	import configs.PlayerStatus;
	
	import events.GameEvent;
	
	import managers.BackGroundFactory;
	
	import starling.display.Image;
	import starling.display.QuadBatch;

	public class DuiZhanScenePart extends SceneBase
	{
		
		private var bg:QuadBatch;
		
		public function DuiZhanScenePart($sceneHeight:int)
		{
			super($sceneHeight);
			bg = new QuadBatch();
			this.addChildAt(bg,0);
			scoreTxt.y = 30;
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
			var i:int = 0, len:int = bgImages.length;
			var img:Image;
			for (;i<len;i++)
			{
				img = bgImages[i];
				if (img.parent)
					img.removeFromParent();
				BackGroundFactory.getInstance().recycleShape(img);
			}
		}
		
		private function backgroundUpdate():void
		{
			bg.reset();
			var i:int = 0, len:int = bgImages.length;
			var img:Image;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = bgImages[i];
				if (img.x+img.width <= 0)
				{
					BackGroundFactory.getInstance().recycleShape(img)
					img.removeFromParent();
					bgImages.splice(i,1);
					len--;
					i--;
				}else{
					img.x -= sceneSpeed;
					bg.addImage(img);
				}
			}
			createBackground();
		}
		
		private var bgImages:Array = [];
		private function createBackground():void
		{
			var i:int = 0, len:int = bgImages.length;
			var img:Image;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = bgImages[i];
				trace(img.x);
				if (img.x < 0)
					totalWidth += (img.width + img.x);
				else
					totalWidth += img.width;
			}
			while (GameInstance.instance.sceneWidth > totalWidth)
			{
				img = BackGroundFactory.getInstance().getShape();
				img.scaleY = sceneHeight / 480;
				bg.addImage(img);
				bgImages.push(img);
				img.x = totalWidth;
				totalWidth += img.width;
			}
		}
	}
}