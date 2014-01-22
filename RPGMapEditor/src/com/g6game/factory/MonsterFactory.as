package com.g6game.factory
{
	import com.g6game.display.BornSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import vo.BornPointVO;

	public class MonsterFactory extends BaseFactory
	{
		
		[Embed(source="assets/monsterSysbol.gif")]
		private var monster:Class;
		
		public function MonsterFactory()
		{
			if (!instance)
			{
				bitmapData = new monster().bitmapData;
				var i:int = 0, s:BornSprite;
				for (i;i<20;i++)
				{
					s = new BornSprite();
					freePools.push(s);
				}
			}
		}
		
		private var bitmapData:BitmapData;
		
		private static var instance:MonsterFactory;
		
		public static function getInstance():MonsterFactory
		{
			if (!instance)
				instance = new MonsterFactory();
			return instance;
		}
		
		public  function getMonsterSysbol(param1:int = 1):BornSprite
		{
			var voo:BornSprite;
			if (freePools.length <= 0)
			{
				voo = new BornSprite();
			}
			else
			{
				voo = freePools.shift();
			}
			voo.update(param1);
			usePools.push(voo);
			return voo;
		}
		
		/**
		 * 回收
		 */
		public function recycleShape(voo:BornSprite):void
		{
			var index:int = usePools.indexOf(voo);
			if (index >= 0)
			{
				usePools.splice(index, 1);
				freePools.push(voo);
				voo.x = 0;
				voo.y = 0;
				voo.voo = null;
			}
		}
	}
}