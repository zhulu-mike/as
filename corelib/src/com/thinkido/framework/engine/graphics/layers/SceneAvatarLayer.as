package com.thinkido.framework.engine.graphics.layers
{
    import com.thinkido.framework.common.utils.dirty.DirtyBoundsMaker;
    import com.thinkido.framework.common.vo.Bounds;
    import com.thinkido.framework.engine.Scene;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
    import com.thinkido.framework.utils.SystemUtil;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    import org.osflash.thunderbolt.Logger;

	/**
	 * 场景中人物层，主要用于渲染(人物)对象  
	 * @author Administrator
	 * 
	 */
    public class SceneAvatarLayer extends Sprite
    {
        private var _scene:Scene;
        private var _avatarBDDict:Dictionary;
		/**
		 * avata x 向 格数 
		 */		
        private var _cutXCount:int;
		/**
		 * avata y 向 格数 
		 */		
        private var _cutYCount:int;
        private var _mapWidth:Number;
        private var _mapHeight:Number;
        private var _mH:Number;
        private var _mV:Number;
        private var _dH:Number;
        private var _dV:Number;
        public var removeBoundsArr:Array;
        public var clearBoundsArr:Array;
		/**
		 * 静止的，休眠的
		 */		
        public var restingAvatarPartArr:Array;
        private var _dirtyBoundsMaker:DirtyBoundsMaker;
        public static const MAX_AVATARBD_WIDTH:Number = 300;
        public static const MAX_AVATARBD_HEIGHT:Number = 300;
        private static const floor:Function = Math.floor;

        public function SceneAvatarLayer($sc:Scene)
        {
            this._avatarBDDict = new Dictionary();
            this.removeBoundsArr = [];
            this.clearBoundsArr = [];
            this.restingAvatarPartArr = [];
            this._dirtyBoundsMaker = new DirtyBoundsMaker();
            this._scene = $sc;
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }
		/**
		 * 获取缓存位图数据 
		 * @param $x
		 * @param $y
		 * @return 
		 * 
		 */
        public function getAvatarBD($x:int, $y:int) : BitmapData
        {
            return this._avatarBDDict[$y + "_" + $x];
        }

        private function getAndCreatAvatarBD($x:int, $y:int) : BitmapData
        {
            var bd:BitmapData = this.getAvatarBD($x, $y);
            if (bd == null)
            {
                this.creatAvatarBD($x, $y);
                bd = this.getAvatarBD($x, $y);
            }
            return bd;
        }

        public function dispose() : void
        {
            this.removeAllAvatarBD();
            this.removeBoundsArr = [];
            this.clearBoundsArr = [];
            this.restingAvatarPartArr = [];
            this._dirtyBoundsMaker.clear();
            return;
        }

        public function initAvatarBD() : void
        {
            this.removeAllAvatarBD();
            this._mapWidth = this._scene.mapConfig.width;
            this._mapHeight = this._scene.mapConfig.height;
            this._mH = this._mapWidth % MAX_AVATARBD_WIDTH;
            this._mV = this._mapHeight % MAX_AVATARBD_HEIGHT;
            this._dH = floor(this._mapWidth / MAX_AVATARBD_WIDTH);
            this._dV = floor(this._mapHeight / MAX_AVATARBD_HEIGHT);
            if (this._mH == 0)
            {
				_dH -=1 ;
            }
            if (this._mV == 0)
            {
				_dV -=1
            }
            this._cutXCount = this._dH + 1;
            this._cutYCount = this._dV + 1;
            return;
        }
		/**
		 * @private
		 * @param _x
		 * @param _y
		 * 创建bitmapdata ，并存储在哈希表中
		 * 以固定大小（MAX_AVATARBD_WIDTH MAX_AVATARBD_HEIGHT）存储
		 */		
        private function creatAvatarBD(_x:int, _y:int) : void
        {
            var xx:int;
            var yy:int;
            var ww:Number;
            var hh:Number;
            var bd:BitmapData;
            var $i:int = _x;
            var $j:int = _y;
            if ($i < 0 || $i > this._dH || $j < 0 || $j > this._dV)
            {
                Logger.error("创建绘图区数据错误！");
                throw new Error("创建绘图区数据错误！");
            }
            if (this._avatarBDDict[$j + "_" + $i] != null)
            {
                return;
            }
//            更具x,y 判断创建图形宽高，边界处图形不全
			yy = $j * MAX_AVATARBD_HEIGHT;
            hh = $j < this._dV || this._mV == 0 ? (MAX_AVATARBD_HEIGHT) : (this._mV);
            xx = $i * MAX_AVATARBD_WIDTH;
            ww = $i < this._dH || this._mH == 0 ? (MAX_AVATARBD_WIDTH) : (this._mH);
            try
            {
                bd = new BitmapData(ww, hh, true, 0);
            }
            catch (e:Error)
            {
                Logger.error("内存不足，无法创建绘图区！");
                throw new Error("内存不足，无法创建绘图区！");
            }
            this._avatarBDDict[$j + "_" + $i] = bd;
            var bm:Bitmap = new Bitmap(bd);
            bm.x = xx;
            bm.y = yy;
            this.addChild(bm);
            return;
        }

        private function removeAllAvatarBD() : void
        {
            var bmd:BitmapData = null;
            var key:String = null;
			SystemUtil.clearChildren(this);
            for (key in this._avatarBDDict)
            {
                
                bmd = this._avatarBDDict[key];
                bmd.dispose();
                delete this._avatarBDDict[key];
            }
            return;
        }

        private function lock() : void
        {
            var bmd:BitmapData = null;
            for each (bmd in this._avatarBDDict)
            {
                bmd.lock();
            }
            return;
        }

        private function unlock() : void
        {
            var bmd:BitmapData = null;
            for each (bmd in this._avatarBDDict)
            {
                bmd.unlock();
            }
            return;
        }
		/**
		 * 删除位图重的图案
		 * @param boundsArr 需要删除的举行区域
		 * 
		 */
        private function clear(boundsArr:Array) : void
        {
            var bound:Bounds = null;
//            var rec:Rectangle = null;
            for each (bound in boundsArr)
            {
//                rec = Bounds.toRectangle(bound);
                this.copyImage(null, 0, 0, bound.right-bound.left, bound.bottom-bound.top, bound.left, bound.top);
            }
            return;
        }

        public function copyImage(bmd:BitmapData, xx:int, yy:int, _width:int, _height:int, _px:int, _py:int) : void
        {
            var _loc_17:int = 0;
            var tempY:int = 0;
            var _loc_19:Number = NaN;
            var _loc_20:Number = NaN;
            var rx:Number = NaN;
            var ry:Number = NaN;
            var rw:Number = NaN;
            var rh:Number = NaN;
            var xp:int = 0;
            var yp:int = 0;
            var tempBmd:BitmapData = null;
            var color:uint = 0;
			var rect:Rectangle = new Rectangle();
			var point:Point = new Point();
            if (_px < 0)//如果图像的场景X<0
            {
                if (-_px > _width)//如果x+图像宽度还<0则不处理，在视野外了
                {
                    return;
                }
                xx = xx - _px;//取图像时，只取在场景内的部分
                _width = _width + _px;//图像宽度减去场景外的部分
                _px = 0;//坐标重新定位到0
            }
            if (_py < 0)//同x处理
            {
                if (-_py > _height)
                {
                    return;
                }
                yy = yy - _py;
                _height = _height + _py;
                _py = 0;
            }
            if (_px + _width > this._mapWidth)//如果图像超出地图宽度
            {
                if (_px > this._mapWidth)//完全超出时，不处理
                {
                    return;
                }
                _width = _width - (_px + _width - this._mapWidth);//图像宽度只取场景内部分
            }
            if (_py + _height > this._mapHeight)//同x处理
            {
                if (_py > this._mapHeight)
                {
                    return;
                }
                _height = _height - (_py + _height - this._mapHeight);
            }
            var left_X:int = _px % MAX_AVATARBD_WIDTH;//计算图像在300*300图像块中的坐标
            var left_Y:int = _py % MAX_AVATARBD_HEIGHT;
            var left_X_W:int = (_px + _width) % MAX_AVATARBD_WIDTH;//计算图像超过该图像块的部分
            var left_Y_H:int = (_py + _height) % MAX_AVATARBD_HEIGHT;
            var cut_x:int = floor(_px / MAX_AVATARBD_WIDTH);//计算图像所属图像块的坐标
            var cut_y:int = floor(_py / MAX_AVATARBD_HEIGHT);
            var cut_x_w:int = floor((_px + _width) / MAX_AVATARBD_WIDTH);//计算图像要占用的最大的图像块的坐标
            var cut_y_h:int = floor((_py + _height) / MAX_AVATARBD_HEIGHT);
            if (left_X_W == 0)//图像刚好全部处于图像块中时，最大占用坐标减1
            {
                cut_x_w--;
            }
            if (left_Y_H == 0)
            {
                cut_y_h--;
            }
            _loc_20 = 0;
            tempY = cut_y;
            while (tempY <= cut_y_h)//循环次数为图像占用的图像块的个数,依次处理各个图像块的内容
            {
                
                ry = yy + _loc_20;//计算当前图像块的图像的源的y偏移量
                if (cut_y == cut_y_h)//如果图像占用的图像块只有一个
                {
                    rh = _height;//那么当前图像高度直接取图像的完全高度
                }
                else if (tempY == cut_y)//如果是第一块，则计算图像高度
                {
                    rh = MAX_AVATARBD_HEIGHT - left_Y;//图像块高度减去图像块中y坐标
                }
                else if (tempY == cut_y_h && left_Y_H != 0)//最后一块
                {
                    rh = left_Y_H;//直接取超过图像块的部分
                }
                else
                {
                    rh = MAX_AVATARBD_HEIGHT;//否则取整个图像块的高度
                }
                _loc_20 += rh;//记录下已经使用的高度
                yp = tempY == cut_y ? (left_Y) : (0);//如果是第一个图像块，y坐标直接取lefty,其他的取0
                _loc_19 = 0;
                _loc_17 = cut_x;
                while (_loc_17 <= cut_x_w)//循环次数为图像占用的图像块的y的个数,依次处理各个图像块的内容
                {
                    
                    rx = xx + _loc_19;
                    if (cut_x == cut_x_w)
                    {
                        rw = _width;
                    }
                    else if (_loc_17 == cut_x)
                    {
                        rw = MAX_AVATARBD_WIDTH - left_X;
                    }
                    else if (_loc_17 == cut_x_w && left_X_W != 0)
                    {
                        rw = left_X_W;
                    }
                    else
                    {
                        rw = MAX_AVATARBD_WIDTH;
                    }
                    _loc_19 +=  rw;
                    xp = _loc_17 == cut_x ? (left_X) : (0);
                    tempBmd = this.getAndCreatAvatarBD(_loc_17, tempY);//取图像块
                    if (bmd != null)
                    {
						point.x = xp, point.y = yp;
						rect.x = rx, rect.y = ry, rect.width = rw, rect.height = rh;
                        tempBmd.copyPixels(bmd, rect, point, null, null, true);
                    }
                    else
                    {
						rect.x = xp, rect.y = yp, rect.width = rw, rect.height = rh;
                        tempBmd.fillRect(rect, color);
                    }
                    _loc_17++;
                }
                tempY++;
            }
            return;
        }

        public function run() : void
        {
            var sc:SceneCharacter = null;
            var bounds:Bounds = null;
            var tempArr:Array = null;
            var ap:AvatarPart = null;
            var apBound:Bounds = null;
            var rec:Rectangle = null;
			var t:int = getTimer();
            this._dirtyBoundsMaker.clear();
            this.clearBoundsArr.length = 0;
            this.restingAvatarPartArr.length = 0;
            var scs:Array = this._scene.renderCharacters;
            scs.sortOn(["showIndex", "pixel_y", "pixel_x", "logicAnglePRI", "id"], [Array.NUMERIC, Array.NUMERIC, Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
            for each (sc in scs)
            {
                sc.runAvatar();
            }
			trace("runAvatar时间："+(getTimer()-t)); 
			t = getTimer();
            this.clearBoundsArr = this.clearBoundsArr.concat(this.removeBoundsArr);
            this.clearBoundsArr.sortOn("top", Array.NUMERIC);
            this.removeBoundsArr.length = 0;
            for each (bounds in this.clearBoundsArr)
            {
				if (!bounds.isEmpty())
				{
					this._dirtyBoundsMaker.addBounds(bounds);
				}else{
					Bounds.deleteBounds(bounds);
				}
            }
			trace("addBounds时间："+(getTimer()-t)); 
			t = getTimer();
            tempArr = this._dirtyBoundsMaker.getBoundsArr();
            for each (ap in this.restingAvatarPartArr)
            {
                for each (bounds in tempArr)
                {
					apBound = Bounds.fromRectangle(ap.cutRect);
					rec = apBound.intersectionRect(bounds);
					if (rec != null)
					{
						ap.updateNow = true;
						ap.renderRectArr.push(rec);
					}
					Bounds.deleteBounds(apBound);
                }
            }
			trace("op bounds时间："+(getTimer()-t)); 
			t = getTimer();
            this.clear(tempArr);
			trace("clearBound时间："+(getTimer()-t));
			t = getTimer();
            for each (sc in scs)
            {
                sc.drawAvatar(this);
            }
			trace("drawAvatar时间："+(getTimer()-t));
            return;
        }

    }
}
