package lm.mui.core
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import lm.mui.events.LibraryEvent;

    public class Library extends EventDispatcher
    {
        private var _loaderContext:LoaderContext;
        private var _enterFrameDispatcher:Sprite;
        private var _embeddedLoaders:Array;
        private var _runtimeLoaders:Array;
        private var _embeddedComplete:Boolean;
        private var _runtimeCompletes:Array;
        private var _runtimeComplete:Boolean;
        private var _name:String;
        private var _bytesLoaded:Number = 0;
        private var _bytesTotal:Number = 0;
        private var _LoaderContext:LoaderContext;

        public function Library(param1:String)
        {
            this._LoaderContext = new LoaderContext();
            this._name = param1;
            this.initialize();
            this._loaderContext = new LoaderContext(false, new ApplicationDomain(null));
            return;
        }

        public function get name() : String
        {
            return this._name;
        }

        public function get bytesLoaded() : Number
        {
            return this._bytesLoaded;
        }

        public function get bytesTotal() : Number
        {
            return this._bytesTotal;
        }

        public function get complete() : Boolean
        {
            return this._embeddedComplete && this._runtimeComplete;
        }

        public function get embeddedComplete() : Boolean
        {
            return this._embeddedComplete;
        }

        public function get runtimeComplete() : Boolean
        {
            return this._runtimeComplete;
        }

        public function loadSWF(param1:String) : void
        {
            var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onLoaderProgress, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaderComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOErrorHandler, false, 0, true);
			loader.load(new URLRequest(param1), this._loaderContext);
            this._runtimeLoaders.push(loader);
            this._runtimeCompletes.push(false);
            return;
        }

        public function embedSWF(param1:Class) : void
        {
			var loader:Loader = new Loader();
			loader.loadBytes(new param1 as ByteArray, this._loaderContext);
            this._embeddedLoaders.push(loader);
            return;
        }

        public function loadSWFS(param1:Array) : void
        {
            this._runtimeComplete = false;
            var len:int = param1.length;
            var index:int = 0;
            while (index < len)
            {
                
                this.loadSWF(param1[index] as String);
				index++;
            }
            return;
        }

        public function embedSWFS(param1:Array) : void
        {
            var loader:Loader = null;
            var cls:Class = null;
            if (this._enterFrameDispatcher.hasEventListener(Event.ENTER_FRAME))
            {
                this._enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
            this._embeddedComplete = false;
            var len:int = param1.length;
            var index:int = 0;
            while (index < len)
            {
                
				cls = Class(param1[index]);
				loader = new Loader();
				loader.loadBytes(new cls as ByteArray, this._loaderContext);
                this._embeddedLoaders.push(loader);
				index++;
            }
            this._enterFrameDispatcher.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
            return;
        }

        public function hasDefinition(param1:String) : Boolean
        {
            return this._loaderContext.applicationDomain.hasDefinition(param1);
        }

        public function getDefinition(param1:String) : Class
        {
            var cls:Class = this._loaderContext.applicationDomain.getDefinition(param1) as Class;
            if (cls)
            {
                return cls;
            }
//            ThrowError.show("ReferenceError: Error #1065: Variable " + param1 + " is not defined.");
            return null;
        }

        public function contains(param1:String) : Boolean
        {
            var loader:Loader = null;
            var len:int = this._embeddedLoaders.length;
            var index:int = 0;
            while (index < len)
            {
                
				loader = Loader(this._embeddedLoaders[index]);
                if (loader.contentLoaderInfo.applicationDomain.hasDefinition(param1))
                {
                    return true;
                }
				index++;
            }
            return false;
        }

        public function reset() : void
        {
            this.destroy();
            this.initialize();
            return;
        }

        public function destroy() : void
        {
            var loader:Loader = null;
            if (this._enterFrameDispatcher.hasEventListener(Event.ENTER_FRAME))
            {
                this._enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
            var len:int = this._runtimeLoaders.length;
            var index:int = 0;
            while (index < len)
            {
                
				loader = Loader(this._runtimeLoaders[index]);
                if (!this._runtimeCompletes[index])
                {
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onLoaderProgress);
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoaderComplete);
					loader.close();
                }
                else
                {
					loader.unload();
                }
				index++;
            }
			len = this._embeddedLoaders.length;
			index = 0;
            while (index < len)
            {
                
				loader = Loader(this._embeddedLoaders[index]);
				loader.unload();
				index++;
            }
            this._embeddedLoaders = null;
            this._runtimeLoaders = null;
            this._runtimeCompletes = null;
            this._enterFrameDispatcher = null;
            this._name = null;
            this._bytesLoaded = undefined;
            this._bytesTotal = undefined;
            return;
        }

        private function initialize() : void
        {
            this._embeddedLoaders = new Array();
            this._runtimeLoaders = new Array();
            this._runtimeCompletes = new Array();
            this._enterFrameDispatcher = new Sprite();
            this._bytesLoaded = 0;
            this._bytesTotal = 0;
            return;
        }

        private function onEnterFrame(event:Event) : void
        {
            this._enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            this._embeddedComplete = true;
            dispatchEvent(new LibraryEvent(LibraryEvent.EMBED_COMPLETE, false, false));
            return;
        }

        private function onLoaderProgress(event:ProgressEvent) : void
        {
            this.checkLoadersProgress();
            return;
        }

        private function onLoaderComplete(event:Event) : void
        {
            var loader:Loader = Loader(event.target.loader);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onLoaderProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoaderComplete);
            var len:int = this._runtimeLoaders.length;
            var index:int = 0;
            while (index < len)
            {
                
                if (loader == Loader(this._runtimeLoaders[index]))
                {
                    this._runtimeCompletes[index] = true;
                    break;
                }
				index++;
            }
            this.checkLoadersProgress(true);
            return;
        }

        private function onIOErrorHandler(event:ErrorEvent) : void
        {
            trace("library:" + event.text);
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text));
            return;
        }

        private function checkLoadersProgress(param1:Boolean = false) : void
        {
			var loader:Loader = null;
            var bytesTotal:Number = 0;
            var bytesLoaded:Number = 0;
            param1 = true;
            var _len:int = this._runtimeLoaders.length;
            var index:int = 0;
            while (index < _len)
            {
				loader = Loader(this._runtimeLoaders[index]);
				bytesTotal = bytesTotal + loader.contentLoaderInfo.bytesTotal;
				bytesLoaded = bytesLoaded + loader.contentLoaderInfo.bytesLoaded;
                if (!this._runtimeCompletes[index])
                {
                    param1 = false;
                }
				index++;
            }
            this._bytesLoaded = bytesLoaded;
            this._bytesTotal = bytesTotal;
            if (param1)
            {
                this._runtimeComplete = true;
                dispatchEvent(new LibraryEvent(LibraryEvent.LOAD_COMPLETE, false, false));
            }
            else
            {
                dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
            }
            return;
        }

    }
}
