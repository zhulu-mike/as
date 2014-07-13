package configs
{
	import managers.LogManager;

	public class PlayerState
	{
		public function PlayerState()
		{
		}
		
		public static const RECT:int = 1;
		
		public static const CIRCLE:int = 2;
		
		public static const TRIANGLE:int = 3;
		
		public static var stateList:Array = [RECT,CIRCLE,TRIANGLE];
		
		public static function randomState():int
		{
			var index:int = Math.random()*100;
			var unit:int = 100 / stateList.length;
			index = index / unit;
			index = index >= stateList.length ? (index-1) : index;
			return stateList[index];
		}
		
		public static function randomStateByPrevState(prev:int):int
		{
			prev--;
			var index:int = Math.random()*98;
			var unit:int = 99 / stateList.length;
			if (int(index / unit) == prev)
			{
				LogManager.logTrace(prev+","+index);
				var three:int = unit / 3;
				var rand:int = Math.random()*10;
				if (rand >= 5)
					three *= -1;
				index += three;
			}
			index = index > 98 ? 98 : index;
			index = index / unit;
			return stateList[index];
		}
	}
}