package managers
{
	import starling.display.DisplayObject;
	import starling.display.Image;

	public class DoorUtil
	{
		public function DoorUtil()
		{
		}
		
		public static function getDoorShape(state:int,isReverse:Boolean=false):DisplayObject
		{
			var shape:DisplayObject;
			if (!isReverse)
				shape = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture(state+".png"));
			else
				shape = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture(state+"reverse.png"));
			return shape;
		}
	}
}