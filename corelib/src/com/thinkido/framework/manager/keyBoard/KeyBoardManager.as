package com.thinkido.framework.manager.keyBoard
{
	import com.thinkido.framework.common.Global;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.osflash.thunderbolt.Logger;
	/**
	 * 键盘管理器 
	 * @author thinkido
	 * 
	 */
    public class KeyBoardManager extends EventDispatcher
    {
        private static var _keyMap:Object = {};
        private static var _instance:KeyBoardManager;
        private static var _stage:Stage;
        public static var ctrlKey:Boolean;
        public static var altKey:Boolean;
		
		public static var enable:Boolean = false;

        public function KeyBoardManager()
        {
            if (_instance != null)
            {
                throw new Error("KeyBoardManager 不能实例化");
            }
            _instance = this;
            return;
        }
		/**
		 * 开始监听 
		 */
        public function start() : void
        {
            _stage = Global.stage;
            if (_stage)
            {
                this.addListener();
            }else{
				Logger.error("找不到 stage");
			}
            return;
        }
		/**
		 * 取消监听 
		 * 
		 */
        public function cancelListener() : void
        {
            if (_stage)
            {
                _stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
                _stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUpHandler);
                _stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocusChangeHandler);
                _stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDownHandler);
            }
            return;
        }
		/**
		 * 监听 
		 * 
		 */
        public function addListener() : void
        {
            if (_stage)
            {
                _stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler, false, 9999, false);
                _stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUpHandler, false, 9999, false);
                _stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocusChangeHandler, false, 9999, false);
                _stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDownHandler, false, 9999, false);
            }
            return;
        }
		/**
		 * 焦点改变时设置输入法 
		 * @param event
		 * 
		 */
        private function onMouseFocusChangeHandler(event:FocusEvent) : void
        {
            if (event.relatedObject is TextField)
            {
                if ((event.relatedObject as TextField).type == TextFieldType.INPUT)
                {
                    this.changeImeEnable(true);
                }
            }
            else
            {
                _stage.focus = _stage;
                this.changeImeEnable(false);
            }
            return;
        }
		/**
		 * 设置打开输入法 
		 * @param enbled
		 * 
		 */
        public function changeImeEnable(enbled:Boolean) : void
        {
            if (enbled == IME.enabled)
            {
                return;
            }
            if (Capabilities.hasIME)
            {
                try
                {
                    IME.enabled = enbled;
                }
                catch (e:Error)
                {
                }
            }
            return;
        }

        private function onMouseDownHandler(event:MouseEvent) : void
        {
            KeyBoardManager.ctrlKey = event.ctrlKey;
            return;
        }

        private function onKeyDownHandler(event:KeyboardEvent) : void
        {
            var _keyEvent:KeyEvent = null;
            altKey = event.altKey;
            var _keyCode:uint = event.keyCode;
            var _keyData:KeyData = getKeyData(_keyCode);
            if (_keyData.isKeyDown == false)
            {
                _keyData.isKeyDown = true;
                _keyEvent = new KeyEvent(KeyEvent.KEY_DOWN);
                _keyEvent.keyEvent = event;
                dispatchEvent(_keyEvent);
            }
            event.stopImmediatePropagation();
            return;
        }

        private function onKeyUpHandler(event:KeyboardEvent) : void
        {
            var _keyEvent:KeyEvent = null;
            altKey = event.altKey;
			var _keyCode:uint = event.keyCode;
			var _keyData:KeyData = getKeyData(_keyCode);
            if (_keyData.isKeyDown == true)
            {
				_keyData.isKeyDown = false;
                _keyEvent = new KeyEvent(KeyEvent.KEY_UP);
                _keyEvent.keyEvent = event;
                dispatchEvent(_keyEvent);
            }
            event.stopImmediatePropagation();
            return;
        }

        public static function get instance() : KeyBoardManager
        {
            if (_instance == null)
            {
                _instance = new KeyBoardManager;
            }
            return _instance;
        }
		/**
		 * 批量添加keyData 监听 
		 * @param $keyDataArr keydata 数组
		 * 
		 */
        public static function addkeys($keyDataArr:Array) : void
        {
            var _keyData:KeyData = null;
            if ($keyDataArr == null || $keyDataArr.length == 0)
            {
                return;
            }
            if ($keyDataArr[0] as KeyData == null)
            {
                throw new Error("addkeys(value:Array) value中不是KeyData类型");
            }
            var len:int = $keyDataArr.length;
            var _index:int = 0;
            while (_index < len)
            {
                _keyData = $keyDataArr[_index] as KeyData;
                _keyMap[_keyData.keyCode] = _keyData;
                _index++;
            }
            return;
        }

        public static function getKeyData($keyCode:uint) : KeyData
        {
            var _keyData:KeyData = _keyMap[$keyCode] as KeyData;
            if (_keyData == null)
            {
                _keyData = new KeyData($keyCode);
                _keyData.isKeyDown = false;
                _keyMap[$keyCode] = _keyData;
            }
            return _keyData;
        }

    }
}
