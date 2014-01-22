package
{
	import flash.display.BitmapData;
	
	[Bindable]
	public class ItemVO
	{
		public function ItemVO($cla:BitmapData=null, $selected:Boolean = true, $type:int = 36)
		{
			cla = $cla;
			selected = $selected;
			type = $type;
		}
		
		public var cla:BitmapData;
		
		public var selected:Boolean = true;
		
		public var type:int;
	}
}