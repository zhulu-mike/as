package lm.mui.controls
{
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import lm.mui.manager.IToolTipItem;
	import lm.mui.manager.ToolTipsManager;

    public class GCellRenderer extends Sprite implements ICellRenderer, IToolTipItem
    {
        protected var _listData:ListData;
        protected var _selected:Boolean;
        protected var _data:Object;
        private var _toolTipData:Object;

        public function GCellRenderer()
        {
            this.configUI();
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageHandler);
            return;
        }

        private function onAddedToStageHandler(event:Event) : void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageHandler);
            this.mouseChildren = true;
            this.mouseEnabled = true;
            return;
        }

        public function setSize(param1:Number, param2:Number) : void
        {
            return;
        }

        protected function configUI() : void
        {
            return;
        }

        protected function draw() : void
        {
            return;
        }

        public function get listData() : ListData
        {
            return this._listData;
        }

        public function set listData(param1:ListData) : void
        {
            this._listData = param1;
            return;
        }

        public function get data() : Object
        {
            return this._data;
        }

        public function set data(param1:Object) : void
        {
            this._data = param1;
            return;
        }

        public function get selected() : Boolean
        {
            return this._selected;
        }

        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            return;
        }

        public function setMouseState(param1:String) : void
        {
            return;
        }

        public function get toolTipData():Object
        {
            return this._toolTipData;
        }

        public function set toolTipData(param1:Object) : void
        {
            if (param1 == null || param1 == "")
            {
                ToolTipsManager.unregister(this);
            }
            else
            {
                ToolTipsManager.register(this);
            }
            this._toolTipData = param1;
            return;
        }

        public function setStyle(param1:String, param2:Object) : void
        {
            return;
        }

    }
}
