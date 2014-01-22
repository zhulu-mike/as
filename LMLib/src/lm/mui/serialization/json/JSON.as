package lm.mui.serialization.json
{

    public class JSON extends Object
    {

        public function JSON()
        {
            return;
        }

        public static function deserialize(param1:String):Object
        {
            var at:Number;
            var ch:String;
            var _isDigit:Function;
            var _isHexDigit:Function;
            var _white:Function;
            var _string:Function;
            var _next:Function;
            var _array:Function;
            var _object:Function;
            var _number:Function;
            var _word:Function;
            var _value:Function;
            var _error:Function;
            var source:* = param1;
            source = new String(source);
            at;
            ch;
            _isDigit = function (param1:String):Boolean
            {
                return param1 >= "0" && param1 <= "9";
            }
            ;
            _isHexDigit = function (param1:String):Boolean
            {
                return _isDigit(param1) || param1 >= "A" && param1 <= "F" || param1 >= "a" && param1 <= "f";
            }
            ;
            _error = function (param1:String) : void
            {
                throw new Error(param1, (at - 1));
            }
            ;
            _next = function ():String
            {
                ch = source.charAt(at);
                (at + 1);
                return ch;
            }
            ;
            _white = function () : void
            {
                while (ch)
                {
                    
                    if (ch <= " ")
                    {
                        _next();
                    }
                    else if (ch == "/")
                    {
                        switch(_next())
                        {
                            case "/":
                            {
                                while (_next() && ch != "\n" && ch != "\r")
                                {
                                    
                                }
                                break;
                            }
                            case "*":
                            {
                                _next();
                                while (true)
                                {
                                    
                                    if (ch)
                                    {
                                        if (ch == "*")
                                        {
                                            if (_next() == "/")
                                            {
                                                _next();
                                                break;
                                            }
                                        }
                                        else
                                        {
                                            _next();
                                        }
                                        continue;
                                    }
                                    _error("Unterminated Comment");
                                }
                                break;
                            }
                            default:
                            {
                                _error("Syntax Error");
                                break;
                            }
                        }
                    }
                    else
                    {
                        ;
                    }
                }
                return;
            }
            ;
            _string = function ():String
            {
                var _loc_3:* = undefined;
                var _loc_4:* = undefined;
                var _loc_1:* = "";
                var _loc_2:* = "";
                var _loc_5:Boolean = false;
                if (ch == "\"")
                {
                    while (_next())
                    {
                        
                        if (ch == "\"")
                        {
                            _next();
                            return _loc_2;
                        }
                        if (ch == "\\")
                        {
                            switch(_next())
                            {
                                case "b":
                                {
                                    _loc_2 = _loc_2 + "\b";
                                    break;
                                }
                                case "f":
                                {
                                    _loc_2 = _loc_2 + "\f";
                                    break;
                                }
                                case "n":
                                {
                                    _loc_2 = _loc_2 + "\n";
                                    break;
                                }
                                case "r":
                                {
                                    _loc_2 = _loc_2 + "\r";
                                    break;
                                }
                                case "t":
                                {
                                    _loc_2 = _loc_2 + "\t";
                                    break;
                                }
                                case "u":
                                {
                                    _loc_4 = 0;
                                    _loc_1 = 0;
                                    while (_loc_1 < 4)
                                    {
                                        
                                        _loc_3 = parseInt(_next(), 16);
                                        if (!isFinite(_loc_3))
                                        {
                                            _loc_5 = true;
                                            break;
                                        }
                                        _loc_4 = _loc_4 * 16 + _loc_3;
                                        _loc_1 = _loc_1 + 1;
                                    }
                                    if (_loc_5)
                                    {
                                        _loc_5 = false;
                                        break;
                                    }
                                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4);
                                    break;
                                }
                                default:
                                {
                                    _loc_2 = _loc_2 + ch;
                                    break;
                                }
                            }
                            continue;
                        }
                        _loc_2 = _loc_2 + ch;
                    }
                }
                _error("Bad String");
                return null;
            }
            ;
            _array = function ():Array
            {
                var _loc_1:Array = [];
                if (ch == "[")
                {
                    _next();
                    _white();
                    if (ch == "]")
                    {
                        _next();
                        return _loc_1;
                    }
                    while (ch)
                    {
                        
                        _loc_1.push(_value());
                        _white();
                        if (ch == "]")
                        {
                            _next();
                            return _loc_1;
                        }
                        if (ch != ",")
                        {
                            break;
                        }
                        _next();
                        _white();
                    }
                }
                _error("Bad Array");
                return null;
            }
            ;
            _object = function ():Object
            {
                var _loc_1:* = {};
                var _loc_2:* = {};
                if (ch == "{")
                {
                    _next();
                    _white();
                    if (ch == "}")
                    {
                        _next();
                        return _loc_2;
                    }
                    while (ch)
                    {
                        
                        _loc_1 = _string();
                        _white();
                        if (ch != ":")
                        {
                            break;
                        }
                        _next();
                        _loc_2[_loc_1] = _value();
                        _white();
                        if (ch == "}")
                        {
                            _next();
                            return _loc_2;
                        }
                        if (ch != ",")
                        {
                            break;
                        }
                        _next();
                        _white();
                    }
                }
                _error("Bad Object");
                return null;
            }
            ;
            _number = function ():Number
            {
                var _loc_2:* = undefined;
                var _loc_1:* = "";
                var _loc_3:String = "";
                var _loc_4:String = "";
                if (ch == "-")
                {
                    _loc_1 = "-";
                    _loc_4 = _loc_1;
                    _next();
                }
                if (ch == "0")
                {
                    _next();
                    if (ch == "x" || ch == "X")
                    {
                        _next();
                        while (_isHexDigit(ch))
                        {
                            
                            _loc_3 = _loc_3 + ch;
                            _next();
                        }
                        if (_loc_3 == "")
                        {
                            _error("mal formed Hexadecimal");
                        }
                        else
                        {
                            return Number(_loc_4 + "0x" + _loc_3);
                        }
                    }
                    else
                    {
                        _loc_1 = _loc_1 + "0";
                    }
                }
                while (_isDigit(ch))
                {
                    
                    _loc_1 = _loc_1 + ch;
                    _next();
                }
                if (ch == ".")
                {
                    _loc_1 = _loc_1 + ".";
                    while (_next() && ch >= "0" && ch <= "9")
                    {
                        
                        _loc_1 = _loc_1 + ch;
                    }
                }
                _loc_2 = 1 * _loc_1;
                if (!isFinite(_loc_2))
                {
                    _error("Bad Number");
                }
                else
                {
                    return _loc_2;
                }
                return NaN;
            }
            ;
            _word = function ():Object
            {
                switch(ch)
                {
                    case "t":
                    {
                        if (_next() == "r" && _next() == "u" && _next() == "e")
                        {
                            _next();
                            return true;
                        }
                        ;
                    }
                    case "f":
                    {
                        if (_next() == "a" && _next() == "l" && _next() == "s" && _next() == "e")
                        {
                            _next();
                            return false;
                        }
                        ;
                    }
                    case "n":
                    {
                        if (_next() == "u" && _next() == "l" && _next() == "l")
                        {
                            _next();
                            return null;
                        }
                        ;
                    }
                    default:
                    {
                        ;
                    }
                }
                _error("Syntax Error");
                return null;
            }
            ;
            _value = function ():Object
            {
                _white();
                switch(ch)
                {
                    case "{":
                    {
                        return _object();
                    }
                    case "[":
                    {
                        return _array();
                    }
                    case "\"":
                    {
                        return _string();
                    }
                    case "-":
                    {
                        return _number();
                    }
                    default:
                    {
                        return ch >= "0" && ch <= "9" ? (_number()) : (_word());
                        break;
                    }
                }
            }
            ;
//            return JSON._value();
			return _value();
        }

        public static function serialize(param1:*) : String
        {
            var _loc_2:String = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_6:* = undefined;
            var _loc_7:String = null;
            var _loc_8:Number = NaN;
            var _loc_5:String = "";
            switch(typeof(param1))
            {
                case "object":
                {
                    if (param1)
                    {
                        if (param1 is Array)
                        {
                            _loc_4 = param1.length;
                            _loc_3 = 0;
                            while (_loc_3 < _loc_4)
                            {
                                
                                _loc_6 = serialize(param1[_loc_3]);
                                if (_loc_5)
                                {
                                    _loc_5 = _loc_5 + ",";
                                }
                                _loc_5 = _loc_5 + _loc_6;
                                _loc_3 = _loc_3 + 1;
                            }
                            return "[" + _loc_5 + "]";
                        }
                        else if (typeof(param1.toString) != "undefined")
                        {
                            for (_loc_7 in param1)
                            {
                                
                                _loc_6 = param1[_loc_7];
                                if (typeof(_loc_6) != "undefined" && typeof(_loc_6) != "function")
                                {
                                    _loc_6 = serialize(_loc_6);
                                    if (_loc_5)
                                    {
                                        _loc_5 = _loc_5 + ",";
                                    }
                                    _loc_5 = _loc_5 + (serialize(_loc_7) + ":" + _loc_6);
                                }
                            }
                            return "{" + _loc_5 + "}";
                        }
                    }
                    return "null";
                }
                case "number":
                {
                    return isFinite(param1) ? (String(param1)) : ("null");
                }
                case "string":
                {
                    _loc_4 = param1.length;
                    _loc_5 = "\"";
                    _loc_3 = 0;
                    while (_loc_3 < _loc_4)
                    {
                        
                        _loc_2 = param1.charAt(_loc_3);
                        if (_loc_2 >= " ")
                        {
                            if (_loc_2 == "\\" || _loc_2 == "\"")
                            {
                                _loc_5 = _loc_5 + "\\";
                            }
                            _loc_5 = _loc_5 + _loc_2;
                        }
                        else
                        {
                            switch(_loc_2)
                            {
                                case "\b":
                                {
                                    _loc_5 = _loc_5 + "\\b";
                                    break;
                                }
                                case "\f":
                                {
                                    _loc_5 = _loc_5 + "\\f";
                                    break;
                                }
                                case "\n":
                                {
                                    _loc_5 = _loc_5 + "\\n";
                                    break;
                                }
                                case "\r":
                                {
                                    _loc_5 = _loc_5 + "\\r";
                                    break;
                                }
                                case "\t":
                                {
                                    _loc_5 = _loc_5 + "\\t";
                                    break;
                                }
                                default:
                                {
                                    _loc_8 = _loc_2.charCodeAt();
                                    _loc_5 = _loc_5 + ("\\u00" + Math.floor(_loc_8 / 16).toString(16) + (_loc_8 % 16).toString(16));
                                    break;
                                }
                            }
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    return _loc_5 + "\"";
                }
                case "boolean":
                {
                    return String(param1);
                }
                default:
                {
                    return "null";
                    break;
                }
            }
        }

    }
}
