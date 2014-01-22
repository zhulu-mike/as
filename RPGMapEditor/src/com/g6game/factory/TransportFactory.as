package com.g6game.factory
{
	import com.g6game.display.TransportRect;

	public class TransportFactory extends BaseFactory
	{
		public function TransportFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<20;i++)
				{
					freePools.push(new TransportRect());
				}
			}
		}
		
		private static var instance:TransportFactory;
		
		public static function getInstance():TransportFactory
		{
			if (!instance)
				instance = new TransportFactory();
			return instance;
		}
		
		public  function getTransportRect():TransportRect
		{
			var voo:TransportRect;
			if (freePools.length <= 0)
			{
				voo = new TransportRect();
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
		public function recycle(voo:TransportRect):void
		{
			voo.voo = null;
			var index:int = usePools.indexOf(voo);
			if (index >= 0)
			{
				usePools.splice(index, 1);
				freePools.push(voo);
			}
		}
	}
}