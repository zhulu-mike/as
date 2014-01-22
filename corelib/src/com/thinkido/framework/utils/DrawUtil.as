package com.thinkido.framework.utils
{
	import com.thinkido.framework.common.vo.StyleData;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * 绘画工具，画线、圆... 
	 * @author thinkido
	 * 
	 */
    public class DrawUtil extends Object
    {
		private static const NEWPOINT:Point = new Point();
		
        public function DrawUtil()
        {
            throw new Event("静态类");
        }
		/**
		 *  画一条直线
		 * @param $canvas 基类为Sprite
		 * @param startPoint 起始点
		 * @param endPoint 结束点
		 * @param $styleData 线的信息，颜色、粗细等
		 * @param clear 是否清楚原来的图像
		 * 
		 */
        public static function drawLine($canvas:*, startPoint:Point, endPoint:Point, $styleData:StyleData = null, clear:Boolean = false) : void
        {
            if (!$canvas)
            {
                return;
            }
            $styleData = $styleData || StyleData.DEFAULT;
            var graph:Graphics = $canvas.graphics;
            if (clear)
            {
                graph.clear();
            }
            graph.lineStyle($styleData.lineThickness, $styleData.lineColor, $styleData.lineAlpha);
            graph.moveTo(startPoint.x, startPoint.y);
            graph.lineTo(endPoint.x, endPoint.y);
            return;
        }
		/**
		 * 画一个矩形 
		 * @param $canvas 基类为Sprite
		 * @param startPoint 起始点
		 * @param endPoint 结束点
		 * @param $styleData 线的信息，颜色、粗细等
		 * @param clear 是否清楚原来的图像
		 * 
		 */
        public static function drawRect($canvas:*, startPoint:Point, endPoint:Point, $styleData:StyleData = null, clear:Boolean = false) : void
        {
            if (!$canvas)
            {
                return;
            }
            $styleData = $styleData || StyleData.DEFAULT;
            var graph:Graphics = $canvas.graphics;
            if (clear)
            {
                graph.clear();
            }
            graph.lineStyle($styleData.lineThickness, $styleData.lineColor, $styleData.lineAlpha);
            graph.beginFill($styleData.fillColor, $styleData.fillAlpha);
            graph.moveTo(startPoint.x, startPoint.y);
            graph.lineTo(endPoint.x, startPoint.y);
            graph.lineTo(endPoint.x, endPoint.y);
            graph.lineTo(startPoint.x, endPoint.y);
            graph.lineTo(startPoint.x, startPoint.y);
            graph.endFill();
            return;
        }
		/**
		 * 画一个圆 
		 * @param $canvas 基类为Sprite
		 * @param startPoint 起始点
		 * @param endPoint 结束点
		 * @param $styleData 线的信息，颜色、粗细等
		 * @param clear 是否清楚原来的图像
		 * 
		 */
        public static function drawCircle($canvas:*, startPoint:Point, endPoint:Point, $styleData:StyleData = null, clear:Boolean = false) : void
        {
            if (!$canvas)
            {
                return;
            }
            $styleData = $styleData || StyleData.DEFAULT;
            var graph:Graphics = $canvas.graphics;
            if (clear)
            {
                graph.clear();
            }
            graph.lineStyle($styleData.lineThickness, $styleData.lineColor, $styleData.lineAlpha);
            graph.beginFill($styleData.fillColor, $styleData.fillAlpha);
            graph.drawCircle(startPoint.x, startPoint.y, Math.sqrt((endPoint.x - startPoint.x) * (endPoint.x - startPoint.x) + (endPoint.y - startPoint.y) * (endPoint.y - startPoint.y)));
            graph.endFill();
            return;
        }
		/**
		 * 画一个网格 
		 * @param $canvas
		 * @param $col x 方向列数
		 * @param $row y 方向行数
		 * @param $tileWidth 单个网格宽
		 * @param $tileHeight 单个网格高
		 * @param $point 起始点
		 * @param $styleData 线的信息，颜色、粗细等
		 * @param clear 是否清楚原来的图像
		 * 
		 */		
		public static function drawGrid($canvas:*, $col:int ,$row:int ,$tileWidth:int ,$tileHeight:int ,$point:Point , $styleData:StyleData = null, clear:Boolean = false) : void
		{
			if (!$canvas)
			{
				return;
			}
			$styleData = $styleData || StyleData.DEFAULT;
			var graph:Graphics = $canvas.graphics;
			if (clear)
			{
				graph.clear();
			}
			graph.lineStyle($styleData.lineThickness, $styleData.lineColor, $styleData.lineAlpha);
			var tempX:int ;
			var tempH:int ;
			var tempy:int ;
			var tempw:int ;
			tempH = $point.y + $row * $tileHeight ;
			tempw = $point.x + $col * $tileWidth ;
			for (var i:int = 0; i < $col ; i++) 
			{
				tempX = $point.x + i*$tileWidth ;
				graph.moveTo(tempX , $point.y );
				graph.lineTo(tempX , tempH );
			}
			for (var j:int = 0; j < $row ; j++) 
			{
				tempy = $point.y + j * $tileHeight ;
				graph.moveTo($point.x , tempy );
				graph.lineTo( tempw , tempy );
			}
			graph.endFill();
			return ;
		}
    }
}
