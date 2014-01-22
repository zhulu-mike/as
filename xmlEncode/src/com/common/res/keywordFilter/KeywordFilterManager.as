package game.common.res.keywordFilter
{
	public class KeywordFilterManager
	{
		public static var keywords:Array;		//关键字
		
		public function KeywordFilterManager()
		{
		}
		
		public static function parse(str:String):void
		{
			str = str.replace(/\r/g,'');
			keywords = str.split('\n');
		}
	}
}