package managers
{
	import com.mike.utils.BaseFactory;
	
	import starling.display.Image;
	
	public class MonsterJianDaoFactory extends BaseFactory
	{
		public function MonsterJianDaoFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<1;i++)
				{
					freePools.push(new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture("2.png")));
					freePools2.push(new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture("2reverse.png")));
				}
			}
		}
		
		private static var instance:MonsterJianDaoFactory;
		
		public static function getInstance():MonsterJianDaoFactory
		{
			if (!instance)
				instance = new MonsterJianDaoFactory();
			return instance;
		}
		
		public  function getShape():Image
		{
			var voo:Image;
			if (freePools.length <= 0)
			{
				voo = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture("2.png"));
			}
			else
			{
				voo = freePools.shift();
			}
			usePools.push(voo);
			return voo;
		}
		
		/**
		 * 回收
		 */
		public function recycleShape(voo:Image):void
		{
			var index:int = usePools.indexOf(voo);
			if (index >= 0)
			{
				usePools.splice(index, 1);
				freePools.push(voo);
				voo.x = voo.y = 0;
			}
		}
		
		private var usePools2:Array = [];
		/**
		 * 回收
		 */
		public function recycleReverseShape(voo:Image):void
		{
			var index:int = usePools2.indexOf(voo);
			if (index >= 0)
			{
				usePools2.splice(index, 1);
				freePools2.push(voo);
				voo.x = voo.y = 0;
			}
		}
		
		private var freePools2:Array = [];
		public  function getShapeReverse():Image
		{
			var voo:Image;
			if (freePools2.length <= 0)
			{
				voo = new Image(ResManager.assetsManager.getTextureAtlas(ResManager.YLXD_NAME).getTexture("2reverse.png"));
			}
			else
			{
				voo = freePools2.shift();
			}
			usePools2.push(voo);
			return voo;
		}
	}
}