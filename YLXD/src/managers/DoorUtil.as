package managers
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import configs.PlayerState;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;

	public class DoorUtil
	{
		public function DoorUtil()
		{
		}
		
		public static function getDoorShape(state:int):DisplayObject
		{
			var shape:DisplayObject;
			shape = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture(state+".png"));
			return shape;
			switch (state)
			{
				case PlayerState.RECT:
//					shape = new Quad(30,30,0x00ff00);
					shape = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture(state+".png"));
					break;
				case PlayerState.TRIANGLE:
//					var circle:Shape = new Shape();
//					circle.graphics.beginFill(0x00ff000);
//					circle.graphics.moveTo(15,0);
//					circle.graphics.lineTo(0,30);
//					circle.graphics.lineTo(30,30);
//					circle.graphics.lineTo(15,0);
//					circle.graphics.endFill();
//					var bmd:BitmapData = new BitmapData(circle.width,circle.height,true,0);
//					bmd.draw(circle);
//					shape = new Image(Texture.fromBitmapData(bmd));
					shape = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture(state+".png"));
					break;
				case PlayerState.CIRCLE:
					var circle:Shape = new Shape();
					circle.graphics.beginFill(0x00ff000);
					circle.graphics.drawCircle(15,15,15);
					circle.graphics.endFill();
					var bmd:BitmapData = new BitmapData(circle.width,circle.height,true,0);
					bmd.draw(circle);
					shape = new Image(Texture.fromBitmapData(bmd));
					break;
			}
			return shape;
		}
	}
}