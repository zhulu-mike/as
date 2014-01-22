package com.g6game.factory
{
	import com.g6game.display.BitmapClip;

	public class BitmapClipFactory extends BaseFactory
	{
		public function BitmapClipFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<20;i++)
				{
					freePools.push(new BitmapClip());
				}
			}
		}
		
		private static var instance:BitmapClipFactory;
		
		public static function getInstance():BitmapClipFactory
		{
			if (!instance)
				instance = new BitmapClipFactory();
			return instance;
		}
		
		public  function getBitmapClip():BitmapClip
		{
			var voo:BitmapClip;
			if (freePools.length <= 0)
			{
				voo = new BitmapClip();
			}
			else
			{
				voo = freePools.shift();
			}
			usePools.push(voo);
			voo.createListener();
			return voo;
		}
		
		/**
		 * 回收
		 */
		public function recycle(voo:BitmapClip):void
		{
			var index:int = usePools.indexOf(voo);
			if (index >= 0)
			{
				usePools.splice(index, 1);
				freePools.push(voo);
			}
			voo.destroy();
		}
	}
}