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
		
		public static function getDoorShape(state:int,isReverse:Boolean=false):Image
		{
			var shape:Image;
			if (!isReverse){
				if (state == PlayerState.STONE)
					return MonsterStoneFactory.getInstance().getShape();
				else if (state == PlayerState.JIANDAO)
					return MonsterJianDaoFactory.getInstance().getShape();
				else
					return MonsterBuFactory.getInstance().getShape();
			}else
			{
				if (state == PlayerState.STONE)
					return MonsterStoneFactory.getInstance().getShapeReverse();
				else if (state == PlayerState.JIANDAO)
					return MonsterJianDaoFactory.getInstance().getShapeReverse();
				else
					return MonsterBuFactory.getInstance().getShapeReverse();
			}
			return shape;
		}
		public static function recycleDoorShape(img:Image,state:int,isReverse:Boolean=false):void
		{
			var shape:DisplayObject;
			if (!isReverse){
				if (state == PlayerState.STONE)
					 MonsterStoneFactory.getInstance().recycleShape(img);
				else if (state == PlayerState.JIANDAO)
					 MonsterJianDaoFactory.getInstance().recycleShape(img);
				else
					 MonsterBuFactory.getInstance().recycleShape(img);
			}else
			{
				if (state == PlayerState.STONE)
					 MonsterStoneFactory.getInstance().recycleReverseShape(img);
				else if (state == PlayerState.JIANDAO)
					 MonsterJianDaoFactory.getInstance().recycleReverseShape(img);
				else
					 MonsterBuFactory.getInstance().recycleReverseShape(img);
			}
		}
		
		public static function getPlayerMC(state:int):MovieClip
		{
			if (state == PlayerState.STONE)
			{
				return MainPlayerStoneFactory.getInstance().getShape();
			}else if (state == PlayerState.JIANDAO)
			{
				return MainPlayerJianDaoFactory.getInstance().getShape();
			}else{
				return MainPlayerBuFactory.getInstance().getShape();
			}
		}
		
		public static function recyclePlayerMC(state:int, mc:MovieClip):void
		{
			if (state == PlayerState.STONE)
			{
				 MainPlayerStoneFactory.getInstance().recycleShape(mc);
			}else if (state == PlayerState.JIANDAO)
			{
				 MainPlayerJianDaoFactory.getInstance().recycleShape(mc);
			}else{
				 MainPlayerBuFactory.getInstance().recycleShape(mc);
			}
		}
	}
}