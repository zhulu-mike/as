package lm.mui.manager
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

    public class ToolTipPool extends Object
    {
        private static var pools:Dictionary = new Dictionary();

        public function ToolTipPool()
        {
            return;
        }

        private static function getPool(param1:Class) : Array
        {
			return param1 in pools ? pools[param1] :(pools[param1] = new Array);
        }

        public static function getObject(param1:Class, ... args):IToolTip
        {
            var objArr:Array = getPool(param1);
            if (objArr.length > 10)
            {
                return objArr.pop();
            }
            return construct(param1, args);
        }

        public static function disposeObject(param1:*, param2:Class = null) : void
        {
            var className:String = null;
            if (!param1)
            {
                return;
            }
            if (!param2)
            {
				className = getQualifiedClassName(param1);
                param2 = getDefinitionByName(className) as Class;
            }
            var arr:Array = getPool(param2);
			arr.push(param1);
            return;
        }

        private static function construct(param1:Class, param2:Array):IToolTip
        {
            switch(param2.length)
            {
                case 0:
                {
                    return new param1;
					break;
                }
                case 1:
                {
                    return new param1(param2[0]);
					break;
                }
                case 2:
                {
                    return new param1(param2[0], param2[1]);
					break;
                }
                case 3:
                {
                    return new param1(param2[0], param2[1], param2[2]);
					break;
                }
                case 4:
                {
                    return new param1(param2[0], param2[1], param2[2], param2[3]);
					break;
                }
                case 5:
                {
                    return new param1(param2[0], param2[1], param2[2], param2[3], param2[4]);
					break;
                }
                case 6:
                {
                    return new param1(param2[0], param2[1], param2[2], param2[3], param2[4], param2[5]);
					break;
                }
                case 7:
                {
                    return new param1(param2[0], param2[1], param2[2], param2[3], param2[4], param2[5], param2[6]);
					break;
                }
                case 8:
                {
                    return new param1(param2[0], param2[1], param2[2], param2[3], param2[4], param2[5], param2[6], param2[7]);
					break;
                }
                case 9:
                {
                    return new param1(param2[0], param2[1], param2[2], param2[3], param2[4], param2[5], param2[6], param2[7], param2[8]);
					break;
                }
                case 10:
                {
                    return new param1(param2[0], param2[1], param2[2], param2[3], param2[4], param2[5], param2[6], param2[7], param2[8], param2[9]);
					break;
                }
                default:
                {
                    return null;
                    break;
                }
            }
        }

    }
}
