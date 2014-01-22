package com.thinkido.framework.engine.vo.avatar
{
    import com.thinkido.framework.manager.RslLoaderManager;
    import com.thinkido.framework.manager.TimerManager;
    
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
	/**
	 * 场景中物体图片数据对象 
	 * @author thinkido.com
	 * 
	 */
    public class AvatarImgData extends Object
    {
        private var _dir07654:BitmapData;
        private var _dir123:BitmapData;
        private var _isOldWay:Boolean;
        private var _dir123Dict:Dictionary;
		private var _dirOtherDict:Dictionary;
        public var useNum:int;
		/**
		 * 渲染物体图片 
		 * @param $aps
		 * @param $key
		 * @param $only1LogicAngel
		 * 人物责采用1、2、3方向 水平翻转 5 6 7 方向图片
		 */
        public function AvatarImgData($aps:AvatarPartStatus, $key:String, $only1LogicAngel:Boolean)
        {
            var w07654:Number;
            var h07654:Number;
            var w123:Number;
            var h123:Number;
            var m:Matrix;
            var time:int;
            var wantCreatList:Array;
            var a:int;
            var creat123:Function;
            var a765:int;
            var f:int = 0;
            var apd765:AvatarPartData;
            var key:String;
            var _aps:AvatarPartStatus = $aps;
            var _key:String = $key;
            var _only1LogicAngel:Boolean = $only1LogicAngel ;
			this._dirOtherDict = new Dictionary();
            this.useNum = 1;
            this._isOldWay = _aps.isOldWay;
            this._dir07654 = RslLoaderManager.getInstance(_key, 1, 1);
            if (this._dir07654 != null)
            {
                if (!_only1LogicAngel)
                {
                    if (this._isOldWay)
                    {
                        w07654 = this._dir07654.width;
                        h07654 = this._dir07654.height;
                        w123 = w07654;
                        h123 = h07654 * 3 / 5;
                        m = new Matrix();
                        m.scale(-1, 1);
                        m.translate(w123, (-h07654) / 5);
                        this._dir123 = new BitmapData(w123, h123, true, 0);
                        this._dir123.draw(this._dir07654, m, null, null, new Rectangle(0, 0, w123, h123));
                    }
                    else
                    {
                        creat123 = function () : void
				            {
				                var _dataList:Array = null;
				                var key:String = null;
				                var _apd:AvatarPartData = null;
				                var _w:Number = NaN;
				                var _h:Number = NaN;
				                var _m:Matrix = null;
				                var bmd:BitmapData = null;
				                var now:int = 0;
				                while (wantCreatList.length > 0)
				                {
				                    _dataList = wantCreatList.shift();
				                    key = _dataList[0];
				                    _apd = _dataList[1];
				                    _w = _apd.width;
				                    _h = _apd.height;
				                    _m = new Matrix();
				                    _m.scale(-1, 1);
				                    _m.translate(_apd.sx + _w, -_apd.sy);
				                    bmd = new BitmapData(_w, _h, true, 0);
				                    bmd.draw(_dir07654, _m, null, null, new Rectangle(0, 0, _w, _h));
				                    _dir123Dict[key] = bmd;
				                    if (wantCreatList.length > 0)
				                    {
				                        now = getTimer();
				                        if (now - time >= 30)
				                        {
				                            time = now;
				                            TimerManager.createOneOffTimer(1, 1, creat123);
				                            break;
				                        }
				                    }
				                }
				                return;
				            };
                        this._dir123Dict = new Dictionary();
                        time = getTimer();
                        wantCreatList = [];
                        a =1;
                        while (a <= 3)
                        {
                            a765 = a;
                            if (a == 1)
                            {
                                a765 = 7 ;
                            }
                            else if (a == 2)
                            {
                                a765 = 6 ;
                            }
                            else if (a == 3)
                            {
                                a765 = 5 ;
                            }
							f = 0;
                            while (f < _aps.frame)
                            {
                                apd765 = _aps.getAvatarPartData(a765, f);
                                if (apd765 != null)
                                {
                                    key = a + "_" + f;
                                    wantCreatList[wantCreatList.length] = [key, apd765];
                                }
                                f ++;
                            }
                            a++;
                        }
                        creat123();
                    }
                }
            }
            return;
        }
		/**
		 * 
		 * @param $angle 方向
		 * @param $frame 第几帧,从0开始
		 * @return 图片
		 * 
		 */
        public function getBitmapData($angle:int, $frame:int) : BitmapData
        {
            var key:String = null;
            if ($angle == 0 || $angle >= 4)
            {
                return this._dir07654;
            }
            if (this._isOldWay)
            {
                return this._dir123;
            }
            key = $angle + "_" + $frame;
            if (this._dir123Dict != null && this._dir123Dict.hasOwnProperty(key))
            {
                return this._dir123Dict[key] as BitmapData;
            }
            return null;
        }
		
		public function getRotationBitmapData($angle:int, $frame:int,$rotation:int):BitmapData
		{
			var key:String = $angle+"_"+$frame+"_"+$rotation;
			if (_dirOtherDict.hasOwnProperty(key))
			{
				return _dirOtherDict[key] as BitmapData;
			}
			return null;
		}
		
		public function setRotationBitmapData($angle:int, $frame:int,$rotation:int,value:BitmapData):void
		{
			var key:String = $angle+"_"+$frame+"_"+$rotation;
			_dirOtherDict[key] = value;
		}
		
		
		/**
		 * 释放内存 
		 */
        public function dispose() : void
        {
            var _loc_1:String = null;
            var _loc_2:BitmapData = null;
            if (this._dir07654 != null)
            {
                this._dir07654.dispose();
                this._dir07654 = null;
            }
            if (this._dir123 != null)
            {
                this._dir123.dispose();
                this._dir123 = null;
            }
            if (this._dir123Dict != null)
            {
                for (_loc_1 in this._dir123Dict)
                {
                    
                    _loc_2 = this._dir123Dict[_loc_1];
                    _loc_2.dispose();
                    _loc_2 = null;
                    delete this._dir123Dict[_loc_1];
                }
            }
			if (this._dirOtherDict != null)
			{
				for (_loc_1 in this._dirOtherDict)
				{
					
					_loc_2 = this._dirOtherDict[_loc_1];
					_loc_2.dispose();
					_loc_2 = null;
					delete this._dirOtherDict[_loc_1];
				}
			}
            return;
        }

    }
}
