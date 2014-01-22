package game.common.res.spirit
{
	import flash.utils.Dictionary;

	public class SpiritResManager
	{
		private static var dict:Object = {};
		private static var tempDic:Dictionary = new Dictionary();
		
		public function SpiritResManager()
		{
		}
		
		public static function parseRes(param1:String) : void
		{
			var res:SpiritRes;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each(var item:XML in xml.spirit)
			{
				res = new SpiritRes();
				res.id = item.@id  ;
				res.name = item.@name  ;
				res.color = item.@color  ;
				res.lv = item.@lv  ;
				res.type = item.@type  ;
				res.cost = item.@cost  ;
				res.sell = item.@sell  ;
				res.att = item.@att  ;
				res.def = item.@def  ;
				res.cru = item.@cru  ;
				res.dcru = item.@dcru  ;
				res.killLv = item.@killLv  ;
				res.blood = item.@blood  ;
				res.img = item.@img  ;
				res.des = item.@des  ;
				dict[res.id] = res;
			}
		}
		
		public static function getResByID($id:int):SpiritRes
		{
			return dict[$id];
		}
		public static function getResArrByType($type:int):Array{
			var temp:Array =[];
			if ( tempDic[$type] != null){
				return tempDic[$type] ;
			}
			for each (var item:SpiritRes in dict) 
			{
				if( item.type == $type){
					temp.push(item);
				}
			}
			tempDic[$type] = temp ;
			return temp;
		}
	}
}