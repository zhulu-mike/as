package lm.mui.controls
{
	import flash.text.TextField;
	
	import lm.mui.manager.IToolTipItem;
	import lm.mui.manager.ToolTipsManager;

    public class GTextFiled extends TextField implements IToolTipItem
    {
        private var _toolTipData:Object;

        public function GTextFiled()
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

    }
}
