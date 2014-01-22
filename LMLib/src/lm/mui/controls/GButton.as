package lm.mui.controls
{
    import fl.controls.Button;
    import fl.core.InvalidationType;
    
    import flash.events.KeyboardEvent;
    
    import lm.mui.manager.IToolTipItem;
    import lm.mui.manager.ToolTipsManager;
    import lm.mui.skins.SkinManager;

    public class GButton extends Button implements IToolTipItem
    {
        public const CLASSNAME:String = "Button";
        protected var _toolTipData:Object;
        protected var _styleName:String;
        protected var _isStyleChange:Boolean = false;

        public function GButton()
        {
            this.buttonMode = true;
            this.useHandCursor = true;
            return;
        }

        override protected function keyDownHandler(event:KeyboardEvent) : void
        {
            return;
        }

        override protected function keyUpHandler(event:KeyboardEvent) : void
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
		
		public function set color(value:uint):void
		{
			
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
		
		public function gotoState(state:String):void
		{
			mouseState = state;
			drawBackground();
		}

    }
}
