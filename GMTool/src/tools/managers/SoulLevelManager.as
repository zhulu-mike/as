package tools.managers
{
	import flash.utils.Dictionary;
	
	import tools.common.vo.SoulFosterVO;

	public class SoulLevelManager
	{
		public function SoulLevelManager()
		{
		}
		
		private static var _dis:Dictionary = new Dictionary();
		
		/***/
		public static function parseConfig(data:XML):void
		{
			var ps:XMLList = data.p;
			var p:XML, temp:SoulFosterVO;
			for each (p in ps)
			{
				temp = new SoulFosterVO();
				temp.lev = p.@level;
				temp.rate = p.@successPro;
				temp.count = p.@count;
				temp.changePro = p.@changePro;
				_dis[temp.lev] = temp;
			}
		}
		
		/***/
		public static function getLevelVO(lev:int):SoulFosterVO
		{
			return _dis.hasOwnProperty(lev) ? _dis[lev] : null;
		}
	}
}