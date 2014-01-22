package lm.mui.manager
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import lm.mui.controls.GMenu;

	public class GMenuManager
	{
		public function GMenuManager()
		{
		}
		
		private static var ui:Sprite;
		private static var currentIns:GMenu;
		
		public static function init(l:Sprite):void
		{
			ui = l;
		}

		public static function removeInstance(event:MouseEvent):void
		{
			
//			if (currentIns && currentIns.parent == ui)
//				ui.removeChild(currentIns);
			if (currentIns)
			{
				//如果事件是点击菜单内部的item并且是mousedown事件时，不处理
				if (event && event.type == MouseEvent.MOUSE_DOWN && isMenuTarget(event))
					return;
				ui.stage.removeEventListener(MouseEvent.MOUSE_DOWN, removeInstance);
				ui.stage.removeEventListener(MouseEvent.CLICK, removeInstance);
				currentIns.visible = false;
			}
		}
		
		/***/
		public static function showMenu(menu:GMenu):void
		{
			if (currentIns && currentIns.parent)
				ui.removeChild(currentIns);
			ui.addChild(menu);
			menu.x = ui.stage.mouseX;
			menu.y = ui.stage.mouseY;
			currentIns = menu;
			ui.stage.addEventListener(MouseEvent.MOUSE_DOWN, removeInstance);
			ui.stage.addEventListener(MouseEvent.CLICK, removeInstance);
		}
		
		/** */
		private static function isMenuTarget(event:MouseEvent):Boolean
		{
			var target:DisplayObject = DisplayObject(event.target);
			while (target)
			{
				if (target is GMenu)
					return true;
				target = target.parent;
			}
			
			return false;
		}
	}
}