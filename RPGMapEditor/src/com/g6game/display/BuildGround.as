package com.g6game.display
{
	import com.g6game.factory.BitmapClipFactory;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class BuildGround extends BaseGround
	{
		public function BuildGround()
		{
			
		}
		
		public function init():void
		{
			filters = [];
			removeAllChild();
		}
		
		public function removeAllChild():void
		{
			while (numChildren)
			{
				BitmapClipFactory.getInstance().recycle(removeChildAt(0) as BitmapClip);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (child is BitmapClip)
			{
				return super.addChild(child);
			}
			else
			{
				throw new Error("只能添加BitmapClip类型的子对象");
			}
			return null;
		}
	}
}