package com.thinkido.framework.engine.graphics.layers
{
    
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.loadingtypes.LoadingItem;
    
    import com.thinkido.framework.common.handler.HandlerThread;
    import com.thinkido.framework.common.timer.vo.TimerData;
    import com.thinkido.framework.common.utils.ZMath;
    import com.thinkido.framework.engine.Scene;
    import com.thinkido.framework.engine.config.GlobalConfig;
    import com.thinkido.framework.engine.config.SceneConfig;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.utils.SceneUtil;
    import com.thinkido.framework.engine.utils.Transformer;
    import com.thinkido.framework.engine.vo.map.MapZone;
    import com.thinkido.framework.manager.SharedObjectManager;
    import com.thinkido.framework.manager.TimerManager;
    import com.thinkido.framework.manager.loader.LoaderManager;
    import com.thinkido.framework.manager.loader.vo.LoadData;
    import com.thinkido.framework.utils.SystemUtil;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.net.URLLoader;
    import flash.utils.ByteArray;
    
    import org.osflash.thunderbolt.Logger;

    public class SceneMapLayer extends Sprite
    {
        private var _scene:Scene;
        private var _currentCameraPos:Point;
        private var _currentMapZone:MapZone;
        private var loadMapHT:HandlerThread;
		/**
		 * 地图等待加载队列 
		 */		
        private var _waitingLoadDatas:Object;
        private static const MAX_ZONE_CACHE_X:int = 3;
        private static const MAX_ZONE_CACHE_Y:int = 2;
		private var mapLoader:BulkLoader = new BulkLoader("SceneMapLayerLoader",1);
		
		private var bytelist:Array = [];
		private var loadTimer:TimerData ;
		/**
		 * 没70毫秒显示(解码)一个图片 , 1024/15 = 67, 每秒大概处理15张图
		 */		
		private var loadTime:Number = 67 ; 
		
        public function SceneMapLayer($scene:Scene)
        {
            this._currentCameraPos = new Point(int.MAX_VALUE, int.MAX_VALUE);
            this.loadMapHT = new HandlerThread();
            this._waitingLoadDatas = {};
            this._scene = $scene;
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }
		/**
		 * 释放资源 
		 */
        public function dispose() : void
        {
			bytelist.length = 0 ;
			mapLoader.removeAll() ;
			SystemUtil.clearChildren(this, false, false);
            this._currentCameraPos = new Point(int.MAX_VALUE, int.MAX_VALUE);
            this._currentMapZone = null;
            this._waitingLoadDatas = {};
            this.loadMapHT.removeAllHandlers();
            return;
        }
		/**
		 * 初始化场景地图图片格子 
		 * 初始化mapzone 坐标
		 */
        public function initMapZones() : void
        {
            var temp:Object = {};
            var _x:int = 0;
            var _y:int = 0;
            var mapZone:MapZone = null;
            var col:Number = this._scene.mapConfig.mapGridX / SceneConfig.ZONE_SCALE;
            var row:Number = this._scene.mapConfig.mapGridY / SceneConfig.ZONE_SCALE;
            while (_x < col)
            {
                _y = 0;
                while (_y < row)
                {
                    mapZone = new MapZone(this);
                    mapZone.tile_width = SceneConfig.ZONE_WIDTH;
                    mapZone.tile_height = SceneConfig.ZONE_HEIGHT;
                    mapZone.tile_x = _x;
                    mapZone.tile_y = _y;
                    mapZone.showContainer.x = mapZone.pixel_x;
                    mapZone.showContainer.y = mapZone.pixel_y;
                    temp[_x + "_" + _y] = mapZone;
                    _y++;
                }
                _x++;
            }
            SceneCache.mapZones = temp;
            return;
        }
		/**
		 * 根据人物移动，加载地图
		 */		
        public function run() : void
        {
            if (this._currentCameraPos.x == this._scene.sceneCamera.pixel_x && this._currentCameraPos.y == this._scene.sceneCamera.pixel_y)
            {
                return;
            }
            this._currentCameraPos.x = this._scene.sceneCamera.pixel_x;
            this._currentCameraPos.y = this._scene.sceneCamera.pixel_y;
            this.loadMap();
            return;
        }
		/**
		 * 加载地图
		 */
        private function loadMap() : void
        {
            var mz:MapZone = null;
            var loadDataArr:Array = null;
            var loadData:LoadData = null;
            var priori:int = 0;
            var pointArr:Array = null;
            var col:Number = 0;
            var row:Number = 0;
            var point:Point = null;
            var key:String = null;
            var loader:URLLoader = null;
			/** 当前可是区zone 对象,最后赋值给静态变量作为当前显示对象列表 */
            var currentMapZoneObj:Object = {};
            var tilePoint:Point = Transformer.transPixelPoint2TilePoint(new Point(this._scene.sceneCamera.pixel_x, this._scene.sceneCamera.pixel_y));
            var zonePoint:Point = Transformer.transTilePoint2ZonePoint(tilePoint);
            var mapZone:MapZone = SceneCache.mapZones[zonePoint.x + "_" + zonePoint.y]; //摄像机中心点 zonePoint
            if (!mapZone)
            {
                return;
            }
            if ( this._currentMapZone != mapZone)  //移动摄像机加载地图
            {
                loadDataArr = [];
//              获取可以看到的zone 图片
				/**TRACEDISABLE:trace("camera",mapZone.tile_x, mapZone.tile_y); TRACEDISABLE*/
				pointArr = SceneUtil.findViewZonePoints(new Point(mapZone.tile_x, mapZone.tile_y), this._scene.sceneCamera.zoneRangeXY.x, this._scene.sceneCamera.zoneRangeXY.y);
                col = this._scene.mapConfig.mapGridX / SceneConfig.ZONE_SCALE;
                row = this._scene.mapConfig.mapGridY / SceneConfig.ZONE_SCALE;
                for each (point in pointArr)
                {
                    
                    if (point.x < 0 || point.x >= col || point.y < 0 || point.y >= row)
                    {
                        continue;
                    }
                    key = point.x + "_" + point.y;
                    mz = SceneCache.currentMapZones[key];
                    if (mz == null)
                    {
                        mz = SceneCache.mapZones[key];
                        currentMapZoneObj[key] = mz;
                    }
                    else //删除过后避免进入remove不可见对象的逻辑
                    {
                        currentMapZoneObj[key] = mz;
                        SceneCache.currentMapZones[key] = null;
                        delete SceneCache.currentMapZones[key];
                    }
                    if (this._waitingLoadDatas[key] == null)
                    {
                        priori = -Math.round(ZMath.getDistanceSquare(mz.pixel_x, mz.pixel_y, mapZone.pixel_x, mapZone.pixel_y));
                        loadData = this.addMapZone(mz, priori);
                        if (loadData)
                        {
                            loadDataArr.push(loadData);
                            this._waitingLoadDatas[key] = loadData;
                        }
                    }
                }
                if (loadDataArr.length > 0)
                {
                    loadDataArr.sortOn(["priority"], [Array.NUMERIC | Array.DESCENDING]);
                }
//				LoaderManager.load(loadDataArr,mapLoader,true) ;
				var _len:int = loadDataArr.length ;
				var loadItem:LoadingItem ;
				for (var i:int = 0; i < _len ; i++) 
				{
					loadData = loadDataArr[i] ;
					if( mapLoader.getBinary(loadData.key) != null ){
						loadData.onComplete(null);
						continue ;
					}
					var prop:Object = {id:loadData.key,type:BulkLoader.TYPE_BINARY,retry:1} ;
					loadItem = mapLoader.add(loadData.url,prop) ;
					loadItem.addEventListener(Event.COMPLETE,loadData.onComplete);
					mapLoader.loadNow(loadItem);
				}
//				mapLoader.start(1);
				
                for (key in SceneCache.currentMapZones)
                {
//                  删除看不见的mapzone
                    mz = SceneCache.currentMapZones[key];
                    if (this.contains(mz.showContainer))
                    {
						/**TRACEDISABLE:trace("remove a",key); TRACEDISABLE*/
						this.removeChild(mz.showContainer);
                    }
					
                    if (Math.abs(mz.tile_x - mapZone.tile_x) > this._scene.sceneCamera.zoneRangeXY.x + MAX_ZONE_CACHE_X || Math.abs(mz.tile_y - mapZone.tile_y) > this._scene.sceneCamera.zoneRangeXY.y + MAX_ZONE_CACHE_Y)
                    {
						/**TRACEDISABLE:trace("remove b",key); TRACEDISABLE*/
						SceneCache.mapImgCache.remove(mz.showContainer.name);
                    }
                }
                SceneCache.currentMapZones = currentMapZoneObj;
                this._currentMapZone = mapZone;
            }
            return;
        }
		
		private function addLoadByteList($parent:DisplayObjectContainer,imageByte:ByteArray,$priority:int,$filePath:String):void{
			if( imageByte ==null ){
				return ;
			}
//			Logger.error("bytes:"+$filePath);
			var i:int = bytelist.length ;
			var item:Object ;
			while( i > 0){
				item = bytelist[i -1] ;
				if( item.filePath == $filePath ){
					return ;
				}
				i-- ;
			}
			bytelist.push({pri:$priority,filePath:$filePath,data:[$parent,imageByte]});
			if( loadTimer == null ){
				loadTimer = TimerManager.createTimer(loadTime,int.MAX_VALUE,loadByteHandler,null,reset);
			}else{
				loadTimer.timer.start();
			}
		}
		
		private function reset():void{
			TimerManager.deleteTimer(loadTimer);
			loadTimer = null ;
		}
		private function loadByteHandler():void{
			if( bytelist.length == 0 ){
				loadTimer.timer.stop();
				return ;
			}
			var _obj:Object = bytelist.shift() ; 
			var _data:Array = _obj.data ;
			var $parent:DisplayObjectContainer = _data[0] ;
			var imageByte:ByteArray = _data[1] ;
			var filePath:String = _obj.filePath ;
			function loadImageComplete(event:Event):void{
				SceneCache.mapImgCache.push(event.target.content, filePath);
				if (GlobalConfig.useSo)
				{
					SharedObjectManager.setDataByHttpUrl(filePath, (event.currentTarget as LoaderInfo).bytes);
				}
				$parent.addChild(event.target.content);
//				Logger.error("addchild:"+filePath); 
			}
			var loader:Loader = new Loader() ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImageComplete);
			loader.loadBytes(imageByte);
//			trace("loadByteHandler",getTimer());
		}
		
		/**
		 * @private
		 * 根据mapZone 返回对应需要加载的图片， 如： 0_0.jpg 
		 * @param mapZone
		 * @param priori
		 * @return 
		 * 
		 */
        private function addMapZone(mapZone:MapZone, priori:int) : LoadData
        {
            var loadData:LoadData;
            var key:String;
            var filePath:String;
            var $mapZone:MapZone = mapZone;
            var $priority:int = priori;
            if ($mapZone.showContainer.numChildren == 0)
            {
                key = $mapZone.tile_x + "_" + $mapZone.tile_y;
				filePath = this._scene.mapConfig.zoneMapDir + key + ".jpg";
				/**TRACEDISABLE:trace("a",key); TRACEDISABLE*/
				if (SceneCache.mapImgCache.has(filePath))
				{
					/**TRACEDISABLE:trace("b",key); TRACEDISABLE*/
					$mapZone.showContainer.addChild(SceneCache.mapImgCache.get(filePath) as DisplayObject);
				}
				else if (GlobalConfig.useSo && SharedObjectManager.getDataByHttpUrl(filePath) != null){
					/**TRACEDISABLE:trace("c",key); TRACEDISABLE*/
					var bytes:ByteArray = SharedObjectManager.getDataByHttpUrl(filePath) as ByteArray;
					addLoadByteList($mapZone.showContainer,bytes,$priority,filePath);
				}
                else
                {
                    var itemLoadComplete:Function = function (event:Event) : void
			            {
							/**TRACEDISABLE:trace("d2",key); TRACEDISABLE*/
							addLoadByteList($mapZone.showContainer,mapLoader.getBinary(loadData.key),$priority,filePath) ;
		                	$mapZone.showContainer.name = loadData.key ;
			                _waitingLoadDatas[key] = null;
			                delete _waitingLoadDatas[key];
			                return;
			            };
					var itemLoadError:Function = function(event:Event) : void
					{
						_waitingLoadDatas[key] = null;
	                    delete _waitingLoadDatas[key];
					}
					/**TRACEDISABLE:trace("d1",key); TRACEDISABLE*/
					loadData = new LoadData(filePath, itemLoadComplete, null, itemLoadError, "", filePath, $priority);
					loadData.userData.type = BulkLoader.TYPE_BINARY ;
					loadData.userData.retry = 1 ;
                }
            }
            if ($mapZone.showContainer.parent != this)
            {
				/**TRACEDISABLE:trace("e",$mapZone.tile_x + "_" + $mapZone.tile_y); TRACEDISABLE*/
				this.addChild($mapZone.showContainer);
            }
            return loadData;
        }
    }
}
