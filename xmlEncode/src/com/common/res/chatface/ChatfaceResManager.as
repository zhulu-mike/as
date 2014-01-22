package game.common.res.chatface
{
	public class ChatfaceResManager
	{
		public static var faceArr:Array = [];
		
		public function ChatfaceResManager()
		{
		}
		
		public static function parseTransRes(param1:String) : void
		{
			var xml:XML = XML(param1);
			var chatface:ChatfaceRes;
			
			for each(var item:Object in xml.items.item)
			{
				chatface = new ChatfaceRes();
				chatface.fileName = item.@fileName;
				chatface.subPath = item.@subPath;
				chatface.toolTip = item.@toolTip;
				faceArr.push(chatface);
			}
		}
	}
}