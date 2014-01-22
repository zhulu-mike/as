package lm.mui.controls
{   
    import fl.controls.NumericStepper;
    import fl.core.InvalidationType;
    
    import lm.mui.manager.IToolTipItem;
    import lm.mui.manager.ToolTipsManager;
    import lm.mui.skins.SkinManager;

	/**
	 * 
	 *		this._numStepper = new GNumericStepper();
            this._numStepper.move(160, 110);
            this._numStepper.width = 65;
            this._numStepper.minimum = 1;
            this._numStepper.maximum = 99;
            this._numStepper.styleName = "NumericStepper";
            this._numStepper.drawNow();
            this._numStepper.textField.setStyle("upSkin", GlobalClass.getScaleBitmap("WindowCenterB"));
            this._numStepper.textField.drawNow();
            addChild(this._numStepper);
	 * 
	 */	
    public class GNumericStepper extends NumericStepper implements IToolTipItem
    {
        public const CLASSNAME:String = "List";
        private var _styleName:String;
        private var _isStyleChange:Boolean = false;
        protected var _toolTipData:Object;

        public function GNumericStepper()
        {
            this._styleName = this.CLASSNAME;
            this.imeMode = null;
            return;
        }

        final override protected function configUI() : void
        {
            super.configUI();
            this.createChildren();
			downArrow.width = upArrow.width = 16;
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
