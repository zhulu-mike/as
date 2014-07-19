package managers
{
	import com.mike.utils.BaseFactory;
	
	import starling.display.MovieClip;
	
	public class MainPlayerJianDaoFactory extends BaseFactory
	{
		public function MainPlayerJianDaoFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<1;i++)
				{
					freePools.push(new MovieClip(ResManager.assetsManager.getTextures("player2")));
				}
			}
		}
		
		private static var instance:MainPlayerJianDaoFactory;
		
		public static function getInstance():MainPlayerJianDaoFactory
		{
			if (!instance)
				instance = new MainPlayerJianDaoFactory();
			return instance;
		}
		
		public  function getShape():MovieClip
		{
			var voo:MovieClip;
			if (freePools.length <= 0)
			{
				voo = new MovieClip(ResManager.assetsManager.getTextures("player2"));
			}
			else
			{
				voo = freePools.shift();
			}
			usePools.push(voo);
			voo.loop = true;
			return voo;
		}
		
		/**
		 * 回收
		 */
		public function recycleShape(voo:MovieClip):void
		{
			var index:int = usePools.indexOf(voo);
			if (index >= 0)
			{
				voo.stop();
				usePools.splice(index, 1);
				freePools.push(voo);
				voo.x = voo.y = 0;
			}
		}
	}
}