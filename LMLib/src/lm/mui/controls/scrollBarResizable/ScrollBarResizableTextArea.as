package lm.mui.controls.scrollBarResizable
{
	import fl.controls.ScrollBarDirection;
	import fl.controls.TextArea;
	import fl.events.ScrollEvent;
	import fl.managers.IFocusManager;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;

    public class ScrollBarResizableTextArea extends TextArea
    {
       private static const SCROLL_BAR_STYLES:Object = {downArrowDisabledSkin:"downArrowDisabledSkin", downArrowDownSkin:"downArrowUpSkin", downArrowOverSkin:"downArrowOverSkin", downArrowUpSkin:"downArrowUpSkin", upArrowDisabledSkin:"upArrowDisabledSkin", upArrowDownSkin:"upArrowDownSkin", upArrowOverSkin:"upArrowOverSkin", upArrowUpSkin:"upArrowUpSkin", thumbDisabledSkin:"thumbDisabledSkin", thumbDownSkin:"thumbUpSkin", thumbOverSkin:"thumbOverSkin", thumbUpSkin:"thumbUpSkin", thumbIcon:"thumbIcon", trackDisabledSkin:"trackDisabledSkin", trackDownSkin:"trackDownSkin", trackOverSkin:"trackOverSkin", trackUpSkin:"trackUpSkin", repeatDelay:"repeatDelay", repeatInterval:"repeatInterval"};

        public function ScrollBarResizableTextArea()
        {
            return;
        }

        override protected function configUI() : void
        {
            isLivePreview = checkLivePreview();
            var $width:Number = super.width;
            var $height:Number = super.height;
            super.scaleY = 1;
            super.scaleX = 1;
            setSize($width, $height);
            move(super.x, super.y);
            startWidth = $width;
            startHeight = $height;
            if (numChildren > 0)
            {
                removeChildAt(0);
            }
            tabChildren = true;
            textField = new TextField();
            addChild(textField);
            updateTextFieldType();
            _verticalScrollBar = new ResizableUIScrollBar();
            _verticalScrollBar.name = "V";
            _verticalScrollBar.visible = false;
            _verticalScrollBar.focusEnabled = false;
            copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
            _verticalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_verticalScrollBar);
            _horizontalScrollBar = new ResizableUIScrollBar();
            _horizontalScrollBar.name = "H";
            _horizontalScrollBar.visible = false;
            _horizontalScrollBar.focusEnabled = false;
            _horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
            copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
            _horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll, false, 0, true);
            addChild(_horizontalScrollBar);
            textField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
            textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
            textField.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
            _horizontalScrollBar.scrollTarget = textField;
            _verticalScrollBar.scrollTarget = textField;
            addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);
            return;
        }

        public function setScrollBarSize(param1:Number) : void
        {
            horizontalScrollBar.setSize(param1, height);
            verticalScrollBar.setSize(param1, height);
            draw();
            return;
        }

        override protected function drawLayout() : void
        {
            super.drawLayout();
            return;
        }

        override protected function focusOutHandler(event:FocusEvent) : void
        {
            var focusManager:IFocusManager = focusManager;
            if (focusManager)
            {
				focusManager.defaultButtonEnabled = true;
            }
            super.focusOutHandler(event);
            if (editable)
            {
                setIMEMode(false);
            }
            return;
        }

    }
}
