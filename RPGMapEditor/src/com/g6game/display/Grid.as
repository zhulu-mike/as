package com.g6game.display
{
	import flash.display.Sprite;
	
	import vo.CellVO;

	/**
	 * @author solo
	 * copyright 2012-07-12
	 * 栅格层
	 * 
	 */
	
	public class Grid extends BaseGround
	{
		private var _row:int;
		private var _col:int;
		
		private var rectHeight:Number;
		private var rectWidth:Number;
		
		private var wHalf:Number;
		private var hHalf:Number;
		
		private var mapWidth:Number;
		private var mapHeight:Number;
		private var leftHeight:Number;
		private var leftWidth:Number;
		private var buttomWidth:Number;
		private var topHeight:Number;
		private var basicHeight:Number;
		
		private var Map_Width:Number;
		private var Map_Height:Number;
		private var Tile_Width:Number;
		private var Tile_Height:Number;
		private var _wHalfTile:int;
		private var _hHalfTile:int;
		
		
		private var basic:Number;
		private var offset:Number;
		
		public function Grid()
		{
			
			/*this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0,0,1);*/
			this.mouseEnabled = false;
		}
		
		
		/**
		 * 画格子 
		 * @param row
		 * @param col
		 */
		public function drawGrid(row:int,col:int):Number
		{
			this.graphics.clear();
			_row = row;
			_col = col;
			
			
			rectHeight = col*CellVO.CELL_HEIGHT;
			rectWidth  = row*CellVO.CELL_WIDTH;
				
			dragCell();
			//this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0,0,rectWidth,rectHeight);
			//this.graphics.endFill();
			
			return leftHeight;
		}
		/**
		 * 画出格子 
		 */
		private function dragCell():void
		{
			var i:int = 0;
			var j:int = 0;
			this.graphics.lineStyle(1,0x000000);
			for (i;i<=_row;i++)
			{
				this.graphics.moveTo(i*CellVO.CELL_WIDTH, 0);
				this.graphics.lineTo(i*CellVO.CELL_WIDTH, rectHeight);
				//this.graphics.beginFill(0xff0000);
				//this.graphics.drawCircle(i*wHalf,leftHeight-i*hHalf,1);
				//this.graphics.endFill();
			}
			for (j;j<=_col;j++)
			{
				this.graphics.moveTo(0, j*CellVO.CELL_HEIGHT);
				this.graphics.lineTo(rectWidth, j*CellVO.CELL_HEIGHT);
			}
			return;
		}
		
		
		public function get row():int
		{
			return _row;
		}
		
		public function get col():int
		{
			return _col;
		}
	}
}