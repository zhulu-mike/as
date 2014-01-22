package game.common.res.goodsware
{
	import game.manager.EquipManager;
	import game.manager.ToolManager;

	public class GoodswareResManager
	{
		public function GoodswareResManager()
		{
		}
		
		public static function parseRes(xmlString:String) : void
		{
			var gr:Object = null;
			var item:XML = null;
			var _xml:XML = XML(xmlString);
			if (!_xml)
			{
				return;
			}
			for each (item in _xml.goodsConfig)
			{
				ToolManager.getInstance().creatConfigByXml(item);
			}
			for each(item in _xml.equipConfig)
			{
				EquipManager.getInstance().creatConfigByXml(item);
			}
			return;
		}
	}
}