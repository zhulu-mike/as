package com.g6game.factory
{
	import com.g6game.display.RedCircle;
	
	import flash.display.Shape;

	public class RedShapeFactory extends BaseFactory
	{
		
		public function RedShapeFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<20;i++)
				{
					freePools.push(new RedCircle());
				}
			}
		}
		
		
		private static var instance:RedShapeFactory;
		
		public static function getInstance():RedShapeFactory
		{
			if (!instance)
				instance = new RedShapeFactory();
			return instance;
		}
		
		public  function getRedCircle():RedCircle
		{
			var voo:RedCircle;
			if (freePools.length <= 0)
			{
				voo = new RedCircle();
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
		public function recycleShape(voo:Shape):void
		{
			var index:int = usePools.indexOf(voo);
			if (index >= 0)
			{
				usePools.splice(index, 1);
				freePools.push(voo);
			}
		}
	}
}