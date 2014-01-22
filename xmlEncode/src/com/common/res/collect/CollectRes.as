package game.common.res.collect
{
	import game.common.res.BaseResID;

	public class CollectRes extends BaseResID
	{
		public var name:String;
		public var sceneid:int;
		public var x:int;
		public var y:int;
		public var direction:int = 0;
		
		public var targetGoods:int;
		
		
		public function CollectRes()
		{
		}
	}
}