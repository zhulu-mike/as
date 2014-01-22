package com.thinkido.framework.common.higheffect.snow
{
	import com.thinkido.framework.common.pool.Pool;
	import com.thinkido.framework.common.utils.ZMath;
	import com.thinkido.framework.manager.PoolManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * 雪盒子，在盒子内显示下雪效果 
	 * @author thinkido
	 * 
	 */
    public class SnowBox extends Sprite
    {
        private var _showArea:Rectangle;
		/**
		 * 雪bitmap图片数组 
		 */		
        private var _snowBDArr:Array;
        private var _eachSnowCount:Number = 1;
        private var _waitAddSnowCount:Number = 0;
        private var _isRunning:Boolean = false;
        private var _areaTop:Number;
        private var _areaLeft:Number;
        private var _areaWidth:Number;
        private var _areaHeight:Number;
        private var _areaBottom:Number;
        private var _areaRight:Number;
        private static var snowFacePool:Pool = PoolManager.creatPool("snowFacePool", 100);
        public static const SNOW_COMPLETE:String = "SNOW_COMPLETE";
        private static const MARGIN:Number = 50;
        private static const MIN_X_STEP:Number = 0;
        private static const MAX_X_STEP:Number = 1;
        private static const MIN_Y_STEP:Number = 1;
        private static const MAX_Y_STEP:Number = 5;
        private static const DENS:Number = 0.000333333;
		/**
		 * 渲染效果的区域
		 * @param $rec 效果区域 
		 * @param $snowBDArr 雪bitmap图片数组
		 * @param $start 是否立刻开始
		 * 
		 */
        public function SnowBox($rec:Rectangle, $snowBDArr:Array = null, $start:Boolean = true)
        {
            mouseChildren = false;
            mouseEnabled = false;
            this.setShowArea($rec);
            this._snowBDArr = $snowBDArr || [];
            if ($start)
            {
                this.start();
            }
            return;
        }
		/**
		 * 是否在运行 
		 * @return 
		 * 
		 */
        public function get isRunning() : Boolean
        {
            return this._isRunning;
        }

        public function setShowArea($rec:Rectangle) : void
        {
//			临时注释
            /*var _loc_3:SnowFace = null;
            this._showArea = $rec.clone();
            this._areaLeft = this._showArea.x - MARGIN;
            this._areaTop = this._showArea.y - MARGIN;
            this._areaWidth = this._showArea.width + MARGIN;
            this._areaHeight = this._showArea.height + MARGIN;
            this._areaRight = this._showArea.right;
            this._areaBottom = this._showArea.bottom;
            this._eachSnowCount = this._areaWidth * DENS;
            var _loc_2:* = numChildren - 1;
            while (_loc_2 >= 0)
            {
                
                _loc_3 = getChildAt(_loc_2) as SnowFace;
                _loc_3.setScope(this._areaLeft, this._areaRight, this._areaBottom);
                _loc_2 = _loc_2 - 1;
            }*/
            return;
        }
		/**
		 * 开始运行 
		 * @param $clear 是否清楚以有效果
		 * 
		 */
        public function start($clear:Boolean = false) : void
        {
            if ($clear)
            {
                while (numChildren > 0)
                {
                    removeChildAt(0);
                }
            }
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            this._isRunning = true;
            return;
        }
		/**
		 *  
		 * @param $clear 清除屏幕
		 * @param $clearPool 清除缓存
		 * 
		 */
        public function stop($clear:Boolean = false, $clearPool:Boolean = false) : void
        {
            if ($clear)
            {
                while (numChildren > 0)
                {
                    removeChildAt(0);
                }
            }
            if ($clearPool)
            {
                snowFacePool.removeAllObjs();
            }
            if (numChildren == 0)
            {
                this.stopEnterFrame();
            }
            this._isRunning = false;
            return;
        }
		/**
		 * 停止渲染并派发完成事件 
		 */
        private function stopEnterFrame() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            dispatchEvent(new Event(SNOW_COMPLETE));
            return;
        }
		/**
		 * 渲染事件 
		 * @param event
		 */
        private function onEnterFrame(event:Event) : void
        {
//			临时注释
            /*var _loc_3:SnowFace = null;
            if (this._isRunning)
            {
                this._waitAddSnowCount = this._waitAddSnowCount + this._eachSnowCount;
                while (this._waitAddSnowCount >= 1)
                {
                    
                    this.creatNewSnow();
					_waitAddSnowCount -= 1;
                }
            }
            var _loc_2:* = numChildren - 1;
            while (_loc_2 >= 0)
            {
                
                _loc_3 = getChildAt(_loc_2) as SnowFace;
                if (_loc_3.update())
                {
                    removeChild(_loc_3);
                    recycleSnowFace(_loc_3);
                    if (!this._isRunning && numChildren == 0)
                    {
                        this.stopEnterFrame();
                    }
                }
                _loc_2 = _loc_2 - 1;
            }*/
            return;
        }
		/**
		 * 创建新的雪 
		 */
        private function creatNewSnow() : void
        {
            var _loc_1:BitmapData = null;
            if (this._snowBDArr.length > 0)
            {
                _loc_1 = this._snowBDArr[ZMath.getRandomNumber(0, (this._snowBDArr.length - 1))] as BitmapData;
            }
          /*  var _loc_2:* = createSnowFace(_loc_1);
            var _loc_3:* = Math.random();
            _loc_2.setXY(this._areaLeft + Math.random() * this._areaWidth, this._areaTop);
            var _loc_4:* = MIN_X_STEP + (MAX_X_STEP - MIN_X_STEP) * _loc_3;
            if (Math.random() > 0.5)
            {
                _loc_4 = _loc_4 * -1;
            }
            var _loc_5:* = MIN_Y_STEP + (MAX_Y_STEP - MIN_Y_STEP) * _loc_3;
            _loc_2.setStep(_loc_4, _loc_5);
            _loc_2.setScope(this._areaLeft, this._areaRight, this._areaBottom);
            addChild(_loc_2);*/
            return;
        }

        /*private static function createSnowFace(value1:BitmapData) : SnowFace
        {
            return snowFacePool.createObj(SnowFace, value1) as SnowFace;
        }

        private static function recycleSnowFace(value1:SnowFace) : void
        {
            snowFacePool.disposeObj(value1);
            return;
        }
*/
    }
}
