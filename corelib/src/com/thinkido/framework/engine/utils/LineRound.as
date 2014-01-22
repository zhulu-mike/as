package com.thinkido.framework.engine.utils
{

    public class LineRound extends Object
    {

        public function LineRound() : void
        {
            return;
        }

        public static function search(param1:Object, param2:int, param3:int, param4:int, param5:int) : Array
        {
            var _loc_15:Array = null;
            var _loc_16:Array = null;
            var _loc_17:Array = null;
            var _loc_18:Array = null;
            var _loc_19:Array = null;
            var _loc_20:Array = null;
            var _loc_21:Boolean = false;
            var _loc_22:Number = NaN;
            var _loc_23:int = 0;
            var _loc_24:Array = null;
            var _loc_26:Array = null;
            var _loc_27:Array = null;
            var _loc_28:Array = null;
            var _loc_29:Array = null;
            var _loc_30:int = 0;
            var _loc_31:int = 0;
            var _loc_32:Boolean = false;
            if (!param1)
            {
                return null;
            }
            if (param2 == param4 && param3 == param5)
            {
                return null;
            }
            if (param1[param2 + "_" + param3] != 0)
            {
                return null;
            }
            if (param1[param4 + "_" + param5] != 0)
            {
                return null;
            }
            var _loc_6:Array = [];
            var _loc_7:Array = [];
            var _loc_8:Array = [];
            var _loc_9:Array = [];
            var _loc_10:Array = [];
            var _loc_11:Boolean = true;
            var _loc_12:Boolean = true;
            var _loc_13:Object = {};
            var _loc_14:Array = [param2, param3];
            _loc_7.push(_loc_14);
            _loc_8.push(_loc_14);
            _loc_13[_loc_14[0] + "_" + _loc_14[1]] = _loc_14;
            var _loc_25:int = -1;
            while (true)
            {
                
                if (_loc_7.length == 0 && _loc_8.length == 0)
                {
                    return null;
                }
                _loc_25 = _loc_25 * -1;
                _loc_21 = _loc_25 == 1 ? (_loc_11) : (_loc_12);
                _loc_15 = _loc_25 == 1 ? (_loc_7) : (_loc_8);
                _loc_17 = _loc_25 == 1 ? (_loc_9) : (_loc_10);
                if (_loc_15.length == 0)
                {
                    continue;
                }
                var _loc_33:* = _loc_15[(_loc_15.length - 1)];
                _loc_19 = _loc_15[(_loc_15.length - 1)];
                _loc_16 = _loc_33;
                _loc_18 = getLinePath(_loc_16[0], _loc_16[1], param4, param5);
                _loc_18.shift();
                _loc_31 = _loc_18.length;
                _loc_32 = false;
                _loc_30 = 0;
                while (_loc_30 < _loc_31)
                {
                    
                    _loc_20 = _loc_18[_loc_30];
                    if (isClog(param1, _loc_13, _loc_20))
                    {
                        _loc_32 = true;
                        if (_loc_21)
                        {
                            _loc_18.splice(_loc_30, _loc_31 - _loc_30);
                            if (_loc_25 == 1)
                            {
                                _loc_11 = false;
                                _loc_7 = _loc_7.concat(_loc_18);
                                _loc_15 = _loc_7;
                                _loc_29 = _loc_19;
                            }
                            else
                            {
                                _loc_12 = false;
                                _loc_8 = _loc_8.concat(_loc_18);
                                _loc_15 = _loc_8;
                                _loc_28 = _loc_19;
                            }
                            _loc_16 = _loc_19;
                            _loc_17[0] = _loc_20[0];
                            _loc_17[1] = _loc_20[1];
                        }
                        break;
                    }
                    else
                    {
                        _loc_19 = _loc_20;
                    }
                    _loc_30++;
                }
                if (_loc_32)
                {
                    while (true)
                    {
                        
                        _loc_22 = getAngel(_loc_16, _loc_17);
                        _loc_23 = _loc_22 % 90 == 0 ? (5) : (7);
                        _loc_24 = getRoundPoint(param1, _loc_13, _loc_22, _loc_16, 1, _loc_23, _loc_25);
                        if (_loc_24)
                        {
                            _loc_27 = getRoundClog(param1, _loc_13, _loc_16, _loc_24, _loc_25);
                            _loc_17[0] = _loc_27[0];
                            _loc_17[1] = _loc_27[1];
                            _loc_15.push(_loc_24);
                            _loc_13[_loc_24[0] + "_" + _loc_24[1]] = _loc_24;
                            break;
                            continue;
                        }
                        if (_loc_15.length > 0)
                        {
                            _loc_26 = _loc_15.pop();
                            _loc_17[0] = _loc_26[0];
                            _loc_17[1] = _loc_26[1];
                            _loc_16 = _loc_15[(_loc_15.length - 1)];
                            continue;
                        }
                        break;
                    }
                    continue;
                }
                _loc_15 = _loc_15.concat(_loc_18);
                _loc_6 = _loc_15.reverse();
                return _loc_6;
            }
            return null;
        }

        private static function getRoundPoint(param1:*, param2:*, param3:Number, param4:Array, param5:int = 1, param6:int = 5, param7:int = 1) : Array
        {
            if (param5 > param6)
            {
                return null;
            }
            param3 = param3 % 360;
            var _loc_8:Object = {};
			_loc_8.p0 = [param4[0], param4[1] + param7];
            _loc_8.p45 = param7 == 1 ? ([param4[0], (param4[1] + 1)]) : ([(param4[0] + 1), param4[1]]);
            _loc_8.p90 = [param4[0] - param7, param4[1]];
            _loc_8.p135 = param7 == 1 ? ([(param4[0] - 1), param4[1]]) : ([param4[0], (param4[1] + 1)]);
            _loc_8.p180 = [param4[0], param4[1] - param7];
            _loc_8.p225 = param7 == 1 ? ([param4[0], (param4[1] - 1)]) : ([(param4[0] - 1), param4[1]]);
            _loc_8.p270 = [param4[0] + param7, param4[1]];
            _loc_8.p315 = param7 == 1 ? ([(param4[0] + 1), param4[1]]) : ([param4[0], (param4[1] - 1)]);
            var _loc_9:* = _loc_8["p" + param3];
            if (isClog(param1, param2, _loc_9))
            {
                _loc_9 = getRoundPoint(param1, param2, param3 + param7 * 45, param4, (param5 + 1), param6, param7);
            }
            return _loc_9;
        }

        private static function getRoundClog(param1:*, param2:*, param3:Array, param4:Array, param5:int = 1) : Array
        {
            var _loc_6:* = getAngel(param3, param4) % 360;
            var _loc_7:Object = {};
			_loc_7.p0 = isClog(param1, param2, [(param3[0] + 1), param3[1] - param5]) ? ([(param3[0] + 1), param3[1] - param5]) : ([param3[0], param3[1] - param5]);
            _loc_7.p45 = param5 == 1 ? ([(param3[0] + 1), param3[1]]) : ([param3[0], (param3[1] + 1)]);
            _loc_7.p90 = isClog(param1, param2, [param3[0] + param5, (param3[1] + 1)]) ? ([param3[0] + param5, (param3[1] + 1)]) : ([param3[0] + param5, param3[1]]);
            _loc_7.p135 = param5 == 1 ? ([param3[0], (param3[1] + 1)]) : ([(param3[0] - 1), param3[1]]);
            _loc_7.p180 = isClog(param1, param2, [(param3[0] - 1), param3[1] + param5]) ? ([(param3[0] - 1), param3[1] + param5]) : ([param3[0], param3[1] + param5]);
            _loc_7.p225 = param5 == 1 ? ([(param3[0] - 1), param3[1]]) : ([param3[0], (param3[1] - 1)]);
            _loc_7.p270 = isClog(param1, param2, [param3[0] - param5, (param3[1] - 1)]) ? ([param3[0] - param5, (param3[1] - 1)]) : ([param3[0] - param5, param3[1]]);
            _loc_7.p315 = param5 == 1 ? ([param3[0], (param3[1] - 1)]) : ([(param3[0] + 1), param3[1]]);
            return _loc_7["p" + _loc_6];
        }

        private static function getAngel(param1:Array, param2:Array) : int
        {
            var _loc_5:int = 0;
            var _loc_3:* = param1[0] - param2[0];
            var _loc_4:* = param1[1] - param2[1];
            if (_loc_3 == -1 && _loc_4 == 0)
            {
                _loc_5 = 0;
            }
            else if (_loc_3 == -1 && _loc_4 == -1)
            {
                _loc_5 = 45;
            }
            else if (_loc_3 == 0 && _loc_4 == -1)
            {
                _loc_5 = 90;
            }
            else if (_loc_3 == 1 && _loc_4 == -1)
            {
                _loc_5 = 135;
            }
            else if (_loc_3 == 1 && _loc_4 == 0)
            {
                _loc_5 = 180;
            }
            else if (_loc_3 == 1 && _loc_4 == 1)
            {
                _loc_5 = 225;
            }
            else if (_loc_3 == 0 && _loc_4 == 1)
            {
                _loc_5 = 270;
            }
            else if (_loc_3 == -1 && _loc_4 == 1)
            {
                _loc_5 = 315;
            }
            return _loc_5;
        }

        private static function getLinePath(param1:int, param2:int, param3:int, param4:int) : Array
        {
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_5:Array = [];
            var _loc_6:* = param3 - param1;
            var _loc_7:* = param4 - param2;
            var _loc_8:* = _loc_6 == 0 ? (0) : (_loc_6 / Math.abs(_loc_6));
            var _loc_9:* = _loc_7 == 0 ? (0) : (_loc_7 / Math.abs(_loc_7));
            _loc_5.push([param1, param2]);
            while (true)
            {
                
                if (_loc_6 == 0 && _loc_7 == 0)
                {
                    break;
                }
                if (_loc_6 != 0)
                {
                    _loc_6 = _loc_6 - _loc_8;
                    _loc_10 = _loc_5[(_loc_5.length - 1)][0] + _loc_8;
                }
                else
                {
                    _loc_10 = param3;
                }
                if (_loc_7 != 0)
                {
                    _loc_7 = _loc_7 - _loc_9;
                    _loc_11 = _loc_5[(_loc_5.length - 1)][1] + _loc_9;
                }
                else
                {
                    _loc_11 = param4;
                }
                _loc_5.push([_loc_10, _loc_11]);
            }
            _loc_5.push([param3, param4]);
            return _loc_5;
        }

        private static function isClog(param1:*, param2:*, param3:Array) : Boolean
        {
            return !param3 || param1[param3[0] + "_" + param3[1]] != 0 || param2[param3[0] + "_" + param3[1]] != null;
        }

    }
}
