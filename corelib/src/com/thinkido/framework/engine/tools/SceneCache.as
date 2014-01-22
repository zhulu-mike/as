package com.thinkido.framework.engine.tools
{
    import com.thinkido.framework.common.cache.Cache;
    import com.thinkido.framework.common.handler.HandlerThread;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.SceneRender;
    import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
    import com.thinkido.framework.engine.staticdata.AvatarPartID;
    import com.thinkido.framework.engine.staticdata.AvatarPartType;
    import com.thinkido.framework.engine.vo.avatar.AvatarImgData;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPartStatus;
    import com.thinkido.framework.engine.vo.avatar.AvatarPartStatusList;
    import com.thinkido.framework.engine.vo.avatar.AvatarPlayCondition;
    import com.thinkido.framework.manager.CacheManager;
    import com.thinkido.framework.manager.RslLoaderManager;
    
    import flash.geom.Point;

	/**
	 * 场景缓存
	 * @author Administrator
	 */
    public class SceneCache extends Object
    {
        private static var LOAD_AVATAR_DELAY:int = 0;
        private static var ADD_AVATAR_DELAY:int = 0;
        public static const UNINSTALL_DELAY_TIME:int = 5000;
        public static var transports:Object = {};
        public static var mapZones:Object = {};
		/**
		 * 当前显示对象列表 
		 */		
        public static var currentMapZones:Object = {};
        public static var mapImgCache:Cache = CacheManager.creatNewCache("mapImgCache");
        public static var mapTiles:Object = {};
        public static var tempMapTiles:Object = {};
        public static var mapSolids:Object = {}; 
        private static var waitingLoadAvatarHT:HandlerThread = new HandlerThread();
        private static var waitingLoadAvatarFun:Object = new Object();
        private static var waitingLoadAvatars:Object = new Object();
        private static var waitingAddAvatarHT:HandlerThread = new HandlerThread();
        private static var waitingAddAvatars:Array = [];
        public static var avatarXmlCache:Cache = CacheManager.creatNewCache("avatarXmlCache");
        public static var avatarImgCache:Cache = CacheManager.creatNewCache("avatarImgCache");
        public static var waitingRemoveAvatarImgs:Object = {};
        private static var count:int = 0;

        public function SceneCache()
        {
            return;
        }
		/**
		 * 添加需要加载的 avatar  
		 * @param $sc 
		 * @param $apd 
		 * @param loadSourceFun
		 * 
		 */
		public static function addWaitingLoadAvatar($sc:SceneCharacter, $apd:AvatarParamData, loadSourceFun:Function = null) : void
		{
			var _isExist:Boolean = false;
			var item:Array = null;
			if (loadSourceFun != null)
			{
				waitingLoadAvatarFun[$apd.sourcePath] = loadSourceFun;
				waitingLoadAvatarHT.push(loadSourceFun, null, LOAD_AVATAR_DELAY, true, true, $sc.isMainChar());
			}
			var items:Array = waitingLoadAvatars[$apd.sourcePath];
			if (items == null)
			{
				waitingLoadAvatars[$apd.sourcePath] = [[$sc, $apd]];
			}
			else
			{
				for each (item in items)
				{
					
					if ($sc == item[0] && $sc.id == item[0].id && $apd.sourcePath == item[1].sourcePath)
					{
						_isExist = true;
						break;
					}
				}
				if (!_isExist)
				{
					waitingLoadAvatars[$apd.sourcePath].push([$sc, $apd]);
				}
			}
			return;
		}

        public static function addWaitingAddAvatar($sc:SceneCharacter, apd:AvatarParamData, apsl:AvatarPartStatusList) : void
        {
            var arr:Array;
            var ht_addAvatarPart:Function;
            var $in_sc:SceneCharacter = $sc;
            var $in_apd:AvatarParamData = apd;
            var $in_apsList:AvatarPartStatusList = apsl;
            ht_addAvatarPart = function () : void
            {
                var index:int = waitingAddAvatars.indexOf(arr);
                if (index != -1)
                {
                    waitingAddAvatars.splice(index, 1);
                }
                addAvatarPart($in_sc, $in_apd, $in_apsList);
                return;
            };
            arr = [$in_sc, $in_apd, ht_addAvatarPart];
            waitingAddAvatars.push(arr);
            waitingAddAvatarHT.push(ht_addAvatarPart, null, ADD_AVATAR_DELAY, true, true, $in_sc.isMainChar());
            return;
        }

		public static function removeWaitingAvatar($in_sc:SceneCharacter = null, $in_avatarPartID:String = null, $in_avatarPartType:String = null, $except_char_arr:Array = null) : void
		{
			var watingArrKey:String;
			var watingArr:Array;
			var loadFun:Function;
			var arr1:Array;
			var len:int;
			var index:int;
			var newWatingArr:Array;
			var arr:Array;
			var sc:SceneCharacter;
			var apd:AvatarParamData;
			var sc1:SceneCharacter;
			var apd1:AvatarParamData;
			var addFun:Function;
			var removeWaitLoadFun:Function = function (param1:String) : void
			{
				var _fun:Function = waitingLoadAvatarFun[apd.sourcePath];
				if (_fun != null)
				{
					waitingLoadAvatarHT.removeHandler(_fun);
				}
				return;
			}
				;
			for (watingArrKey in waitingLoadAvatars)
			{
				watingArr = waitingLoadAvatars[watingArrKey];
				if (watingArr != null && watingArr.length > 0)
				{
					newWatingArr =[];
					for each (arr in watingArr)
					{
						sc = arr[0] as SceneCharacter;
						apd = arr[1] as AvatarParamData;
						if (AvatarPartID.isDefaultKey(apd.id) || $except_char_arr != null && $except_char_arr.indexOf(sc) != -1 || !(($in_sc == null || sc == $in_sc && sc.id == $in_sc.id) && ($in_avatarPartID == null || apd.id == $in_avatarPartID) && ($in_avatarPartType == null || apd.type == $in_avatarPartType)))
						{
							newWatingArr.push(arr);
							continue;
						}
						apd.executeCallBack($in_sc);
					}
					if (newWatingArr.length > 0)
					{
						waitingLoadAvatars[watingArrKey] = newWatingArr;
					}
					else
					{
						delete waitingLoadAvatars[watingArrKey];
						removeWaitLoadFun(watingArrKey);
//						RslLoaderManager.cancelLoadByUrl(watingArrKey);			//sc 死亡后，死亡效果容易取消下载 导致看不到死亡特效
					}
					continue;
				}
				delete waitingLoadAvatars[watingArrKey];
				removeWaitLoadFun(watingArrKey);
//				RslLoaderManager.cancelLoadByUrl(watingArrKey);
			}
			len = waitingAddAvatars.length;
			index = len - 1;
			while (index >= 0){                
				arr1 = waitingAddAvatars[index];
				sc1 = arr1[0];
				apd1 = arr1[1];
				addFun = arr1[2];
				if ($except_char_arr != null && $except_char_arr.indexOf(sc1) != -1 || !(($in_sc == null || sc1 == $in_sc && sc1.id == $in_sc.id) && ($in_avatarPartID == null || apd1.id == $in_avatarPartID) && ($in_avatarPartType == null || apd1.type == $in_avatarPartType)))
				{
				}
				else
				{
					waitingAddAvatars.splice(index, 1);
					waitingAddAvatarHT.removeHandler(addFun);
				}
				index = (index - 1);
			}
			return;
		}

        public static function dowithWaiting(key:String, apsl:AvatarPartStatusList = null) : void
        {
            var items:Array = null;
            var sc:SceneCharacter = null;
            var apd:AvatarParamData = null;
            var item:Array = null;
//            if (apsl != null)
//            {
            items = waitingLoadAvatars[key];
            if (items != null && items.length > 0)
            {
                for each (item in items)
                {
                    
                    sc = item[0];
                    apd = item[1];
					if (apsl != null)
					{
						addWaitingAddAvatar(sc, apd, apsl);
					}else{
						apd.executeCallBack(sc);
					}
                }
            }
//            }
            delete waitingLoadAvatars[key];
            return;
        }

        private static function addAvatarPart(sc:SceneCharacter, apd:AvatarParamData, apsl:AvatarPartStatusList) : void
        {
            if (sc == null || !sc.usable)
            {
                apd.executeCallBack(sc);
                return;
            }
            if (!sc.isOnMount)
            {
                if (apd.useType == 2)
                {
                    apd.executeCallBack(sc);
                    return;
                }
                if (apd.type == AvatarPartType.BODY)
                {
                    if (apd.id == AvatarPartID.BLANK)
                    {
                        if (sc.hasTypeAvatarParts(AvatarPartType.BODY))
                        {
                            apd.executeCallBack(sc);
                            return;
                        }
                    }
                    else
                    {
                        sc.removeAvatarPartByID(AvatarPartID.BLANK, false);
                    }
                }
            }
            else
            {
                if (apd.useType == 1)
                {
                    apd.executeCallBack(sc);
                    return;
                }
                if (apd.type == AvatarPartType.BODY)
                {
                    if (apd.id == AvatarPartID.BLANK)
                    {
                        if (sc.hasTypeAvatarParts(AvatarPartType.BODY))
                        {
                            apd.executeCallBack(sc);
                            return;
                        }
                    }
                    else
                    {
                        sc.removeAvatarPartByID(AvatarPartID.BLANK, false);
                    }
                }
            }
            var ap:AvatarPart = AvatarPart.createAvatarPart(apd.clone(), apsl);
            var apc:AvatarPlayCondition = sc.avatar.playCondition;
            if (sc.avatar.playCondition != null)
            {
                apc = apc.clone();
            }
            sc.addAvatarPart(ap, apd.clearSameType);
            if (sc.usable)
            {
                ap.playTo(sc.avatar.status, sc.avatar.logicAngle, apd.rotation, apc);
            }
            return;
        }

        public static function checkUninstall() : void
        {
            var key:String = null;
            if (++count < 1000)
            {
                return;
            }
            count = count % 1000;
            var nowTime:int = SceneRender.nowTime;
            for (key in waitingRemoveAvatarImgs)
            {
                
                if (nowTime - waitingRemoveAvatarImgs[key] > UNINSTALL_DELAY_TIME)
                {
                    doUninstallAvatarImg(key);
                    waitingRemoveAvatarImgs[key] = null;
                    delete waitingRemoveAvatarImgs[key];
                }
            }
            return;
        }

        public static function uninstallAvatarImg(key:String) : void
        {
            var _loc_2:AvatarImgData = null;
            if (avatarImgCache.has(key))
            {
                _loc_2 = avatarImgCache.get(key) as AvatarImgData;
				_loc_2.useNum = _loc_2.useNum - 1;
                if (_loc_2.useNum <= 0)
                {
                    if (!waitingRemoveAvatarImgs.hasOwnProperty(key))
                    {
                        waitingRemoveAvatarImgs[key] = SceneRender.nowTime;
                    }
                }
            }
            return;
        }

        private static function doUninstallAvatarImg(key:String) : void
        {
            var aid:AvatarImgData = null;
            if (avatarImgCache.has(key))
            {
                aid = avatarImgCache.get(key) as AvatarImgData;
                if (aid.useNum <= 0)
                {
                    aid.dispose();
                    avatarImgCache.remove(key);
                }
            }
            return;
        }

        public static function installAvatarImg(aps:AvatarPartStatus, param2:String, param3:Boolean) : AvatarImgData
        {
            var aid:AvatarImgData = null;
            if (aps == null)
            {
                return null;
            }
            if (!avatarImgCache.has(param2))
            {
                aid = new AvatarImgData(aps, param2, param3);
                avatarImgCache.push(aid, param2);
            }
            else
            {
                aid = avatarImgCache.get(param2) as AvatarImgData;
                (avatarImgCache.get(param2) as AvatarImgData).useNum = aid.useNum + 1;
            }
            if (waitingRemoveAvatarImgs.hasOwnProperty(param2))
            {
                waitingRemoveAvatarImgs[param2] = null;
                delete waitingRemoveAvatarImgs[param2];
            }
            return aid;
        }

		/**
		 * 搜索指定点周围可用的点
		 * @param p
		 * @return 
		 * 
		 */		
		public static function searchAroundPoint(p:Point, dis:int=1):Point
		{
			
			if (mapSolids[(p.x-dis) + "_" + p.y] == 0)
			{
				p.x = p.x - dis;
			}else if (mapSolids[(p.x+dis) + "_" + p.y] == 0)
			{
				p.x = p.x + dis;
			}else if (mapSolids[p.x + "_" + (p.y-dis)] == 0)
			{
				p.y= p.y - dis;
			}else if (mapSolids[p.x + "_" + (p.y+dis)] == 0)
			{
				p.y = p.y + dis;
			}else if (mapSolids[(p.x-dis) + "_" + (p.y-dis)] == 0)
			{
				p.x = p.x - dis;
				p.y = p.y - dis;
			}else if (mapSolids[(p.x-dis) + "_" + (p.y+dis)] == 0)
			{
				p.x = p.x - dis;
				p.y = p.y + dis;
			}else if (mapSolids[(p.x+dis) + "_" + (p.y-dis)] == 0)
			{
				p.x = p.x + dis;
				p.y = p.y - dis;
			}else if (mapSolids[(p.x+dis) + "_" + (p.y+dis)] == 0)
			{
				p.x = p.x + dis;
				p.y = p.y + dis;
			}
			return p;
		}
		
    }
}
