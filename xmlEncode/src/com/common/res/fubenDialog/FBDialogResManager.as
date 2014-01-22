package game.common.res.fubenDialog
{
	public class FBDialogResManager
	{
		private static var drama:Object = {};
		
		public function FBDialogResManager()
		{
		}
		
		public static function parseRes(param1:String) : void
		{
			var xml:XML = XML(param1);
			
			var xml_1:XMLList = xml.elements('npc');
			var xml_2:XMLList = xml.elements('data');
			trace(xml_1)
			var obj:Object;
			var dramaData:Object;
			var subscript:String;
			for each(var $daram:XML in xml.drama)
			{
				subscript = $daram.@sceneid + '_' + $daram.@dialogType;
				drama[subscript] = {};
				drama[subscript]['npc'] = [];
				drama[subscript]['data'] = [];
				for each(var item:XML in $daram.npc)
				{
					trace(item.name());
					obj = {};
					obj.id = int(item.@id);
					obj.x = int(item.@x);
					obj.y = int(item.@y);
					obj.status = String(item.@status);
					obj.direction = int(item.@direction);
					drama[subscript]['npc'].push(obj);
				}
				for each(var item:XML in $daram.data)
				{
					obj = {};
					obj.id = int(item.@id);
					obj.type = String(item.@type);
					obj.step = int(item.@step);
					obj.dest_x = int(item.@dest_x);
					obj.dest_y = int(item.@dest_y);
					obj.status = String(item.@status);
					obj.direction = int(item.@direction);
					obj.msg = String(item.@msg);
					drama[subscript]['data'].push(obj);
				}
				(drama[subscript]['data'] as Array).sortOn('step',Array.NUMERIC);
			}
			
//			for each(var item:Object in xml.drama)
//			{
//				chatface = new ChatfaceRes();
//				chatface.fileName = item.@fileName;
//				chatface.subPath = item.@subPath;
//				chatface.toolTip = item.@toolTip;
//				faceArr.push(chatface);
//			}
		}
		
		public static function getFubenDialogRes(sceneid:int, type:int):Object
		{
			return drama[sceneid + '_' + type];
		}
	}
}