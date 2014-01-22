package lm.mui.display.toolTip
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

    public class LabelToolTip extends Sprite
    {
        private var label:TextField;
        private var _toolTipStr:String;

        public function LabelToolTip(param1:String = "")
        {
            this._toolTipStr = param1;
            this.init();
            return;
        }

        public function set data(param1:String) : void
        {
            this._toolTipStr = param1;
            this.init();
            return;
        }

        private function init() : void
        {
            if (!this.label)
            {
                this.label = new TextField();
            }
            addChild(this.label);
            this.label.defaultTextFormat = new TextFormat("宋体", 12, 0xffffff, null, null, null, null, null, null, null, null, null, null);
            this.label.autoSize = TextFieldAutoSize.LEFT;
            this.label.multiline = true;
            this.label.htmlText = this._toolTipStr;
			if (label.textWidth > 195)
			{
				label.width = 200;
				this.label.wordWrap = true;
			}else{
				label.width = label.textWidth + 5;
			}
            return;
        }

        public function dispose() : void
        {
            while (this.numChildren)
            {
                
                removeChildAt(0);
            }
            return;
        }

    }
}
