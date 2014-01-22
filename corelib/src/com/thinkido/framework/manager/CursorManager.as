package com.thinkido.framework.manager
{
	import com.thinkido.framework.common.handler.helper.HandlerHelper;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	/**
	 * 鼠标管理器，使用旧式鼠标控制，此处可以修改为fp10新特性 
	 * @author Administrator
	 * 
	 */
    public class CursorManager extends Object
    {
        private static var _stage:Stage;
        private static var _face:DisplayObject;
        private static var _data:Object;
        private static var _cursorPositionUV:Point;
        private static var _onClick:Function;
        private static var _onClickParameters:Array;
        private static var _onInvalidClick:Function;
        private static var _onInvalidClickParameters:Array;
        public static var CURSOR_BUZHUO:String = "";

		
		
		private static var isLockOn:Boolean = false;
		
        public function CursorManager()
        {
            throw new Event("静态类");
        }

        public static function init(param1:Stage) : void
        {
            _stage = param1;
            return;
        }

        public static function showCursor(param1:DisplayObject = null, param2:Object = null, param3:Point = null, param4:Function = null, param5:Array = null, param6:Function = null, param7:Array = null) : void
        {
            if (_stage == null)
            {
                throw new Error("请先执行init方法初始化");
            }
            var _loc_8:* = _face;
            _face = param1;
            _data = param2;
            _cursorPositionUV = param3;
            _onClick = param4;
            _onClickParameters = param5;
            _onInvalidClick = param6;
            _onInvalidClickParameters = param7;
            if (_loc_8 != _face)
            {
                if (_loc_8 != null)
                {
                    if (_loc_8.parent == _stage)
                    {
                        _stage.removeChild(_loc_8);
                    }
                }
                if (_face != null)
                {
                    Mouse.hide();
                    _stage.addChild(param1);
                    if (_loc_8 == null)
                    {
                        _stage.addEventListener(Event.ADDED, onAdded);
                        _stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
                        _stage.addEventListener(MouseEvent.CLICK, mouseClickHandle, true);
                    }
                }
                else
                {
                    Mouse.show();
                    if (_loc_8 != null)
                    {
                        _stage.removeEventListener(Event.ADDED, onAdded);
                        _stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                        _stage.removeEventListener(MouseEvent.CLICK, mouseClickHandle, true);
                    }
                }
            }
            return;
        }

        public static function clear() : void
        {
            showCursor(null, null, null);
            return;
        }

        public static function get data() : Object
        {
            return _data;
        }

        private static function onAdded(event:Event) : void
        {
            if (_face.parent == _stage)
            {
                _stage.setChildIndex(_face, (_stage.numChildren - 1));
            }
            return;
        }

        private static function onEnterFrame(event:Event) : void
        {
            var _loc_2:Rectangle = null;
            _loc_2 = _face.getBounds(_face);
            if (!_cursorPositionUV)
            {
                _face.x = _stage.mouseX - _loc_2.x;
                _face.y = _stage.mouseY - _loc_2.y;
            }
            else
            {
                _face.x = _stage.mouseX - _loc_2.x - _loc_2.width * _cursorPositionUV.x;
                _face.y = _stage.mouseY - _loc_2.y - _loc_2.height * _cursorPositionUV.y;
            }
            return;
        }

        private static function mouseClickHandle(event:MouseEvent) : void
        {
            var dropToTarget:InteractiveObject;
            var iObj:InteractiveObject;
            var item:DisplayObject;
            var stageXY:Point = new Point(event.stageX, event.stageY);
            var arr:Array = _stage.getObjectsUnderPoint(stageXY);
            var _loc_3:int = 0;
            var _loc_4:* = arr ;
            while (_loc_4 in _loc_3)
            {
                
                item = _loc_4[_loc_3];
                iObj = item as InteractiveObject;
                if (iObj && iObj.mouseEnabled)
                {
                    dropToTarget = iObj;
                    break;
                }
            }
            if (dropToTarget && dropToTarget.hasOwnProperty("dropIn"))
            {
                try
                {
                    (dropToTarget as Object).dropIn(_data);
                }
                catch (e:Error)
                {
                }
                HandlerHelper.execute(_onClick, _onClickParameters);
            }
            else
            {
                HandlerHelper.execute(_onInvalidClick, _onInvalidClickParameters);
            }
            return;
        }

    }
}
