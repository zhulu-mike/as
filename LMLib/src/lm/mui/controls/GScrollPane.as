package lm.mui.controls
{
    import fl.containers.ScrollPane;
    import fl.core.InvalidationType;
    
    import lm.mui.skins.SkinManager;

    public class GScrollPane extends ScrollPane
    {
        private var verticalScrollBarPosition:String = "right";
        public const CLASSNAME:String = "ScrollPane";
        private var _styleName:String = "";
        private var _isStyleChange:Boolean = false;
        public static const SCROLLBARPOSITIONLEFT:String = "left";
        public static const SCROLLBARPOSITIONRIGHT:String = "right";

        public function GScrollPane()
        {
            this._styleName = this.CLASSNAME;
            return;
        }

        public function get styleName() : String
        {
            return this._styleName;
        }

        public function set styleName(param1:String) : void
        {
            if (this._styleName != param1)
            {
                this._styleName = param1;
                invalidate(InvalidationType.STYLES);
                this._isStyleChange = true;
            }
            return;
        }

        final override protected function draw() : void
        {
            if (isInvalid(InvalidationType.STYLES))
            {
                if (this._isStyleChange)
                {
                    SkinManager.setComponentStyle(this, this._styleName);
                    this._isStyleChange = false;
                }
                this.updateStyle();
            }
            if (isInvalid(InvalidationType.DATA))
            {
                this.updateDate();
            }
            if (isInvalid(InvalidationType.SIZE))
            {
                this.updateSize();
            }
            if (isInvalid(InvalidationType.SCROLL))
            {
            }
            if (isInvalid(InvalidationType.ALL))
            {
                this.updateDisplayList();
            }
            try
            {
                super.draw();
            }
            catch (e:Error)
            {
            }
            return;
        }

        protected function createChildren() : void
        {
            return;
        }

        protected function updateStyle() : void
        {
            return;
        }

        protected function updateSize() : void
        {
            return;
        }

        protected function updateDate() : void
        {
            return;
        }

        protected function updateDisplayList() : void
        {
            return;
        }

        public function setScrollBarSize(param1:Number) : void
        {
            _horizontalScrollBar.setSize(param1, height);
            _verticalScrollBar.setSize(param1, height);
            return;
        }

        override protected function drawLayout() : void
        {
            super.drawLayout();
            this.setVerticalScrollBarPosition();
            return;
        }

        public function set verticalScrollBarPos(param1:String) : void
        {
            this.verticalScrollBarPosition = param1 != SCROLLBARPOSITIONLEFT ? (SCROLLBARPOSITIONRIGHT) : (SCROLLBARPOSITIONLEFT);
            invalidate(InvalidationType.SCROLL);
            return;
        }

        private function setVerticalScrollBarPosition() : void
        {
            if (vScrollBar)
            {
                if (this.verticalScrollBarPosition == SCROLLBARPOSITIONRIGHT)
                {
                    _verticalScrollBar.x = width - _verticalScrollBar.width;
                }
                else
                {
                    _verticalScrollBar.x = 0;
                    contentClip.x = contentClip.x + _verticalScrollBar.width;
                }
            }
            _verticalScrollBar.visible = vScrollBar;
            return;
        }

    }
}
