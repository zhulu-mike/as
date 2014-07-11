package configs
{
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
	}
}