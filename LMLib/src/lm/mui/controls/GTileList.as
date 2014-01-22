package lm.mui.controls
{
    import fl.controls.ScrollBar;
    import fl.controls.ScrollBarDirection;
    import fl.controls.ScrollPolicy;
    import fl.controls.TileList;
    import fl.controls.listClasses.ICellRenderer;
    import fl.controls.listClasses.ListData;
    import fl.controls.listClasses.TileListData;
    import fl.core.InvalidationType;
    import fl.core.UIComponent;
    import fl.data.DataProvider;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    
    import lm.mui.events.MuiEvent;
    import lm.mui.skins.SkinManager;
	
    public class GTileList extends TileList
    {
        private var _verticalGap:Number = 0;
        private var _horizontalGap:Number = 0;
        private var _styleName:String;
        private var _isStyleChange:Boolean = false;
        private var _isDraw:Boolean = false;

        public function GTileList()
        {
            return;
        }

        public function set horizontalGap(param1:Number) : void
        {
            this._horizontalGap = param1;
            return;
        }

        public function get horizontalGap() : Number
        {
            return this._horizontalGap;
        }

        public function set verticalGap(param1:Number) : void
        {
            this._verticalGap = param1;
            return;
        }

        public function get verticalGap() : Number
        {
            return this._verticalGap;
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
		
		override public function get rowCount():uint {
			var pad:Number = Number(getStyleValue("contentPadding"));
			var cols:uint = Math.max(1,(_width-2*pad+horizontalGap)/(_columnWidth+horizontalGap)<<0);
			var rows:uint = Math.max(1,(_height-2*pad+verticalGap)/(_rowHeight+verticalGap)<<0);
			if (_scrollDirection == ScrollBarDirection.HORIZONTAL) {
				if (_scrollPolicy == ScrollPolicy.ON || (_scrollPolicy == ScrollPolicy.AUTO && length > cols*rows)) {
					// account for horizontal scrollbar:
					rows = Math.max(1,(_height-2*pad-15+verticalGap)/(_rowHeight+verticalGap)<<0);
				}
				// else use the default rows value from above.
			} else {
				// we might have a partial row visible:
				rows = Math.max(1,(_height-2*pad+verticalGap)/(_rowHeight+verticalGap)<<0);
			}
			return rows;
		}
		
		override public function set rowCount(value:uint):void {
			if (value == 0) { return; }
			if (componentInspectorSetting) { 
				__rowCount = value; 
				return;
			}
			__rowCount = 0;
			
			var pad:Number = Number(getStyleValue("contentPadding"));
			var showScroll:Boolean = (Math.ceil(length/value) > ((width+horizontalGap)/(columnWidth+horizontalGap))>>0 && _scrollPolicy == ScrollPolicy.AUTO) || _scrollPolicy == ScrollPolicy.ON;
			height = (value-1)*verticalGap + rowHeight * value + 2*pad + ((_scrollDirection == ScrollBarDirection.HORIZONTAL && showScroll) ? ScrollBar.WIDTH : 0);
		}
		
		override public function get columnCount():uint {
			var pad:Number = Number(getStyleValue("contentPadding"));
			var cols:uint = Math.max(1,(_width-2*pad+horizontalGap)/(_columnWidth+horizontalGap)<<0);
			var rows:uint = Math.max(1,(_height-2*pad+verticalGap)/(_rowHeight+verticalGap)<<0);
			if (_scrollDirection != ScrollBarDirection.HORIZONTAL) {
				if (_scrollPolicy == ScrollPolicy.ON || (_scrollPolicy == ScrollPolicy.AUTO && length > cols*rows)) {
					// account for vertical scrollbar:
					cols = Math.max(1,(_width-2*pad-15+horizontalGap)/(_columnWidth+horizontalGap)<<0);
				}
				// else we just use the default cols value from above.
			} else {
				// we might have a partial column visible:
				cols = Math.max(1,(_width-2*pad+horizontalGap)/(_columnWidth+horizontalGap)<<0);
			}
			return cols;
		}

		override public function set columnCount(value:uint):void {
			if (value == 0) { return; }
			if (componentInspectorSetting) { 
				__columnCount = value; 
				return;
			}
			__columnCount = 0;
			
			var pad:Number = Number(getStyleValue("contentPadding"));
			var showScroll:Boolean = (Math.ceil(length/value) > ((height+verticalGap)/(rowHeight+verticalGap))>>0 && _scrollPolicy == ScrollPolicy.AUTO) || _scrollPolicy == ScrollPolicy.ON;
			width = (value-1)*horizontalGap + columnWidth*value+2*pad+(_scrollDirection == ScrollBarDirection.VERTICAL && showScroll ? 15 : 0);
		}
		
		override protected function drawLayout():void {
			// figure out our scrolling situation:
			_horizontalScrollPolicy = (_scrollDirection == ScrollBarDirection.HORIZONTAL) ? _scrollPolicy : ScrollPolicy.OFF;
			_verticalScrollPolicy = (_scrollDirection != ScrollBarDirection.HORIZONTAL) ? _scrollPolicy : ScrollPolicy.OFF;
			if (_scrollDirection == ScrollBarDirection.HORIZONTAL) {
				var rows:uint = rowCount;
				contentHeight = rows*_rowHeight + (rows-1)*verticalGap;
				contentWidth = (_columnWidth+horizontalGap)*Math.ceil(length/rows)-horizontalGap;
			} else {
				var cols:uint = columnCount;
				contentWidth = cols*(_columnWidth+horizontalGap)-horizontalGap;
				contentHeight = (verticalGap+_rowHeight)*Math.ceil(length/cols)-verticalGap;//这个值决定了滚动条的滚动范围
			}
			
			// hand off drawing the layout to BaseScrollPane:
			calculateAvailableSize();
			calculateContentWidth();
			
			background.width = width;
			background.height = height;
			
			if (vScrollBar) {
				_verticalScrollBar.visible = true;
				_verticalScrollBar.x = width - ScrollBar.WIDTH - contentPadding;
				_verticalScrollBar.y = contentPadding;
				_verticalScrollBar.height = availableHeight;
			} else {
				_verticalScrollBar.visible = false;
			}
			
			_verticalScrollBar.setScrollProperties(availableHeight, 0, contentHeight - availableHeight, verticalPageScrollSize);
			setVerticalScrollPosition(_verticalScrollBar.scrollPosition, false);
			
			if (hScrollBar) {
				_horizontalScrollBar.visible = true;
				_horizontalScrollBar.x = contentPadding;
				_horizontalScrollBar.y = height - ScrollBar.WIDTH - contentPadding;
				_horizontalScrollBar.width = availableWidth;
			} else {
				_horizontalScrollBar.visible = false;
			}
			
			_horizontalScrollBar.setScrollProperties(availableWidth, 0, (useFixedHorizontalScrolling) ? _maxHorizontalScrollPosition : contentWidth - availableWidth, horizontalPageScrollSize);
			setHorizontalScrollPosition(_horizontalScrollBar.scrollPosition, false);
			
			drawDisabledOverlay();
			
			contentScrollRect = listHolder.scrollRect;
			contentScrollRect.width = availableWidth;
			contentScrollRect.height = availableHeight;
			listHolder.scrollRect = contentScrollRect;
//			super.drawLayout();
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
            }
            this._isDraw = true;
            super.draw();
			dispatchEvent(new MuiEvent(MuiEvent.UPDATE_COMPLETE));
            this._isDraw = false;
            return;
        }

       override protected function drawList() : void
        {
            var _loc_1:uint = 0;
            var _loc_2:uint = 0;
            var _loc_3:Object = null;
            var _loc_4:ICellRenderer = null;
            var _loc_7:Number = NaN;
            var _loc_11:uint = 0;
            var _loc_12:uint = 0;
            var _loc_15:Dictionary = null;
            var _loc_16:uint = 0;
            var _loc_17:uint = 0;
            var _loc_18:uint = 0;
            var _loc_19:uint = 0;
            var _loc_20:Boolean = false;
            var _loc_21:String = null;
            var _loc_22:Object = null;
            var _loc_23:Object = null;
            var _loc_24:Sprite = null;
            var _loc_25:String = null;
            var _loc_26:UIComponent = null;
            var _loc_5:* = rowCount;
            var _loc_6:* = columnCount;
            _loc_7 = columnWidth;
            var _loc_8:* = rowHeight;
            var _loc_9:Number = 0;
            var _loc_10:Number = 0;
            listHolder.x = contentPadding;
            listHolder.y = contentPadding;
//            contentScrollRect = new Rectangle(listHolder.scrollRect.x, listHolder.scrollRect.y, _loc_6*columnWidth+(_loc_6-1)*horizontalGap, _loc_5*rowHeight+(_loc_5-1)*verticalGap) ;
           	contentScrollRect = listHolder.scrollRect;
			contentScrollRect.x = Math.floor(_horizontalScrollPosition) % _loc_7;
            contentScrollRect.y = Math.floor(_verticalScrollPosition) % _loc_8;
            listHolder.scrollRect = contentScrollRect;
            listHolder.cacheAsBitmap = useBitmapScrolling;
            var _loc_13:Array = [];
            if (_scrollDirection == ScrollBarDirection.HORIZONTAL)
            {
                _loc_16 = availableWidth / _loc_7 << 0;
                _loc_17 = Math.max(_loc_16, Math.ceil(length / _loc_5));
                _loc_9 = _horizontalScrollPosition / _loc_7 << 0;
                _loc_6 = Math.max(_loc_16, Math.min(_loc_17 - _loc_9, (_loc_6 + 1)));
                _loc_12 = 0;
                while (_loc_12 < _loc_5)
                {
                    
                    _loc_11 = 0;
                    while (_loc_11 < _loc_6)
                    {
                        
                        _loc_2 = _loc_12 * _loc_17 + _loc_9 + _loc_11;
                        if (_loc_2 >= length)
                        {
                            break;
                        }
                        _loc_13.push(_loc_2);
                        _loc_11 = _loc_11 + 1;
                    }
                    _loc_12 = _loc_12 + 1;
                }
            }
            else
            {
                _loc_5 = _loc_5 + 1;
                _loc_10 = _verticalScrollPosition / _loc_8 << 0;
                _loc_18 = Math.floor(_loc_10 * _loc_6);
                _loc_19 = Math.min(length, _loc_18 + _loc_5 * _loc_6);
                _loc_1 = _loc_18;
                while (_loc_1 < _loc_19)
                {
                    
                    _loc_13.push(_loc_1);
                    _loc_1 = _loc_1 + 1;
                }
            }
            renderedItems = new Dictionary(true);
            var _loc_14:Dictionary = new Dictionary(true);
            for each (_loc_2 in _loc_13)
            {
                
                _loc_14[_dataProvider.getItemAt(_loc_2)] = true;
            }
            _loc_15 = new Dictionary(true);
            while (activeCellRenderers.length > 0)
            {
                
                _loc_4 = activeCellRenderers.pop();
                _loc_3 = _loc_4.data;
                if (_loc_14[_loc_3] == null || invalidItems[_loc_3] == true)
                {
                    availableCellRenderers.push(_loc_4);
                }
                else
                {
                    _loc_15[_loc_3] = _loc_4;
                    invalidItems[_loc_3] = true;
                }
                list.removeChild(_loc_4 as DisplayObject);
            }
            invalidItems = new Dictionary(true);
            _loc_1 = 0;
            for each (_loc_2 in _loc_13)
            {
                
                _loc_11 = _loc_1 % _loc_6;
                _loc_12 = _loc_1 / _loc_6 << 0;
                _loc_20 = false;
                _loc_3 = _dataProvider.getItemAt(_loc_2);
                if (_loc_15[_loc_3] != null)
                {
                    _loc_20 = true;
                    _loc_4 = _loc_15[_loc_3];
                    delete _loc_15[_loc_3];
                }
                else if (availableCellRenderers.length > 0)
                {
                    _loc_4 = availableCellRenderers.pop() as ICellRenderer;
                }
                else
                {
                    _loc_4 = getDisplayObjectInstance(getStyleValue("cellRenderer")) as ICellRenderer;
                    _loc_24 = _loc_4 as Sprite;
                    if (_loc_24 != null)
                    {
                        _loc_24.addEventListener(MouseEvent.CLICK, handleCellRendererClick, false, 0, true);
                        _loc_24.addEventListener(MouseEvent.ROLL_OVER, handleCellRendererMouseEvent, false, 0, true);
                        _loc_24.addEventListener(MouseEvent.ROLL_OUT, handleCellRendererMouseEvent, false, 0, true);
                        _loc_24.addEventListener(Event.CHANGE, handleCellRendererChange, false, 0, true);
                        _loc_24.doubleClickEnabled = true;
                        _loc_24.addEventListener(MouseEvent.DOUBLE_CLICK, handleCellRendererDoubleClick, false, 0, true);
                        if (_loc_24.hasOwnProperty("setStyle"))
                        {
                            for (_loc_25 in rendererStyles)
                            {
                                
                                var _loc_31:* = _loc_24;
                                _loc_31._loc_24["setStyle"](_loc_25, rendererStyles[_loc_25]);
                            }
                        }
                    }
                }
                list.addChild(_loc_4 as Sprite);
                activeCellRenderers.push(_loc_4);
                _loc_4.y = _loc_8 * _loc_12 + this.verticalGap * _loc_12;
                _loc_4.x = _loc_7 * _loc_11 + this.horizontalGap * _loc_11;
                _loc_4.setSize(columnWidth, rowHeight);
                _loc_21 = this.itemToLabel(_loc_3);
                _loc_22 = null;
                if (_iconFunction != null)
                {
                    _loc_22 = _iconFunction(_loc_3);
                }
                else if (_iconField != null && _loc_3 && _loc_3.hasOwnProperty(_iconField))
                {
                    _loc_22 = _loc_3[_iconField];
                }
                _loc_23 = null;
                if (_sourceFunction != null)
                {
                    _loc_23 = _sourceFunction(_loc_3);
                }
                else if (_sourceField != null && _loc_3 && _loc_3.hasOwnProperty(_sourceField))
                {
                    _loc_23 = _loc_3[_sourceField];
                }
                if (!_loc_20)
                {
                    _loc_4.data = _loc_3;
                }
                _loc_4.listData = new TileListData(_loc_21, _loc_22, _loc_23, this, _loc_2, _loc_10 + _loc_12, _loc_9 + _loc_11) as ListData;
                _loc_4.selected = _selectedIndices.indexOf(_loc_2) != -1;
                if (_loc_4 is UIComponent)
                {
                    _loc_26 = _loc_4 as UIComponent;
                    _loc_26.drawNow();
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }

        override public function set dataProvider(param1:DataProvider) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            if (super.dataProvider)
            {
                _loc_2 = Math.max(super.dataProvider.length, param1.length);
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    if (_loc_3 > (super.dataProvider.length - 1) && _loc_3 <= (param1.length - 1))
                    {
                        super.dataProvider.addItemAt(param1.getItemAt(_loc_3), _loc_3);
                    }
                    else if (_loc_3 > (param1.length - 1))
                    {
                        super.dataProvider.removeItemAt(param1.length);
                    }
                    else
                    {
                        _loc_4 = this.dataProvider.getItemAt(_loc_3);
                        _loc_5 = param1.getItemAt(_loc_3);
                        super.dataProvider.replaceItemAt(_loc_5, _loc_3);
                        invalidateItemAt(_loc_3);
                    }
                    _loc_3++;
                }
            }
            else
            {
                super.dataProvider = param1;
            }
            return;
        }

        override public function itemToLabel(param1:Object) : String
        {
            if (_labelFunction != null)
            {
                return String(_labelFunction(param1));
            }
            if (_labelField == null || param1 == null || param1.hasOwnProperty(_labelField) == false)
            {
                return "";
            }
            return String(param1[_labelField]);
        }
		
		/**
		 * @copy fl.controls.SelectableList#scrollToIndex()
		 *
		 * @includeExample examples/TileList.scrollToIndex.1.as -noswf
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		override public function scrollToIndex(newCaretIndex:int):void {
			drawNow(); // Force validation.
			
			var totalCols:uint = Math.max(1, (contentWidth/_columnWidth<<0));
			if (_scrollDirection == ScrollBarDirection.VERTICAL) {
				if (rowHeight > availableHeight) {
					return; // nothing: don't scroll if the item is bigger than the viewable area)
				}
				var itemY:Number = (newCaretIndex/totalCols>>0) * (rowHeight+verticalGap);
				if (itemY < verticalScrollPosition) {
					verticalScrollPosition = itemY;
				} else if (itemY > verticalScrollPosition + availableHeight - (rowHeight+verticalGap)) {
					verticalScrollPosition = itemY + (rowHeight+verticalGap) - availableHeight;
				}
			} else {
				if (columnWidth > availableWidth) {
					return;
				}
				var itemX:Number = newCaretIndex % totalCols * (columnWidth+horizontalGap);
				if (itemX < horizontalScrollPosition) {
					horizontalScrollPosition = itemX;	
				} else if (itemX > horizontalScrollPosition + availableWidth - (columnWidth+horizontalGap)) {
					horizontalScrollPosition = itemX + (columnWidth+horizontalGap) - availableWidth;
				}
			}
		}

        override protected function _invalidateList() : void
        {
            if (this._isDraw)
            {
                super._invalidateList();
            }
            else
            {
                var index:int = 0;
                while (index < _dataProvider.length)
                {
                    
                    invalidateItem(_dataProvider.getItemAt(index));
					index++;
                }
                invalidate(InvalidationType.DATA);
            }
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

		public function getReallyList():Sprite
		{
			return list;
		}
		
    }
}
