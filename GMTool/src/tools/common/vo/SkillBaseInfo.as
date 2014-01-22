package tools.common.vo
{
	public final class SkillBaseInfo
	{
		public function SkillBaseInfo()
		{
		}
		
		private var _id:int;
		
		private var _bigImg:int;
		
		private var _affectValue:int;
		
		private var _upgradeNeedLevel:int;
		
		private var _upgradeNeedLingqi:int;
		
		private var _type:int;
		
		private var _affectType:int;
		
		private var _level:int;
		
		private var _desc:String = "";
		
		private var _name:String = "";
		
		private var _skillAffects:Array = [];
		
		private var _distance:int;
		
		private var _nuqi:int;
		
		private var _coldtime:int;
		
	
		private var _isDanTi:int = 0;
		

		public function get isDanTi():int
		{
			return _isDanTi;
		}
		/**0表示单体，1表示群体，2表示辅助*/
		public function set isDanTi(value:int):void
		{
			_isDanTi = value;
		}

		/**技能配置ID*/
		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}
		/**技能的40*40大图标*/
		public function get bigImg():int
		{
			return _bigImg;
		}

		public function set bigImg(value:int):void
		{
			_bigImg = value;
		}
		/**效果描述*/
		public function get affectValue():int
		{
			return _affectValue;
		}

		public function set affectValue(value:int):void
		{
			_affectValue = value;
		}
		/**升级人物等级需求*/
		public function get upgradeNeedLevel():int
		{
			return _upgradeNeedLevel;
		}

		public function set upgradeNeedLevel(value:int):void
		{
			_upgradeNeedLevel = value;
		}
		/**升级灵气需求*/
		public function get upgradeNeedLingqi():int
		{
			return _upgradeNeedLingqi;
		}

		public function set upgradeNeedLingqi(value:int):void
		{
			_upgradeNeedLingqi = value;
		}

		/**类型@see SkillType.as*/
		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		/**效果类型@see SkillAffectType.as*/
		public function get affectType():int
		{
			return _affectType;
		}

		public function set affectType(value:int):void
		{
			_affectType = value;
		}

		/**技能等级*/
		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		/**技能描述*/
		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}
	
		/**技能名称*/
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}


		/**技能效果*/
		public function get skillAffects():Array
		{
			return _skillAffects;
		}

		public function set skillAffects(value:Array):void
		{
			_skillAffects = value;
		}


		public function get distance():int
		{
			return _distance;
		}

		/**施法距离*/
		public function set distance(value:int):void
		{
			_distance = value;
		}

		/**怒气*/
		public function get nuqi():int
		{
			return _nuqi;
		}

		public function set nuqi(value:int):void
		{
			_nuqi = value;
		}

		/**冷却时间*/
		public function get coldtime():int
		{
			return _coldtime;
		}

		public function set coldtime(value:int):void
		{
			_coldtime = value;
		}


	}
}