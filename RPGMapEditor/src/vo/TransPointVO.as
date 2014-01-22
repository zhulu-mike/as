package vo
{
	import com.g6game.display.TransportGround;
	import com.g6game.display.TransportRect;
	
	import flash.display.Shape;
	import flash.geom.Point;

	public class TransPointVO
	{
		public function TransPointVO()
		{
		}
		
		/**坐标*/
		public var p:Point = new Point();
		
		
		public var shape:TransportRect;
		
		public var mid:String = "";//目标地图
		
		public var type:int = 1;//type:1-地图，2-关卡列表
		
		public var targetP:Point = new Point();
	}
}