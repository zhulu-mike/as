package com.thinkido.framework.common.codemix
{
	import flash.display.Stage;
	import flash.utils.ByteArray;

    public class CodeMixer extends Object
    {

        public function CodeMixer()
        {
            return;
        }

        public static function encodeBytes($by:ByteArray) : ByteArray
        {
            var _loc_8:uint = 0;
            var _loc_2:* = Stage.prototype["a"];
            var _loc_3:* = Stage.prototype["b"];
            var _loc_4:* = Stage.prototype["c"];
            $by.position = 0;
            var _loc_5:* = $by.length;
            var _loc_6:uint = 0;
            while (true)
            {
                
                _loc_8 = 0;
                while (_loc_8 < _loc_3)
                {
                    
                    $by[_loc_6] = $by[_loc_6] ^ _loc_2;
                    if (++_loc_6 >= _loc_5)
                    {
                        break;
                    }
                    _loc_8 = _loc_8 + 1;
                }
                _loc_6 = ++_loc_6 + _loc_4;
                if (_loc_6 >= _loc_5)
                {
                    break;
                }
            }
            var _loc_7:* = new ByteArray();
			_loc_7.writeBytes($by);
            return _loc_7;
        }

        public static function decodeBytes(value1:ByteArray) : ByteArray
        {
            var _loc_8:uint = 0;
            var _loc_2:* = Stage.prototype["a"];
            var _loc_3:* = Stage.prototype["b"];
            var _loc_4:* = Stage.prototype["c"];
            value1.position = 0;
            var _loc_5:* = new ByteArray();
            value1.readBytes(_loc_5);
            var _loc_6:* = _loc_5.length;
            var _loc_7:uint = 0;
            while (true)
            {
                
                _loc_8 = 0;
                while (_loc_8 < _loc_3)
                {
                    
                    _loc_5[_loc_7] = _loc_5[_loc_7] ^ _loc_2;
                    if (++_loc_7 >= _loc_6)
                    {
                        break;
                    }
                    _loc_8 = _loc_8 + 1;
                }
                _loc_7 = ++_loc_7 + _loc_4;
                if (_loc_7 >= _loc_6)
                {
                    break;
                }
            }
            return _loc_5;
        }

    }
}
