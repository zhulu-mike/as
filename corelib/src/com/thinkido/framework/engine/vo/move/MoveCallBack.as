package com.thinkido.framework.engine.vo.move
{
	/**
	 * 移动回调方法 
	 * @author Administrator
	 */
    public class MoveCallBack extends Object
    {
        public var onMoveReady:Function;
        public var onMoveThrough:Function;
        public var onMoveArrived:Function;
        public var onMoveUnable:Function;

        public function MoveCallBack()
        {
            return;
        }

        public function clone() : MoveCallBack
        {
            var temp:MoveCallBack = new MoveCallBack();
            temp.onMoveReady = this.onMoveReady;
            temp.onMoveThrough = this.onMoveThrough;
            temp.onMoveArrived = this.onMoveArrived;
            temp.onMoveUnable = this.onMoveUnable;
            return temp;
        }

    }
}
