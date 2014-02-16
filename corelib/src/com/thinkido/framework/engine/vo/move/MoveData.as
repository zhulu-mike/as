package com.thinkido.framework.engine.vo.move
{
	import com.thinkido.framework.engine.move.PathCutter;
	
	import flash.geom.Point;
	/**
	 * 移动数据 ，移动数据、目标点等
	 * @author Administrator
	 * 
	 */
    public class MoveData extends Object
    {
        public var walk_speed:Number = 160;
        public var walk_pathArr:Array;
        public var walk_targetP:Point;
        public var walk_standDis:Number = 0;
        public var walk_lastTime:int = 0;
        public var walk_pathCutter:PathCutter;
        public var walk_MoveCallBack:MoveCallBack = null;
        public var jump_maxDis:Number = 200;
		/*** 自动寻路 ,false:用于显示鼠标,true:自动寻路不显示 */		
		public var walk_auto:Boolean = false ;
        public var jump_targetP:Point;
        public var jump_MoveCallBack:MoveCallBack = null;
        public var isJumping:Boolean;
        public var on2Jumping:Boolean;
        private static const J:Number = 450;
        private static const crossX:Number = 320;
        private static const crossY:Number = 350;
        private static const K:Number = -41142.9;

        public function MoveData()
        {
            return;
        }

        public function get jump_speed() : Number
        {
            return J + K / (this.walk_speed - K / J);
        }
		/**
		 * 清楚移动数据 
		 */
        public function clear() : void
        {
            this.walk_pathArr = null;
            this.walk_targetP = null;
            this.walk_lastTime = 0;
            this.walk_standDis = 0;
            if (this.walk_pathCutter)
            {
                this.walk_pathCutter.clear();
            }
            this.walk_MoveCallBack = null;
            this.jump_targetP = null;
            this.jump_MoveCallBack = null;
            this.isJumping = false;
            this.on2Jumping = false;
            return;
        }

    }
}
