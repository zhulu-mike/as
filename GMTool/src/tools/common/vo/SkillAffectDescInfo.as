package tools.common.vo
{
	public class SkillAffectDescInfo
	{
		
		/**百分比*/
		public static const PERCENT:int =1;
		
		/**整数*/
		public static const ZHENGSHU:int = 2;
		
		public function SkillAffectDescInfo()
		{
		}
		
		private var _type:int;
		
		private var _value:int;
		
		private var _vType:int;
		
		public var label:String = "";
		
		public var icon:Object = {};
		
		/**伤害类型*/
		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}
		/**伤害值*/
		public function get value():int
		{
			return _value;
		}

		public function set value(value:int):void
		{
			_value = value;
		}
		/**伤害值的类型@see SkillAffectDescInfo.as*/
		public function get vType():int
		{
			return _vType;
		}

		public function set vType(value:int):void
		{
			_vType = value;
		}

	}
}