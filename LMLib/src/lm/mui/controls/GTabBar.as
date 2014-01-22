package lm.mui.controls
{
    import fl.core.InvalidationType;
    
    import flash.events.MouseEvent;
    
    import lm.mui.containers.GBox;
    import lm.mui.containers.globalVariable.GBoxDirection;
    import lm.mui.events.MuiEvent;

    public class GTabBar extends GBox
    {
        protected var _dataProvider:Array;
        protected var _dataProviderChange:Boolean = false;
        protected var _selectedIndex:int = 0;
        protected var _selectedChange:Boolean = false;
        protected var _buttonStyleName:String = "TabButton";
        protected var _buttonWidth:int = 67;
        protected var _buttonHeight:int = 22;
        protected var _buttonFilters:Array;
        protected var allButtons:Vector.<GButton>;

        public function GTabBar()
        {
            this.allButtons = new Vector.<GButton>;
            return;
        }

        override protected function createChildren() : void
        {
            super.createChildren();
            return;
        }

        public function set dataProvider(param1:Array) : void
        {
            if (this._dataProvider == param1)
            {
                return;
            }
            this._dataProvider = param1;
            this._dataProviderChange = true;
            invalidate(InvalidationType.ALL);
            return;
        }

        public function get dataProvider() : Array
        {
            return this._dataProvider;
        }

        public function set selectedIndex(param1:int) : void
        {
            if (this._selectedIndex != param1)
            {
                this._selectedIndex = param1;
                this._selectedChange = true;
                invalidate();
            }
            return;
        }

        public function get selectedIndex() : int
        {
            return this._selectedIndex;
        }

        public function get selectedItem() : Object
        {
            if (this._dataProvider && this._dataProvider.length > this._selectedIndex)
            {
                return this._dataProvider[this._selectedIndex];
            }
            return null;
        }

        public function set buttonStyleName(param1:String) : void
        {
            this._buttonStyleName = param1;
            invalidate(InvalidationType.STYLES);
            return;
        }

        public function get buttonStyleName() : String
        {
            return this._buttonStyleName;
        }

        public function set buttonWidth(param1:int) : void
        {
            this._buttonWidth = param1;
            return;
        }

        public function get buttonWidth() : int
        {
            return this._buttonWidth;
        }

        public function set buttonHeight(param1:int) : void
        {
            this._buttonHeight = param1;
            return;
        }

        public function get buttonHeight() : int
        {
            return this._buttonHeight;
        }

        public function set buttonFilters(param1:Array) : void
        {
            if (this._buttonFilters == param1)
            {
                return;
            }
            this._buttonFilters = param1;
            return;
        }

        public function get buttonFilters() : Array
        {
            return this._buttonFilters;
        }

        public function getButtonAt(param1:int) : GButton
        {
            if (param1 < this.allButtons.length)
            {
                return this.allButtons[param1];
            }
            return null;
        }

        override protected function updateDisplayList() : void
        {
            var _data:Object = null;
            var _gbutton:GButton = null;
            if (this._dataProviderChange)
            {
                this.dispose();
                for each (_data in this.dataProvider)
                {
                    _gbutton = new GButton();
                    _gbutton.name = _data.name;
                    _gbutton.label = _data.label;
                    _gbutton.width = this.buttonWidth;
                    _gbutton.height = this.buttonHeight;
                    _gbutton.styleName = this.buttonStyleName;
					_gbutton.toggle = true;//如果这个不设置，那么改变它的selected无效
//					if( !_data.hasOwnProperty("enabled") ||  _data.enabled ){
//						_gbutton.enabled = false ;
//					}else {
//						_gbutton.enabled = true ;
//						_gbutton.addEventListener(MouseEvent.CLICK, this.btnClickHandler, false, 0, true);
//					}
                    this.allButtons.push(_gbutton);
					_gbutton.addEventListener(MouseEvent.CLICK, this.btnClickHandler, false, 0, true);
                    if (this._buttonFilters)
                    {
                        _gbutton.textField.filters = this._buttonFilters;
                    }
                    this.addChild(_gbutton);
                }
                this.checkSelected();
                this._dataProviderChange = false;
            }
            if (this._selectedChange)
            {
                this._selectedChange = false;
                this.checkSelected();
            }
            super.updateDisplayList();
            return;
        }

        protected function checkSelected() : void
        {
            var btn:GButton = null;
            var index:int = 0;
            while (index < numChildren)
            {
                
				btn = getChildAt(index) as GButton;
                if (this.selectedIndex == index)
                {
					btn.selected = true;
					btn.enabled = false;
                }
                else if (!btn.enabled)
                {
					btn.selected = false;
					btn.enabled = true;
                }
				btn.drawNow();
				index++;
            }
            return;
        }

        override protected function updateSize() : void
        {
            super.updateSize();
            this.width = direction == GBoxDirection.HORIZONTAL ? (numChildren * (this.buttonWidth + horizontalGap)) : (this.buttonWidth);
            this.height = direction == GBoxDirection.HORIZONTAL ? (this.buttonHeight) : (numChildren * (this.buttonHeight + verticalGap));
            return;
        }

        protected function btnClickHandler(event:MouseEvent) : void
        {
            (event.target as GButton).selected = true;
			(event.target as GButton).enabled = false;
            var layerIndex:int = this.getChildIndex(event.target as GButton);
            if (this._selectedIndex != layerIndex && this._selectedIndex >= 0 && this._selectedIndex < numChildren)
            {
                (this.getChildAt(this._selectedIndex) as GButton).selected = false;
				(this.getChildAt(this._selectedIndex) as GButton).enabled = true;
            }
            this._selectedIndex = layerIndex;
            dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE, layerIndex));
            return;
        }

        public function dispose() : void
        {
            while (numChildren > 0)
            {
                
                (getChildAt(0) as GButton).removeEventListener(MouseEvent.CLICK, this.btnClickHandler);
                this.removeChild(getChildAt(0));
            }
            this.allButtons = new Vector.<GButton>;
            return;
        }

    }
}
