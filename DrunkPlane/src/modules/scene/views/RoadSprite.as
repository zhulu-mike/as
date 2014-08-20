package modules.scene.views
{
	import configs.GameInstance;
	
	import managers.ResManager;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	
	public class RoadSprite extends Sprite
	{
		private var roads:QuadBatch;
		public var mainSpeed:int;
		public function RoadSprite()
		{
			super();
			roads = new QuadBatch();
			this.addChild(roads);
			roads.blendMode = BlendMode.NONE;
			roadItem = new Image(ResManager.assetsManager.getTexture("road"));
			roadItemWidth = roadItem.width-10;
		}
		
		private var roadImages:Array = [];
		private var roadItem:Image;
		private var roadItemWidth:int;
		
		public function update(dis:int):void
		{
			roads.reset();
			var i:int = 0, len:int = roadImages.length;
			var img:Object;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = roadImages[i];
				if (img.x+img.width-dis <= 0)
				{
					roadImages.splice(i,1);
					len--;
					i--;
				}else{
					img.x -= dis;
					roadItem.x = img.x;
					roads.addImage(roadItem);
				}
			}
			createRoad();
		}
		
		private function createRoad():void
		{
			var i:int = 0, len:int = roadImages.length;
			var img:Object;
			var totalWidth:int = 0;
			for (;i<len;i++)
			{
				img = roadImages[i];
				if (img.x < 0)
					totalWidth += (img.width + img.x);
				else
					totalWidth += img.width;
			}
			while (GameInstance.instance.sceneWidth > totalWidth)
			{
				roadItem.x = totalWidth;
				roads.addImage(roadItem);
				roadImages.push({x:totalWidth,width:roadItemWidth});
				totalWidth += roadItemWidth;
			}
		}
	}
}