package vo
{
	import flash.display.Shape;
	import flash.geom.Point;

	public class HinderPointVO
	{
		public function HinderPointVO()
		{
		}
		
		/**坐标*/
		public var p:Point = new Point();
		
		/**0表示阻挡，1表示阴影*/
		public var type:int = 0;
		
		public var shape:Shape;
	}
}