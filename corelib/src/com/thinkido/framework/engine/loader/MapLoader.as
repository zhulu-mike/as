package com.thinkido.framework.engine.loader
{
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.loadingtypes.LoadingItem;
    
    import com.thinkido.framework.common.codemix.ZZip;
    import com.thinkido.framework.common.events.EventDispatchCenter;
    import com.thinkido.framework.engine.Scene;
    import com.thinkido.framework.engine.config.GlobalConfig;
    import com.thinkido.framework.engine.config.MapConfig;
    import com.thinkido.framework.engine.config.SceneConfig;
    import com.thinkido.framework.engine.events.SceneEvent;
    import com.thinkido.framework.engine.events.SceneEventAction_process;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.tools.SceneLoader;
    import com.thinkido.framework.engine.utils.Astar;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.manager.loader.LoaderManager;
    import com.thinkido.framework.utils.SystemUtil;
    
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;

	/**
	 * 地图加载器,用于加载地图xml 和 缩略图 
	 * @author Administrator
	 * 
	 */
    public class MapLoader
    {
        public function MapLoader()
        {
            return;
        }
		/**
		 * 加载地图信息  
		 * @param $mapID 地图id
		 * @param $mapConfigUrl 地图xml文件名
		 * @param $secen 场景
		 * @param $onComplete 完成时调用
		 * @param $onUpdate 更新时调用
		 */
        public static function loadMapConfig($mapID:int, $mapConfigName:String, $secen:Scene, $onComplete:Function = null, $onUpdate:Function = null) : void
        {
            var newOnComplete:Function;
            var mapID:int = $mapID;
            var mapConfigName:String = $mapConfigName;
            var scene:Scene = $secen;
            var onComplete:Function = $onComplete;
            var onUpdate:Function = $onUpdate;
            newOnComplete = function (event:Event) : void
	            {
	                var temp:* = undefined;
	                var item:XML = null;
	                var path:String = null;
	                var slipcover:Object = null;
	                var mapTipX:int = 0;
	                var mapTipY:int = 0;
	                if (event.target is LoadingItem)
	                {
	                    temp = event.target.content;
	                }
					else if( event.target is BulkLoader ){
						temp = SceneLoader.smallMapImgLoader.getBinary( murl ,true ) ;
					}
	                else
	                {
	                    temp = event.target.data;
	                }
	                if (GlobalConfig.decode != null)
	                {
	                    temp = ZZip.extractFristTextFileContent(temp, GlobalConfig.decode);
	                    if (temp == "")
	                    {
	                        return;
	                    }
	                }
					if(temp is ByteArray && GlobalConfig.customDecode != null)
					{
						temp = GlobalConfig.customDecode.call(null, temp);
					}
					
//					地图数据
	                var data:XML = XML(temp);
	                var mapConfig:MapConfig = new MapConfig();
					mapConfig.mapID = mapID;
	                mapConfig.mapGridX = data.head.grids.@grid_h;
	                mapConfig.mapGridY = data.head.grids.@grid_v;
					Astar.init();
					trace("init前"+getTimer());
					Astar.starGrid.init(mapConfig.mapGridX, mapConfig.mapGridY);
					trace("init后"+getTimer());
	                mapConfig.width = mapConfig.mapGridX * SceneConfig.TILE_WIDTH;
	                mapConfig.height = mapConfig.mapGridY * SceneConfig.TILE_HEIGHT;
	                mapConfig.zoneMapDir = GlobalConfig.getZoneMapFolder(mapConfigName);
	                mapConfig.smallMapUrl = GlobalConfig.getSmallMapPath(mapConfigName);
//	                	地图上的动画
					if (data.movies != undefined && data.movies.movie != undefined)
	                {
	                    for each (item in data.movies.movie)
	                    {
	                        
	                        path = GlobalConfig.getAvatarMapSlipcoverPath(int(item.@id));
	                        slipcover = {pixel_x:Number(item.@x), pixel_y:Number(item.@y), sourcePath:path};
	                        if (mapConfig.slipcovers == null)
	                        {
	                            mapConfig.slipcovers = [slipcover];
	                            continue;
	                        }
	                        mapConfig.slipcovers.push(slipcover);
	                    }
	                }
	                var trans:Object = SceneCache.transports;
	                var tempMapId:int = mapConfig.mapID;
	                var mapTypeDic:Object = {};
	                var mapDic:Object = {};
	                for each (item in data.tiles.tile)
	                {
	                    mapTipX = item.@x;
	                    mapTipY = item.@y;
	                    mapTypeDic[mapTipX + "_" + mapTipY] = new MapTile(mapTipX, mapTipY, item.@s == "1", item.@s == "2", item.@m == "1", trans[tempMapId + "_" + mapTipX + "_" + mapTipY] != undefined);
	                    mapDic[mapTipX + "_" + mapTipY] = item.@s == "1" ? (1) : (0);
						Astar.starGrid.setWalkable(mapTipX, mapTipY, item.@s == "1" ? false : true);
	                }
					System.disposeXML(data);
					for (var i:int = 0; i < mapConfig.mapGridX; i++) 
					{
						for (var j:int = 0; j < mapConfig.mapGridY ; j++) 
						{
							if( mapDic[i + "_" + j] == undefined ){
								mapTypeDic[i + "_" + j] = new MapTile(i, j,false,false,false, trans[tempMapId + "_" + i + "_" + j] != undefined);
								mapDic[i + "_" + j] = 0 ;
								Astar.starGrid.setWalkable(i, j, true);
							}
						}
					}
					//记载玩马晒客地图胡进入场景
					var bm:Bitmap = SceneLoader.smallMapImgLoader.getBitmap(mapImg);
					if (bm)
					{
						var se:SceneEvent = null;
						scene.mapConfig = mapConfig ;
						bm.width = scene.mapConfig.width;
						bm.height = scene.mapConfig.height;
						scene.sceneSmallMapLayer.addChild(bm);
						se = new SceneEvent(SceneEvent.PROCESS, SceneEventAction_process.LOAD_SMALL_MAP_COMPLETE, bm.bitmapData);
						EventDispatchCenter.getInstance().dispatchEvent(se);
					}
					if (onComplete != null)
	                {
	                    onComplete(mapConfig, mapTypeDic, mapDic);
	                }
					SceneLoader.smallMapImgLoader.removeEventListener(BulkLoader.COMPLETE, newOnComplete);
					SceneLoader.smallMapImgLoader.removeEventListener(BulkLoader.PROGRESS, onUpdate);
					return;
	            };
//			加载地图配置文件.xml
			var murl:String = GlobalConfig.getMapConfigPath(mapConfigName);
			SystemUtil.clearChildren(scene.sceneSmallMapLayer, true);
			SceneLoader.smallMapImgLoader.pauseAll();
			SceneLoader.smallMapImgLoader.removeAll();			
			var loadingItem:LoadingItem = SceneLoader.smallMapImgLoader.add(murl,{type:BulkLoader.TYPE_BINARY});
			var mapImg:String = GlobalConfig.getSmallMapPath(mapConfigName) ;
			SceneLoader.smallMapImgLoader.add(mapImg);
			SceneLoader.smallMapImgLoader.addEventListener(BulkLoader.COMPLETE, newOnComplete);
			SceneLoader.smallMapImgLoader.addEventListener(BulkLoader.PROGRESS, onUpdate);
			SceneLoader.smallMapImgLoader.start();
            return;
        }
		/**
		 * 加载小地图，小地图放大实现马晒客效果 
		 * @param scene
		 * 
		 */
        public static function loadSmallMap(scene:Scene) : void
        {
            var loadSmallMapComplete:Function;
            var $scene:Scene = scene ;
            loadSmallMapComplete = function (event:Event) : void
	            {
	                var bm:Bitmap = null;
	                var se:SceneEvent = null;
	                var item:LoadingItem = event.target as LoadingItem;
					bm  = item.content as Bitmap;
	                if (bm)
	                {
	                    bm.width = $scene.mapConfig.width;
	                    bm.height = $scene.mapConfig.height;
	                    $scene.sceneSmallMapLayer.addChild(bm);
	                    se = new SceneEvent(SceneEvent.PROCESS, SceneEventAction_process.LOAD_SMALL_MAP_COMPLETE, bm.bitmapData);
	                    EventDispatchCenter.getInstance().dispatchEvent(se);
	                }
	                return;
	            };
            SystemUtil.clearChildren($scene.sceneSmallMapLayer, true);
            SceneLoader.smallMapImgLoader.pauseAll();
            SceneLoader.smallMapImgLoader.removeAll();
            LoaderManager.lazyLoad(loadSmallMapComplete, SceneLoader.smallMapImgLoader, false, $scene.mapConfig.smallMapUrl);
            return;
        } 
    }
}
