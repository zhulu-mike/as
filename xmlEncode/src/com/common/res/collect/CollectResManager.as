package game.common.res.collect
{
	import game.common.res.npc.NpcRes;

	public class CollectResManager
	{
		private static var npcResContainer:Object = new Object();
		private static var npcTransContainer:Object = new Object();
		
		public function CollectResManager()
		{
			return;
		}
		
		public static function parseCollectRes(xmlStr:String) : void
		{
			var collRes:CollectRes;
			var collResXML:XML = XML(xmlStr);
			if (!collResXML)
			{
				return;
			}
			for each (var xml:XML in collResXML.collection)
			{
				collRes = new CollectRes();
				collRes.id_kind = int(xml.@id);
				collRes.id_m = int(xml.@model);
				collRes.name = String(xml.@name);
				collRes.sceneid = int(xml.@sceneid);
				collRes.x = int(xml.@x);
				collRes.y = int(xml.@y);
				collRes.targetGoods = int(xml.@targetGoods);
				npcResContainer[collRes.id_kind] = collRes;
			}
			return;
		}
		
		public static function getCollRes($id_kind:int):CollectRes
		{
			return npcResContainer[$id_kind];
		}
		
		/**
		 *	获取场景中的所有采集对象 
		 * @param sceneID
		 * @return 
		 * 
		 */		
		public static function getCollectArrBySceneID(sceneID:int) : Array
		{
			var res:CollectRes = null;
			var arr:Array = [];
			for each (res in npcResContainer)
			{
				if (res.sceneid == sceneID)
				{
					arr[arr.length] = res;
				}
			}
			return arr;
		}
	}
}