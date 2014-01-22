package tools.managers
{
	import flash.utils.Dictionary;
	
	import tools.common.vo.ToolBase;
	import tools.common.vo.UserToolInfo;
	import tools.events.PipeEvent;

	public class ToolManager
	{
		public function ToolManager()
		{
		}
		
		private static var instance:ToolManager;
		public static function getInstance():ToolManager
		{
			if (!instance)
				instance = new ToolManager();
			return instance;
		}
		
		/**存放道具的基本信息*/
		private var toolConfig:Dictionary = new Dictionary();
		
		
		public function creatConfigByXml(temp:XML):void
		{
			var base:Object, vo:UserToolInfo, baseVO:ToolBase;
			if (!toolConfig.hasOwnProperty(temp.@config_item_id))
			{
				baseVO = new ToolBase();
				baseVO.id = temp.@config_item_id;
				baseVO.affect_obj = temp.@affect_obj;
				baseVO.buy_price = temp.@buy_price;
				baseVO.career = temp.@career;
				baseVO.cd = temp.@cd;
				baseVO.consum = temp.@consum;
				baseVO.desc = temp.@desc;
				baseVO.effect_type = temp.@effect_type;
				baseVO.effect_value = temp.@effect_value;
				baseVO.guild_pst_lmt = temp.@guild_pst_lmt;
				baseVO.is_sell = temp.@is_sell;
				baseVO.is_throwaway = temp.@is_throwaway;
				baseVO.is_use = temp.@is_use;
				baseVO.level = temp.@level;
				baseVO.max_heap = temp.@level;
				baseVO.max_use_time = temp.@max_use_time;
				baseVO.name = temp.@name;
				baseVO.onlyone = temp.@onlyone;
				baseVO.public_cd = temp.@public_cd;
				baseVO.quality = temp.@quality;
				baseVO.sell_price = temp.@sell_price;
				baseVO.sell_type = temp.@sell_type;
				baseVO.team_lmt = temp.@team_lmt;
				baseVO.time_end = temp.@time_end;
				baseVO.type = temp.@type;
				baseVO.use_desc = temp.@use_desc;
				baseVO.vip = temp.@vip;
				baseVO.img = temp.@icon;
				baseVO.source = temp.@source;
				toolConfig[baseVO.id] = baseVO;
			}
		}
		
		/**
		 * 返回所有道具数据 
		 * @return 
		 */
		public function getAllToolInfo():Array
		{
			
			var toolArr:Array=new Array();
			for(var k:* in toolConfig)
			{
				var toolObj:Object=new Object();
				toolObj.id=toolConfig[k].id;
				toolObj.affect_obj=toolConfig[k].affect_obj;
				toolObj.buy_price=toolConfig[k].buy_price;
				toolObj.career=toolConfig[k].career;
				toolObj.cd=toolConfig[k].cd;
				toolObj.consum=toolConfig[k].consum;
				toolObj.desc=toolConfig[k].desc;
				toolObj.effect_type=toolConfig[k].effect_type;
				toolObj.effect_value=toolConfig[k].effect_value;
				toolObj.guild_pst_lmt=toolConfig[k].guild_pst_lmt;
				toolObj.is_sell=toolConfig[k].is_sell;
				toolObj.is_throwaway=toolConfig[k].is_throwaway;
				toolObj.is_use=toolConfig[k].is_use;
				toolObj.level=toolConfig[k].level;
				toolObj.max_heap=toolConfig[k].max_heap;
				toolObj.max_use_time=toolConfig[k].max_use_time;
				toolObj.name=toolConfig[k].name;
				toolObj.onlyone=toolConfig[k].onlyone;
				toolObj.public_cd=toolConfig[k].public_cd;
				toolObj.quality=toolConfig[k].quality;
				toolObj.sell_price=toolConfig[k].sell_price;
				toolObj.sell_type=toolConfig[k].sell_type;
				toolObj.team_lmt=toolConfig[k].team_lmt;
				toolObj.time_end=toolConfig[k].time_end;
				toolObj.type=toolConfig[k].type;
				toolObj.use_desc=toolConfig[k].use_desc;
				toolObj.vip=toolConfig[k].vip;
				toolObj.img=toolConfig[k].img;
				toolObj.source=toolConfig[k].source;	
				toolArr.push(toolObj);
			}
			return toolArr;
		}
		
		
		/**
		 * 获取道具的基本信息 
		 * @param cid 配置ID
		 * 
		 */		
		public function getToolConfigInfo(cid:int):ToolBase
		{
			if (toolConfig.hasOwnProperty(cid))
			{
				return toolConfig[cid] as ToolBase;
			}
			return null;
		}
		
	}
}