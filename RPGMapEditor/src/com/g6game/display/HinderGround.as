package com.g6game.display
{
	import com.g6game.factory.GreenCircleFactory;
	import com.g6game.factory.HinderPointFactory;
	import com.g6game.factory.RedShapeFactory;
	import com.g6game.managers.EditorConfig;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import utils.GridUtils;
	
	import vo.CellVO;
	import vo.HinderPointVO;
	
	/**
	 * 阻挡和阴影层
	 */
	public class HinderGround extends BaseGround
	{
		//路障
//		private var hinderArr:Vector.<HinderPointVO> = new Vector.<HinderPointVO>();
		private var hinderArr:Dictionary = new Dictionary();
		
		private var currentIndex:String;
		
		public function HinderGround()
		{
			setMouseEnable(false);
		}
		
		public function init():void
		{
			currentIndex = "";
			deleteAllHinders();
			while (this.numChildren)
			{
				
			}
		}
		
		
		/**
		 * 搜索该位置是否有处理过的点
		 * @param m:int the point row index 
		 * @param n:int the point col index
		 */
		public function searchPoint(m:int,n:int):Boolean
		{
			var hinder:Boolean = searchHinderPoint(m,n);
			return hinder;
		}
		
		
		/**
		 * 搜索该位置是否有障碍点
		 * @param m:int the point row index 
		 * @param n:int the point col index
		 */
		private function searchHinderPoint(m:int,n:int):Boolean
		{
//			var len:int = hinderArr.length;
			if (!hinderArr)
				return false;
			if (hinderArr.hasOwnProperty(m+"_"+n))
			{
				currentIndex = m+"_"+n;
				return true;
			}
			return false;
			/*var i:int=0;
			var p:Point;
			for (i;i<len;i++)
			{
				p = hinderArr[i].p;
				if (m==p.x&&n==p.y){
					currentIndex = i;
					return true;
				}
			}
			return false;*/
		}
		
		/**
		 * 画路障点 
		 * 
		 */
		public function drawRedCircle(m:int,n:int):void
		{
			var xpos:Number = GridUtils.getXPos(m,n);
			var ypos:Number = GridUtils.getYPos(m,n);
			var app:RedCircle = RedShapeFactory.getInstance().getRedCircle();
			addChild(app);
			app.x = xpos+CellVO.CELL_WIDTH*0.5;
			app.y = ypos+CellVO.CELL_HEIGHT*0.5;
			var voo:HinderPointVO = HinderPointFactory.getInstance().getHinderPointVO();
			voo.p.x = m;
			voo.p.y = n;
			voo.type = 0;
			voo.shape = app;
			hinderArr[m+"_"+n] = voo;
			app = null;
		}
		
		/**
		 * 清除路障点 
		 * 
		 */
		public function destroyCircle():void
		{
			var voo:HinderPointVO = hinderArr[currentIndex];
			this.removeChild(voo.shape);
			if (voo.type == 0)
				RedShapeFactory.getInstance().recycleShape(voo.shape);
			else
				GreenCircleFactory.getInstance().recycleShape(voo.shape);
			HinderPointFactory.getInstance().recycleVO(voo);
			hinderArr[currentIndex] = null;
			delete hinderArr[currentIndex];
		}
		
		/**
		 * 画遮罩点 
		 * 
		 */
		public function drawGreenCircle(m:int,n:int):void
		{
			var xpos:Number = GridUtils.getXPos(m,n);
			var ypos:Number = GridUtils.getYPos(m,n);
			var app:GreenCircle = GreenCircleFactory.getInstance().getGreenCircle();
			addChild(app);
			app.x = xpos+CellVO.CELL_WIDTH*0.5;
			app.y = ypos+CellVO.CELL_HEIGHT*0.5;
			var voo:HinderPointVO = HinderPointFactory.getInstance().getHinderPointVO();
			voo.p.x = m;
			voo.p.y = n;
			voo.type = 1;
			voo.shape = app;
			hinderArr[m+"_"+n] = voo;
			app = null;
		}
		
		/**
		 * 删除所有的阻挡和阴影点
		 */
		public function deleteAllHinders():void
		{
			/*currentIndex = 0;
			var len:int = hinderArr.length;
			while (len > 0)
			{
				destroyCircle();
				len = hinderArr.length;
			}*/
			for (currentIndex in hinderArr)
			{
				destroyCircle();
			}
		}
		
		public function get hinders():Dictionary
		{
			return hinderArr;
		}
	}
}