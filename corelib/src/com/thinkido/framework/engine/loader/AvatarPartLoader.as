package com.thinkido.framework.engine.loader
{
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.config.GlobalConfig;
    import com.thinkido.framework.engine.staticdata.SceneCharacterType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPartStatusList;
    import com.thinkido.framework.manager.RslLoaderManager;
    import com.thinkido.framework.manager.loader.vo.LoadData;

	/**
	 * AvatarPart swf 的加载器 
	 * @author thinkido
	 * 
	 */	
    public class AvatarPartLoader extends Object
    {

        public function AvatarPartLoader()
        {
            return;
        }
		/**
		 * 更具 AvatarParamData 获取角色对象链接类，加载资源
		 * @param sc
		 * @param apd
		 * 
		 */
        public static function loadAvatarPart(sc:SceneCharacter, apd:AvatarParamData = null) : void
        {
            var apd:AvatarParamData;
            var apsList:AvatarPartStatusList;
            var tryLoadCount:int;
            var priority:int;
            var loadSourceComplete:Function;
            var loadError:Function;
            var $sc:SceneCharacter = sc;
            var $apd:AvatarParamData = apd;
            $apd = $apd != null ? ($apd.clone()) : (new AvatarParamData());
            if ($sc != null && $sc.usable && $apd.sourcePath != null && $apd.sourcePath != "")
            {
                if ($apd.clearSameType)
                {
                    SceneCache.removeWaitingAvatar($sc, null, $apd.type);
                }
                if (!SceneCache.avatarXmlCache.has($apd.sourcePath))
                {
                    var loadSource:Function = function () : void
			            {
			                var loadData:LoadData = new LoadData($apd.sourcePath, null, null, loadError, "", "", 0, GlobalConfig.decode);
			                RslLoaderManager.load([loadData], loadSourceComplete, priority);
			                return;
			            };
                    loadSourceComplete = function () : void
			            {
			                var apslXml:XML = null;
			                var $class:Class = RslLoaderManager.getClass($apd.className);
			                if ($class != null)
			                {
			                    apslXml = $class.X_M_L as XML;
			                    apsList = new AvatarPartStatusList($apd.className, apslXml);
			                    if (SceneCache.avatarXmlCache.has($apd.sourcePath))
			                    {
			                        SceneCache.avatarXmlCache.get($apd.sourcePath).data = apsList;
			                    }
			                    else
			                    {
			                        SceneCache.avatarXmlCache.push({data:apsList}, $apd.sourcePath);
			                    }
			                    SceneCache.dowithWaiting($apd.sourcePath, apsList);
			                }
			                else
			                {
			                    loadError(null, null, false);
			                }
			                return;
			            }       ;
                    loadError = function (value1:LoadData = null, value2:* = null, reLoad:Boolean = true) : void
			            {
			                var giveUp:Boolean = true;
			                if (reLoad)
			                {
			                    tryLoadCount += 1;
			                    if (tryLoadCount < 3)
			                    {
			                        giveUp = false;
			                        loadSource();
			                    }
			                    else
			                    {
			                        giveUp = true;
			                    }
			                }
			                if (giveUp)
			                {
			                    if (SceneCache.avatarXmlCache.has($apd.sourcePath))
			                    {
			                        SceneCache.avatarXmlCache.remove($apd.sourcePath);
			                    }
			                    SceneCache.dowithWaiting($apd.sourcePath, null);
			                    $apd.executeCallBack($sc);
			                }
			                return;
			            } ;
                    SceneCache.avatarXmlCache.push({data:null}, $apd.sourcePath);
                    SceneCache.addWaitingLoadAvatar($sc, $apd, loadSource);
                    tryLoadCount;
                    priority = SceneCharacterType.getDefaultLoadPriority($sc.type);
                }
                else
                {
                    apsList = SceneCache.avatarXmlCache.get($apd.sourcePath).data;
                    if (apsList == null)
                    {
                        SceneCache.addWaitingLoadAvatar($sc, $apd.clone());
                    }
                    else
                    {
                        SceneCache.addWaitingAddAvatar($sc, $apd.clone(), apsList);
                    }
                }
				var $class:Class = RslLoaderManager.getClass($apd.className);
				if ($class == null)
				{
					$apd.executeCallBack($sc);
				}
            }
            else
            {
                $apd.executeCallBack($sc, null, true, true, true, true, true, true, 0, 0, 0, 0, 0, 0);
            }
            return;
        }

    }
}
