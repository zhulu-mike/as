package helper
{
	import flash.utils.Dictionary;

	public class ConfigHelper
	{
		public function ConfigHelper()
		{
		}
		
		private static var dic:Dictionary = new Dictionary();
		
		public static function parseXML(data:XML):void
		{
			var ps:XMLList = data.p;
			var obj:Object, p:XML;
			for each (p in ps)
			{
				obj = {px:int(p.@registerx), py:int(p.@registery), time:int(p.@time)};
				dic[String(p.@id)] = obj;
			}
		}
		
		public static function getConfig(id:String):Object
		{
			return dic[id];
		}
				
	}
}