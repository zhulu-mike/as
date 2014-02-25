package com.thinkido.framework.engine.tools
{
    import com.thinkido.framework.common.cache.Cache;
    import com.thinkido.framework.common.handler.HandlerThread;
    import com.thinkido.framework.common.share.CountShare;
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
    import com.thinkido.framework.engine.staticdata.AvatarPartID;
    import com.thinkido.framework.engine.staticdata.AvatarPartType;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPartStatus;
    import com.thinkido.framework.manager.CacheManager;
    import com.thinkido.framework.manager.RslLoaderManager;
    
    import flash.utils.ByteArray;

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
		public static var mapSolidsByte:ByteArray = new ByteArray(); 
		
        private static var waitingLoadAvatarHT:HandlerThread = new HandlerThread();
        private static var waitingLoadAvatarFun:Object = new Object();
        private static var waitingLoadAvatars:Object = new Object();
        private static var waitingAddAvatarHT:HandlerThread = new HandlerThread();
        private static var waitingAddAvatars:Array = [];
        public static var avatarXmlCache:Cache = CacheManager.creatNewCache("avatarXmlCache");
        public static var waitingRemoveAvatarImgs:Object = {};
        private static var count:int = 0;
		public static var avatarCountShare:CountShare = new CountShare(12000);

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
		public static function addWaitingLoadAvatar($ap:AvatarPart, $status:String, $fullSourchPath:String, $loadFun:Function = null) : void
		{
			var exist:Boolean;
			var arr:Array;
			var ap:AvatarPart;
			var fullSourchPath:String;
			var priority:Boolean;
			var new_loadFun:Function;
			if (!$ap.usable || !$ap.avatar.usable)
			{
				return;
			}
			if ($ap.type == AvatarPartType.BODY && $ap.id != AvatarPartID.BLANK)
			{
				$ap.avatar.sceneCharacter.loadAvatarPart($ap.avatar.sceneCharacter.scene.blankAvatarParamData);
			}
			var watingArr:Array = waitingLoadAvatars[$fullSourchPath];
			if (watingArr == null)
			{
				waitingLoadAvatars[$fullSourchPath] = [[$ap, $status, $fullSourchPath]];
			}
			else
			{
				var watingLen:uint = watingArr.length ;
				for (var _index:int = 0 ; _index < watingLen ; _index++)
				{
					arr = watingArr[_index];
					ap = arr[0];
					fullSourchPath = arr[2];
					if ($ap == ap && $fullSourchPath == fullSourchPath)
					{
						exist;
						break;
					}
				}
				if (!exist)
				{
					waitingLoadAvatars[$fullSourchPath].push([$ap, $status, $fullSourchPath]);
				}
			}
			if ($loadFun != null)
			{
				new_loadFun = function () : void
				{
					if (waitingLoadAvatarFun[$fullSourchPath] == new_loadFun)
					{
						waitingLoadAvatarFun[$fullSourchPath] = null;
						delete waitingLoadAvatarFun[$fullSourchPath];
						$loadFun();
					}
					return;
				};
				waitingLoadAvatarFun[$fullSourchPath] = new_loadFun;
				priority = $ap.sceneCharacter.isMainChar();
				waitingLoadAvatarHT.push(new_loadFun, null, LOAD_AVATAR_DELAY, true, true, priority);
			}
			return;
		}

        public static function addWaitingAddAvatar($ap:AvatarPart, $aps:AvatarPartStatus) : void
        {
			var uniqueID:Number;
			var arr:Array;
            var ht_addAvatarPart:Function;
			ht_addAvatarPart = function () : void
            {
                var index:int = waitingAddAvatars.indexOf(arr);
                if (index != -1)
                {
                    waitingAddAvatars.splice(index, 1);
					if ($ap.usable && $ap.uniqueID == uniqueID)
					{
						$ap.setAvatarPartStatus($aps);
					}
                }
                return;
            };
			if (!$ap.usable || !$ap.avatar.usable)
			{
				return;
			}
			if ($ap.type == AvatarPartType.BODY && $ap.id != AvatarPartID.BLANK)
			{
				$ap.avatar.sceneCharacter.removeAvatarPartByID(AvatarPartID.BLANK,false);
			}
			uniqueID = $ap.uniqueID;
			arr = [$ap, $aps, ht_addAvatarPart];
			var priority:Boolean = $ap.sceneCharacter.isMainChar();
			waitingAddAvatars.push(arr);
            waitingAddAvatarHT.push(ht_addAvatarPart, null, ADD_AVATAR_DELAY, true, true, priority);
            return;
        }

		public static function removeWaitingAvatar($in_sc:SceneCharacter = null, $in_avatarPartID:String = null, $in_avatarPartType:String = null, $in_fullSourchPath:String = null, $stopLoad:Boolean = true) : void
		{
			var watingArrKey:String;
			var watingArr:Array;
			var loadFun:Function;
			var arr1:Array;
			var index:int;
			var newWatingArr:Array;
			var arr:Array;
			var ap:AvatarPart;
			var sc:SceneCharacter;
			var apd:AvatarParamData;
			var status:String;
			var ap1:AvatarPart;
			var sc1:SceneCharacter;
			var apd1:AvatarParamData;
			var aps1:AvatarPartStatus;
			var addFun:Function;
			var removeWaitLoadFun:Function = function (param1:String) : void
			{
				var _loc_2:Function = waitingLoadAvatarFun[param1];
				if (_loc_2 != null)
				{
					waitingLoadAvatarHT.removeHandler(_loc_2);
					waitingLoadAvatarFun[param1] = null;
					delete waitingLoadAvatarFun[param1];
				}
				return;
			};
			
			var _watingArrLen:int ;
			for (watingArrKey in waitingLoadAvatars)
			{
				watingArr = waitingLoadAvatars[watingArrKey];
				newWatingArr = [];
				_watingArrLen = watingArr.length ;
				for (var _index1:int = 0; _index1 < _watingArrLen ; _index1 ++)
				{
					arr = watingArr[_index1];
					ap = arr[0];
					if (ap.usable && ap.avatar.usable)
					{
						sc = ap.sceneCharacter;
						apd = ap.avatarParamData;
						status = arr[1];
						if (!(($in_sc == null || sc == $in_sc) && ($in_avatarPartID == null || apd.id == $in_avatarPartID) && ($in_avatarPartType == null || apd.type == $in_avatarPartType) && ($in_fullSourchPath == null || watingArrKey == $in_fullSourchPath)))
						{
							newWatingArr.push(arr);
						}
					}
				}
				if (newWatingArr.length > 0)
				{
					waitingLoadAvatars[watingArrKey] = newWatingArr;
					continue;
				}
				waitingLoadAvatars[watingArrKey] = null;
				delete waitingLoadAvatars[watingArrKey];
				removeWaitLoadFun(watingArrKey);
				
				if ($stopLoad)
				{
					RslLoaderManager.cancelLoadByUrl(watingArrKey);
					avatarXmlCache.remove(watingArrKey);
				}
			}
			index = waitingAddAvatars.length - 1;
			while (index >= 0){
				arr1 = waitingAddAvatars[index];
				ap1 = arr1[0];
				sc1 = ap1.sceneCharacter;
				apd1 = ap1.avatarParamData;
				aps1 = arr1[1];
				addFun = arr1[2];
				if (ap1.usable && !(($in_sc == null || sc1 == $in_sc) && ($in_avatarPartID == null || apd1.id == $in_avatarPartID) && ($in_avatarPartType == null || apd1.type == $in_avatarPartType) && ($in_fullSourchPath == null || aps1.fullSourchPath == $in_fullSourchPath)))
				{
				}
				else
				{
					waitingAddAvatars.splice(index, 1);
					waitingAddAvatarHT.removeHandler(addFun);
				}
				index--;
			}
			return;
		}

        public static function dowithWaiting(key:String, aps:AvatarPartStatus = null) : void
        {
			var _itemArr:Array = null;
			var _ap:AvatarPart = null;
			var _status:String = null;
			var items:Array = waitingLoadAvatars[key];
			waitingLoadAvatars[key] = null;
			delete waitingLoadAvatars[key];
			if (items == null || items.length == 0)
			{
				return;
			}
			if (aps != null)
			{
				for each (_itemArr in items)
				{
					_ap = _itemArr[0];
					addWaitingAddAvatar(_ap, aps);
				}
			}
			else
			{
				for each (_itemArr in items)
				{
					
					_ap = _itemArr[0];
					if (_ap.usable && _ap.avatarParamData)
					{
						_status = _itemArr[1];
						_ap.avatarParamData.executeCallBack(_ap.sceneCharacter, _ap, _status, true, true, true, true, true, true, 0, 0, 0, 0, 0, 0);
						if (_ap && _ap.usable && _ap.avatar && _ap.avatarParamData.playCompleteAutoRecycle)
						{
							_ap.avatar.removeAvatarPart(_ap);
						}
					}
				}
			}
            return;
        }
    }
}
