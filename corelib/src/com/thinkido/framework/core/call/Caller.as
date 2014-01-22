package com.thinkido.framework.core.call
{
	import com.thinkido.framework.utils.ArrayUtil;
	
	import flash.utils.Dictionary;

    public class Caller extends Object implements ICaller
    {
        private var _callerMap:Dictionary;

        public function Caller()
        {
            this._callerMap = new Dictionary(true);
            return;
        }

        public function addCall(param1:Object, param2:Function) : void
        {
            var _loc_3:* = this.getlistByType(param1);
            _loc_3.push(param2);
            return;
        }

        public function removeCall(param1:Object, param2:Function) : void
        {
            var _loc_3:* = this._callerMap[param1] as Array;
            if (_loc_3 && _loc_3.length > 0)
            {
                ArrayUtil.removeItem(_loc_3, param2);
            }
            return;
        }

        public function call(param1:Object, ... args) : Boolean
        {
            var _loc_4:Function = null;
            args = this._callerMap[param1] as Array;
            if (args && args.length > 0)
            {
                for each (_loc_4 in args)
                {
                    
                    _loc_4.apply(null, args);
                }
            }
            return true;
        }

        public function dispose(param1:Boolean = true) : void
        {
            var _loc_2:Array = null;
            var _loc_3:String = null;
            for (_loc_3 in this._callerMap)
            {
                
                _loc_2 = this._callerMap[_loc_3] as Array;
                _loc_2.length = 0;
                delete this._callerMap[_loc_3];
            }
            return;
        }

        private function getlistByType(param1:Object) : Array
        {
            if (param1 in this._callerMap)
            {
                return this._callerMap[param1];
            }
            var _loc_2:* = new Array();
            this._callerMap[param1] = _loc_2;
            return _loc_2;
        }

        public function removeCallByType(param1:Object) : void
        {
            var _loc_2:* = this._callerMap[param1] as Array;
            if (_loc_2)
            {
                _loc_2.length = 0;
                delete this._callerMap[param1];
            }
            return;
        }

        public function hasCall(param1:Object) : Boolean
        {
            return param1 in this._callerMap;
        }

    }
}
