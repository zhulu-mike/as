package com.thinkido.framework.engine.loader
{
    import com.thinkido.framework.engine.SceneCharacter;
    import com.thinkido.framework.engine.config.GlobalConfig;
    import com.thinkido.framework.engine.graphics.avatar.AvatarPart;
    import com.thinkido.framework.engine.staticdata.SceneCharacterType;
    import com.thinkido.framework.engine.tools.SceneCache;
    import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
    import com.thinkido.framework.engine.vo.avatar.AvatarPartStatus;
    import com.thinkido.framework.manager.RslLoaderManager;
    import com.thinkido.framework.manager.loader.vo.LoadData;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    import org.osflash.thunderbolt.Logger;

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
        public static function loadAvatarPart($ap:AvatarPart, $status:String) : void
        {
            var apd:AvatarParamData;
			var fullSourchPath:String;
			var sc:SceneCharacter = $ap.sceneCharacter ;
			apd = $ap.avatarParamData;
			
            var priority:int;
            var loadSourceComplete:Function;
            var loadError:Function;
            var $sc:SceneCharacter = sc;
            var $apd:AvatarParamData = apd;
			if (sc != null && sc.usable && $ap.usable && apd.sourcePath != null && apd.sourcePath != "" && $status != null && $status != "")
			{
				fullSourchPath = apd.getFullSourcePath($status);
//				if (!SceneCache.avatarXmlCache.has(fullSourchPath) && RslLoaderManager.getClass(apd.baseClassName+$status))
//				{
//					var cl:Class = RslLoaderManager.getClass(apd.baseClassName+$status) as Class;
//					if (apd.statusList == null)
//					{
//						apd.statusList = cl.STATUS_LIST as Array;
//					}
//					var x_m_l:XML = cl.X_M_L as XML;
//					var taps:AvatarPartStatus = new AvatarPartStatus(fullSourchPath, x_m_l);
//					SceneCache.avatarXmlCache.push({data:taps}, fullSourchPath);
//				}
				if (!SceneCache.avatarXmlCache.has(fullSourchPath))
				{
					var loadSource:Function = function () : void
					{
						var loadData:LoadData = new LoadData(fullSourchPath, loadSourceComplete, null, loadError, "", "", 0, GlobalConfig.decode);
						RslLoaderManager.load([loadData],null,priority);
						return;
					};
					loadSourceComplete = function ($ld:LoadData, evt:Event) : void
					{
						var _xml:XML = null;
						var _mc:MovieClip = null;
						var _shape:Shape = null;
						var _rec:Rectangle = null;
						var _bmd:BitmapData = null;
						var _matrix:Matrix = null;
						var _bitmap:Bitmap = null;
						var apsXml:XML = null;
						var $class:Class;
						$class = RslLoaderManager.getClass(apd.baseClassName+$status);
						if (apd.statusList == null)
						{
							if ($class == null)
								Logger.info("加载不成功"+$ld.url);
							apd.statusList = $class.STATUS_LIST as Array;
						}
						if ($class != null)
						{
							apsXml = $class.X_M_L as XML;
							var aps:AvatarPartStatus = new AvatarPartStatus(fullSourchPath, apsXml);
							if (SceneCache.avatarXmlCache.has(fullSourchPath))
							{
								SceneCache.avatarXmlCache.get(fullSourchPath).data = aps;
							}
							else
							{
								SceneCache.avatarXmlCache.push({data:aps}, fullSourchPath);
							}
							SceneCache.dowithWaiting(fullSourchPath, aps);
						}
						else
						{
							loadError(null, null, false);
						}
						return;
					};
					loadError = function ($ld:LoadData, evt:Event = null, reLoad:Boolean = true) : void
					{
						var giveUp:Boolean = true;
						if (reLoad)
						{
							tryLoadCount ++;
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
							if (SceneCache.avatarXmlCache.has(fullSourchPath))
							{
								SceneCache.avatarXmlCache.remove(fullSourchPath);
							}
							SceneCache.dowithWaiting(fullSourchPath, null);
						}
						return;
					};
					var tryLoadCount:int = 0;
					priority = SceneCharacterType.getDefaultLoadPriority($sc.type);
					SceneCache.avatarXmlCache.push({data:null}, fullSourchPath);
					SceneCache.addWaitingLoadAvatar($ap, $status, fullSourchPath, loadSource);
				}else{
					var avatarData:Object = SceneCache.avatarXmlCache.get(fullSourchPath);
					if (avatarData.data == null)
					{
						SceneCache.addWaitingLoadAvatar($ap, $status, fullSourchPath, null);
					}
					else
					{
						SceneCache.addWaitingAddAvatar($ap, avatarData.data as AvatarPartStatus);
					}
				}
				var $class:Class = RslLoaderManager.getClass($apd.baseClassName+$status);
				if ($class == null)
				{
					$apd.executeCallBack(sc);
				}
            }
            else
            {
				$apd.executeCallBack(sc, $ap, $status, true, true, true, true, true, true, 0, 0, 0, 0, 0, 0);
				if ($ap && $apd.playCompleteAutoRecycle && $ap.avatar)
				{
					$ap.avatar.removeAvatarPart($ap);
				}
            }
            return;
        }

    }
}
