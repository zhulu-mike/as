package com.g6game.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import utils.GridUtils;
	
	import vo.BornPointVO;
	import vo.CellVO;
	
	/**
	 * 出生点外衣
	 */
	public class BornSprite extends Sprite
	{
		public var voo:BornPointVO;
		private var text:TextField;
		
		public function BornSprite()
		{
//			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mouseChildren = false;
			this.graphics.beginFill(0x009dff);
			this.graphics.drawRect(0, 0, CellVO.CELL_WIDTH, CellVO.CELL_HEIGHT);
			this.graphics.endFill();
			text = new TextField();
			text.defaultTextFormat = new TextFormat("Simu", 12, 0xffffff, null, null, null, null, null, "center");
			text.text = "传";
			text.width = 20;
			text.height = text.textHeight + 4;
			addChild(text);
			text.x = (this.width - text.width)*0.5;
			text.y = (this.height - text.height)*0.5;
		}
		
		/**1表示怪物，2表示NPC, 3表示采集品*/
		public function update(type:int = 1):void
		{
			var color:uint;
			if (type == 1)
			{
				color = 0x00ff00;
				if (voo && voo.mname.length>0)
					text.text = voo.mname.substr(0,1);
				else
					text.text = "怪";
				if (this.voo && voo.mid != "")
					color = 0xff0000;
			}else if (type == 2){
				color = 0x000000;
				text.text = "NPC";
			}else{
				color = 0x0000ff;
				if (this.voo && voo.mid != "")
					color = 0xff0000;
				text.text = "采";
			}
			this.graphics.endFill();
			this.graphics.beginFill(color);
			this.graphics.drawRect(0, 0, CellVO.CELL_WIDTH, CellVO.CELL_HEIGHT);
			this.graphics.endFill();
			
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			this.startDrag();
		}
			
		private function onMouseUp(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			this.stopDrag();
			this.voo.m = GridUtils.getMpos(x, y);
			this.voo.n = GridUtils.getNpos(x, y);
		}
		
		
	}
}