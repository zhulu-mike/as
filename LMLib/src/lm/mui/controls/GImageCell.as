package lm.mui.controls
{
	import fl.controls.listClasses.ImageCell;
	
	import lm.mui.manager.IToolTipItem;
	import lm.mui.manager.ToolTipsManager;

    public class GImageCell extends ImageCell implements IToolTipItem
    {
        private var _tooltipData:Object;
        protected var _toolTipDataFunction:Function;

        public function GImageCell()
        {
            return;
        }

        public function get toolTipData():Object
        {
            return this._tooltipData;
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
            this._tooltipData = param1;
            return;
        }

        public function set toolTipDataFunction(param1:Function) : void
        {
            if (param1 == null)
            {
                ToolTipsManager.unregister(this);
            }
            else
            {
                ToolTipsManager.register(this);
            }
            this._toolTipDataFunction = param1;
            return;
        }

        public function get toolTipDataFunction() : Function
        {
            return this._toolTipDataFunction;
        }

    }
}
