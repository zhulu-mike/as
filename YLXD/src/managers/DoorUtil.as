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
				if (player1 == null){
					player1 = new MovieClip(ResManager.assetsManager.getTextures("player1"));
					player1.loop = true;
				}
				return player1;
			}else if (state == PlayerState.CIRCLE)
			{
				if (player2 == null){
					player2 = new MovieClip(ResManager.assetsManager.getTextures("player2"));
					player2.loop = true;
				}
				return player2;
			}else{
				if (player3 == null){
					player3 = new MovieClip(ResManager.assetsManager.getTextures("player3"));
					player3.loop = true;
				}
				return player3;
			}
		}
		
		private static var player1:MovieClip;
		private static var player2:MovieClip;
		private static var player3:MovieClip;
				
	}
}