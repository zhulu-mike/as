package display
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	
	public class CircleLoopEffect extends Sprite
	{
		
		private var filter:Array = [new GlowFilter(0xffff00,0.7)];
		
		/**
		 * 小圆圈的半径
		 */		
		public var smallRadius:Number = 5; 
		
		/**
		 * 小圆圈存放容器
		 */		
		private var circleArr:Array = [];
		
		private var currentIndex:int = 0;
		
		private var diffLen:int = 4;
		
		/**
		 * 圆形的加载动画
		 * @param radius 半径
		 * @param count 围绕中心转的圆圈数量
		 */		
		public function CircleLoopEffect(radius:Number,count:int)
		{
			draw(radius,count);
		}

		private function onEnterFrame(event:Event):void
		{
			initShape();
			var i:int = 0;
			var shape:Shape;
			var bScale:Number = 1;
			var index:int = currentIndex
			for (;i<diffLen;i++)
			{
				bScale += 0.2;
				shape = circleArr[index];
				shape.filters = filter;
				shape.scaleX = shape.scaleY = bScale;
				index++;
				if (index >= circleArr.length)
					index = 0;
			}
			currentIndex++;
			if (currentIndex >= circleArr.length)
				currentIndex = 0;
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 绘制
		 * @param radius
		 * @param count
		 * 
		 */		
		private function draw(radius:Number,count:int):void
		{
			circleArr.length = 0;
			var degree:Number =  (360 / count), beginDegree:Number = 270;
			var i:int = 0, cX:Number, cY:Number;
			var circle:Shape;
			for (;i<count;i++)
			{
				circle = new Shape();
				circle.graphics.beginFill(0xffff00,0.5);
				circle.graphics.drawCircle(0,0,smallRadius);
				circle.graphics.endFill();
				circleArr.push(circle);
				this.addChild(circle);
				circle.x = radius * Math.cos(angleToRadian(beginDegree));
				circle.y = radius * Math.sin(angleToRadian(beginDegree));
				beginDegree += degree;
			}
		}
		
		private function initShape():void
		{
			var i:int = 0, len:int = circleArr.length;
			var circle:Shape;
			for (;i<len;i++)
			{
				circle = circleArr[0];
				circle.graphics.clear();
				circle.graphics.beginFill(0xffff00,0.5);
				circle.graphics.drawCircle(0,0,smallRadius);
				circle.graphics.endFill();
				circle.filters = [];
			}
		}
		
		public function angleToRadian(angle : int) : Number {
			return angle * Math.PI / 180;
		}
	}
}