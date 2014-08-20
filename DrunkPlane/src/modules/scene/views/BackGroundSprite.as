package modules.scene.views
{
	import configs.GameInstance;
	
	import managers.ResManager;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	
	public class BackGroundSprite extends Sprite
	{
		private var bg:QuadBatch;
		public var mainSpeed:int = 0;
		public function BackGroundSprite($sceneWidth:Number)
		{
			bg = new QuadBatch();
			this.addChild(bg);
			bg.blendMode = BlendMode.NONE;
			bgItem = new Image(ResManager.assetsManager.getTexture("swing_bg.png"));
			bgItem.width = $sceneWidth;
			bgItemHeight = bgItem.height-1;
		}
		
		public function update(dis:int):void
		{
			bg.reset();
			var i:int = 0, len:int = bgImages.length;
			var img:Object;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = bgImages[i];
				if (img.y+img.height-dis <= 0)
				{
					bgImages.splice(i,1);
					len--;
					i--;
				}else{
					img.y -= dis;
					bgItem.y = img.y;
					bg.addImage(bgItem);
				}
			}
			createBackground();
		}
		
		private var bgImages:Array = [];
		private var bgItem:Image;
		private var bgItemHeight:int;
		private function createBackground():void
		{
			var i:int = 0, len:int = bgImages.length;
			var img:Object;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = bgImages[i];
				if (img.y < 0)
					totalWidth += (bgItemHeight + img.y);
				else
					totalWidth += bgItemHeight;
			}
			while (GameInstance.instance.sceneHeight > totalWidth)
			{
				bgItem.y = totalWidth;
				bg.addImage(bgItem);
				bgImages.push({y:totalWidth,height:bgItemHeight});
				totalWidth += bgItemHeight;
			}
		}
	}
}