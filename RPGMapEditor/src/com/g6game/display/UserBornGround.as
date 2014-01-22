package com.g6game.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import utils.GridUtils;

	public class UserBornGround extends BaseGround
	{
		/**
		 * 人物出生层
		 */
		public function UserBornGround()
		{
			super();
		}
		
		private var mainMC:Sprite;
		
		public function init():void
		{
			if (mainMC)
			{
				this.removeChild(mainMC);
			}
		}
		
		public function addMainMC():void
		{
			if (!mainMC)
			{
				mainMC = new Sprite();
				mainMC.graphics.beginFill(0x0208fd);
				mainMC.graphics.drawRect(0, 0, 30, 30);
				mainMC.graphics.endFill();
				mainMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			addChild(mainMC);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			mainMC.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mainMC.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			mainMC.startDrag();
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			mainMC.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mainMC.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			mainMC.stopDrag();
		}
		
		public function deleteMainMC():void
		{
			if (mainMC)
			{
				this.removeChild(mainMC);
			}
		}
		
		public function getBornPoint():Point
		{
			if (mainMC)
			{
				return new Point(mainMC.x, mainMC.y);
			}
			return null;
		}
		
		public function setMCpos(x:Number, y:Number):void
		{
			if (mainMC)
			{
				mainMC.x = GridUtils.getXPos(x,y);
				mainMC.y = GridUtils.getYPos(x,y);
			}
		}
	}
}