package managers
{
	import com.mike.utils.BaseFactory;
	
	import starling.display.MovieClip;
	
	public class MainPlayerBuFactory extends BaseFactory
	{
		public function MainPlayerBuFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<1;i++)
				{
					freePools.push(new MovieClip(ResManager.assetsManager.getTextures("player1")));
				}
			}
		}
		
		private static var instance:MainPlayerBuFactory;
		
		public static function getInstance():MainPlayerBuFactory
		{
			if (!instance)
				instance = new MainPlayerBuFactory();
			return instance;
		}
		
		public  function getShape():MovieClip
		{
			var voo:MovieClip;
			if (freePools.length <= 0)
			{
				voo = new MovieClip(ResManager.assetsManager.getTextures("player3"));
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