package com.thinkido.framework.events
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	/**
	 * 自定义鼠标右键 
	 * @author Administrator
	 * 用于fp11之前旧版本的使用方法,可能于输入法冲突
	 */	
	public class MouseRightEvent extends MouseEvent
	{
		public static const MOUSE_CLICK:String = "Mouse_Click";
		public function MouseRightEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, localX:Number=0, localY:Number=0, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false, buttonDown:Boolean=false, delta:int=0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
	}
}