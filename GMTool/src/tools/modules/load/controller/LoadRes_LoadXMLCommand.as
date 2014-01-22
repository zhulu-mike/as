package tools.modules.load.controller
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tools.events.PipeEvent;
	import tools.managers.EquipManager;
	import tools.managers.GoodswareResManager;
	import tools.managers.ImmortalGasManager;
	import tools.managers.PipeManager;
	import tools.managers.ServerManager;
	import tools.managers.SkillManager;
	import tools.managers.SoulLevelManager;
	import tools.modules.load.view.components.LoaderBar;

    public class LoadRes_LoadXMLCommand extends SimpleCommand
    {

    	private var xmlLoader:URLLoader;

        public function LoadRes_LoadXMLCommand()
        {
            return;
        }

		
		
        override public function execute(param1:INotification) : void
        {
			xmlLoader = new URLLoader();
			
			xmlLoader.addEventListener(Event.COMPLETE, onComplete);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			xmlLoader.load(new URLRequest(Global.fileBaseFolder + "program/config/xmlData.byt"));
          	LoaderBar.getInstance().show();
			LoaderBar.getInstance().setText(Language.LOADING_SOURSE+"......0%");
			return;
        }

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			removeListener1();
			loadServerList();
		}

		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			if (event.status == 403)
			{
				removeListener1();
				loadServerList();
			}
		}

		private function onIoError(event:IOErrorEvent):void
		{
			removeListener1();
			loadServerList();
		}

		private function onProgress(event:ProgressEvent):void
		{
			LoaderBar.getInstance().setText(Language.LOADING_SOURSE+"......"+int(event.bytesLoaded/event.bytesTotal*100)+"%");
		}
		
		private function removeListener1():void
		{
			xmlLoader.removeEventListener(Event.COMPLETE, onComplete);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		private function onComplete(event:Event):void
		{
			removeListener1();
			var data:ByteArray = xmlLoader.data as ByteArray;
			data.uncompress();
			var xmls:Object = data.readObject() as Object;
			for(var item:String in xmls)
			{
				this.parse(item, XML(xmls[item]));
			}
			loadServerList();
		}
		
		/**
		 *	解析 
		 * @param key
		 * @param data
		 * 
		 */		
		private function parse(key:String, data:XML):void
		{
			switch(key)
			{
				case 'goods':
				{
					GoodswareResManager.parseRes(data);
					break;
				}
				case "upgradeconfig"://强化消耗
				{
					EquipManager.getInstance().parseUpgradeConfig(data as XML);
					break;
				}
				case 'immortalgas':
				{
					ImmortalGasManager.parseConfig(data);
					break;
				}
				case "skilleffect":
				{
					SkillManager.getInstance().analysisXML(data);
					break;
				}
				case 'soulfoster':
				{
					SoulLevelManager.parseConfig(data as XML);
					break;
				}
			}
		}
		
		/**
		 * 加载服务器列表
		 * 
		 */		
		private function loadServerList():void
		{
			xmlLoader.addEventListener(Event.COMPLETE, onServerComplete);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onServerIoError);
			xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onServerHttpStatus);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onServerSecurityError);
			xmlLoader.load(new URLRequest(Global.fileBaseFolder + "program/config/serverlist.xml"));
		}
		
		protected function onServerSecurityError(event:SecurityErrorEvent):void
		{
			// TODO Auto-generated method stub
			removeListener();
			PipeManager.sendMsg(PipeEvent.STARTUP_LOGIN);
			LoaderBar.getInstance().close();
		}
		
		protected function onServerHttpStatus(event:HTTPStatusEvent):void
		{
			// TODO Auto-generated method stub
			if (event.status == 404)
			{
				removeListener();
				PipeManager.sendMsg(PipeEvent.STARTUP_LOGIN);
				LoaderBar.getInstance().close();
			}
		}
		
		protected function onServerIoError(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			removeListener();
			PipeManager.sendMsg(PipeEvent.STARTUP_LOGIN);
			LoaderBar.getInstance().close();
		}
		
		/**服务器列表加载完毕*/
		protected function onServerComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			removeListener();
			ServerManager.parseData(XML(xmlLoader.data));
			PipeManager.sendMsg(PipeEvent.STARTUP_LOGIN);
			LoaderBar.getInstance().close();
		}
		
		private function removeListener():void
		{
			xmlLoader.removeEventListener(Event.COMPLETE, onServerComplete);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onServerIoError);
			xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onServerHttpStatus);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onServerSecurityError);
		}
		
		
		
		
    }
}
