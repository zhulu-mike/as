package lm.mui.interfaces
{
	import flash.display.DisplayObject;

	public interface IEffect
	{
		
		function play(target:DisplayObject, data:Object=null):void;
	}
}