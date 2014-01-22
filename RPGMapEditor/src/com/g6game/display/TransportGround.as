package com.g6game.display
{
	import com.g6game.factory.TransportFactory;
	import com.g6game.managers.EditorManager;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.messaging.AbstractConsumer;
	
	import utils.GridUtils;
	
	import vo.CellVO;
	import vo.TransPointVO;

	public class TransportGround extends BaseGround
	{
		/**
		 * 传送层
		 */
		public function TransportGround()
		{
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		//传送
		private var transArr:Vector.<TransPointVO> = new Vector.<TransPointVO>();
		
		private var currentIndex:int;
		
		private var filter:Array = [new GlowFilter(0xFF0000,1,3,3,10,1)];
		
		private var filterSprite:TransportRect;
		
		public function init():void
		{
			currentIndex = -1;
			deleteAllHinders();
			filterSprite = null;
		}
		
		public function get trans():Vector.<TransPointVO>
		{
			return transArr;
		}
		
		/**
		 * 搜索该位置是否有传送点
		 * @param m:int the point row index 
		 * @param n:int the point col index
		 */
		public function searchTransPoint(m:int,n:int):Boolean
		{
			var len:int = transArr.length;
			if (len <= 0)
				return false;
			var i:int=0;
			var p:Point;
			for (i;i<len;i++)
			{
				p = transArr[i].p;
				if (m==p.x&&n==p.y){
					currentIndex = i;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 删除所有的传送点 
		 */
		public function deleteAllHinders():void
		{
			currentIndex = 0;
			var len:int = transArr.length;
			while (len > 0)
			{
				destroyCircle();
				len = transArr.length;
			}
		}
		
		/**
		 * 清除传送点 
		 * 
		 */
		public function destroyCircle():void
		{
			var voo:TransPointVO = transArr[currentIndex];
			voo.p = null;
			if (voo.shape == filterSprite){
				filterSprite = null;
				EditorManager.getInstance().hideSelectTrans();
			}
			this.removeChild(voo.shape);
			TransportFactory.getInstance().recycle(voo.shape);
			voo.shape = null;
			transArr.splice(currentIndex,1);
		}
		
		/**
		 * 画传送点 
		 * 
		 */
		public function drawTranspoint(m:int,n:int):TransPointVO
		{
			var xpos:Number = GridUtils.getXPos(m,n);
			var ypos:Number = GridUtils.getYPos(m,n);
			var app:TransportRect = TransportFactory.getInstance().getTransportRect();
			addChild(app);
			app.x = xpos;
			app.y = ypos;
			var voo:TransPointVO = new TransPointVO();
			voo.p.x = m;
			voo.p.y = n;
			voo.shape = app;
			app.voo = voo;
			transArr.push(voo);
			app = null;
			return voo;
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (e.target is TransportRect)
			{
				if (filterSprite)
					filterSprite.filters = [];
				if (filterSprite == e.target)
				{
					filterSprite = null;
					EditorManager.getInstance().hideSelectTrans();
				}
				else
				{
					e.target.filters = filter;
					filterSprite = e.target as TransportRect;
					EditorManager.getInstance().showSelectTrans(filterSprite.voo);
				}
			}
		}
		
		public function changeProperty(id:int, t:String, p:Point=null):void
		{
			p = p == null ? new Point(0,0) : p;
			if (filterSprite)
			{
				filterSprite.voo.type = id;
				filterSprite.voo.mid = t;
				filterSprite.voo.targetP.x = p.x;
				filterSprite.voo.targetP.y = p.y;
				Alert.show("修改成功");
			}
			else
			{
				Alert.show("请先选中一个传送点");
			}
		}
				
	}
}