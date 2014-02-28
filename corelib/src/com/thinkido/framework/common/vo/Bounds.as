package com.thinkido.framework.common.vo
{
	import com.thinkido.framework.common.pool.IPoolClass;
	import com.thinkido.framework.common.pool.Pool;
	import com.thinkido.framework.manager.PoolManager;
	
	import flash.geom.Rectangle;
	/**
	 * 类似rectangle 
	 * @author Administrator
	 * 
	 */
    public class Bounds extends Object implements IPoolClass
    {
        public var left:int;
        public var right:int;
        public var top:int;
        public var bottom:int;
        private static const max:Function = Math.max;
        private static const min:Function = Math.min;
		private static var boundsPool:Pool = PoolManager.creatPool("boundsPool",3000);

        public function Bounds($left:int = 0, $right:int = 0, $top:int = 0, $bottom:int = 0)
        {
			reSet( [$left,$right,$top,$bottom] ) ;
            return;
        }

		public static function deleteBounds($bound:IPoolClass):void{
			boundsPool.disposeObj($bound);
		}
		public static function creatBounds($left:int = 0, $right:int = 0, $top:int = 0, $bottom:int = 0):Bounds{
			return boundsPool.createObj(Bounds,$left,$right,$top,$bottom) as Bounds;
		}
		
        public function isEmpty() : Boolean
        {
            return this.right <= this.left || this.bottom <= this.top;
        }

        public function areaSize() : int
        {
            return (this.right - this.left) * (this.bottom - this.top);
        }

        public function contains(value1:Bounds) : Boolean
        {
            return value1.left >= this.left && value1.right <= this.right && value1.top >= this.top && value1.bottom <= this.bottom;
        }

        public function equals(value1:Bounds) : Boolean
        {
            return value1.left == this.left && value1.right == this.right && value1.top == this.top && value1.bottom == this.bottom;
        }
		/**
		 * 是否相交，true:相交 
		 * @param value1
		 * @return 
		 * 
		 */
        public function intersects(value1:Bounds) : Boolean
        {
            var _leftMax:int = max(this.left, value1.left);
            var _rightMin:int = min(this.right, value1.right);
            var _topMax:int = max(this.top, value1.top);
            var _bottomMin:int = min(this.bottom, value1.bottom);
            if (_leftMax < _rightMin && _topMax < _bottomMin)
            {
                return true;
            }
            return false;
        }
		/**
		 * 交集 
		 * @param value1
		 * @return 
		 * 
		 */
        public function intersection(value1:Bounds) : Bounds
        {
			var _leftMax:int = max(this.left, value1.left);
			var _rightMin:int = min(this.right, value1.right);
			var _topMax:int = max(this.top, value1.top);
			var _bottomMin:int = min(this.bottom, value1.bottom);
			if (_leftMax < _rightMin && _topMax < _bottomMin)
			{
                return creatBounds(_leftMax , _rightMin , _topMax , _bottomMin );
            }
            return null;
        }
		/**
		 * 交集 
		 * @param value1
		 * @return 
		 * 
		 */
        public function intersectionRect(value1:Bounds) : Rectangle
        {
			var _leftMax:int = max(this.left, value1.left);
			var _rightMin:int = min(this.right, value1.right);
			var _topMax:int = max(this.top, value1.top);
			var _bottomMin:int = min(this.bottom, value1.bottom);
			if (_leftMax < _rightMin && _topMax < _bottomMin)
			{
				return new Rectangle(_leftMax, _topMax, _rightMin - _leftMax, _bottomMin - _topMax);
            }
            return null;
        }
		/**
		 * 返回新的并集 
		 * @param value1
		 * @return 
		 * 
		 */
        public function union(value1:Bounds) : Bounds
        {
			var _leftMax:int = min(this.left, value1.left);
			var _rightMin:int = max(this.right, value1.right);
			var _topMax:int = min(this.top, value1.top);
			var _bottomMin:int = max(this.bottom, value1.bottom);
			return creatBounds(_leftMax , _rightMin , _topMax , _bottomMin);
        }
		/**
		 * 并集 
		 * @param value1
		 * 
		 */
        public function extend(value1:Bounds) : void
        {
            this.left = min(this.left, value1.left);
            this.right = max(this.right, value1.right);
            this.top = min(this.top, value1.top);
            this.bottom = max(this.bottom, value1.bottom);
            return;
        }

        public function clone() : Bounds
        {
            return creatBounds(this.left, this.right, this.top, this.bottom);
        }

        public static function toRectangle(value1:Bounds) : Rectangle
        {
            return new Rectangle(value1.left, value1.top, value1.right - value1.left, value1.bottom - value1.top);
        }

        public static function fromRectangle(value1:Rectangle) : Bounds
        {
            return creatBounds(value1.left, value1.right, value1.top, value1.bottom);
        }

		public function dispose():void
		{
			this.left = 0 ;
			this.right = 0 ;
			this.top = 0 ;
			this.bottom = 0 ;
		}
		
		public function reSet($inins:Array):void
		{
			this.left = $inins[0] ;
			this.right = $inins[1] ;
			this.top = $inins[2] ;
			this.bottom = $inins[3] ;
		}
    }
}
