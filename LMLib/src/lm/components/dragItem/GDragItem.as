package lm.components.dragItem
{
    
    import fl.core.InvalidationType;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    import lm.mui.controls.GImage;
    import lm.mui.controls.GImageCell;
    import lm.mui.display.ScaleBitmap;
    import lm.mui.manager.DragManager;
    import lm.mui.manager.IDragDrop;
    import lm.mui.manager.ToolTipsManager;

	/**
	 *  必须设置source属性，不设置责不能拖动
	 * @author thinkido
	 * 
	 */
    public class GDragItem extends GImageCell implements IDragDrop
    {
        public var posType:int = 0;
        public var posIndex:int = 0;
		
        protected var amountLabel:TextField;			//数量文本框      
        protected var _amount:int = 0;					//数量
//      protected var freezingEffect:FreezingEffect;   //冻结效果
//      protected var lockedEffect:ScaleBitmap;
        protected var lockedIcon:Bitmap;				
        protected var usedEffect:ScaleBitmap;
        protected var noDurabilityEffect:ScaleBitmap;
        protected var notMeetCareerEffect:ScaleBitmap;
        protected var _source:Object = "";	
        protected var _strengthLabel:TextField;
        protected var imageWidth:Number = -1;
        protected var imageHeight:Number = -1;
        protected var imageUrl:String;
        protected var effectLayer:Sprite;
        public var isShowToolTip:Boolean = true;
        private var _bitmapdata:BitmapData = null;
        private var _defaultBitmapData:BitmapData = null;
        protected var _bitmap:GImage = null;
        private var _isShowLock:Boolean = false;
//        private var _lightMask:LightMask;
        public var dropChecktFunction:Function;            
        protected var _dragAble:Boolean = true;
        protected var _dropAble:Boolean = true;
        protected var _throwAble:Boolean = true;
        protected var _toolTipRenderClass:Class;
        protected var _locked:Boolean = false;
        protected var _used:Boolean = false;
        protected var _meetCareer:Boolean = false;
		protected var _defaultImgUrl:String = "";
        protected var _haveDurability:Boolean = true;
        private var _isBind:Boolean = false;
        protected var _strengthNum:int = 0;
        public static const Event_EffectComplete:String = "冷却动画播放结束";

        public function GDragItem()
        {
            this.createChildren();
            return;
        }

        public function get bitmapdata() : BitmapData
        {
            var scale:Number = NaN;
            if (this._bitmapdata)
            {
                if (this._bitmapdata.width > this.width + 5 || this._bitmapdata.height > this.height + 5)
                {
					scale = this.width / this._bitmapdata.width;
                    this._bitmapdata = new BitmapData(this.width, this.height, true, 0);
                    this._bitmapdata.draw(this._bitmap, new Matrix(scale, 0, 0, scale, 0, 0));
                }
            }
            return this._bitmapdata;
        }

        public function get amount() : int
        {
            return this._amount;
        }

        public function set amount(param1:int) : void
        {
            if (this._amount != param1)
            {
                this._amount = param1;
                if (this._amount <= 1)
                {
                    this.amountLabel.text = "";
                }
                else
                {
                    this.amountLabel.text = this._amount + "";
                }
            }
            return;
        }

        public function setAmountText(param1:int) : void
        {
            if (param1 == -1)
            {
                this.amountLabel.text = "";
            }
            else
            {
                this.amountLabel.text = param1 + "";
            }
            return;
        }

        public function get meetCareer() : Boolean
        {
            return this._meetCareer;
        }

        public function set meetCareer(param1:Boolean) : void
        {
            this._meetCareer = param1;
            this.notMeetCareerEffect.visible = this._meetCareer;
            return;
        }

        public function set haveDurability(param1:Boolean) : void
        {
            this._haveDurability = param1;
            this.noDurabilityEffect.visible = !this._haveDurability;
            return;
        }

        public function get used() : Boolean
        {
            return this._used;
        }

        public function set used(param1:Boolean) : void
        {
            this._used = param1;
            this.usedEffect.visible = this._used;
            return;
        }

        public function get locked() : Boolean
        {
            return this._locked;
        }

        public function set locked(param1:Boolean) : void
        {
            this._locked = param1;
//            this.lockedEffect.visible = param1;
            return;
        }

        public function get dragSource() : Object
        {
			return this.data;
        }

        public function set dragSource(param1:Object) : void
        {
           this.data = param1;
        }

        public function get toolTipRenderClass() : Class
        {
            return this._toolTipRenderClass;
        }

        public function set toolTipRenderClass(param1:Class) : void
        {
            this._toolTipRenderClass = param1;
            return;
        }

        protected function set isBind(param1:Boolean) : void
        {
            this._isBind = param1;
            if (!this._isShowLock)
            {
                return;
            }
            if (this._isBind)
            {
                if (!this.lockedIcon)
                {
//                    this.lockedIcon = GlobalClass.getBitmap("Lock");
//                    addChild(this.lockedIcon);
                }
            }
            if (this.lockedIcon)
            {
                this.lockedIcon.visible = this._isBind;
            }
            return;
        }

        protected function get isBind() : Boolean
        {
            return this._isBind;
        }

        public function get isDropAble() : Boolean
        {
            return this._dropAble;
        }

        public function set isDropAble(param1:Boolean) : void
        {
            this._dropAble = param1;
            return;
        }

        public function get isDragAble() : Boolean
        {
            return this._dragAble;
        }

        public function set isDragAble(param1:Boolean) : void
        {
            this._dragAble = param1;
            if (this._dragAble)
            {
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            }
            else if (this.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            }
            return;
        }

        public function get isThrowAble() : Boolean
        {
            return this._throwAble;
        }

        public function set isThrowAble(param1:Boolean) : void
        {
            this._throwAble = param1;
            return;
        }

        public function canDrop(param1:IDragDrop, param2:IDragDrop) : Boolean
        {
            if (this.dropChecktFunction != null)
            {
                return this.dropChecktFunction(param1, this);
            }
            return this.isDropAble;
        }

        override public function get toolTipData():Object
        {
            if (!this.isShowToolTip)
            {
                return null;
            }
            if (toolTipDataFunction != null)
            {
                return this.toolTipDataFunction(this);
            }
            return super.toolTipData;
        }

        override public function setSize(param1:Number, param2:Number) : void
        {
            super.setSize(param1, param2);
            this.imageWidth = param1;
            this.imageHeight = param2;
            this._width = param1;
            this._height = param2;
            this.resetBitmapSize();
//            if (this.freezingEffect)
//            {
//                this.freezingEffect.x = 18;
//                this.freezingEffect.y = 18;
//                this.freezingEffect.setMaskSize(_width, _height);
//            }
            if (this.amountLabel)
            {
                this.amountLabel.width = param1;
            }
//            if (this.lockedEffect)
//            {
//                this.lockedEffect.width = param1;
//                this.lockedEffect.height = param2;
//            }
            if (this.lockedIcon)
            {
            }
            if (this.usedEffect)
            {
                this.usedEffect.width = param1;
                this.usedEffect.height = param2;
            }
            if (this.noDurabilityEffect)
            {
                this.noDurabilityEffect.width = param1;
                this.noDurabilityEffect.height = param2;
            }
            if (this.notMeetCareerEffect)
            {
                this.notMeetCareerEffect.width = param1;
                this.notMeetCareerEffect.height = param2;
            }
            return;
        }

        override public function get width() : Number
        {
            return this._width;
        }

        override public function get height() : Number
        {
            return this._height;
        }

        override public function set label(param1:String) : void
        {
            if (param1 != null)
            {
                super.label = param1;
            }
            return;
        }

        public function get playingEffect() : Boolean
        {
//            return this.freezingEffect.isPlaying;
			return false;
        }
		
		/***/
		public function getBitmap():GImage
		{
			return _bitmap;
		}

        protected function createChildren() : void
        {
            this.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this._bitmap = new GImage();
            this.addChild(this._bitmap);
            this.resetBitmapSize();
            super.label = "";
            this.label = "";
            this.amountLabel = new TextField();
            this.amountLabel.selectable = false;
            this.amountLabel.mouseEnabled = false;
            this.amountLabel.width = 20;
            this.amountLabel.height = 20;
            this.amountLabel.y = 20;
            addChild(this.amountLabel);
            var _loc_1:TextFormat = new TextFormat();
            _loc_1.align = TextFormatAlign.RIGHT;
            _loc_1.color = 16777215;
            _loc_1.size = 11;
            this.amountLabel.defaultTextFormat = _loc_1;
            this.amountLabel.autoSize = TextFieldAutoSize.NONE;
            this.amountLabel.filters = [new GlowFilter(0, 1, 2, 2, 10)];
            var _loc_2:* = new Sprite();
            _loc_2.graphics.beginFill(16711680, 0);
            _loc_2.graphics.drawRect(0, 0, 10, 10);
            this.setStyle("upSkin", _loc_2);
            this.setStyle("downSkin", _loc_2);
            this.setStyle("overSkin", _loc_2);
            this.setStyle("selectedDownSkin", _loc_2);
            this.setStyle("selectedOverSkin", _loc_2);
            this.setStyle("selectedUpSkin", _loc_2);
//            this.lockedEffect = new ScaleBitmap(BitmapDataConst.LockedBitmapData);
//            this.addChild(this.lockedEffect);
//            this.lockedEffect.visible = this._locked;
//            this.usedEffect = new ScaleBitmap(BitmapDataConst.UsedBmd);
//            this.addChild(this.usedEffect);
//            this.usedEffect.visible = this._used;
//            this.noDurabilityEffect = new ScaleBitmap(BitmapDataConst.NoDurabilityBMD);
//            this.addChild(this.noDurabilityEffect);
//            this.noDurabilityEffect.visible = false;
//            this.notMeetCareerEffect = new ScaleBitmap(BitmapDataConst.NotMeetCareerBMD);
//            this.addChild(this.notMeetCareerEffect);
//            this.notMeetCareerEffect.visible = this._meetCareer;
//            this.freezingEffect = new FreezingEffect();
//            addChild(this.freezingEffect);
            this.effectLayer = new Sprite();
            addChild(this.effectLayer);
            ToolTipsManager.register(this);
            return;
        }

        protected function onMouseDown(event:MouseEvent) : void
        {
//            if (this.itemData && this.isDragAble && !this._locked && !this._used)
			if (this.isDragAble && !this._locked && !this._used)
            {
                DragManager.instance.startDragItem(this, this.bitmapdata);
            }
            return;
        }

        override public function set source(param1:Object) : void
        {
            if (param1 is Bitmap)
            {
                this._bitmapdata = (param1 as Bitmap).bitmapData;
                this._bitmap.bitmapData = this._bitmapdata;
                this.resetBitmapSize();
                this.amountLabel.visible = true;
            }
            else
            {
                if (param1 is BitmapData)
                {
                    this._bitmap.bitmapData = param1 as BitmapData;
                    this.resetBitmapSize();
                    this.amountLabel.visible = true;
                    return;
                }
                if (param1 is String)
                {
                    this.imageUrl = param1 as String;
					invalidate(InvalidationType.ALL);
				}
                else if (this.imageUrl)
                {
                    this.imageUrl = null;
                }
            }
			this.validateNow();
            this._source = param1;
        }

		private function onIoError(event:IOErrorEvent):void
		{
			
		}
		
		override public function get source():Object
		{
			return this._source;
		}

        protected function get strengthLabel() : TextField
        {
            var _loc_1:TextFormat = null;
            if (!this._strengthLabel)
            {
                _loc_1 = new TextFormat();
                _loc_1.align = TextFormatAlign.RIGHT;
                _loc_1.color = 16776960;
                _loc_1.bold = true;
                _loc_1.size = 14;
                _loc_1.font = "华文行楷";
//                this._strengthLabel = ObjCreate.createTextField("", -8, 17, 42, 20, this, _loc_1);
//                this._strengthLabel.selectable = false;
//                this._strengthLabel.mouseEnabled = false;
//                this._strengthLabel.embedFonts = true;
//                this._strengthLabel.autoSize = TextFieldAutoSize.RIGHT;
            }
            return this._strengthLabel;
        }

        protected function set strengthNum(param1:int) : void
        {
            this._strengthNum = param1;
            if (this._strengthNum > 0)
            {
                this.strengthLabel.text = "+" + param1;
                this.strengthLabel.visible = true;
            }
            else
            {
                this.strengthLabel.visible = false;
            }
            return;
        }

        protected function onLoadCompleteHandler(event:Event) : void
        {
            this.resetBitmapSize();
            this.amountLabel.visible = true;
            return;
        }
		
		

        override protected function handleErrorEvent(event:IOErrorEvent) : void
        {
            dispatchEvent(event);
            return;
        }

        public function addEffect(param1:String) : void
        {
            return;
        }

        public function removeEffect() : void
        {
            while (this.effectLayer.numChildren > 0)
            {
                
                this.effectLayer.removeChildAt(0);
            }
            return;
        }

        protected function resetBitmapSize() : void
        {
            if (this._bitmap)
            {
                this._bitmap.width = _width;
                this._bitmap.height = _height;
            }
            return;
        }

        public function get isShowLock() : Boolean
        {
            return this._isShowLock;
        }

        public function set isShowLock(param1:Boolean) : void
        {
            this._isShowLock = param1;
            return;
        }

        public function showLightMask() : void
        {
//            if (!this._lightMask)
//            {
//                this._lightMask = ObjectPool.getObject(LightMask);
//                this._lightMask.transform.matrix = new Matrix();
//            }
//            addChild(this._lightMask);
            return;
        }

        public function hideLightMask() : void
        {
//            if (this._lightMask)
//            {
//                if (contains(this._lightMask))
//                {
//                    removeChild(this._lightMask);
//                }
//                this._lightMask.width = 40;
//                this._lightMask.height = 40;
//                ObjectPool.disposeObject(this._lightMask);
//            }
            return;
        }

        public function setAmountLabelPos(param1:int, param2:int) : void
        {
            this.amountLabel.x = param1;
            this.amountLabel.y = param2;
            return;
        }

        public function setStrengthLabel(param1:int, param2:int) : void
        {
            this.strengthLabel.x = param1;
            this.strengthLabel.y = param2;
            return;
        }

        public function setAmountLabelFormat(param1:TextFormat) : void
        {
            this.amountLabel.defaultTextFormat = param1;
            return;
        }
		
		/***/
		public function get bitmap():GImage
		{
			return _bitmap;
		}
		
		override protected function draw():void
		{
			if (isInvalid(InvalidationType.ALL))
			{
				if (imageUrl == null ||imageUrl == "")
				{
					this._bitmap.bitmapData = this._defaultBitmapData;
					this._bitmap.imgUrl = "";
					_defaultImgUrl = "";
				}else if (imageUrl != _defaultImgUrl)
				{
					_defaultImgUrl = imageUrl;
					this._bitmap.imgUrl = imageUrl;
					this._bitmap.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
					this._bitmap.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
					this._bitmap.drawNow();
				}
			}
			super.draw();
		}

    }
}
