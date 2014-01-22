package com.g6game.display
{
	import com.g6game.managers.EditorManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vo.CellVO;
	import vo.TransPointVO;
	
	/**
	 * 传送点
	 */
	public class TransportRect extends Sprite
	{
		
		public var voo:TransPointVO;
		public function TransportRect()
		{
			mouseChildren = false;
			this.graphics.beginFill(0x009dff);
			this.graphics.drawRect(0, 0, CellVO.CELL_WIDTH, CellVO.CELL_HEIGHT);
			this.graphics.endFill();
			var text:TextField = new TextField();
			text.defaultTextFormat = new TextFormat("Simu", 14, 0x000000, null, null, null, null, null, "center");
			text.text = "传";
			text.width = 20;
			text.height = text.textHeight + 4;
			addChild(text);
			text.x = (this.width - text.width)*0.5;
			text.y = (this.height - text.height)*0.5;

		}
	}
}