package lm.mui.manager
{
	import flash.display.Sprite;

    public class ToolTipItem extends Sprite implements IToolTipItem
    {
        private var _toolTipData:Object;

        public function ToolTipItem()
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
