package com.thinkido.framework.manager
{
	import com.thinkido.framework.common.Global;
	import com.thinkido.framework.events.MouseRightEvent;
	import com.thinkido.framework.utils.RightClick;
	
	import flash.display.DisplayObject;
	/**
	 * flashplayer 屏蔽右键管理工具， 似乎使用了这个无法使用输入法，这里可以使用书法发的打开于关闭配合使用
	 * @author thinkido
	 * 
	 */
	public class RightClickManager
	{
		
		/**
		 * @param displayObject  弹出右键菜单的组件
		 * @param callBack 右击回调事件
		 * 
		 */		
		public static function registerRClick(displayObject:DisplayObject,callBack:Function):void
		{
			RightClick.init(Global.stage);
			if( !displayObject.hasEventListener(MouseRightEvent.MOUSE_CLICK)){
				displayObject.addEventListener(MouseRightEvent.MOUSE_CLICK,callBack);			
			}
		}
		
		public static function unregisterRClick(displayObject:DisplayObject,callBack:Function):void
		{
			RightClick.unInit(Global.stage);
			if( displayObject.hasEventListener(MouseRightEvent.MOUSE_CLICK)){
				displayObject.removeEventListener(MouseRightEvent.MOUSE_CLICK,callBack);
			}
		}
			
	}
}