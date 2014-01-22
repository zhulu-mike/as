package lm.mui.controls
{
    import fl.core.InvalidationType;
    
    import lm.mui.controls.scrollBarResizable.ResizableUIScrollBar;
    import lm.mui.skins.SkinManager;

    public class GUIScrollBar extends ResizableUIScrollBar
    {
        public const CLASSNAME:String = "ScrollBar";
        private var _styleName:String;
        private var _isStyleChange:Boolean = false;

        public function GUIScrollBar()
        {
            this._styleName = this.CLASSNAME;
            return;
        }

        final override protected function configUI() : void
        {
            super.configUI();
            this.createChildren();
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
            if (isInvalid(InvalidationType.SIZE, InvalidationType.SELECTED, InvalidationType.DATA))
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

    }
}
