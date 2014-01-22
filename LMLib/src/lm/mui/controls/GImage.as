package lm.mui.controls
{
	
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class GImage extends GUIComponent
	{
		protected var _loader:Loader;
		protected var _imgUrl:String = "";
		private var _defaultUrl:String = "";
		private var bitmap:Bitmap;
		private var contentCon:Sprite;
		
		public function GImage()
		{
			
			createChildren();
		}
		
		/***/
		public function get content():DisplayObject
		{
			if (bitmap.parent)
				return bitmap;
			if (contentCon.parent && contentCon.numChildren > 0)
				return contentCon.getChildAt(0);
			return null;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			_loader = new Loader();
			
			bitmap = new Bitmap();
			this.addChild(bitmap);
			
			contentCon = new Sprite();
			this.addChild(contentCon);
		}
		
		/***/
		public function set imgUrl(value:String):void
		{
			if (value == "")
			{
				if (contentCon.parent)
				{
					while (contentCon.numChildren)
						contentCon.removeChildAt(0);
				}else if (bitmap.parent)
				{
					bitmap.bitmapData = null;
				}
				_defaultUrl = "";
			}
			if (value != _imgUrl)
			{
				_imgUrl = value;
				invalidate(InvalidationType.DATA);
			}
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			if (contentCon.parent){
				this.removeChild(contentCon);
			}
			this.addChild(bitmap);
			bitmap.bitmapData = value;
		}
		
		
		public function setContent(value:Object):void
		{
			if (value is BitmapData)
			{
				bitmapData = value as BitmapData;
			}else if (value is Bitmap)
			{
				bitmapData = value.bitmapData;
			}else if (value is DisplayObject){
				if (bitmap.parent){
					this.removeChild(bitmap);
				}
				while (contentCon.numChildren)
					contentCon.removeChildAt(0);
				contentCon.addChild(value as DisplayObject);
				if (contentCon.parent == null)
					this.addChild(contentCon);
			}
		}
		
		
		/***/
		public function get imgUrl():String
		{
			return _imgUrl;
		}
		
		protected function onIoError(event:IOErrorEvent):void
		{
			trace(event.text);
		}
		
		protected function loadComplete(event:Event):void
		{
			if (_loader.contentLoaderInfo.url != _defaultUrl)
				return;
			this.width = _loader.content.width;
			this.height = _loader.content.height;
			var disp:DisplayObject = _loader.content;
			trace(this._imgUrl);
			setContent(disp);
			this.dispatchEvent(event);
			
		}
		
		public function gotoAndPlay(frame:int):void
		{
			if (_loader.content && _loader.content is MovieClip)
			{
				(_loader.content as MovieClip).gotoAndPlay(frame);
			}
		}
		
		public function gotoAndStop(frame:int):void
		{
			if (_loader.content && _loader.content is MovieClip)
			{
				(_loader.content as MovieClip).gotoAndStop(frame);
			}
		}
		
		public function stop():void
		{
			if (_loader.content && _loader.content is MovieClip)
			{
				(_loader.content as MovieClip).stop();
			}
		}
		
		public function play():void
		{
			if (_loader.content && _loader.content is MovieClip)
			{
				(_loader.content as MovieClip).play();
			}
		}
		
		override protected function updateDate():void
		{
			super.updateDate();
			if (_imgUrl == "")
			{
				_loader.unload();
				_defaultUrl = "";
			}else if (_defaultUrl != _imgUrl){
				_defaultUrl = _imgUrl;
				var index:int = _imgUrl.lastIndexOf("?");
				if (index < 0)
					index = _imgUrl.length;
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				_loader.load(new URLRequest(_imgUrl));
			}
		}
		
		public function get loader():Loader
		{
			return _loader;
		}
		
		public function set loader(value:Loader):void
		{
			if (_loader.parent)
			{
				this.removeChild(_loader);
			}
			_loader = value;
			this.addChild(_loader);
			
		}
		
	}
}