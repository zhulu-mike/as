package lm.mui.controls
{
    import fl.controls.Label;
    import fl.core.InvalidationType;
    
    import flash.filters.GlowFilter;
    
    import lm.mui.manager.IToolTipItem;
    import lm.mui.manager.ToolTipsManager;
    import lm.mui.skins.SkinManager;

    public class GLabel extends Label implements IToolTipItem
    {
        private var _toolTipData:Object;
        private var _styleName:String;
        private var _isStyleChange:Boolean = false;
		private var _filterColor:uint = 0x000000;
		private var filterFlag:Boolean = false;

        public function GLabel()
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
			if (filterFlag)
				this.filters = [new GlowFilter(filterColor, 1, 3, 3, 5, 1)];
            return;
        }

        override public function setSize(param1:Number, param2:Number) : void
        {
            super.setSize(param1, param2);
            this.width = param1;
            this.height = param2;
            return;
        }

        override public function set width(param1:Number) : void
        {
            super.width = param1;
            if (textField)
            {
                textField.width = param1;
            }
            return;
        }

        override public function set height(param1:Number) : void
        {
            super.height = param1;
            if (textField)
            {
                textField.height = param1;
            }
            return;
        }


		public function get filterColor():uint
		{
			return _filterColor;
		}
		
		/**
		 * 描边颜色
		 */
		public function set filterColor(value:uint):void
		{
			invalidate(InvalidationType.ALL);
			_filterColor = value;
			filterFlag = true;
		}


    }
}
