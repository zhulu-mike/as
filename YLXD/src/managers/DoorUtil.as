package managers
{
	import configs.PlayerState;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;

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
		
		public static function getPlayerMC(state:int):MovieClip
		{
			if (state == PlayerState.RECT)
			{
				return MainPlayerStoneFactory.getInstance().getShape();
			}else if (state == PlayerState.CIRCLE)
			{
				return MainPlayerJianDaoFactory.getInstance().getShape();
			}else{
				return MainPlayerBuFactory.getInstance().getShape();
			}
		}
		
		public static function recyclePlayerMC(state:int, mc:MovieClip):void
		{
			if (state == PlayerState.RECT)
			{
				 MainPlayerStoneFactory.getInstance().recycleShape(mc);
			}else if (state == PlayerState.CIRCLE)
			{
				 MainPlayerJianDaoFactory.getInstance().recycleShape(mc);
			}else{
				 MainPlayerBuFactory.getInstance().recycleShape(mc);
			}
		}
	}
}