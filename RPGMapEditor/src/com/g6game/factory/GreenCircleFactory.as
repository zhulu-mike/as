package com.g6game.factory
{
	import com.g6game.display.GreenCircle;
	
	import flash.display.Shape;

	public class GreenCircleFactory extends BaseFactory
	{
		
		public function GreenCircleFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<20;i++)
				{
					freePools.push(new GreenCircle());
				}
			}
		}
		
		
		private static var instance:GreenCircleFactory;
		
		public static function getInstance():GreenCircleFactory
		{
			if (!instance)
				instance = new GreenCircleFactory();
			return instance;
		}
		
		public  function getGreenCircle():GreenCircle
		{
			var voo:GreenCircle;
			if (freePools.length <= 0)
			{
				voo = new GreenCircle();
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