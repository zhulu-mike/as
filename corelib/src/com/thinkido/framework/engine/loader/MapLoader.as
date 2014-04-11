package com.thinkido.framework.engine.loader
{
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
    import com.thinkido.framework.engine.utils.astars.AStarGrid;
    import com.thinkido.framework.engine.vo.map.MapTile;
    import com.thinkido.framework.manager.loader.LoaderManager;
    import com.thinkido.framework.utils.SystemUtil;
    
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.utils.getTimer;
    
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;
    import br.com.stimuli.loading.loadingtypes.LoadingItem;

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
            var newOnUpdate:Function;
            var mapID:int = $mapID;
            var mapConfigName:String = $mapConfigName;
            var scene:Scene = $secen;
            var onComplete:Function = $onComplete;
			newOnUpdate = function (e:BulkProgressEvent):void
			{
				if ($onUpdate != null)
				{
					$onUpdate(e);
				}
			}
            newOnComplete = function (event:Event) : void
	            {
					trace("进入地图初始化"+getTimer());
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
					trace("进入地图初始化2"+getTimer());
					if(temp is ByteArray && GlobalConfig.customDecode != null)
					{
						temp = GlobalConfig.customDecode.call(null, temp);
					}
					trace("加载地图完毕"+getTimer());
					var mapConfig:MapConfig = new MapConfig();
					mapConfig.mapID = mapID;
//					地图数据
					var by:ByteArray;
					if (temp is ByteArray)
					{
						by = temp as ByteArray;
						by.endian = Endian.LITTLE_ENDIAN;
						by.readInt();
						by.readInt();
						mapConfig.mapGridX = by.readInt();
						mapConfig.mapGridY = by.readInt();
						mapConfig.safeRect.top = by.readInt();
						mapConfig.safeRect.left = by.readInt();
						mapConfig.safeRect.right = by.readInt();
						mapConfig.safeRect.bottom = by.readInt();
					}else{
						var data:XML = XML(temp);
						mapConfig.mapGridX = data.head.grids.@grid_h;
						mapConfig.mapGridY = data.head.grids.@grid_v;
						mapConfig.safeRect.top = int(data.head.grids.@safetop); 
						mapConfig.safeRect.left = int(data.head.grids.@safeleft); 
						mapConfig.safeRect.right = int(data.head.grids.@saferight); 
						mapConfig.safeRect.bottom = int(data.head.grids.@safebuttom);
					}
					trace("初始化xml"+getTimer());
					Astar.init();
					Astar.starGrid.init(mapConfig.mapGridX, mapConfig.mapGridY);
	                mapConfig.width = mapConfig.mapGridX * SceneConfig.TILE_WIDTH;
	                mapConfig.height = mapConfig.mapGridY * SceneConfig.TILE_HEIGHT;
	                mapConfig.zoneMapDir = GlobalConfig.getZoneMapFolder(mapConfigName);
	                mapConfig.smallMapUrl = GlobalConfig.getSmallMapPath(mapConfigName);
					var trans:Object = SceneCache.transports;
					var tempMapId:int = mapConfig.mapID;
					var mapTypeDic:Object = {};
					var astarGrid:AStarGrid = Astar.starGrid;
					var gridByte:ByteArray = new ByteArray();
//	                	地图上的动画
					if (temp is ByteArray)
					{
						var m:int = 0, n:int = 0, v:int = mapConfig.mapGridY, h:int = mapConfig.mapGridX, value:int;
						for (;m<h;m++)
						{
							for (n=0;n<v;n++)
							{
								value = by.readByte();
								mapTipX = m;
								mapTipY = n;
								mapTypeDic[mapTipX + "_" + mapTipY] = new MapTile(mapTipX, mapTipY, value == 1, value == 2, value == 2, trans[tempMapId + "_" + mapTipX + "_" + mapTipY] != undefined);
								gridByte.writeByte(value!=1?0:1);
							}
						}
						trace("读完grids"+getTimer());
						var len:int = by.readByte();
						if (len > 0)
						{
							for (m=0;m<len;m++)
							{
								path = GlobalConfig.getAvatarMapSlipcoverPath(int(by.readUTFBytes(1)));
								slipcover = {pixel_x:Number(by.readInt()), pixel_y:Number(by.readInt()), sourcePath:path};
								if (mapConfig.slipcovers == null)
								{
									mapConfig.slipcovers = [slipcover];
									continue;
								}
								mapConfig.slipcovers.push(slipcover);
							}
						}
						trace("读完movies"+getTimer());
					}else{
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
						trace("初始化astar"+getTimer());
						for each (item in data.tiles.tile)
						{
							mapTipX = item.@x;
							mapTipY = item.@y;
							mapTypeDic[mapTipX + "_" + mapTipY] = new MapTile(mapTipX, mapTipY, item.@s == "1", item.@s == "2", item.@m == "1", trans[tempMapId + "_" + mapTipX + "_" + mapTipY] != undefined);
						}
						trace("初始化astar2"+getTimer());
						
						for (var i:int = 0; i < mapConfig.mapGridX; i++) 
						{
							for (var j:int = 0; j < mapConfig.mapGridY ; j++) 
							{
								if( mapTypeDic[i + "_" + j] == undefined ){
									mapTypeDic[i + "_" + j] = new MapTile(i, j,false,false,false, trans[tempMapId + "_" + i + "_" + j] != undefined);
									gridByte.writeByte(0);
								}else{
									gridByte.writeByte(mapTypeDic[i + "_" + j].isSolid?1:0);
								}
							}
						}
					}
					
					trace("生成astar"+getTimer());
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
	                    onComplete(mapConfig, mapTypeDic, gridByte);
	                }
					SceneLoader.smallMapImgLoader.removeEventListener(BulkLoader.COMPLETE, newOnComplete);
					SceneLoader.smallMapImgLoader.removeEventListener(BulkLoader.PROGRESS, newOnUpdate);
					return;
	            };
//			加载地图配置文件.xml
			trace("开始加载地图"+getTimer());
			var murl:String = GlobalConfig.getMapConfigPath(mapConfigName);
			SystemUtil.clearChildren(scene.sceneSmallMapLayer, true);
			SceneLoader.smallMapImgLoader.pauseAll();
			SceneLoader.smallMapImgLoader.removeAll();			
			var loadingItem:LoadingItem = SceneLoader.smallMapImgLoader.add(murl,{type:BulkLoader.TYPE_BINARY});
			var mapImg:String = GlobalConfig.getSmallMapPath(mapConfigName) ;
			SceneLoader.smallMapImgLoader.add(mapImg);
			SceneLoader.smallMapImgLoader.addEventListener(BulkLoader.COMPLETE, newOnComplete);
			SceneLoader.smallMapImgLoader.addEventListener(BulkLoader.PROGRESS, newOnUpdate);
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
