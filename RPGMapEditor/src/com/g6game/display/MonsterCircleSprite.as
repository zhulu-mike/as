package com.g6game.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import vo.CellVO;
	
	public class MonsterCircleSprite extends Sprite
	{
		public function MonsterCircleSprite()
		{
			draw(10);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onMouseDown(event:MouseEvent):void
		{
			this.startDrag();
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
		}

		private function onMouseUp(event:MouseEvent):void
		{
			this.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function draw(radius:int):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(5,0xff0000);
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawCircle(0,0,radius*CellVO.CELL_WIDTH);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,0xff0000);
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
		}
	}
}