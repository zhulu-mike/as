package lm.mui.controls.scrollBarResizable
{
	import fl.controls.UIScrollBar;
	import fl.core.InvalidationType;

    public class ResizableUIScrollBar extends UIScrollBar
    {

        public function ResizableUIScrollBar()
        {
            return;
        }

        override protected function draw() : void
        {
            var $height:Number = 0;
            if (isInvalid(InvalidationType.DATA))
            {
                updateScrollTargetProperties();
            }
            if (isInvalid(InvalidationType.SIZE))
            {
				$height = super.height;
                downArrow.setSize(_width, _width);
                upArrow.setSize(_width, _width);
                downArrow.move(0, Math.max(upArrow.height, $height - downArrow.height));
                track.move(0, _width);
                track.setSize(_width, Math.max(0, $height - (downArrow.height + upArrow.height)));
                thumb.setSize(_width, thumb.height);
                updateThumb();
            }
            if (isInvalid(InvalidationType.STYLES, InvalidationType.STATE))
            {
                setStyles();
            }
            downArrow.drawNow();
            upArrow.drawNow();
            track.drawNow();
            thumb.drawNow();
            validate();
            return;
        }

    }
}
