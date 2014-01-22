package tools.managers
{
	import flash.utils.Dictionary;
	
	import tools.common.vo.ServerInfo;
	
	/**
	 * 服务器列表管理器
	 * @author Administrator
	 * 
	 */	
	public class ServerManager
	{
		public function ServerManager()
		{
		}
		
		/**
		 *  服务器列表数据存储器
		 */		
		private static var serverDic:Array = [];
		
		/**
		 * 解析服务器列表的xml
		 * @param data
		 * 
		 */		
		public static function parseData(data:XML):void
		{
			if (data == null)
				return;
			var xmls:XMLList = data.server;
			var xml:XML, info:ServerInfo;
			for each (xml in xmls)
			{
				info = new ServerInfo();
				info.id = int(xml.@id);
				info.name = xml.@name;
				serverDic.push(info);
			}
		}
		
		/**
		 * 获取服务器列表
		 * @return 
		 * 
		 */		
		public static function getServerList():Array
		{
			return serverDic;
		}
	}
}