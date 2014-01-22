package vo
{
	import com.g6game.display.BornSprite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class BornPointVO
	{
		public function BornPointVO()
		{
		}
		
		
		public var m:Number = NaN;
		
		public var n:Number = NaN;
		
		public var mid:String = "";
		
		public var mname:String = "";
		
		public var monster:BornSprite;
		
		public var type:int = 1;
		
		public var p:Point = new Point();
		
		public var dir:int = 0;
		
		public var group:int = 0;//队伍号
		
		public var model:String = "";//采集品模型
		
		public var goods:String = "";//采集品物资
	}
}