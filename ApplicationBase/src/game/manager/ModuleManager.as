package game.manager
{
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import com.thinkido.framework.common.privatehome.PrivateHome;
	import com.thinkido.framework.engine.config.GlobalConfig;
	import com.thinkido.framework.manager.RslLoaderManager;
	import com.thinkido.framework.manager.loader.LoaderManager;
	import com.thinkido.framework.manager.loader.vo.LoadData;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import game.common.vos.ModuleResVO;
	import game.config.GameConfig;
	
	import org.osflash.thunderbolt.Logger;

	public class ModuleManager
	{
		private static var loadingDic:Dictionary = new Dictionary();
		private static var privateHome:PrivateHome = new PrivateHome();
		public function ModuleManager()
		{
		}
		public static function load($name:String,$callBack = null):void{
			var temp:String = $name.substring($name.lastIndexOf(".")+1,$name.indexOf("_")) ;
			
			var swfName:String = temp + "Module.swf";
			var path:String;
			path = GameConfig.baseFileUrl+VersionManager.getUrlWithPath($name.substring(0,$name.lastIndexOf(".")+1).replace(/\./g,"/") + swfName);
			var res:ModuleResVO = ModuleResManager.getModuleVO(temp);
			var loadData:LoadData;
			var len:int = res != null ? res.fileArr.length : 0, i:int = 0;
			var loadQueen:Array = [];
			
			if (len > 0)
			{
				for (;i<len;i++)
				{
					loadData = new LoadData(GameConfig.baseFileUrl+VersionManager.getUrlWithPath(res.fileArr[i].url), loadConfigComplete, null, null, "", res.fileArr[i].key, 0, GlobalConfig.decode, {order:i+1, max:len+1}) ;
					loadQueen.push(loadData);
				}
				
			}
			var loadQueenRsl:Array = [];
			len = res != null ? res.resArr.length : 0, i = 0;
			for (;i<len;i++)
			{
				if (ModuleResManager.loadedRecord[res.resArr[i].key])
					continue;
				loadData = new LoadData(GameConfig.baseFileUrl+VersionManager.getUrlWithPath(res.resArr[i].url),loadFileComplete, loadUpdate, loadError, "", res.resArr[i].key, 0, GlobalConfig.decode, {order:i+1, max:len+1}) ;
				loadQueenRsl.push(loadData);
			}
			loadData = new LoadData(path, loadComplete, loadUpdate, loadError, "", $name, 0, GlobalConfig.decode,  {order:i+1, data:$callBack, max:len+1}) ;
			loadQueenRsl.push(loadData);
			if (loadQueen.length > 0)
			{
				var loadComplete_xml:Function;
				loadComplete_xml = function (param:*):void
				{
					privateHome.clear();
					
					RslLoaderManager.load(loadQueenRsl);
				}
				var _loc_1:* = LoaderManager.creatNewLoader("moduleXmlLoader", loadComplete_xml, loadUpdate_xml);
				privateHome.addObject(_loc_1);
				LoaderManager.load(loadQueen,_loc_1,false);
			}else{
				RslLoaderManager.load(loadQueenRsl);
			}
//			LoadingBar.show();
		}
		
		private static function loadUpdate_xml(param1:BulkProgressEvent) : void
		{
			var _loc_2:Number = NaN;
			if (param1.hasOwnProperty("weightPercent"))
			{
				_loc_2 = param1.weightPercent;
			}
			else
			{
				_loc_2 = param1.bytesLoaded / param1.bytesTotal;
			}
//			LoadingBar.updatePercent(_loc_2, 1,  1, Language.getKey("3231"));
			return;
		}
		
		private static function loadConfigUpdate(param1:*) : void
		{
			return;
		}
		
		private static function loadUpdate($ld:LoadData, event:*) : void
		{
			
			var percent:Number = NaN;
			if (event is Number)
			{
				percent = event;
			}
			else if (event.hasOwnProperty("weightPercent"))
			{
				percent = event.weightPercent;
			}
			else
			{
				percent = event.bytesLoaded / event.bytesTotal;
			}
//			LoadingBar.updatePercent(percent, $ld.data.order, $ld.data.max, Language.getKey("3232"));
			return;
		}
		
		/**
		 * 加载模块的资源完毕
		 * @param $ld
		 * @param evt
		 * 
		 */		
		private static function loadConfigComplete(evt:Event):void
		{
			var target:LoadingItem = evt.target as LoadingItem;
			ModuleResManager.parseModuleData(target.content,  target.id);
		}
		
		private static function loadFileComplete(ld:LoadData, evt:Event):void
		{
			ModuleResManager.loadedRecord[ld.key] = true;
		}
		
		/**
		 * 加载模块swf完毕
		 * @param $ld
		 * @param evt
		 * 
		 */		
		private static function loadComplete($ld:LoadData, evt:Event) : void
		{
			loadingDic[$ld.url] = false ;
//			LoadingBar.hide();
			PipeManager.sendMsg($ld.key, $ld.data.data);
			if ($ld.data.data && $ld.data.data.hasOwnProperty("panelKey"))
			{
				PipeManager.sendMsg($ld.data.data.panelKey, $ld.data.data.data);
			}
		}
		private static function loadError($ld:LoadData, evt:Event) : void
		{
//			LoadingBar.hide();
//			GAlert.show(Language.getKey("3234") + $ld.key + Language.getKey("3235"),'',GAlert.OK);
//			Logger.error(Language.getKey("3180")+ $ld.key + Language.getKey("3236"));
//			throw new Error(Language.getKey("3180") + $ld.key + Language.getKey("3181"));
		}
	}
}