package com.g6game.factory
{
	import vo.HinderPointVO;

	/**
	 * 障碍点VO工厂
	 */
	public class HinderPointFactory extends BaseFactory
	{
		
		public function HinderPointFactory()
		{
			if (!instance)
			{
				var i:int = 0;
				for (i;i<20;i++)
				{
					freePools.push(new HinderPointVO());
				}
			}
		}
		
		private static var instance:HinderPointFactory;
		
		public static function getInstance():HinderPointFactory
		{
			if (!instance)
				instance = new HinderPointFactory();
			return instance;
		}
		
		public  function getHinderPointVO():HinderPointVO
		{
			var voo:HinderPointVO;
			if (freePools.length <= 0)
			{
				voo = new HinderPointVO();
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
		public function recycleVO(voo:HinderPointVO):void
		{
			var index:int = usePools.indexOf(voo);
			if (index >= 0)
			{
				usePools.splice(index, 1);
				voo.p.x = 0;
				voo.p.y = 0;
				voo.type = 0;
				voo.shape = null;
				freePools.push(voo);
			}
		}
	}
}