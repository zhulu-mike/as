package tools.common.bind
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * 
	 * @example
	 *  <listing version="3.0"> 
			BindUtils.bindSetter(say, testVO, "name");
			BindUtils.bindProperty(temp, "name", testVO, "name", true);
			testVO.name = "jiang" ;
			
			trace("temp.name:",temp.name);
		 	
			private function say(value:* = null ):void{
				trace("say hi",value);
			}
		}
		</listing> 
	 */
    public class BindUtils extends Object
    {
        private var _sHost:IEventDispatcher;
        private var _index:int;
        private var _sProp:String;
        private var _tHost:Object;
        private var _setter:Function;
        private var _tProp:String;
        private static var __index:int = 0;
        private static var __hosts:Dictionary = new Dictionary();

        public function BindUtils(singleTon:BindUtilsEnforcer, $index:int, $sHost:IEventDispatcher, $sProp:String, $setter:Function = null, $tHost:Object = null, $tProp:String = "")
        {
            if (!singleTon)
            {
                throw new Error(Language.getKey("5215"));
            }
            _index = $index;
            _sHost = $sHost;
            _sProp = $sProp;
            _setter = $setter;
            _tHost = $tHost;
            _tProp = $tProp;
            bind();
            return;
        }

        public function bind() : void
        {
            _sHost.addEventListener(DataChangeEvent.CHANGE, dataChangeHander);
            return;
        }

        private function dataChangeHander(event:DataChangeEvent) : void
        {
            if (event.valueName == _sProp && event.newValue != event.oldValue)
            {
                if (_setter != null)
                {
                    _setter(event.newValue);
                }
                if (_tHost != null)
                {
                    _tHost[_tProp] = event.newValue;
                }
            }
            return;
        }

        public function clear() : void
        {
            unbind();
            _sHost = null;
            _tHost = null;
            _setter = null;
            delete __hosts[_index];
            return;
        }

        public function unbind() : void
        {
            _sHost.removeEventListener(DataChangeEvent.CHANGE, dataChangeHander);
            return;
        }
		/**
		 *  
		 * @param $tHost 定义绑定到 $sProp 的属性的 Object。 
		 * @param $tProp 在要绑定的 site Object 中定义的公用属性的名称。当 chain 值更改时，该属性将接收 chain 的当前值。
		 * @param $sHost 用于承载要监视的属性或属性链的对象。 
		 * @param $sProp 用于指定要监视的属性或属性链的值。
		 * @param $immediately 是否立即执行
		 * @return 
		 * @example
	 	 *  <listing version="3.0"> 
		 		BindUtils.bindProperty(_page, "currentPage", _pageData, "currentPage", true);
			</listing> 
		 */
        public static function bindProperty($tHost:Object, $tProp:String, $sHost:IEventDispatcher, $sProp:String, $immediately:Boolean = false) : BindUtils
        {
            if ($immediately)
            {
                $tHost[$tProp] = $sHost[$sProp];
            }
            __index = __index + 1;
            var _bind:BindUtils = new BindUtils(new BindUtilsEnforcer(), __index, $sHost, $sProp, null, $tHost, $tProp);
            __hosts[__index] = _bind;
            return _bind;
        }

        public static function allUnbind() : void
        {
            var _temp:Object = null;
            for (_temp in __hosts)
            {
                __hosts[_temp].clear();
            }
            __index = 0;
            __hosts = new Dictionary();
            return;
        }
		/**
		 * 
		 * @param $setter 属性改变时触发事件
		 * @param $sHost  用于承载要监视的属性或属性链的对象
		 * @param $tProp  用于指定要监视的属性或属性链的值。
		 * @param $immediately 是否立即执行
		 * @return 
		 * @example
	 	*   <listing version="3.0"> 
				BindUtils.bindSetter(setListFun, _pageData, "showList");
			</listing> 
		 */
        public static function bindSetter($setter:Function, $sHost:IEventDispatcher, $tProp:String, $immediately:Boolean = false) : BindUtils
        {
            if ($immediately)
            {
                $setter($sHost[$tProp]);
            }
            __index = __index + 1;
            var _bind:BindUtils = new BindUtils(new BindUtilsEnforcer(), __index, $sHost, $tProp, $setter);
            __hosts[__index] = _bind;
            return _bind;
        }

    }
}

class BindUtilsEnforcer {
	public function BindUtilsEnforcer(){
	}
}
