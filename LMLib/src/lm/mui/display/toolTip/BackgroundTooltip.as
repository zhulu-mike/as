package lm.mui.display.toolTip
{
	import flash.display.DisplayObject;
	
	import lm.mui.CompCreateFactory;
	import lm.mui.controls.BaseToolTip;
	import lm.mui.display.ScaleBitmap;

    public class BackgroundTooltip extends BaseToolTip
    {
        protected var scaleBg:ScaleBitmap;

        public function BackgroundTooltip()
        {
            this.scaleBg = CompCreateFactory.getGeneralToolTip();
            super.addChild(this.scaleBg);
            super.addChild(contentContainer);
            return;
        }

        override protected function updateSize(param1:Number, param2:Number) : void
        {
            super.updateSize(param1, param2);
            this.scaleBg.width = _width;
            this.scaleBg.height = _height;
            return;
        }

        override public function addChild(param1:DisplayObject) : DisplayObject
        {
            if (contentContainer != param1)
            {
                this.contentContainer.addChild(param1);
            }
            else
            {
                super.addChild(param1);
            }
            return param1;
        }

    }
}
