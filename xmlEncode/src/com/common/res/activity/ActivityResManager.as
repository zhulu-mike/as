package game.common.res.activity
{
    import game.common.res.task.vo.*;
    import game.manager.*;

    public class ActivityResManager extends Object
    {
        private static var activityResContainer:Object = new Object();
		
		/**小助手*/
		private static var aidanceContainer:Object = new Object();
		/**活跃度*/
		private static var actiRateContainer:Object = new Object();
		/**日常活动*/
		private static var actiDailyContainer:Object = new Object();
		/**日常副本*/
		private static var actiFubenContainer:Object = new Object();
		/**野外Boss*/
		private static var actiFieldContainer:Object = new Object();
		/**每周活动*/
		private static var actiWeekContainer:Object = new Object();
		/**活跃度奖励*/
		public static var rateAwardContainer:Array = [];

        public function ActivityResManager()
        {
            return;
        }

        public static function parseActivityRes(param1:String) : void
        {
            var res:ActivityRes = null;
            var xml_item:XML = null;
            var xml:XML = XML(param1);
            if (!xml)
            {
                return;
            }
            for each (xml_item in xml.activity)
            {
                res = new ActivityRes();
                res.id = int(xml_item.@id);
				res.icon = xml_item.@icon;
                res.name = xml_item.name;
				res.type = xml_item.@type;
                res.desc = xml_item.desc;
				res.memo = xml_item.memo;
				res.during = xml_item.@during;
//                res.fromTime = xml_item.@fromTime;
//                res.toTime = xml_item.@toTime;
                res.receptionLevel = int(xml_item.@receptionLevel);
				res.receptionPropID = xml_item.@receptionPropID;
				res.loop = xml_item.@loop;
				res.copper = xml_item.@copper;
				res.aura = xml_item.@aura;
				res.exp = xml_item.@exp;
				res.prestige = xml_item.@prestige;
				res.button_label = xml_item.@button_label;
//                res.minTeamPlayerNum = int(Number(xml_item.@minTeamPlayerNum));
                activityResContainer[res.id] = res;
            }
            return;
        }

        public static function getActivityRes(id:int) : ActivityRes
        {
            return activityResContainer[id];
        }
		
		/**
		 * 	解析小助手数据
		 */		
		public static function parseAidanceRes(param1:String) : void
		{
			var res:AidanceRes = null;
			var xml_item:XML = null;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each (xml_item in xml.aidItem)
			{
				res = new AidanceRes();
				res.id = int(xml_item.@id);
				res.name = xml_item.@name.toString();
				res.desc = xml_item.@desc.toString();
				res.recommend = xml_item.@recommend.toString();
				res.operateType = int(xml_item.@operateType);
				res.targetNPC = int(xml_item.@targetNPC);
				res.type = int(xml_item.@type);
				res.path = String(xml_item.@path);
				aidanceContainer[res.id] = res;
			}
			return;
		}
		
		/**
		 * 	获得小助手项
		 */		
		public static function getAidanceRes(id:int) : AidanceRes
		{
			return aidanceContainer[id];
		}
		
		
		/**
		 *	解析活跃度数据 
		 * @param param1
		 * 
		 */		
		public static function parseActiRate(param1:String):void
		{
			
			var res:ActiRateRes;
			var xml_item:XML = null;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each (xml_item in xml.rate)
			{
				res = new ActiRateRes();
				res.id = int(xml_item.@id);
				res.icon = int(xml_item.@icon);
				res.name = xml_item.@name.toString();
				res.desc = String(xml_item.@desc);
				res.mapAcceptedTask = int(xml_item.@mapAcceptedTask);
				res.mapFinishedTask = int(xml_item.@mapFinishedTask);
				res.operateType = int(xml_item.@operateType);
				res.total = int(xml_item.@total);
				res.rate = int(xml_item.@rate);
				res.path = String(xml_item.@path);
				res.targetNPC = int(xml_item.@targetNPC);
				actiRateContainer[res.id] = res;
			}
			
			var item:ActiRateAwardRes;
			for each (xml_item in xml.award)
			{
				item = new ActiRateAwardRes;
				item.id = int(xml_item.@id);
				item.condition = int(xml_item.@condition);
				item.prop = analyseProp(String(xml_item.@prop));
				rateAwardContainer.push(item);
			}
		}
		
		/**
		 * 	获得活跃度项
		 */		
		public static function getActiRateRes(id:int) : ActiRateRes
		{
			return actiRateContainer[id];
		}
		
		
		/**
		 *	解析日常活动数据 
		 * @param param1
		 * 
		 */		
		public static function parseActiDaily(param1:String):void
		{
			var res:ActiDailyRes;
			var xml_item:XML = null;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each (xml_item in xml.dailyItem)
			{
				res = new ActiDailyRes();
				res.id = int(xml_item.@id);
				res.icon = int(xml_item.@icon);
				res.name = xml_item.@name.toString();
				res.during = String(xml_item.@during);
				res.receptionLevel = int(xml_item.@receptionLevel);
				res.loop = int(xml_item.@loop);
				res.copper = int(xml_item.@copper);
				res.aura = int(xml_item.@aura);
				res.ptg = int(xml_item.@ptg);
				res.exp = int(xml_item.@exp);
				res.desc = String(xml_item.@desc);
				
				res.targetNPC = int(xml_item.@targetNPC);
				res.operateType = int(xml_item.@operateType);
				res.path = String(xml_item.@path);
				
				res.prop = analyseProp(String(xml_item.@prop));
				res.equip = analyseEquip(String(xml_item.@equip));
				
				actiDailyContainer[res.id] = res;
			}
		}
		
		
		
		/**
		 * 	获得日常活动项
		 */		
		public static function getActiDailyRes(id:int) : ActiDailyRes
		{
			return actiDailyContainer[id];
		}
		
		/**
		 *	解析日常副本数据 
		 * @param param1
		 * 
		 */		
		public static function parseActiFuben(param1:String):void
		{
			var res:ActiFubenRes;
			var xml_item:XML = null;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each (xml_item in xml.fubenItem)
			{
				res = new ActiFubenRes();
				res.id = int(xml_item.@id);
				res.icon = int(xml_item.@icon);
				res.awardDesc = String(xml_item.@awardDesc);
				res.name = xml_item.@name.toString();
				res.receptionLevel = int(xml_item.@receptionLevel);
				res.loop = int(xml_item.@loop);
				res.copper = int(xml_item.@copper);
				res.aura = int(xml_item.@aura);
				res.ptg = int(xml_item.@ptg);
				res.exp = int(xml_item.@exp);
				res.desc = String(xml_item.@desc);
				
				res.prop = analyseProp(String(xml_item.@prop));
				res.equip = analyseEquip(String(xml_item.@equip));
				
				res.targetNPC = int(xml_item.@targetNPC);
				res.operateType = int(xml_item.@operateType);
				res.path = String(xml_item.@path);
				
				actiFubenContainer[res.id] = res;
			}
		}
		
		
		/**
		 * 	获得日常副本项
		 */		
		public static function getActiFubenRes(id:int) : ActiFubenRes
		{
			return actiFubenContainer[id];
		}
		
		/**
		 *	解析野外Boss数据 
		 * @param param1
		 * 
		 */		
		public static function parseActiField(param1:String):void
		{
			var res:ActiFieldRes;
			var xml_item:XML = null;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each (xml_item in xml.fieldItem)
			{
				res = new ActiFieldRes();
				res.id = int(xml_item.@id);
				res.icon = int(xml_item.@icon);
				res.name = xml_item.@name.toString();
				res.bossLevel = int(xml_item.@bossLevel);
				res.copper = int(xml_item.@copper);
				res.aura = int(xml_item.@aura);
				res.ptg = int(xml_item.@ptg);
				res.exp = int(xml_item.@exp);
				
				res.prop = analyseProp(String(xml_item.@prop));
				res.equip = analyseEquip(String(xml_item.@equip));
				
				res.image = int(xml_item.@image);
				res.operateType = int(xml_item.@operateType);
				res.place = String(xml_item.@place);
				res.path = String(xml_item.@path);
				
				actiFieldContainer[res.id] = res;
			}
		}
		
		
		/**
		 * 	获得野外BOSS项
		 */		
		public static function getActiFieldRes(id:int) : ActiFieldRes
		{
			return actiFieldContainer[id];
		}
		
		
		/**
		 *	解析每周活动数据 
		 * @param param1
		 * 
		 */		
		public static function parseActiWeek(param1:String):void
		{
			var res:ActiWeekRes;
			var xml_item:XML = null;
			var xml:XML = XML(param1);
			if (!xml)
			{
				return;
			}
			for each (xml_item in xml.weekItem)
			{
				res = new ActiWeekRes();
				res.id = int(xml_item.@id);
				res.icon = int(xml_item.@icon);
				res.name = xml_item.@name.toString();
				res.during = String(xml_item.@during);
				res.receptionLevel = int(xml_item.@receptionLevel);
				res.loop = int(xml_item.@loop);
				res.copper = int(xml_item.@copper);
				res.aura = int(xml_item.@aura);
				res.ptg = int(xml_item.@ptg);
				res.exp = int(xml_item.@exp);
				res.desc = String(xml_item.@desc);
				
				res.prop = analyseProp(String(xml_item.@prop));
				res.equip = analyseEquip(String(xml_item.@equip));
				
				res.targetNPC = int(xml_item.@targetNPC);
				res.operateType = int(xml_item.@operateType);
				res.path = String(xml_item.@path);
				
				actiWeekContainer[res.id] = res;
			}	
		}
	
		/**
		 * 	获得每周活动项
		 */		
		public static function getActiWeekRes(id:int) : ActiWeekRes
		{
			return actiWeekContainer[id];
		}
		
		
		/**
		 *	解析装备      
		 * @param str  id;id;...
		 * @return 
		 * 
		 */		
		private static function analyseEquip(str:String):Array
		{
			if(str == '' || str == '0')
			{
				return [];
			}
			else
			{
				return str.split(';');
			}
			return [];
		}
		
		/**
		 *	解析道具  
		 * @param str	id,num;id,num;... 
		 * @return 
		 * 
		 */		
		private static function analyseProp(str:String):Array
		{
			if(str == '' || str == '0')
			{
				return [];
			}
			var tempArr:Array = str.split(';');
			var num:int = tempArr.length;
			var temp:Array;
			var obj:Object;
			var arr:Array = [];
			for(var i:int = 0; i < num; i++)
			{
				temp = tempArr[i].split(',');
				obj = {};
				obj.id = temp[0];
				obj.num = temp[1];
				arr.push(obj);
			}
			return arr;
		}
		
    }
}
