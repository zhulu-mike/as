package game.common.res.sysFunNotice
{
	import lm.mui.controls.GAlert;
	
	public class FuncOpenNoticeManager
	{
		public static var funcOpenResArr:Array = [];
		
		public function FuncOpenNoticeManager()
		{
			return;
		}
		
		public static function parseFuncOpenRes(xmlStr:String) : void
		{
			var res:FuncOpenRes;
			var funcOpenXML:XML = XML(xmlStr);
			if (!funcOpenXML)
			{
				return;
			}
			for each (var xml:XML in funcOpenXML.item)
			{	
				res = new FuncOpenRes();
				res.id = int(xml.@id);
				res.type = int(xml.@type);
				res.name = String(xml.@name);
				res.desc = String(xml.@desc);
				res.openAcceptTask = int(xml.@openAcceptTask);
				res.openFinishedTask = int(xml.@openFinishedTask);
				res.openLevel = int(xml.@openLevel);
				res.closeAcceptTask = int(xml.@closeAcceptTask);
				res.closeFinishedTask = int(xml.@closeFinishedTask);
				res.closeLevel = int(xml.@closeLevel);
				funcOpenResArr.push(res);
				
				if(res.openAcceptTask > 0 && res.openFinishedTask > 0 || res.closeAcceptTask > 0 && res.closeFinishedTask > 0)
				{
					GAlert.show("功能开启配置出错" + ',' + "开启或关闭只可以存在一个任务" + 'ID');
				}
			}
			return;
		}
		
		public static function getFuncOpenRes($id_kind:int):FuncOpenRes
		{
			return null;
		}
	}
}