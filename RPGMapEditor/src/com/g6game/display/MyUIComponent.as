package com.g6game.display
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	

	/**
	 * @author solo 
	 * copyright 2011-12-28
	 * 此子类是为了让sprite不超过canvas的范围，产生滚动条而
	 * 写
	 * 
	 */
	public class MyUIComponent extends UIComponent
	{
		public function MyUIComponent()
		{
			super();
		}
		
		
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var obj:DisplayObject = super.addChild(child);
			this.invalidateSize();
			return obj;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var obj:DisplayObject = super.addChildAt(child, index);
			this.invalidateSize();
			return obj;
		}
		
		/**
		 * 重载measure,手动设置测量高度 
		 * 
		 */
		override protected function measure():void
		{
			super.measure();
			var w:Number=0.0,h:Number=0.0,i:int=0,num:int=numChildren;
			while (num > 0){
				var child2:DisplayObject = getChildAt(num-1) as DisplayObject;
				w = Math.max(w,child2.width);
				h = Math.max(h, child2.height);
				num--;
			}
			measuredWidth = w;
			measuredHeight = h;
			trace(width,height);
		}
	}
}