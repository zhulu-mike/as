package managers
{
	import com.mike.utils.BaseFactory;
	
	import starling.display.Image;
	
	public class BackGroundFactory extends BaseFactory
	{
		public function BackGroundFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<2;i++)
				{
					freePools.push(new Image(ResManager.assetsManager.getTexture("background")));
				}
			}
		}
		
		private static var instance:BackGroundFactory;
		
		public static function getInstance():BackGroundFactory
		{
			if (!instance)
				instance = new BackGroundFactory();
			return instance;
		}
		
		public  function getShape():Image
		{
			var voo:Image;
			if (freePools.length <= 0)
			{
				voo = new Image(ResManager.assetsManager.getTexture("background"));
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
			voo.scaleX = 1;
			voo.scaleY = 1;
			if (index >= 0)
			{
				usePools.splice(index, 1);
				freePools.push(voo);
				voo.x = voo.y = 0;
			}
		}
		
	}
}