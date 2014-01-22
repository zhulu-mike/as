package lm.mui.controls
{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    
    import lm.mui.display.ScaleBitmap;
    import lm.mui.events.GLoadEvent;

    public class GImageBitmap extends ScaleBitmap
    {
		private var _width:int = 0;
		private var _height:int = 0;
		
        private var _imgUrl:String;
        public static var _arySuffix:Array = [".png", ".jpg", ".jpeg", ".swf",'gif'];
		public var loadComFunc:Function;
		public var loadErrorFunc:Function;

        public function GImageBitmap(param1:Object = null, param2:int = 0, param3:int = 0)
        {
			if(param1 is Class)
			{
				this.bitmapData = new param1().bitmapData;
				x = param2;
				y = param3;
				if(this._width != 0) {
					this.width = this._width;
					this._width = 0;
				}
				if(this._height != 0) {
					this.height = this._height;
					this._height = 0;
				}
			}
			else if(param1 is String)
			{
				this.imgUrl = param1 as String;
				x = param2;
				y = param3;
			}
			super(this.bitmapData);
        }
		
		override public function set scale9Grid(rect:Rectangle):void
		{
			if(this.bitmapData == null)
			{
				this._scale9Grid = rect;
			}
			else
			{
				super.scale9Grid = rect;
			}
		}
		
		override public function set width(param:Number):void
		{
			if(this.bitmapData == null)
			{
				this._width = param;
			}
			else
			{
				super.width = param;
			}
		}
		
		override public function set height(param:Number):void
		{
			if(this.bitmapData == null)
			{
				this._height = param;
			}
			else
			{
				super.height = param;
			}
		}
		/**
		 * 设置地址，原来设置过scale9Grid 的地方需要 归零。scale9Grid = new Rectangle() ;
		 * @param param1
		 * 
		 */
        public function set imgUrl(param1:String) : void
        {
            if (!param1)
            {
				this.bitmapData = null;
				this._imgUrl = "";
                return;
            }
			var old:String =  this._imgUrl;
            this._imgUrl = getUrl(param1);
			if (this._imgUrl == old)
			{
				return;
			}
            this.setBitmapdata(this._imgUrl);
            return;
        }

        public function get imgUrl() : String
        {
            return this._imgUrl;
        }
		
		private var loader:Loader = new Loader();
		
        private function setBitmapdata(url:String) : void
        {
//			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,  onProgress);
			loader.load(new URLRequest(url));
        }

		private function onProgress(event:ProgressEvent):void
		{
			this.dispatchEvent(event);
		}

		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			if (event.status == 404 && loadErrorFunc != null)
			{
				loadErrorFunc();
			}
			var evt:GLoadEvent = new GLoadEvent(GLoadEvent.HTTP_STATUS);
			evt.data = event;
			this.dispatchEvent(evt);
		}

		private function onIoError(event:IOErrorEvent):void
		{
			if (loadErrorFunc != null)
				loadErrorFunc();
			var evt:GLoadEvent = new GLoadEvent(GLoadEvent.IO_ERROR);
			evt.data = event;
			this.dispatchEvent(evt);
		}
		
		private function loaded(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
			if (loader.contentLoaderInfo.url != this._imgUrl)
			{
				loader.unload();
				return;
			}
			if(loader.content is Bitmap)
			{
				this.bitmapData = (loader.content as Bitmap).bitmapData;
			}
			if(this._width != 0) {
				this.width = this._width;
				this._width = 0;
			}
			if(this._height != 0) {
				this.height = this._height;
				this._height = 0;
			}
			if(this._scale9Grid  != null)
			{
				super.scale9Grid = this._scale9Grid;
			}
			loader.unload();
			if (loadComFunc != null)
				loadComFunc();
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function loadedHander(event:Event):void
		{
			
		}

        public static function getUrl(url:String) : String
        {
            var str:String = null;
            var tempUrl:String = url.toLocaleLowerCase();
            for each (str in _arySuffix)
            {
                
                if (tempUrl.indexOf(str) > 0)
                {
                    return url;
                }
            }
            return url + ".swf";
        }

    }
}
