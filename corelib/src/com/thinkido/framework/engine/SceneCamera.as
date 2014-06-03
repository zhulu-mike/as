package com.thinkido.framework.engine
{
	import com.thinkido.framework.engine.config.GlobalConfig;
	import com.thinkido.framework.engine.config.SceneConfig;
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
			this.tileRangeXY = new Point();
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
            getViewTileRangeXY();
            this.zoneRangeXY = SceneUtil.getViewZoneRangeXY(this._scene);
            this.x_limen = this._scene.sceneConfig.width * this.LIMEN_RATIO;
            this.y_limen = this._scene.sceneConfig.height * this.LIMEN_RATIO;
        }
		
		/**
		 * 获取可渲染范围的区域。
		 * @param $scene
		 * @return 
		 * 
		 */
		private function getViewTileRangeXY() : void
		{
			tileRangeXY.x = GlobalConfig.renderWidth >> 1;
			tileRangeXY.y = GlobalConfig.renderHeight >> 1;
		}
		
		/**
		 * 能否看到角色 
		 * @param sc 需要判断 的 角色
		 * @return true:能看见
		 * 
		 */
        public function canSee(sc:SceneCharacter) : Boolean
        {
			var tx:int = sc.tile_x, ty:int = sc.tile_y, stx:int = _lastScTileX, sty:int = _lastScTileY;
            return tx >= stx-this.tileRangeXY.x && tx <= this.tileRangeXY.x+stx && ty >= sty-this.tileRangeXY.y && ty <= this.tileRangeXY.y+sty;
        }
		/**
		 * 能否看到网格 
		 * @param  需要判断 的 网格x,y
		 * @return true:能看见
		 */
        public function canSeeTile($tileX:int ,$tileY:int) : Boolean
        {
			var stx:int = _lastScTileX, sty:int = _lastScTileY;
            return $tileX >= stx-this.tileRangeXY.x && $tileX <= this.tileRangeXY.x+stx && $tileY >= sty-this.tileRangeXY.y && $tileY <= this.tileRangeXY.y+sty;
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
		private var _lastScTileX:int = -1;
		private var _lastScTileY:int = -1;
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
			if( _lastScPixelX == _followCharacter.pixel_x && _lastScPixelY == _followCharacter.pixel_y && !isForce){
				return ;
			}else{
				_lastScPixelX = _followCharacter.pixel_x ;
				_lastScTileX = _lastScPixelX / SceneConfig.TILE_WIDTH;
				_lastScPixelY = _followCharacter.pixel_y ;
				_lastScTileY = _lastScPixelY/SceneConfig.TILE_HEIGHT;
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
            var _cp:Point = new Point(this._followCharacter.pixel_x, this._followCharacter.pixel_y);
            _cp = this._scene.localToGlobal(_cp);
            if (this._scene.mapConfig.width > this._scene.sceneConfig.width)
            {
                _centerX = this._scene.sceneConfig.width >> 1;
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
                        this._scene.x += moveDisX;
                    }
                    else
                    {
                        this._scene.x = (this._scene.x + moveDisX * this.TWEEN_SPEED)<<0;
                    }
                }
            }
            else
            {
                _centerX = this._scene.mapConfig.width >> 1;
                resuleX = (this._scene.sceneConfig.width - this._scene.mapConfig.width) >> 1;
                if (this._scene.x != resuleX)
                {
                    this._scene.x = resuleX;
                }
            }
            if (this._scene.mapConfig.height > this._scene.sceneConfig.height)
            {
                _y = this._scene.sceneConfig.height >> 1;
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
                        this._scene.y += moveDisY ;
                    }
                    else
                    {
                        this._scene.y = (this._scene.y + moveDisY * this.TWEEN_SPEED)<<0 ;
                    }
                }
            }
            else
            {
                _y = this._scene.mapConfig.height >> 1;
                resuleY = (this._scene.sceneConfig.height - this._scene.mapConfig.height) >> 1;
                if (this._scene.y != resuleY)
                {
                    this._scene.y = resuleY;
                }
            }
			_cp.x = _centerX;
			_cp.y = _y;
			_cp = this._scene.globalToLocal(_cp);
            pixel_x = _cp.x;
            pixel_y = _cp.y;
            return;
        }

    }
}
