// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display
{
    import flash.geom.Rectangle;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    /** Dispatched when the user triggers the button. Bubbles. */
    [Event(name="triggered", type="starling.events.Event")]
    
    /** A simple button composed of an image and, optionally, text.
     *  
     *  <p>You can pass a texture for up- and downstate of the button. If you do not provide a down 
     *  state, the button is simply scaled a little when it is touched.
     *  In addition, you can overlay a text on the button. To customize the text, almost the 
     *  same options as those of text fields are provided. In addition, you can move the text to a 
     *  certain position with the help of the <code>textBounds</code> property.</p>
     *  
     *  <p>To react on touches on a button, there is special <code>triggered</code>-event type. Use
     *  this event instead of normal touch events - that way, users can cancel button activation
     *  by moving the mouse/finger away from the button before releasing.</p> 
     */ 
    public class Button extends DisplayObjectContainer
    {
        private static const MAX_DRAG_DIST:Number = 50;
        
        private var mUpState:Texture;
        private var mDownState:Texture;
        private var mOverState:Texture;
        private var mDisabledState:Texture;
        
        private var mContents:Sprite;
        private var mBackground:Image;
        private var mTextField:TextField;
        private var mTextBounds:Rectangle;
        private var mOverlay:Sprite;
        
        private var mScaleWhenDown:Number;
        private var mAlphaWhenDisabled:Number;
        private var mUseHandCursor:Boolean;
        private var mEnabled:Boolean;
        private var mState:String;
        
        /** Creates a button with a set of state-textures and (optionally) some text.
         *  Any state that is left 'null' will display the up-state texture. */
        public function Button(upState:Texture, text:String="", downState:Texture=null,
                               overState:Texture=null, disabledState:Texture=null)
        {
            if (upState == null) throw new ArgumentError("Texture cannot be null");
            
            mUpState = upState;
            mDownState = downState ? downState : upState;
            mOverState = overState ? overState : upState;
            mDisabledState = disabledState ? disabledState : upState;

            mState = ButtonState.UP;
            mBackground = new Image(upState);
            mScaleWhenDown = downState ? 1.0 : 0.9;
            mAlphaWhenDisabled = disabledState ? 1.0: 0.5;
            mEnabled = true;
            mUseHandCursor = true;
            mTextBounds = new Rectangle(0, 0, upState.width, upState.height);            
            
            mContents = new Sprite();
            mContents.addChild(mBackground);
            addChild(mContents);
            addEventListener(TouchEvent.TOUCH, onTouch);
            
            this.touchGroup = true;
            this.text = text;
        }
        
        /** @inheritDoc */
        public override function dispose():void
        {
            // text field might be disconnected from parent, so we have to dispose it manually
            if (mTextField)
                mTextField.dispose();
            
            super.dispose();
        }
        
        private function createTextField():void
        {
            if (mTextField == null)
            {
                mTextField = new TextField(mTextBounds.width, mTextBounds.height, "");
                mTextField.vAlign = VAlign.CENTER;
                mTextField.hAlign = HAlign.CENTER;
                mTextField.touchable = false;
                mTextField.autoScale = true;
                mTextField.batchable = true;
            }
            
            mTextField.width  = mTextBounds.width;
            mTextField.height = mTextBounds.height;
            mTextField.x = mTextBounds.x;
            mTextField.y = mTextBounds.y;
        }
        
        private function onTouch(event:TouchEvent):void
        {
            Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ?
                MouseCursor.BUTTON : MouseCursor.AUTO;
            
            var touch:Touch = event.getTouch(this);
            
            if (!mEnabled)
            {
                return;
            }
            else if (touch == null)
            {
                state = ButtonState.UP;
            }
            else if (touch.phase == TouchPhase.HOVER)
            {
                state = ButtonState.OVER;
            }
            else if (touch.phase == TouchPhase.BEGAN && mState != ButtonState.DOWN)
            {
                state = ButtonState.DOWN;
            }
            else if (touch.phase == TouchPhase.MOVED && mState == ButtonState.DOWN)
            {
                // reset button when user dragged too far away after pushing
                var buttonRect:Rectangle = getBounds(stage);
                if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
                    touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                    touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
                    touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
                {
                    state = ButtonState.UP;
                }
            }
            else if (touch.phase == TouchPhase.ENDED && mState == ButtonState.DOWN)
            {
                state = ButtonState.UP;
                dispatchEventWith(Event.TRIGGERED, true);
            }
        }
        
        /** The current state of the button. The corresponding strings are found
         *  in the ButtonState class. */
        public function get state():String { return mState; }
        public function set state(value:String):void
        {
            mState = value;
            mContents.scaleX = mContents.scaleY = 1.0;

            switch (mState)
            {
                case ButtonState.DOWN:
                    mBackground.texture = mDownState;
                    mContents.scaleX = mContents.scaleY = scaleWhenDown;
                    mContents.x = (1.0 - scaleWhenDown) / 2.0 * mBackground.width;
                    mContents.y = (1.0 - scaleWhenDown) / 2.0 * mBackground.height;
                    break;
                case ButtonState.UP:
                    mBackground.texture = mUpState;
                    mContents.x = mContents.y = 0;
                    break;
                case ButtonState.OVER:
                    mBackground.texture = mOverState;
                    mContents.x = mContents.y = 0;
                    break;
                case ButtonState.DISABLED:
                    mBackground.texture = mDisabledState;
                    mContents.x = mContents.y = 0;
                    break;
                default:
                    throw new ArgumentError("Invalid button state: " + mState);
            }
        }

        /** The scale factor of the button on touch. Per default, a button with a down state 
         *  texture won't scale. */
        public function get scaleWhenDown():Number { return mScaleWhenDown; }
        public function set scaleWhenDown(value:Number):void { mScaleWhenDown = value; }
        
        /** The alpha value of the button when it is disabled. @default 0.5 */
        public function get alphaWhenDisabled():Number { return mAlphaWhenDisabled; }
        public function set alphaWhenDisabled(value:Number):void { mAlphaWhenDisabled = value; }
        
        /** Indicates if the button can be triggered. */
        public function get enabled():Boolean { return mEnabled; }
        public function set enabled(value:Boolean):void
        {
            if (mEnabled != value)
            {
                mEnabled = value;
                mContents.alpha = value ? 1.0 : mAlphaWhenDisabled;
                state = value ? ButtonState.UP : ButtonState.DISABLED;
            }
        }
        
        /** The text that is displayed on the button. */
        public function get text():String { return mTextField ? mTextField.text : ""; }
        public function set text(value:String):void
        {
            if (value.length == 0)
            {
                if (mTextField)
                {
                    mTextField.text = value;
                    mTextField.removeFromParent();
                }
            }
            else
            {
                createTextField();
                mTextField.text = value;
                
                if (mTextField.parent == null)
                    mContents.addChild(mTextField);
            }
        }
        
        /** The name of the font displayed on the button. May be a system font or a registered
         *  bitmap font. */
        public function get fontName():String { return mTextField ? mTextField.fontName : "Verdana"; }
        public function set fontName(value:String):void
        {
            createTextField();
            mTextField.fontName = value;
        }
        
        /** The size of the font. */
        public function get fontSize():Number { return mTextField ? mTextField.fontSize : 12; }
        public function set fontSize(value:Number):void
        {
            createTextField();
            mTextField.fontSize = value;
        }
        
        /** The color of the font. */
        public function get fontColor():uint { return mTextField ? mTextField.color : 0x0; }
        public function set fontColor(value:uint):void
        {
            createTextField();
            mTextField.color = value;
        }
        
        /** Indicates if the font should be bold. */
        public function get fontBold():Boolean { return mTextField ? mTextField.bold : false; }
        public function set fontBold(value:Boolean):void
        {
            createTextField();
            mTextField.bold = value;
        }
        
        /** The texture that is displayed when the button is not being touched. */
        public function get upState():Texture { return mUpState; }
        public function set upState(value:Texture):void
        {
            if (mUpState != value)
            {
                mUpState = value;
                if (mState == ButtonState.UP) mBackground.texture = value;
            }
        }
        
        /** The texture that is displayed while the button is touched. */
        public function get downState():Texture { return mDownState; }
        public function set downState(value:Texture):void
        {
            if (mDownState != value)
            {
                mDownState = value;
                if (mState == ButtonState.DOWN) mBackground.texture = value;
            }
        }

        /** The texture that is displayed while mouse hovers over the button. */
        public function get overState():Texture { return mOverState; }
        public function set overState(value:Texture):void
        {
            if (mOverState != value)
            {
                mOverState = value;
                if (mState == ButtonState.OVER) mBackground.texture = value;
            }
        }

        /** The texture that is displayed when the button is disabled. */
        public function get disabledState():Texture { return mDisabledState; }
        public function set disabledState(value:Texture):void
        {
            if (mDisabledState != value)
            {
                mDisabledState = value;
                if (mState == ButtonState.DISABLED) mBackground.texture = value;
            }
        }
        
        /** The vertical alignment of the text on the button. */
        public function get textVAlign():String
        {
            return mTextField ? mTextField.vAlign : VAlign.CENTER;
        }
        
        public function set textVAlign(value:String):void
        {
            createTextField();
            mTextField.vAlign = value;
        }
        
        /** The horizontal alignment of the text on the button. */
        public function get textHAlign():String
        {
            return mTextField ? mTextField.hAlign : HAlign.CENTER;
        }
        
        public function set textHAlign(value:String):void
        {
            createTextField();
            mTextField.hAlign = value;
        }
        
        /** The bounds of the textfield on the button. Allows moving the text to a custom position. */
        public function get textBounds():Rectangle { return mTextBounds.clone(); }
        public function set textBounds(value:Rectangle):void
        {
            mTextBounds = value.clone();
            createTextField();
        }
        
        /** The color of the button's state image. Just like every image object, each pixel's
         *  color is multiplied with this value. @default white */
        public function get color():uint { return mBackground.color; }
        public function set color(value:uint):void { mBackground.color = value; }

        /** The overlay sprite is displayed on top of the button contents. It scales with the
         *  button when pressed. Use it to add additional objects to the button (e.g. an icon). */
        public function get overlay():Sprite
        {
            if (mOverlay == null)
                mOverlay = new Sprite();

            mContents.addChild(mOverlay); // make sure it's always on top
            return mOverlay;
        }

        /** Indicates if the mouse cursor should transform into a hand while it's over the button. 
         *  @default true */
        public override function get useHandCursor():Boolean { return mUseHandCursor; }
        public override function set useHandCursor(value:Boolean):void { mUseHandCursor = value; }
    }
}