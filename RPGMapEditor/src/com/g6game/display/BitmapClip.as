package com.g6game.display
{
	import com.g6game.managers.EditorManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	
	import vo.NpcVO;
	
	/**
	 * 图片包装器
	 */
	public class BitmapClip extends Sprite
	{
		public function BitmapClip()
		{
		
		}
		
		public function createListener():void
		{
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function cancelListener():void
		{
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public var info:NpcVO;
		
		public var className:String = "";
		
		private  var tranFlag:Boolean = false;//是否是传送点
		
		/**设置NPC属性*/
		public function setNpc(nid:String , nname:String):void
		{
			if (!info)
				info = new NpcVO();
			info.nid = nid;
			info.name = nname;
		}
		
		public function cancelNpc():void
		{
			info = null;
		}
		
		public function destroy():void
		{
			cancelListener();
			x = y = 0;
			info = null;
			className = "";
			tranFlag = false;
			this.filters = [];
			this.removeChildAt(0);
		}
		
		private function onClick(e:MouseEvent):void
		{
			EditorManager.getInstance().app.setBitmapClipFilter(this);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			this.startDrag(false);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			this.stopDrag();
		}
		
		public function set trans(value:Boolean):void
		{
			if (tranFlag == value)
				return;
			tranFlag = value;
			var str:String = "";
			if (tranFlag)
			{
				
				str = "设置传送点成功";
			}
			else
			{
				str = "取消传送点成功";
			}
			Alert.show(str);
		}
		
		public function get trans():Boolean
		{
			return tranFlag;
		}
	}
}