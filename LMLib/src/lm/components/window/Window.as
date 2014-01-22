package lm.components.window
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import lm.mui.controls.GButton;
	import lm.mui.controls.GUIComponent;
	import lm.mui.display.ScaleBitmap;
	import lm.mui.interfaces.ILayer;
	import lm.mui.interfaces.IView;
	import lm.mui.manager.IDragDrop;
	
    

    public class Window extends GUIComponent implements IView, IDragDrop, ILayer
    {
        protected var _title:DisplayObject;
        protected var _windowBg:ScaleBitmap;
        protected var _helpBtn:GButton;
        protected var _closeBtn:GButton;
        protected var _titleSprite:Sprite;
        protected var _isAddHelpButton:Boolean = false;
        protected var _isAddClolseButton:Boolean = true;
        protected var _isCenter:Boolean = false;
        protected var _isFirstCenter:Boolean = true;
        protected var contentSprite:Sprite;
        protected var _titleSpriteHight:Number = 30;
        protected var _isFirstShow:Boolean = true;
        protected var _popupSprite:Sprite;
        private var _stagerect:Rectangle;
        private var _bgBitmap:Bitmap;
        protected var _titleHeight:Number = 48;
        protected var _titleChange:Boolean = false;
        private var _titleLabel:TextField;
        protected var _layer:ILayer;
        private var _isHide:Boolean = true;
		private var _stage:Stage;

        public function Window(param1:ILayer = null)
        {
            this._stagerect = new Rectangle();
            if (param1 == null)
            {
//                this.layer = LayerManager.windowLayer;
            }
            else
            {
                this.layer = param1;
            }
            this.addEventListener(MouseEvent.MOUSE_DOWN, this.onWindowDownHandler);
            return;
        }

        public function get closeBtn() : GButton
        {
            return this._closeBtn;
        }

        private function onWindowDownHandler(event:MouseEvent) : void
        {
           /* if (this.layer is WindowLayer)
            {
                PopupManager.setTop(this);
            }
            else
            {
                this.layer.setTop(this);
            }*/
        }

        override protected function createChildren() : void
        {
            super.createChildren();
            this._titleSprite = new Sprite();
            this._titleSprite.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDownHandler);
            this.$addChild(this._titleSprite);
            this.contentSprite = new Sprite();
            this.contentSprite.mouseEnabled = false;
            this.$addChild(this.contentSprite);
            if (this._isAddClolseButton)
            {
                this._closeBtn = new GButton();
                this._closeBtn.focusEnabled = true;
                this._closeBtn.setSize(19, 19);
                this._closeBtn.label = "";
                this._closeBtn.styleName = "CloseButton";
                this._closeBtn.addEventListener(MouseEvent.CLICK, this.closeBtnClickHandler);
                this.$addChild(this._closeBtn);
            }
            if (this._isAddHelpButton)
            {
                this._helpBtn = new GButton();
                this._helpBtn.setSize(20, 19);
                this._helpBtn.label = "";
                this._helpBtn.styleName = "HelpButton";
                this._helpBtn.addEventListener(MouseEvent.CLICK, this.onHelpBtnClickHandler);
                this.$addChild(this._helpBtn);
            }
            this.addTopChild();
            this._popupSprite = new Sprite();
            this.$addChild(this._popupSprite);
            return;
        }

        protected function addTopChild() : void
        {
            return;
        }

        override public function addChild(param1:DisplayObject) : DisplayObject
        {
            return this.contentSprite.addChild(param1);
        }

        override public function removeChild(param1:DisplayObject) : DisplayObject
        {
            return this.contentSprite.removeChild(param1);
        }

        override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
        {
            return this.contentSprite.addChildAt(param1, param2);
        }

        override public function removeChildAt(param1:int) : DisplayObject
        {
            return this.contentSprite.removeChildAt(param1);
        }

        override public function contains(param1:DisplayObject) : Boolean
        {
            return this.contentSprite.contains(param1);
        }

        protected function $addChild(param1:DisplayObject) : DisplayObject
        {
            return super.addChild(param1);
        }

        protected function $removeChild(param1:DisplayObject) : DisplayObject
        {
            return super.removeChild(param1);
        }

        protected function $addChildAt(param1:DisplayObject, param2:int) : DisplayObject
        {
            return super.addChildAt(param1, param2);
        }

        protected function $removeChildAt(param1:int) : DisplayObject
        {
            return super.removeChildAt(param1);
        }

        protected function onMouseDownHandler(event:MouseEvent) : void
        {
			
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUpHandler);
           /* if (this._layer is WindowLayer)
            {
                this._stagerect.x = 0;
                this._stagerect.y = 0;
                this._stagerect.width = this.stage.stageWidth;
                this._stagerect.height = this.stage.stageHeight - this._titleHeight;
                this.startDrag(false, this._stagerect);
            }*/
//            else
            {
                this.startDrag(false);
            }
            return;
        }

        private function onMouseUpHandler(event:MouseEvent) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUpHandler);
            this.stopDrag();
            return;
        }

        private function setTitleSprite(param1:Number, param2:Number) : void
        {
            if (this._bgBitmap == null)
            {
                this._bgBitmap = new Bitmap(new BitmapData(10, 10, true, 0));
                this._titleSprite.addChildAt(this._bgBitmap, 0);
            }
            this._bgBitmap.width = param1;
            this._bgBitmap.height = param2;
            return;
        }

        protected function closeBtnClickHandler(event:MouseEvent) : void
        {
            stage.focus = stage;
//            SoundManager.instance.soundPlay(SoundTypeConst.UIclose);
            this.hide();
            return;
        }

        protected function onHelpBtnClickHandler(event:MouseEvent) : void
        {
            return;
        }

        public function set titleHeight(param1:Number) : void
        {
            this._titleHeight = param1;
            return;
        }

        public function get titleHeight() : Number
        {
            return this._titleHeight;
        }

        public function get title():Object
        {
            return this._title;
        }

        public function set title(param1:Object) : void
        {
            if (this._title && this._title.parent)
            {
                this._title.parent.removeChild(this._title);
                this._title = null;
            }
            if (param1 is DisplayObject)
            {
                this._title = param1 as DisplayObject;
                this._titleSprite.addChild(this._title);
            }
            else if (param1 is String)
            {
                this._titleLabel = new TextField();
                this._titleLabel.mouseEnabled = false;
                this._titleLabel.embedFonts = true;
//                this._titleLabel.defaultTextFormat = GlobalStyle.windowTitle;
                this._titleLabel.selectable = false;
                this._titleLabel.filters = [new GlowFilter(480077, 1, 2, 2, 10), new DropShadowFilter(0, 120, 3086, 0.75, 5, 5)];
                this._titleLabel.autoSize = TextFieldAutoSize.LEFT;
                this._titleLabel.htmlText = param1 as String;
                this._title = this._titleLabel;
                this._titleSprite.addChild(this._titleLabel);
//                ResManager.instance.registerTitle(this.resetTitle);
            }
            this._titleChange = true;
            this.updateDisplayList();
            return;
        }

        private function resetTitle() : void
        {
            if (this._titleLabel)
            {
//                this._titleLabel.setTextFormat(GlobalStyle.windowTitle);
                this._titleLabel.autoSize = TextFieldAutoSize.CENTER;
                this._titleLabel.htmlText = this._titleLabel.htmlText;
            }
            return;
        }

        override protected function updateSize() : void
        {
            super.updateSize();
            this.updateBtnSize();
            this.setTitleSprite(this.width, this._titleSpriteHight);
            return;
        }

        protected function updateBtnSize() : void
        {
            if (this._closeBtn)
            {
                this._closeBtn.x = this.width - this._closeBtn.width - 8;
                this._closeBtn.y = 7;
            }
            if (this._helpBtn)
            {
                this._helpBtn.x = this._closeBtn.x - 26;
                this._helpBtn.y = this._closeBtn.y;
            }
            return;
        }

        override protected function updateDisplayList() : void
        {
            super.updateDisplayList();
            if (this._titleChange)
            {
                this._titleChange = false;
                if (this._title)
                {
                    this._title.y = 4;
                    this._title.x = (this.width - this._title.width) / 2;
                }
            }
            return;
        }

        public function dispose() : void
        {
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.closeBtnClickHandler);
            this._closeBtn = null;
            return;
        }

        public function set layer(param1:ILayer) : void
        {
            this._layer = param1;
            return;
        }

        public function get layer() : ILayer
        {
            return this._layer;
        }

        public function get isHide() : Boolean
        {
            return this._isHide;
        }

        public function update(param1:Object, ... args) : void
        {
            return;
        }

        public function hide() : void
        {
            var _loc_1:DisplayObject = null;
            if (this._layer && !this._isHide)
            {
                this.stopDrag();
                stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUpHandler);
                this._isHide = true;
                this._layer.removePopup(this);
                this.dispatchEvent(new WindowEvent(WindowEvent.CLOSE));
                while (this._popupSprite.numChildren > 0)
                {
                    
                    _loc_1 = this._popupSprite.getChildAt(0);
                    if (_loc_1 is IView)
                    {
                        (_loc_1 as IView).hide();
                        continue;
                    }
                    this.removeChild(_loc_1);
                }
            }
            return;
        }

        public function show(param1:int = 0, param2:int = 0) : void
        {
            if (this._layer)
            {
                if (this._isHide)
                {
                    this._isHide = false;
                    this._layer.addPopUp(this);
                    if (this._isFirstCenter)
                    {
                        this._layer.centerPopup(this);
                        this._isFirstCenter = this._isCenter;
                    }
                    this.dispatchEvent(new WindowEvent(WindowEvent.SHOW));
                }
                else
                {
                    this._layer.setTop(this);
                }
                if (param1 != 0 && param2 != 0)
                {
                    this._layer.setPosition(this, param1, param2);
                }
            }
            return;
        }

        public function leftToChat() : void
        {
           /* if (this.layer is WindowLayer)
            {
                (this.layer as WindowLayer).leftToChat(this);
            }*/
            return;
        }

        public function rightToTask() : void
        {
           /* if (this.layer is WindowLayer)
            {
                (this.layer as WindowLayer).rightToTask(this);
            }*/
            return;
        }

        public function get isDragAble() : Boolean
        {
            return false;
        }

        public function get isDropAble() : Boolean
        {
            return true;
        }

        public function get isThrowAble() : Boolean
        {
            return false;
        }

        public function get dragSource() : Object
        {
            return {};
        }

        public function set dragSource(param1:Object) : void
        {
            return;
        }

        public function canDrop(param1:IDragDrop, param2:IDragDrop) : Boolean
        {
            return true;
        }

        public function get isAddHelpButton() : Boolean
        {
            return this._isAddHelpButton;
        }

        public function set isAddHelpButton(param1:Boolean) : void
        {
            this._isAddHelpButton = param1;
            return;
        }

        public function addPopUp(param1:DisplayObject, param2:Boolean = false) : void
        {
            if (param1 && this._popupSprite.contains(param1) == false)
            {
                this._popupSprite.addChild(param1);
            }
            return;
        }

        public function centerPopup(param1:DisplayObject) : void
        {
           /* if (this is WindowLayer)
            {
                param1.x = (Global.stage.stageWidth - param1.width) / 2;
                param1.y = (Global.stage.stageHeight - param1.height) / 2;
            }
            else*/
            {
                param1.x = (this.width - param1.width) / 2;
                param1.y = (this.height - param1.height) / 2;
            }
            return;
        }

        public function setPosition(param1:DisplayObject, param2:int, param3:int) : void
        {
            param1.x = param2;
            param1.y = param3;
            return;
        }

        public function isTop(param1:DisplayObject) : Boolean
        {
            if (this._popupSprite.contains(param1))
            {
                return this._popupSprite.getChildIndex(param1) == (this._popupSprite.numChildren - 1);
            }
            return false;
        }

        public function removePopup(param1:DisplayObject) : void
        {
            if (this._popupSprite.contains(param1))
            {
                this._popupSprite.removeChild(param1);
            }
            return;
        }

        public function isPopup(param1:DisplayObject) : Boolean
        {
            return this._popupSprite.contains(param1);
        }

        public function setTop(param1:DisplayObject) : void
        {
            if (this._popupSprite.contains(param1))
            {
                if (this._popupSprite.getChildIndex(param1) != (this._popupSprite.numChildren - 1))
                {
                    this._popupSprite.setChildIndex(param1, (this._popupSprite.numChildren - 1));
                }
            }
            return;
        }

        public function resize(param1:Number, param2:Number) : void
        {
            var displayObject:DisplayObject = null;
            var count:int = 0;
            while (count < numChildren)
            {
                
				displayObject = this.getChildAt(count);
                if (displayObject is IView)
                {
					displayObject.x = displayObject.x * param1;
					displayObject.y = displayObject.y * param2;
                }
				count++;
            }
            return;
        }

    }
}
