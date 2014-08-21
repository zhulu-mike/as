package
{
	import com.mike.utils.PlatUtil;
	
	import flash.utils.Dictionary;

	public class Language
	{
		public function Language()
		{
		}
		
		
		public static const QIDONGZHONG:String = "Game Begin Soon...";
		
		public static var PLAYER_WORDS:Array = ["反转模式好难啊","别忘了分享给你的小伙伴哦","点击屏幕切换我的手型","分数超过50后猜赢红色手型可得到5秒的无敌时间哦","遇到红色手型，要比它小才能赢哦！","我今天还没赢过，好衰啊！",
												  "我喜欢妹子，你呢？","我有一只小毛驴，我从来也不骑......","二货主人太菜了！","呵呵！","我一直说的不停，主人你烦吗？",""];
		public static var MONSTER_WORDS:Array = ["我这辈子还没输过","你是我的小呀小苹果儿","我要把你踢下去",
			"我的个乖乖啊，无敌了","我想要个妹子"];
		
		public static function parse(data:XML):void
		{
			PLAYER_WORDS.length = 0;
			MONSTER_WORDS.length = 0;
			var xmls:XMLList = data.common;
			var xml:XML = xmls[0];
			xmls = xml.key;
			for each (xml in xmls)
			{
				dic[String(xml.@id)] = xml.text().toString();
			}
			xmls = data.player;
			xml = xmls[0];
			xmls = xml.key;
			for each (xml in xmls)
			{
				PLAYER_WORDS.push(xml.text().toString());
			}
			PlatUtil.initPlat(int(getString("PLAT")));
		}
		
		public static function getString(key:String):String
		{
			return dic[key] || "";
		}
		
		private static var dic:Dictionary = new Dictionary();
	}
}