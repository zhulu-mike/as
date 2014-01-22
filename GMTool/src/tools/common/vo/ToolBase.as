package tools.common.vo
{

	public class ToolBase
	{
		
		/**	药品*/
		public static const YAOPIN:int = 1;
		/**材料*/
		public static const CAILIAO:int = 2;
		/**宝石*/
		public static const BAOSHI:int = 3;
		/**合成卷轴*/
		public static const HECHENGJUANZHOU:int = 4;
		/**任务物品*/
		public static const RENWUWUPIN:int = 5;
		/**礼包*/
		public static const LIBAO:int = 6;

//		/***/
//		public static const TYPESTRING:Object = {YAOPIN:Language.getKey("yaopin"),
//												 CAILIAO:Language.getKey("cailiao"),
//												 BAOSHI:Language.getKey("baoshi"),
//												 HECHENGJUANZHOU:Language.getKey("hechengjuanzhou"),
//												 RENWUWUPIN:Language.getKey("renwuwupin"),
//												 LIBAO:Language.getKey("libao"),
//												 0:""
//		};
		
		public function ToolBase()
		{
		}
		
		/**配置ID*/
		private var _id:int ;
		
		private var _name:String = "";
		/**品质*/
		private var _quality:int;
		/**堆叠上限*/
		private var _max_heap:int;
		/**类型*/
		private var _type:int;
		/**描述*/
		private var _desc:String = "";
		/**使用要求描述*/
		private var _use_desc:String = "";
		/**是否可卖*/
		private var _is_sell:int;
		/**卖出货币类型*/
		private var _sell_type:int;
		/**卖出价格*/
		private var _sell_price:int;
		/**买入价格*/
		private var _buy_price:int;
		/**是否唯一*/
		private var _onlyone:int;
		/**到期时间*/
		private var _time_end:int;
		/**是否可丢弃*/
		private var _is_throwaway:int;
		/**是否可使用*/
		private var _is_use:int;
		/**使用次数上限*/
		private var _max_use_time:int;
		/**职业限制*/
		private var _career:int;
		/**等级限制*/
		private var _level:int;
		/**VIP限制*/
		private var _vip:int;
		/**公会职位限制*/
		private var _guild_pst_lmt:int;
		/**队伍限制*/
		private var _team_lmt:int;
		/**Cd*/
		private var _cd:int;
		/**公公CD*/
		private var _public_cd:int;
		/**作用对象*/
		private var _affect_obj:int;
		/**消耗*/
		private var _consum:int;
		/**效果类型*/
		private var _effect_type:int;
		/**效果值*/
		private var _effect_value:int;
		private var _img:int = 0;
		
		/**产地,format:章节id,普通管卡id*/
		private var _source:String = "";


		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		/**品质1)	白色
2)	绿色
3)	紫色
4)	金色
5)	红色
*/
		public function get quality():int
		{
			return _quality;
		}

		public function set quality(value:int):void
		{
			_quality = value;
		}

		public function get max_heap():int
		{
			return _max_heap;
		}

		public function set max_heap(value:int):void
		{
			_max_heap = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

		public function get use_desc():String
		{
			return _use_desc;
		}

		public function set use_desc(value:String):void
		{
			_use_desc = value;
		}

		public function get is_sell():int
		{
			return _is_sell;
		}

		public function set is_sell(value:int):void
		{
			_is_sell = value;
		}

		/**1表示铜钱，2表示元宝*/
		public function get sell_type():int
		{
			return _sell_type;
		}

		public function set sell_type(value:int):void
		{
			_sell_type = value;
		}

		public function get sell_price():int
		{
			return _sell_price;
		}

		public function set sell_price(value:int):void
		{
			_sell_price = value;
		}

		public function get buy_price():int
		{
			return _buy_price;
		}

		public function set buy_price(value:int):void
		{
			_buy_price = value;
		}

		public function get onlyone():int
		{
			return _onlyone;
		}

		public function set onlyone(value:int):void
		{
			_onlyone = value;
		}

		public function get time_end():int
		{
			return _time_end;
		}

		public function set time_end(value:int):void
		{
			_time_end = value;
		}

		public function get is_throwaway():int
		{
			return _is_throwaway;
		}

		public function set is_throwaway(value:int):void
		{
			_is_throwaway = value;
		}

		public function get is_use():int
		{
			return _is_use;
		}

		public function set is_use(value:int):void
		{
			_is_use = value;
		}

		public function get max_use_time():int
		{
			return _max_use_time;
		}

		public function set max_use_time(value:int):void
		{
			_max_use_time = value;
		}

		public function get career():int
		{
			return _career;
		}

		public function set career(value:int):void
		{
			_career = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function get vip():int
		{
			return _vip;
		}

		public function set vip(value:int):void
		{
			_vip = value;
		}

		public function get guild_pst_lmt():int
		{
			return _guild_pst_lmt;
		}

		public function set guild_pst_lmt(value:int):void
		{
			_guild_pst_lmt = value;
		}

		public function get team_lmt():int
		{
			return _team_lmt;
		}

		public function set team_lmt(value:int):void
		{
			_team_lmt = value;
		}

		public function get cd():int
		{
			return _cd;
		}

		public function set cd(value:int):void
		{
			_cd = value;
		}

		public function get public_cd():int
		{
			return _public_cd;
		}

		public function set public_cd(value:int):void
		{
			_public_cd = value;
		}

		public function get affect_obj():int
		{
			return _affect_obj;
		}

		public function set affect_obj(value:int):void
		{
			_affect_obj = value;
		}

		public function get consum():int
		{
			return _consum;
		}

		public function set consum(value:int):void
		{
			_consum = value;
		}

		public function get effect_type():int
		{
			return _effect_type;
		}

		public function set effect_type(value:int):void
		{
			_effect_type = value;
		}

		public function get effect_value():int
		{
			return _effect_value;
		}

		public function set effect_value(value:int):void
		{
			_effect_value = value;
		}

		/**图标*/
		public function get img():int
		{
			return _img;
		}

		/**
		 * @private
		 */
		public function set img(value:int):void
		{
			_img = value;
		}


		public function get source():String
		{
			return _source;
		}

		/**产地*/
		public function set source(value:String):void
		{
			_source = value;
		}


	}
}
