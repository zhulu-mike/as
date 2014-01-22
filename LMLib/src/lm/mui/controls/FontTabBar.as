package lm.mui.controls
{
	
	import flash.events.MouseEvent;
	
	import lm.mui.containers.globalVariable.GBoxDirection;
	import lm.mui.events.MuiEvent;
	
    public class FontTabBar extends GTabBar
    {
        protected var _btnTips:Array;
        protected var _tipsChange:Boolean;
        protected var _disableWidth:int;
        protected var _disableHeight:int;

        public function FontTabBar()
        {
            return;
        }

        public function set disableWidth(param1:int) : void
        {
            this._disableWidth = param1;
            return;
        }

        public function get disableWidth() : int
        {
            return this._disableWidth;
        }

        public function set disableHeight(param1:int) : void
        {
            this._disableHeight = param1;
            return;
        }

        public function get disableHeight() : int
        {
            return this._disableHeight;
        }

        protected function updateBtnSize(param1:FontBtn, param2:Boolean) : void
        {
            var $width:int = 0;
            var $height:int = 0;
            if (param2)
            {
                param1.updateBtnSize(buttonWidth, buttonHeight);
            }
            else
            {
				$width = this.disableWidth == 0 ? (buttonWidth) : (this.disableWidth);
				$height = this.disableHeight == 0 ? (buttonHeight) : (this.disableHeight);
                param1.updateBtnSize($width, $height);
            }
            return;
        }

        private function onBtnMouseOverHandler(event:MouseEvent) : void
        {
            var fontBtn:FontBtn = event.target as FontBtn;
            this.updateBtnSize(fontBtn, false);
			fontBtn.addEventListener(MouseEvent.MOUSE_OUT, this.onBtnMouseOutHandler);
            return;
        }

        private function onBtnMouseOutHandler(event:MouseEvent) : void
        {
			var fontBtn:FontBtn = event.target as FontBtn;
            if (fontBtn.enabled)
            {
                this.updateBtnSize(fontBtn, true);
            }
			fontBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.onBtnMouseOutHandler);
            return;
        }

        override protected function resetPosition() : void
        {
            var index:int = 0;
            var fontBtn:FontBtn = null;
            var tempY:int = 0;
            var num:int = this.numChildren;
            if (this.direction == GBoxDirection.VERTICAL)
            {
				index = 0;
                while (index < num)
                {
                    
					fontBtn = this.getChildAt(index) as FontBtn;
					fontBtn.x = 0;
					fontBtn.y = tempY + verticalGap;
					tempY = fontBtn.y + fontBtn.height;
					index++;
                }
            }
            else if (this.direction == GBoxDirection.HORIZONTAL)
            {
				index = 0;
                while (index < num)
                {
                    
					fontBtn = this.getChildAt(index) as FontBtn;
                    (this.getChildAt(index) as FontBtn).x = fontBtn.x + tempY + horizontalGap;
					fontBtn.y = fontBtn.y;
					tempY = fontBtn.x + buttonWidth - fontBtn.btnx;
					index++;
                }
            }
            return;
        }

        override protected function updateDisplayList() : void
        {
            var obj:Object = null;
            var fontBtn:FontBtn = null;
            var count:int = 0;
            var len:int = 0;
            var fontBtn2:FontBtn = null;
            if (_dataProviderChange)
            {
                dispose();
                for each (obj in dataProvider)
                {
                    
					fontBtn = new FontBtn();
					fontBtn.name = obj.name;
					fontBtn.imgUrl = obj.img;
                    if (buttonWidth != 0)
                    {
						fontBtn.width = buttonWidth;
                    }
                    if (buttonHeight != 0)
                    {
						fontBtn.height = buttonHeight;
                    }
					fontBtn.styleName = buttonStyleName;
                    allButtons.push(fontBtn);
					fontBtn.addEventListener(MouseEvent.CLICK, this.btnClickHandler, false, 0, true);
					fontBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onBtnMouseOverHandler);
                    if (_buttonFilters)
                    {
						fontBtn.textField.filters = _buttonFilters;
                    }
                    this.addChild(fontBtn);
                }
                this.checkSelected();
                _dataProviderChange = false;
            }
            if (_selectedChange)
            {
                _selectedChange = false;
                this.checkSelected();
            }
            super.updateDisplayList();
            if (this._tipsChange && this._btnTips != null && this._btnTips.length != 0)
            {
                this._tipsChange = false;
                len = allButtons.length;
                while (count < len)
                {
                    
					fontBtn2 = getButtonAt(count) as FontBtn;
//					fontBtn2.toolTipData = HTMLUtil.addColor(this._btnTips[count], "#00ff00");
					count++;
                }
            }
            return;
        }

        override protected function checkSelected() : void
        {
            var fontBtn:FontBtn = null;
            var index:int = 0;
            while (index < numChildren)
            {
                
				fontBtn = getChildAt(index) as FontBtn;
                if (selectedIndex == index)
                {
					fontBtn.enabled = false;
                }
                else if (!fontBtn.enabled)
                {
					fontBtn.enabled = true;
                }
                this.updateBtnSize(fontBtn, fontBtn.enabled);
				fontBtn.drawNow();
				index++;
            }
            return;
        }

        override protected function btnClickHandler(event:MouseEvent) : void
        {
            var fontBtn:FontBtn = event.target as FontBtn;
			fontBtn.enabled = false;
            this.updateBtnSize(fontBtn, fontBtn.enabled);
            var layerIndex:int = this.getChildIndex(fontBtn);
			
			var tempFontBtn:FontBtn;
            if (_selectedIndex != layerIndex && _selectedIndex >= 0 && _selectedIndex < numChildren)
            {
				tempFontBtn = this.getChildAt(_selectedIndex) as FontBtn;
				tempFontBtn.enabled = true;
                this.updateBtnSize(tempFontBtn, tempFontBtn.enabled);
            }
            _selectedIndex = layerIndex;
            dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE, layerIndex));
            return;
        }

        override public function set toolTipData(param1:Object) : void
        {
            if (param1 != null && param1 is Array)
            {
                this._btnTips = param1 as Array;
                this._tipsChange = true;
            }
            else
            {
                super.toolTipData = param1;
            }
            return;
        }

    }
}
