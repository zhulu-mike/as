package tools.common.vo
{
	import tools.common.bind.Data;
	
	public class SoulFosterVO extends Data
	{
		public function SoulFosterVO()
		{
			super();
		}
		
		override protected function getProperty(name:String):*
		{
			return this[name];
		}		
		override protected function setProperty(name:String, value:*) : void
		{
			this[name] = value;
			return;
		}

		private var _lev:int;

		public function get lev():int
		{
			return _lev;
		}

		public function set lev(value:int):void
		{
			valueChanged("lev", "_lev", value);
		}
		
		private var _rate:int;

		/**
		 * 陈功率
		 * @return 
		 * 
		 */		
		public function get rate():int
		{
			return _rate;
		}

		public function set rate(value:int):void
		{
			valueChanged("rate", "_rate", value);
		}

		private var _count:int;

		/**
		 *需要战魂石 
		 * @return 
		 * 
		 */		
		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			valueChanged("count", "_count", value);
		}


		private var _changePro:int;

		/**
		 * 转化率
		 * @return 
		 * 
		 */		
		public function get changePro():int
		{
			return _changePro;
		}

		public function set changePro(value:int):void
		{
			valueChanged("changePro", "_changePro", value);
		}

		
	}
}