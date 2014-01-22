package com.thinkido.framework.manager.modules
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * 模块加载器 
	 * @author thinkido
	 */
    public class ModuleLoader extends EventDispatcher
    {
        private var _url:String;
        private var _loader:Loader;
        private var _contentType:String;
        private var _loaderInfo:LoaderInfo;
        protected var _appDomain:ApplicationDomain;

        public function ModuleLoader()
        {
            return;
        }

        public function load($url:String, $loaderComtext:LoaderContext = null) : void
        {
            if (this._url != $url)
            {
                this._url = $url;
                if (this._loader == null)
                {
                    this._loader = new Loader();
                }
                else
                {
                    this._loader.contentLoaderInfo.removeEventListener(Event.INIT, this.onInitHandler);
                    this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
                    this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onProgressHandler);
                    this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
                }
                this._loader.contentLoaderInfo.addEventListener(Event.INIT, this.onInitHandler);
                this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onCompleteHandler);
                this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onProgressHandler);
                this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
                this._loader.load(new URLRequest(this._url), $loaderComtext);
            }
            return;
        }

        private function onInitHandler(event:Event) : void
        {
            this._loaderInfo = this._loader.contentLoaderInfo;
            this._appDomain = this._loaderInfo.applicationDomain;
            return;
        }

        private function onCompleteHandler(event:Event) : void
        {
            this._loader.contentLoaderInfo.removeEventListener(Event.INIT, this.onInitHandler);
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
            this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onProgressHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
            dispatchEvent(event);
            return;
        }

        private function onProgressHandler(event:ProgressEvent) : void
        {
            dispatchEvent(event);
            return;
        }

        private function onIOErrorHandler(event:IOErrorEvent) : void
        {
            dispatchEvent(event);
            return;
        }

        public function dispose() : void
        {
            this._loader.contentLoaderInfo.removeEventListener(Event.INIT, this.onInitHandler);
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
            this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onProgressHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
            this._loader.unload();
            this._loader = null;
            this._url = null;
            return;
        }

        public function get url() : String
        {
            return this._url;
        }

        public function get content() : DisplayObject
        {
            if (this._loaderInfo)
            {
                return this._loaderInfo.content;
            }
            return null;
        }

        public function get contentType() : String
        {
            if (this._loaderInfo)
            {
                return this._loaderInfo.contentType;
            }
            return null;
        }

        public function get loaderInfo() : LoaderInfo
        {
            return this._loaderInfo;
        }

        public function getExportedAsset(param1:String) : Object
        {
            if (this._appDomain == null)
            {
                throw new Error("not initialized");
            }
            var _class:Class = this.getAssetClass(param1);
            if (_class != null)
            {
                return new _class;
            }
            return null;
        }

        public function getAssetClass($className:String) : Class
        {
            if (this._appDomain == null)
            {
                throw new Error("not initialized");
            }
            if (this._appDomain.hasDefinition($className))
            {
                return this._appDomain.getDefinition($className) as Class;
            }
            return null;
        }

    }
}
