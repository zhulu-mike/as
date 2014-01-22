package vo
{
	[Bindable]
	public class MapVO
	{
		public function MapVO()
		{
		}
		
		public var rows:int = 0;//行数
		
		public var cols:int = 0;//格子的列数
		
		public var name:String = "";//地图名称
		
		public var born:Boolean = false;//是否已经添加人物出生点
		
		public var bornX:Number = 0;
		
		public var bornY:Number = 0;
		
		public var id:String = "";
		
		public var type:int = 0;//0表示公共地图","1个人地图","2组队地图","3公会地图
	}
}