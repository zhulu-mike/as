package com.thinkido.framework.engine
{
	import com.thinkido.framework.engine.utils.SceneUtil;
	import com.thinkido.framework.engine.vo.BaseElement;
	
	import flash.geom.Point;
	/**
	 * 摄像机,用于控制屏幕移动 
	 * @author Administrator
	 * 
	 */
    public class SceneCamera extends BaseElement
    {
        private const LIMEN_RATIO:Number = 0.05;
        private var x_limen:int = 200;
        private var y_limen:int = 116;
        private const TWEEN_SPEED:Number = 0.4 ;
        private var _scene:Scene;
        private var _followCharacter:SceneCharacter;
        private var _isLocked:Boolean = false;
        public var tileRangeXY:Point;
        public var zoneRangeXY:Point;

        public function SceneCamera(scene:Scene)
        {
            this._scene = scene;
            this.updateRangeXY();
        }

        public function lock() : void
        {
            this._isLocked = true;
        }

        public function unlock() : void
        {
            this._isLocked = false;
        }
		/**
		 *改变可视区域范围，（看齐屏幕中心点） 
		 * 坐标：scene坐标系
		 */
        public function updateRangeXY() : void
        {
            this.tileRangeXY = SceneUtil.getViewTileRangeXY(this._scene);
            this.zoneRangeXY = SceneUtil.getViewZoneRangeXY(this._scene);
            this.x_limen = this._scene.sceneConfig.width * this.LIMEN_RATIO;
            this.y_limen = this._scene.sceneConfig.height * this.LIMEN_RATIO;
        }
		/**
		 * 能否看到角色 
		 * @param sc 需要判断 的 角色
		 * @return true:能看见
		 * 
		 */
        public function canSee(sc:SceneCharacter) : Boolean
        {
            return sc.tile_x > tile_x - this.tileRangeXY.x && sc.tile_x < tile_x + this.tileRangeXY.x && sc.tile_y > tile_y - this.tileRangeXY.y && sc.tile_y < tile_y + this.tileRangeXY.y;
        }
		/**
		 * 能否看到网格 
		 * @param  需要判断 的 网格x,y
		 * @return true:能看见
		 */
        public function canSeeTile($tileX:int ,$tileY:int) : Boolean
        {
            return $tileX > tile_x - this.tileRangeXY.x && $tileX < tile_x + this.tileRangeXY.x && $tileY > tile_y - this.tileRangeXY.y && $tileY < tile_y + this.tileRangeXY.y;
        }
		/**
		 * 设定摄像机根据角色移动 
		 * @param chara 摄像机 捕获角色
		 * @param value2 
		 * 
		 */
        public function lookAt(chara:SceneCharacter, $useTween:Boolean = false) : void
        {
            this._followCharacter = chara;
            this.run($useTween);
        }
		private var _lastScPixelX:int = -1 ; 
		private var _lastScPixelY:int = -1 ; 
		/**
		 * 移动摄像头
		 * @param useTween 缓动
		 * @param isForce 强制更新，比如人物没人，场景宽高改变（拖动）窗口导致边缘出现黑边
		 */
        public function run(useTween:Boolean = true,isForce:Boolean = false ) : void
        {
            if (this._isLocked || _followCharacter == null)
            {
                return;
            }
            var _centerX:Number = 0;
            var _y:Number = 0;
            var gapW:Number = 0;
            var gapY:Number = 0;
            var resuleX:Number = 0;
            var resuleY:Number = 0;
            var moveDisX:Number = 0;
            var moveDisY:Number = 0;
            var sMoveX:Number = 0;
            var sMoveY:Number = 0;
			if( _lastScPixelX == _followCharacter.pixel_x && _lastScPixelY == _followCharacter.pixel_y && !isForce){
				return ;
			}else{
				_lastScPixelX = _followCharacter.pixel_x ;
				_lastScPixelY = _followCharacter.pixel_y ;
			}
            var _cp:Point = new Point(this._followCharacter.pixel_x, this._followCharacter.pixel_y);
            _cp = this._scene.localToGlobal(_cp);
			if (this._scene.mapConfig == null)
				throw new Error("mapconfig cannot find");
			if (this._scene.sceneConfig == null)
				throw new Error("sceneConfig cannot find");
            if (this._scene.mapConfig.width > this._scene.sceneConfig.width)
            {
                _centerX = this._scene.sceneConfig.width * 0.5;
                gapW = this._scene.sceneConfig.width - this._scene.mapConfig.width;
                moveDisX = _centerX - _cp.x;
                if (moveDisX > this.x_limen)
                {
                    sMoveX = moveDisX - this.x_limen;
                }
                else if (moveDisX < -this.x_limen)
                {
                    sMoveX = moveDisX + this.x_limen;
                }
                resuleX = this._scene.x + sMoveX;
                if (resuleX < gapW)
                {
                    resuleX = gapW;
                }
                if (resuleX > 0)
                {
                    resuleX = 0;
                }
                moveDisX = resuleX - this._scene.x;
                if (moveDisX != 0)
                {
                    if (!useTween)
                    {
                        this._scene.x = this._scene.x + moveDisX;
                    }
                    else
                    {
                        this._scene.x = (this._scene.x + moveDisX * this.TWEEN_SPEED)<<0;
                    }
                }
            }
            else
            {
                _centerX = this._scene.mapConfig.width * 0.5;
                resuleX = (this._scene.sceneConfig.width - this._scene.mapConfig.width) / 2;
                if (this._scene.x != resuleX)
                {
                    this._scene.x = resuleX;
                }
            }
            if (this._scene.mapConfig.height > this._scene.sceneConfig.height)
            {
                _y = this._scene.sceneConfig.height * 0.5;
                gapY = this._scene.sceneConfig.height - this._scene.mapConfig.height;
                moveDisY = _y - _cp.y;
                if (moveDisY > this.y_limen)
                {
                    sMoveY = moveDisY - this.y_limen;
                }
                else if (moveDisY < -this.y_limen)
                {
                    sMoveY = moveDisY + this.y_limen;
                }
                resuleY = this._scene.y + sMoveY;
                if (resuleY < gapY)
                {
                    resuleY = gapY;
                }
                if (resuleY > 0)
                {
                    resuleY = 0;
                }
                moveDisY = resuleY - this._scene.y;
                if (moveDisY != 0)
                {
                    if (!useTween)
                    {
                        this._scene.y = this._scene.y + moveDisY ;
                    }
                    else
                    {
                        this._scene.y = (this._scene.y + moveDisY * this.TWEEN_SPEED)<<0 ;
                    }
                }
            }
            else
            {
                _y = this._scene.mapConfig.height * 0.5;
                resuleY = (this._scene.sceneConfig.height - this._scene.mapConfig.height) / 2;
                if (this._scene.y != resuleY)
                {
                    this._scene.y = resuleY;
                }
            }
            var _p:Point = new Point(_centerX, _y);
            _p = this._scene.globalToLocal(_p);
            pixel_x = _p.x;
            pixel_y = _p.y;
            return;
        }

    }
}
