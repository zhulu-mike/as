package com.g6game.display
{
	import com.g6game.managers.EditorManager;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import utils.GridUtils;
	
	import vo.CellVO;
	
	/**
	 * 交互层
	 */
	public class InteractiveGround extends BaseGround
	{
		
		private var _row:int;
		private var _col:int;
		private var rectHeight:Number;
		private var rectWidth:Number;
		private var beginPoint:Point = new Point();
		private var endPoint:Point = new Point();
		
		public function InteractiveGround()
		{
			addEventListener(MouseEvent.CLICK, onClickLayer);
		}
		
		public function fillBackground(row:int,col:int):void
		{
			this.graphics.clear();
			_row = row;
			_col = col;
			rectHeight = col*CellVO.CELL_HEIGHT;
			rectWidth  = row*CellVO.CELL_WIDTH;
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(0,0,rectWidth,rectHeight);
			this.graphics.endFill();
			
			
			
		}
		
		private function onClickLayer(e:MouseEvent):void
		{
			EditorManager.getInstance().onClickLayer(e);
		}
		
		/***/
		public function addMouseDownListener():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onMouseDown(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, onClickLayer);
			addEventListener(MouseEvent.MOUSE_UP, onMouseMove);
		}

		private function onMouseMove(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onClickLayer);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseMove);
		}
		
		/***/
		public function removeMouseDownListener():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown2);
			addEventListener(MouseEvent.CLICK, onClickLayer);
		}
		
		/**框选*/
		public function addMouseDownListener2():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown2);
			removeEventListener(MouseEvent.CLICK, onClickLayer);
		}
		
		private function onMouseDown2(event:MouseEvent):void
		{
			beginPoint.x = event.localX;
			beginPoint.y = event.localY;
			addEventListener(MouseEvent.MOUSE_MOVE, drawRectLine);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onMouseOut(event:MouseEvent):void
		{
			var g:Graphics = EditorManager.getInstance().app.hinder.graphics;
			g.clear();
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.MOUSE_MOVE, drawRectLine);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			var g:Graphics = EditorManager.getInstance().app.hinder.graphics;
			g.clear();
			onMouseOut(event);
			endPoint.x = event.localX;
			endPoint.y = event.localY;
			drawPoint();
		}
		
		private function drawRectLine(e:MouseEvent):void
		{
			var g:Graphics = EditorManager.getInstance().app.hinder.graphics;
			g.clear();
			g.lineStyle(2,0xff0000);
			g.moveTo(beginPoint.x, beginPoint.y);
			g.lineTo(e.localX, beginPoint.y);
			g.lineTo(e.localX, e.localY);
			g.lineTo(beginPoint.x, e.localY);
			g.lineTo(beginPoint.x, beginPoint.y);
		}
		
		/** */
		private function drawPoint():void
		{
			var bx:int = GridUtils.getMpos(beginPoint.x, beginPoint.y);
			var by:int = GridUtils.getNpos(beginPoint.x, beginPoint.y);
			var ex:int = GridUtils.getMpos(endPoint.x, endPoint.y);
			var ey:int = GridUtils.getNpos(endPoint.x, endPoint.y);
			var minX:int = Math.min(bx,ex), maxX:int = Math.max(bx,ex);
			var minY:int = Math.min(by,ey), maxY:int = Math.max(by,ey);
			var i:int=0,j:int=0;
			for (i=minX;i<=maxX;i++)
			{
				for (j=minY;j<=maxY;j++)
				{
					EditorManager.getInstance().drawPoint(i,j);
				}
			}
		}
	}
}