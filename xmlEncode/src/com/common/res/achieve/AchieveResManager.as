package game.common.res.achieve
{
	public class AchieveResManager
	{
		private static var achieveResContainer:Object = new Object();
		public static var topicResContainer:Object = {};
		
		public function AchieveResManager()
		{
			return;
		}
		
		public static function parseRes(param1:String) : void
		{
			var _loc_3:XML = null;
			var _loc_4:AchieveRes = null;
			var chapterRes:AchieveTopicRes;
			var _loc_2:* = XML(param1);
			for each(_loc_3 in _loc_2.achieves)
			{
				chapterRes = new AchieveTopicRes();
				chapterRes.id = _loc_3.@id;
				chapterRes.name = _loc_3.@name;
//				chapterRes.range = _loc_3.@range;
				chapterRes.gold = _loc_3.@gold;
				chapterRes.icon = _loc_3.@icon;
				chapterRes.receptionLevel = _loc_3.@receptionLevel;
				topicResContainer[chapterRes.id] = chapterRes;
				
				
				for each (_loc_3 in _loc_2.achieves.achieve)
				{
					_loc_4 = new AchieveRes();
					_loc_4.id = _loc_3.@id;
					_loc_4.name = _loc_3.@name;
					_loc_4.desc = _loc_3.desc;
					_loc_4.total = _loc_3.@total;
					achieveResContainer[_loc_4.id] = _loc_4;
				}
			}
			return;
		}
		
		public static function getAchieveRes(param1:int) : AchieveRes
		{
			return achieveResContainer[param1];
		}
		
		public static function getTopicRes(id:int):AchieveTopicRes
		{
			return topicResContainer[id];
		}
		
		public static function getAchieveResListByKind(param1:int) : Array
		{
//			var _loc_3:AchieveRes = null;
//			var _loc_2:Array = [];
//			for each (_loc_3 in achieveResContainer)
//			{
//				
//				if (_loc_3.kind == param1)
//				{
//					_loc_2.push(_loc_3);
//				}
//			}
//			return _loc_2;
			return null;
		}
	}
}