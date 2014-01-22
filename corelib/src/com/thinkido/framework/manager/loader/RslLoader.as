package com.thinkido.framework.manager.loader
{
	import com.thinkido.framework.engine.config.GlobalConfig;
	import com.thinkido.framework.manager.SharedObjectManager;
	import com.thinkido.framework.manager.loader.vo.LoadData;
	import com.thinkido.framework.manager.loader.vo.RslLoadingInfo;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * 通常用来加载swf 文件到 当前域中   
	 * @author thinkido
	 * 
	 */
    public class RslLoader extends EventDispatcher
    {
        private var _loader:Loader;
        private var _urlLoader:URLLoader;
        private var _context:LoaderContext;
        public var isLocked:Boolean;
        public var isLoading:Boolean;
        public var rslLoadData:LoadData;
        public var rslLoadingInfo:RslLoadingInfo;

        public function RslLoader()
        {
            this._context = new LoaderContext();
            this._context.applicationDomain = ApplicationDomain.currentDomain;
			try{
				_context.allowCodeImport = true ;
			}catch(e:*){
				
			}
            this._urlLoader = new URLLoader();
            this._urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this._loader = new Loader();
            return;
        }

        public function load($loadData:LoadData) : void
        {
            this.isLoading = true;
            this.rslLoadData = $loadData;
			var urlReq:URLRequest;
			if (!GlobalConfig.useSo)
			{
				doLoad();
			}else{
				//从SO中获取
				var bytes:ByteArray = SharedObjectManager.getDataByHttpUrl(this.rslLoadData.url) as ByteArray;
				if (bytes == null)
				{
					doLoad();
				}else{
					doBytes(bytes);
				}
			}
            return;
        }
		
		private function doLoad():void
		{
			var urlReq:URLRequest;
			this.initUrlLoadEvent();
			urlReq = new URLRequest(this.rslLoadData.url);
			urlReq.method = URLRequestMethod.POST;
			this._urlLoader.load(urlReq);
		}

        public function stop() : void
        {
            this.removeUrlLoadEvent();
            try
            {
                this._urlLoader.close();
            }
            catch (e:Error)
            {
                try
                {	
					this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
					this._loader.close();
                }catch (e:Error)
				{
				}            
            }
            
            this.isLoading = false;
            return;
        }

        private function initUrlLoadEvent() : void
        {
            this._urlLoader.addEventListener(ProgressEvent.PROGRESS, this.onUrlProgress);
            this._urlLoader.addEventListener(Event.COMPLETE, this.onUrlComplete);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onUrlError);
            this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUrlError);
            return;
        }

        private function removeUrlLoadEvent() : void
        {
            this._urlLoader.removeEventListener(ProgressEvent.PROGRESS, this.onUrlProgress);
            this._urlLoader.removeEventListener(Event.COMPLETE, this.onUrlComplete);
            this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onUrlError);
            this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUrlError);
            return;
        }

        private function onUrlComplete(event:Event) : void
        {
            var by:ByteArray = event.currentTarget.data;
			if (GlobalConfig.useSo)
			{
				SharedObjectManager.setDataByHttpUrl(this.rslLoadData.url,by);
			}
			doBytes(by);
        }
		
		private function doBytes(by:ByteArray):void
		{
			if (this.rslLoadData.decode != null)
			{
				by = this.rslLoadData.decode(by);
			}
			by.position = 0;
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
			this._loader.loadBytes(by, this._context);
			return;
		}

        private function onUrlProgress(event:ProgressEvent) : void
        {
            dispatchEvent(event);
            return;
        }

        private function onUrlError(event:Event) : void
        {
            this.stop();
            dispatchEvent(event);
            return;
        }

        private function onComplete(event:Event) : void
        {
            this.stop();
            dispatchEvent(event);
            return;
        }

		public function get loader():Loader
		{
			return _loader;
		}


    }
}
