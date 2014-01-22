package com.thinkido.framework.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * 游戏过滤词相关处理 
	 * @author thinkido
	 */
    public class FilterText extends EventDispatcher
    {
        private const MAX_LENGTH:int = 1000;
        private var _loader:URLLoader;
        private var _filterStr:String;
        private var _filterRegExp:RegExp;
		/**
		 * 过滤词分隔符正则 
		 */		
        private var _splitReg:RegExp;
        private var _wordMap:Dictionary;
        private var _filterRegAry:Array;
        private static var _instance:FilterText;

        public function FilterText()
        {
            this._splitReg = /(\n|\r)+""(\n|\r)+/mg;
            this._filterRegAry = [];
            this._loader = new URLLoader();
            this._wordMap = new Dictionary();
            return;
        }
		/**
		 * 加载过滤词 
		 * @param fileUrl 文件地址
		 * 
		 */
        public function load(fileUrl:String) : void
        {
            var request:URLRequest = new URLRequest(fileUrl);
            try
            {
                this._loader.load(request);
                this.addListener();
            }
            catch (error:Error)
            {
                trace("Unable to load requested document.");
            }
            return;
        }

        private function addListener() : void
        {
            this._loader.addEventListener(Event.COMPLETE, this.completeHandler);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            return;
        }

        private function removelistener() : void
        {
            this._loader.removeEventListener(Event.COMPLETE, this.completeHandler);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            return;
        }

        private function completeHandler(event:Event) : void
        {
            this.log("加载完成");
            this.removelistener();
            var _loc_2:URLLoader = URLLoader(event.target);
            this.createRegExpStr(String(_loc_2.data));
            dispatchEvent(event);
            return;
        }
		/**
		 * 解析敏感词字符 
		 * @param $content 敏感词字符串、文本
		 * 
		 */
        private function createRegExpStr($content:String) : void
        {
            var _loc_2:Array = $content.split(this._splitReg);
            var _loc_3:int = _loc_2.length;
            var _index:int = 0;
            while (_index < _loc_3)
            {
                this.addWord(_loc_2[_index]);
                _index++;
            }
            return;
        }

        public function ioErrorHandler(event:IOErrorEvent) : void
        {
            trace(event);
            dispatchEvent(event);
            return;
        }
		/**
		 * 屏蔽敏感内容 
		 * @param $cotent 需要屏蔽的内容
		 * @return 屏蔽后的内容
		 */
        public function getFilterStr($cotent:String) : String
        {
            var _loc_3:String = null;
            var _loc_4:* = undefined;
            if ($cotent == null || $cotent == "")
            {
                return "";
            }
            var _loc_2:* = $cotent.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_2)
            {
                
                _loc_3 = $cotent.charAt(_loc_5);
                if (_loc_3 != "*")
                {
                    _loc_4 = this._wordMap[_loc_3];
                    if (_loc_4 is String)
                    {
                        var _loc_6:* = new RegExp("(" + _loc_4 + ")", "img");
                        this._wordMap[_loc_3] = new RegExp("(" + _loc_4 + ")", "img");
                        _loc_4 = _loc_6;
                    }
                    $cotent = $cotent.replace(_loc_4, this.regHandler);
                }
                _loc_5++;
            }
            return $cotent;
        }
		/**
		 * 替换敏感词内容 
		 * @return 屏蔽后的内容
		 */
        private function regHandler() : String
        {
            arguments = arguments[1].toString();
            return arguments.replace(/.{1}"".{1}/g, "*");
        }

        private function log(param1:Object) : void
        {
            trace(param1);
            return;
        }
		/**
		 * 设置、添加敏感词
		 * @param $content 敏感词
		 * @param reg 敏感词分隔符正则
		 * 
		 */
        public function setFilterStr($content:String, reg:RegExp = null) : void
        {
            if (reg != null)
            {
                this._splitReg = reg;
            }
            this.createRegExpStr($content);
            return;
        }
		/**
		 * 添加过滤词 
		 * @param $word 敏感关键字
		 * 
		 */
        public function addWord($word:String) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            $word = $word.replace("\n", "");
            if ($word != null && $word.length > 0)
            {
                _loc_3 = $word.charAt(0);
                _loc_2 = this._wordMap[_loc_3] as String;
                if (_loc_2)
                {
                    this._wordMap[_loc_3] = this._wordMap[_loc_3] + ("|" + $word);
                }
                else
                {
                    this._wordMap[_loc_3] = $word;
                }
            }
            return;
        }

        public static function get instance() : FilterText
        {
            if (_instance == null)
            {
                _instance = new FilterText;
            }
            return _instance;
        }

    }
}
