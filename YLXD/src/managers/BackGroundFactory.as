package managers
{
	import com.mike.utils.BaseFactory;
	
	import starling.display.Image;
	import starling.textures.TextureSmoothing;
	
	public class BackGroundFactory extends BaseFactory
	{
		public function BackGroundFactory()
		{
			if (!instance)
			{
				var i:int = 0,vo:Image;
				for (i;i<2;i++)
				{
					vo = new Image(ResManager.assetsManager.getTexture("background"));
					freePools.push(vo);
					vo.smoothing = TextureSmoothing.NONE;
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
				voo.smoothing = TextureSmoothing.NONE;
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