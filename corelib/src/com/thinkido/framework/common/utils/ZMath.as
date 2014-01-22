package com.thinkido.framework.common.utils
{
    import flash.geom.*;
    
    import org.osflash.thunderbolt.Logger;

    public class ZMath extends Object
    {
        private static var abs:Function = Math.abs;
        private static var sin:Function = Math.sin;
        private static var cos:Function = Math.cos;
        private static var sqrt:Function = Math.sqrt;
        private static var PI:Number = 3.14159;
        public static var toDeg:Number = 180 / PI;
        public static var toRad:Number = PI / 180;

        public function ZMath()
        {
            return;
        }

        public static function getRandomNumber(value1:Number, value2:Number) : Number
        {
            return Math.floor(Math.random() * (value2 - value1 + 1)) + value1;
        }

        public static function getDistanceSquare(value1:Number, value2:Number, value3:Number, value4:Number) : Number
        {
            return (value1 - value3) * (value1 - value3) + (value2 - value4) * (value2 - value4);
        }

        public static function getRotPoint(value1:Point, value2:Point, value3:Number) : Point
        {
            value3 = value3 * ZMath.toRad;
            var _loc_4:* = new Point();
			_loc_4.x = Math.cos(value3) * (value1.x - value2.x) - Math.sin(value3) * (value1.y - value2.y) + value2.x;
            _loc_4.y = Math.cos(value3) * (value1.y - value2.y) + Math.sin(value3) * (value1.x - value2.x) + value2.y;
            return _loc_4;
        }
		/**
		 * 返回两点间的弧度 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */
        public static function getTowPointsAngle(p1:Point, p2:Point) : Number
        {
            var angle:Number = Math.atan2(p2.y - p1.y, p2.x - p1.x);//此方法返回的是弧度，API上描述有误
//			Logger.warn("角度："+angle);
            if (angle < 0)
            {
                angle = angle + 2 * Math.PI;
            }
            return angle * 180 / Math.PI;
        }
		/**
		 * 获取领进的角度 
		 * @param angle 角度
		 * @param dirNum 方向数量
		 * @return 
		 * 
		 */
        public static function getNearAngel(angle:Number, dirNum:int = 8) : int
        {
            angle = ((angle % 360) + 360 )%360 ;
            var part:int = 360 / dirNum ;
            var index:int = Math.floor(angle / part);
            var pre:int = index * part;
            var next:int = (index + 1) * part;
            return (angle - pre <= next - angle ? (pre) : (next)) % 360;
        }
		/**
		 * 获取斜视角中的临近角度 
		 * @param angle
		 * @param dirNum
		 * @return 
		 * 
		 */		
        public static function getNearAngel45(angle:Number, dirNum:int = 4) : int
        {
            angle = ((angle % 360) + 360 )%360 ;
            var part:int = 360 / dirNum ;
            var index:int = Math.floor(angle / part);
            var pre:int = index * part + 45 ;
            var next:int = (index + 1) * part+ 45 ;
            return (angle - pre <= next - angle ? (pre) : (next)) % 360;
        }
		
		/**
		 * 保留小数点后几位
		 * 
		 */		
		public static function getPointBit(value:Number, bit:int):Number
		{
			var str:String = value.toString();
			var index:int = str.indexOf(".");
			str = str.substring(0,index+bit+1);
			return Number(str);
		}
    }
}
