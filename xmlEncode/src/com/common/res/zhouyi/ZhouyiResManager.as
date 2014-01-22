package game.common.res.zhouyi
{
	public class ZhouyiResManager
	{
		private static var dict:Object = {};
		
		public function ZhouyiResManager()
		{
		}
		
		public static function parseRes(param1:String) : void
		{
			var res:ZhouyiRes;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each(var item:XML in xml.diagram)
			{
				res = new ZhouyiRes();
				res.color = int(item.@color);
				res.desc = item.desc;
				res.id = int(item.@id);
				res.memo = item.@memo;
				res.name = item.@name;
				res.nick = item.@nick;
				res.taskID = int(item.@task_id);
				res.underDiagram = int(item.@underDiagram);
				res.upperDiagram = int(item.@upperDiagram);
				res.tip = String(item.@tishi);
				dict[res.id] = res;
			}
		}
		
		public static function getResByID($id:int):ZhouyiRes
		{
			return dict[$id];
		}
	}
}