package com.components
{
	import flash.geom.Point;
	
	import starling.display.Sprite;
	
	public class ArrowGriphic extends Sprite
	{
		private var gs:GraphicSprite;
		
		public function ArrowGriphic()
		{
			gs = new GraphicSprite();
			this.addChild(gs);
		}
		/**
		 * 路径
		 */		
		private var path:Array = [];
		
		/**
		 * 每帧，划线宽度的减少量
		 */		
		private static const reduce:Number = 0.8;
		private static const reduceAlpha:Number = 0.04;
		/**
		 * 初始宽度
		 */		
		private static const INITTHICK:int = 10;
		
		/**
		 * 初始颜色
		 */		
		private static const INIT_COLOR:uint = 0x000000;
		
		public function addPoint(p:Point):void
		{
			//最多画10个点足矣
			if (path.length >= 10)
				return;
			path.push({point:p, w:INITTHICK,alpha:1.0});
		}
		
		public function update():void
		{
			if (path.length > 1)
			{
				gs.graphics.clear();
				gs.draw();
				
				var obj:Object;
				var i:int, len:int = path.length;
				for (;i<len;i++)
				{
					obj = path[i];
					obj.w = obj.w - reduce;
					obj.alpha -= reduceAlpha;
					if (obj.w <= 0)
					{
						path.splice(i,1);
						len--;
						i--;
					}
				}
				if (len > 1)
				{
					i = 0;
					for (;i<len;i++)
					{
						obj = path[i];
						if (i == 0)
						{
							gs.graphics.moveTo(obj.point.x,obj.point.y);
						}else{
							gs.graphics.lineStyle(obj.w,INIT_COLOR,1,true);
							gs.graphics.lineTo(obj.point.x,obj.point.y);
						}
					}
					gs.draw();
				}
			}
		}
		
		public function isComplete():Boolean
		{
			return path.length < 2;
		}
		
		public function destroy():void
		{
			gs.destroy();
			path.length = 0;
			path = null;
			gs.removeFromParent(true);
			gs = null;
		}
	}
}