package lm.mui.controls
{
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import lm.mui.core.GlobalClass;
	import lm.mui.display.ScaleBitmap;
	import lm.mui.skins.ListMenuCellRenderer;
    

    public class ListMenu extends GUIComponent
    {
		private static var instance:ListMenu;
		
        private var _bg:ScaleBitmap;
        private var _list:List;
        private var _delayTimer:Timer;
        private var _dataProvider:DataProvider;
        private var _target:DisplayObject;

        public function ListMenu(param1:ScaleBitmap = null)
        {
            setSize(86, 121);
            this._bg = this.addChild(param1 != null ? (param1) : (GlobalClass.getScaleBitmap("GeneralToolTip", new Rectangle(10,10,10,10)))) as ScaleBitmap;
           	this._bg.width = 100;
			this._list = new List();
            this._list.x = 14;
            this._list.y = 10;
			this._list.width = 80;
            this._list.rowHeight = 18;
            this._list.horizontalScrollPolicy = "off";
            this._list.verticalScrollPolicy = "off";
            this._list.setStyle("skin", new Bitmap());
            this._list.setStyle("cellRenderer", ListMenuCellRenderer);
            this._list.addEventListener(ListEvent.ITEM_CLICK, this.itemClickHandler);
            this.addChild(this._list);
            return;
        }
		
		public static function getInstance():ListMenu
		{
			if(instance == null)
			{
				instance = new ListMenu();
			}
			return instance;
		}

        public function get dataProvider() : DataProvider
        {
            return this._dataProvider;
        }

        public function set dataProvider(param1:DataProvider) : void
        {
            this._dataProvider = param1;
            this._list.dataProvider = param1;
            this._list.height = param1.length * this._list.rowHeight;
            this.height = this._list.height + 21;
			
			var maxWidth:int = getMaxWidth();
			this.width = maxWidth + 60;
            return;
        }
		
		private function getMaxWidth():int
		{
			var len:int = this._dataProvider.length;
			var str:String = this._dataProvider.getItemAt(0).name;
			var total:int = str.length;
			for(var i:int = 1; i < len; i++)
			{
				str = this._dataProvider.getItemAt(i).name;
				if(str.length > total)
				{
					total = str.length;
				}
			}
			var tf:TextField = new TextField();
			tf.autoSize = 'left';
			tf.text = this.dataProvider.getItemAt(0).name as String;
			return tf.width;
		}

        public function set target(param1:DisplayObject) : void
        {
            this._target = param1;
            return;
        }

        public function get target() : DisplayObject
        {
            return this._target;
        }

        public function hide() : void
        {
            this.visible = false;
            if (this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            }
            this._list.clearSelection();
            return;
        }

        public function show(param1:Number, param2:Number, param3:DisplayObject) : void
        {
            this.x = param1;
            this.y = param2;
            this.target = param3;
            if (!hasEventListener(MouseEvent.MOUSE_OVER))
            {
                this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            }
            if (!this._delayTimer)
            {
                this._delayTimer = new Timer(3000);
                this._delayTimer.addEventListener(TimerEvent.TIMER, this.delayTimerHandler);
                this._delayTimer.start();
            }
            else
            {
                this._delayTimer.reset();
                this._delayTimer.start();
            }
            this.visible = true;
            return;
        }

        private function enterFrameHandler(event:Event) : void
        {
            if (!this._bg.hitTestPoint(stage.mouseX, stage.mouseY, true))
            {
                this.hide();
            }
            return;
        }

        private function mouseOverHandler(event:MouseEvent) : void
        {
            this._delayTimer.stop();
            this._delayTimer.removeEventListener(TimerEvent.TIMER, this.delayTimerHandler);
            this._delayTimer = null;
            this.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            return;
        }

        private function delayTimerHandler(event:TimerEvent) : void
        {
            this._delayTimer.stop();
            this._delayTimer.removeEventListener(TimerEvent.TIMER, this.delayTimerHandler);
            this._delayTimer = null;
            this.hide();
            return;
        }

        private function itemClickHandler(event:ListEvent) : void
        {
            switch(event.item)
            {
                case "":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.hide();
            return;
        }

        public function get list() : List
        {
            return this._list;
        }

        override public function set width(value:Number) : void
        {
            super.width = value;
            this._bg.width = value;
			list.width = value - 28 ;
            return;
        }

        override public function set height(param1:Number) : void
        {
            super.height = param1;
            this._bg.height = param1;
            return;
        }

        public function dispose() : void
        {
            return;
        }

    }
}
