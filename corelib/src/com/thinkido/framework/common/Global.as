package com.thinkido.framework.common
{
	import com.thinkido.framework.core.call.Caller;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.LocalConnection;
	/**
	 * 主要用于存放stage变量作为 全局变量
	 * @author Administrator
	 * 
	 */
    public class Global extends Object
    {
        private var _caller:Caller;
        private var _isCallLater:Boolean = false;
        private static var _stage:Stage;
        public static var isDebugModle:Boolean = false;
        public static var isActivate:Boolean = true;
        private static const CallerType:String = "render";
        private static var _instance:Global;
        public static var application:Application;

        public function Global()
        {
            this._caller = new Caller();
            if (_instance != null)
            {
                throw new Error("Global 单例");
            }
            return;
        }

        public function initStage($stage:Stage) : void
        {
            _stage = $stage;
            _stage.addEventListener(Event.RESIZE, this.onReSizeHandler, false, 99999, false);
            _stage.addEventListener(Event.ACTIVATE, this.onActivateHandler, false, 99999);
            _stage.addEventListener(Event.DEACTIVATE, this.onDeactivateHandler, false, 99999);
            return;
        }

        private function onRenderHandler(event:Event) : void
        {
            this._isCallLater = false;
            this._caller.call(CallerType);
            this._caller.removeCallByType(CallerType);
            return;
        }

        private function onActivateHandler(event:Event) : void
        {
            _stage.focus = stage;
            isActivate = true;
            return;
        }

        private function onDeactivateHandler(event:Event) : void
        {
            isActivate = false;
            return;
        }

        private function onReSizeHandler(event:Event) : void
        {
            if (event.target is Stage == false)
            {
                event.stopImmediatePropagation();
            }
            return;
        }

        public function callLater(func:Function) : void
        {
            this._caller.addCall(CallerType, func);
            if (this._isCallLater == false)
            {
                _stage.invalidate();
                _stage.addEventListener(Event.RENDER, this.onRenderHandler);
                this._isCallLater = true;
            }
            return;
        }

        public static function get instance() : Global
        {
            if (_instance == null)
            {
                _instance = new Global;
            }
            return _instance;
        }

        public static function get stage() : Stage
        {
            return _stage;
        }

        public static function gc() : void
        {
            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch (e)
            {
            }
            return;
        }

    }
}
