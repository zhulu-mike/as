package lm.mui.controls
{   
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

    public class FontBtn extends GButton
    {
        private var _bmp:Bitmap;
        private var _btnx:Number = 0;

        public function FontBtn()
        {
            this._bmp = new Bitmap();
            addChild(this._bmp);
            label = "";
            styleName = "TabButton";
            return;
        }

        /*private function onImgLoadedHandler(param1:ImageInfo) : void
        {
            if (param1 && param1.bitmapData)
            {
                this._bmp.bitmapData = param1.bitmapData;
                this.updateBtnPos();
            }
            return;
        }*/

        protected function updateBtnPos() : void
        {
            if (this._bmp && this._bmp.bitmapData)
            {
                this._bmp.x = (width - this._bmp.bitmapData.width) / 2;
                this._bmp.y = (height - this._bmp.bitmapData.height) / 2;
            }
            return;
        }

        public function set imgUrl(url:String) : void
        {
//            LoaderManager.instance.load(param1, this.onImgLoadedHandler);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.load(new URLRequest(url));
			
            return;
        }
		
		private function loaded(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
			if(loader.content is Bitmap)
			{
				this._bmp.bitmapData = (loader.content as Bitmap).bitmapData;
				this.updateBtnPos();
				loader.unload();
			}
		}

        public function updateBtnSize(param1:int, param2:int) : void
        {
            var btnx:int = (width - param1) / 2;
            if (btnx != 0)
            {
                this._btnx = btnx;
            }
            x = x + btnx;
            y = y + (height - param2) / 2;
            width = param1;
            height = param2;
            this.updateBtnPos();
            return;
        }

        public function get btnx() : Number
        {
            return this._btnx;
        }

    }
}
