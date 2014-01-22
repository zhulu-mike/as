package vo
{
	import com.g6game.display.BaseGround;
	
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	
	[Bindable]
	public class LayerVO
	{
		public function LayerVO(l:BaseGround, ln:String = "", loc:Boolean = false, flag:Boolean = true, dele:Boolean = false, lockFlag:Boolean = false)
		{
			layer = l;
			canLock = loc;
			layerName = ln;
			editFlag = flag;
			deleteFlag = dele;
			lock = lockFlag;
		}
		
		public var layer:BaseGround;
		
		public var lock:Boolean = false;//是否锁定
		
		public var layerName:String = "";
		
		public var editFlag:Boolean = true;//是否可更改显示
		
		public var deleteFlag:Boolean = false;//是否可删除本层
		
		public var canLock:Boolean = false;//是否可以锁定,系统层不能锁定
	}
}