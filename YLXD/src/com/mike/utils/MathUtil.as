package com.mike.utils {
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Math 工具，包含常用方法
	 * @author thinkido
	 */
	public class MathUtil {
		public static const ORIGIN : Point = new Point(0, 0);
		public static const ONE_RADIANS:Number = 57.2958;
		public static const ONE_ANGLE:Number = 0.0174533;

		private static var _cosLock : Array;
		private static var _sinLock : Array;

		public static function angleToRadian(angle : int) : Number {
			return angle * Math.PI / 180;
		}
		public static function getRadiansByPoint(p1:Point, p2:Point) : Number
		{
			return Math.atan2(p2.y - p1.y, p2.x - p1.x);
		}
		
		public static function getRadiansByXY(x1:int, y1:int, x2:int, y2:int) : Number
		{
			return Math.atan2(y2 - y1, x2 - x1);
		}
		
		public static function getRadians($angle:Number) : Number
		{
			return $angle * ONE_ANGLE;
		}
		
		public static function toUAngle(angle : int) : int {
			if(angle > -1 && angle < 360)
				return angle;
			angle %= 360;
			if(angle < 0)
				angle += 360;
			return angle;
		}

		public static function cos(angle : int) : Number {
			if(MathUtil._cosLock == null) {
				MathUtil._cosLock = new Array(360);
				for(var i : int = 0;i < 360;i++) {
					MathUtil._cosLock[i] = Math.cos(i * Math.PI / 180);
				}
			}
			return MathUtil._cosLock[MathUtil.toUAngle(angle)];
		} 

		public static function sin(angle : int) : Number {
			if(MathUtil._sinLock == null) {
				MathUtil._sinLock = new Array(360);
				for(var i : int = 0;i < 360;i++) {
					MathUtil._sinLock[i] = Math.sin(i * Math.PI / 180);
				}
			}
			return MathUtil._sinLock[MathUtil.toUAngle(angle)];
		}

		public static function toIntRect(rect : Rectangle) : Rectangle {
			rect.x = Math.round(rect.x);
			rect.y = Math.round(rect.y);
			rect.width = Math.round(rect.width);
			rect.height = Math.round(rect.height);
			return rect;
		}
		/**
		 * @param n 当前值
		 * @param min 最小值
		 * @param max 最大值
		 * @return 修正数据值，属于介于最小值和 最大值 之间
		 * 
		 */
		public static function clamp(n : Number, min : Number, max : Number) : Number {
			if(n < min)
				return min;
			if(n > max)
				return max;
			return n;
		}

		public static function getAngle(startX : int, startY : int, endX : int, endY : int) : int {
			var dx : Number = endX - startX;
			var dy : Number = endY - startY;
			return Math.round(Math.atan2(dy, dx) / Math.PI * 180);
		}

		public static function getTwoPointAngle(start : Point, end : Point) : int {
			var dx : Number = end.x - start.x;
			var dy : Number = end.y - start.y;
			return Math.round(Math.atan2(dy, dx) / Math.PI * 180);
		}

		public static function random(min : int, max : int) : int {
			return Math.round(Math.random() * (max - min)) + min;
		}
		
		public static function randomNumber(min : Number, max : Number) : Number {
			return Math.random() * (max - min) + min;
		}

		public static function randomList(max : int) : Array {
			var s : Array = new Array();
			for(var i : int = 0;i < max;i++) {
				s.push(i);
			}
			var t : Array = new Array();
			while(s.length > 0) {
				t.push(s.splice(random(0, s.length - 1), 1));
			}
			return t;
		}

		public static function randomBoolean() : Boolean {
			var i : int = MathUtil.random(0, 1);
			return i == 0;
		}

		public static function getDistance(startX : Number, startY : Number, endX : Number, endY : Number) : Number {
			var dx : Number = endX - startX;
			var dy : Number = endY - startY;
			return Math.sqrt(dx * dx + dy * dy);
		}

		public static function getTwoPointDistance(start : Point, end : Point) : Number {
			if(start == null || end == null)
				return 0;
			var dx : Number = end.x - start.x;
			var dy : Number = end.y - start.y;
			return Math.sqrt(dx * dx + dy * dy);
		}

		public static function rotate(x : int, y : int, angle : int, tx : int = 0, ty : int = 0) : Point {
			var xr : int = Math.round(x * MathUtil.cos(angle)) - Math.round(y * MathUtil.sin(angle)) + tx;
			var yr : int = Math.round(x * MathUtil.sin(angle)) + Math.round(y * MathUtil.cos(angle)) + ty;
			return new Point(xr, yr);
		}

		public static function getRotateMatrix(target : DisplayObject, angle : int) : void {
			var matrix : Matrix = new Matrix();
			matrix.rotate(angle * Math.PI / 180);
			var a : Point = matrix.transformPoint(new Point(0, 0));
			var b : Point = matrix.transformPoint(new Point(target.width, 0));
			var c : Point = matrix.transformPoint(new Point(target.width, target.height));
			var d : Point = matrix.transformPoint(new Point(0, target.height));
			var minX : Number = Math.min(a.x, b.x, c.x, d.x);
			var minY : Number = Math.min(a.y, b.y, c.y, d.y);
			matrix.tx += -minX;
			matrix.ty += -minY;
		}

		public static function transformRect(a : Point, b : Point, c : Point, d : Point, tx : int, ty : int) : void {
			a.x += tx;
			a.y += ty;
			b.x += tx;
			b.y += ty;
			c.x += tx;
			c.y += ty;
			d.x += tx;
			d.y += ty;
		}

		public static function cutTwoPoint(source : Point, target : Point, radius : int) : Array {
			var distance : Number = MathUtil.getTwoPointDistance(source, target);
			var diameter : int = radius << 1;
			var cut : Point = new Point();
			if(distance > diameter) {
				var count : int = Math.ceil(distance / diameter);
				var angle : int = MathUtil.getTwoPointAngle(source, target);
				cut.x = Math.round(diameter * MathUtil.cos(angle));
				cut.y = Math.round(diameter * MathUtil.sin(angle));
				var list : Array = new Array();
				var point : Point = source.clone();
				for(var i : int = 0;i < count;i++) {
					list[i] = point;
					point = point.add(cut);
				}
				return list;
			} else {
				return [source];
			}
		}

		public static function getLastInsertPoint(source : Point, target : Point, radius : int) : Point {
			var distance : Number = MathUtil.getTwoPointDistance(source, target);
			var diameter : int = radius * 2;
			var cut : Point = new Point();
			if(distance > diameter) {
				var count : int = Math.ceil(distance / diameter) - 1;
				var angle : int = MathUtil.getTwoPointAngle(source, target);
				cut.x = count * diameter * MathUtil.cos(angle);
				cut.y = count * diameter * MathUtil.sin(angle);
				return source.add(cut);
			} else {
				return source;
			}
		}
		/**
		 * 获取直线距离上的第三个点 
		 * @param source 第1个点 
		 * @param target 第2个点 
		 * @param radius 距离
		 * @return 第3个点 
		 */		
		public static function getNextPoint(source : Point, target : Point, radius : int) : Point {
			var cut : Point = new Point();
			var angle : int = MathUtil.getTwoPointAngle( source,target );
			cut.x = radius * MathUtil.cos(angle);
			cut.y = radius * MathUtil.sin(angle);
			return target.add(cut);
		}
		/**
		 *  大于-180 且 小于等于 180    的角度差 
		 * @param source 第一个角度
		 * @param target 第二个角度
		 * @return 角度差
		 */
		public static function getCrossAngle(source : int, target : int) : int {
			if(source == target)
				return 0;
			if(source >= 360)
				source -= 360;
			else if(source < 0)
				source += 360;
			if(target >= 360)
				target -= 360;
			else if(target < 0)
				target += 360;
			var angle : int;
			if(source < target) {
				angle = target - source;
				if(angle > 180) {
					angle = 360 - angle;
					return -angle;
				} else
					return angle;
			} else {
				angle = source - target;
				if(angle > 180) {
					angle = 360 - angle;
					return angle;
				} else
					return -angle;
			}
		}
		
		/**
		 * 根据2点获取前端方向 ，-1 为错误，
		 * @param curP
		 * @param nextP
		 * @return 
		 * 方向从时钟12点方向开始： 4 5 6 7 0 1 2 3
		 */		
		public static function getVectorBy2Point(curP:Point, nextP:Point) : int
		{
			var tempX:int = nextP.x - curP.x;
			var tempY:int = nextP.y - curP.y;
			if (tempX == 0 && tempY == 1)
			{
				return 0 ;
			}else 
			if (tempX == -1 && tempY == 1)
			{
				return 1;
			}else 
			if (tempX == -1 && tempY == 0)
			{
				return 2;
			}else 
			if (tempX == -1 && tempY == -1)
			{
				return 3;
			}else 
			if (tempX == 0 && tempY == -1)
			{
				return 4;
			}else 
			if (tempX == 1 && tempY == -1)
			{
				return 5;
			}else 
			if (tempX == 1 && tempY == 0)
			{
				return 6;
			}else 
			if (tempX == 1 && tempY == 1)
			{
				return 7;
			}
			return -1;
		}
		
		public static function getPointByAngle(x:int, y:int, angle:int):Point
		{
			var p:Point = new Point(x, y);
			switch (angle)
			{
				case 0:
					p.y += 1; 
					break;
				case 1:
					p.x -= 1;
					p.y += 1; 
					break;
				case 2:
					p.x -= 1; 
					break;
				case 3:
					p.x -= 1;
					p.y -= 1; 
					break;
				case 4:
					p.y -= 1; 
					break;
				case 5:
					p.x += 1;
					p.y -= 1; 
					break;
				case 6:
					p.x += 1; 
					break;
				case 7:
					p.x += 1;
					p.y += 1; 
					break;
			}
			return p;
		}
		/**
		 * 根据2点获取前端方向 ，-1 为错误，
		 * @param curP
		 * @param nextP
		 * @return 
		 * 方向从时钟12点方向开始： 4 5 6 7 0 1 2 3
		 */		
		public static function getVectorBy2XY(cx:int ,cy:int, nx:int ,ny:int) : int
		{
			var tempX:int = nx - cx;
			var tempY:int = ny - cy;
			if (tempX == 0 && tempY == 1)
			{
				return 0;
			}else
			if (tempX == -1 && tempY == 1)
			{
				return 1;
			}else
			if (tempX == -1 && tempY == 0)
			{
				return 2;
			}else
			if (tempX == -1 && tempY == -1)
			{
				return 3;
			}else
			if (tempX == 0 && tempY == -1)
			{
				return 4;
			}else
			if (tempX == 1 && tempY == -1)
			{
				return 5;
			}else
			if (tempX == 1 && tempY == 0)
			{
				return 6;
			}else
			if (tempX == 1 && tempY == 1)
			{
				return 7;
			}
			return -1;
		}
		
		/**
		 * 根据两点确定这两点连线的二元一次方程 y = ax + b或者 x = ay + b
		 * @param ponit1
		 * @param point2
		 * @param type		指定返回函数的形式。为0则根据x值得到y，为1则根据y得到x
		 * 
		 * @return 由参数中两点确定的直线的二元一次函数
		 */		
		public static function getLineFunc(ponit1:Point, point2:Point, type:int=0):Function
		{
			var resultFuc:Function;
			
			
			// 先考虑两点在一条垂直于坐标轴直线的情况，此时直线方程为 y = a 或者 x = a 的形式
			if( ponit1.x == point2.x )
			{
				if( type == 0 )
				{
					throw new Error("两点所确定直线垂直于y轴，不能根据x值得到y值");
				}
				else if( type == 1 )
				{
					resultFuc =	function( y:Number ):Number
					{
						return ponit1.x;
					}
					
				}
				return resultFuc;
			}
			else if( ponit1.y == point2.y )
			{
				if( type == 0 )
				{
					resultFuc =	function( x:Number ):Number
					{
						return ponit1.y;
					}
				}
				else if( type == 1 )
				{
					throw new Error("两点所确定直线垂直于y轴，不能根据x值得到y值");
				}
				return resultFuc;
			}
			
			// 当两点确定直线不垂直于坐标轴时直线方程设为 y = ax + b
			var a:Number;
			
			// 根据
			// y1 = ax1 + b
			// y2 = ax2 + b
			// 上下两式相减消去b, 得到 a = ( y1 - y2 ) / ( x1 - x2 ) 
			a = (ponit1.y - point2.y) / (ponit1.x - point2.x);
			
			var b:Number;
			
			//将a的值代入任一方程式即可得到b
			b = ponit1.y - a * ponit1.x;
			
			//把a,b值代入即可得到结果函数
			if( type == 0 )
			{
				resultFuc =	function( x:Number ):Number
				{
					return a * x + b;
				}
			}
			else if( type == 1 )
			{
				resultFuc =	function( y:Number ):Number
				{
					return (y - b) / a;
				}
			}
			
			return resultFuc;
		}
		
		/**
		 * 得到两点间连线的斜率 
		 * @param ponit1	
		 * @param point2
		 * @return 			两点间连线的斜率 
		 * 
		 */		
		public static function getSlope( ponit1:Point, point2:Point ):Number
		{
			return (point2.y - ponit1.y) / (point2.x - ponit1.x); 
		}
		
		/**
		 * 判断某个点是否在多边形里面
		 * @param pt 要检测的点
		 * @param polygonVertex 多边形的顶点集合，每个点只需要出现一次。
		 * @return 
		 * 
		 */		
		public static function isPointInPolygon(pt:Point, polygonVertex:Vector.<Point>):Boolean
		{
			if (polygonVertex.length < 1)
				return false;
			 var nCross:int = 0, i:int = 0, nCount:int = polygonVertex.length;
			 var p1:Point, p2:Point;
			 var x:Number;
		　　for (;i < nCount;i++) 
		　　{ 
		　　　　p1 = polygonVertex[i]; 
		　　　　p2 = polygonVertex[(i + 1) % nCount];
		
		　　　　// 求解 y=p.y 与 p1p2 的交点
		　　　　if ( p1.y == p2.y ) // p1p2 与 y=p0.y平行 
			　　　　continue;
		　　　　if (pt.y < Math.min(p1.y, p2.y) ) // 交点在p1p2延长线上 
			　　　　　　continue; 
		　　　　if (pt.y >= Math.max(p1.y, p2.y) ) // 交点在p1p2延长线上 
			　　　　　　continue;
		　　　　// 求交点的 X 坐标 -------------------------------------------------------------- 
		　　　　x = (pt.y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
		　　　　if ( x > pt.x ) 
			　　　　　nCross++; // 只统计单边交点 
		　　}
			// 单边交点为偶数，点在多边形之外 --- 
			return (nCross % 2 == 1); 
		}
	}
}