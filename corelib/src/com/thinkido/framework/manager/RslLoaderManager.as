package com.thinkido.framework.manager
{
    
    import com.thinkido.framework.manager.loader.RslLoader;
    import com.thinkido.framework.manager.loader.vo.LoadData;
    import com.thinkido.framework.manager.loader.vo.RslLoadingInfo;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.system.ApplicationDomain;
    
    import org.osflash.thunderbolt.Logger;

    public class RslLoaderManager extends Object
    {
        private static var waitLoadList:Array = [];
        private static var loaderList:Array = [];
        public static var MAX_THREAD:int = 10;

        public function RslLoaderManager()
        {
            throw new Error("Can not New!");
        }
		/**
		 * 从当前应用程序域中获取类
		 * @param $className 类名
		 * @return 
		 * 
		 */
        public static function getClass($className:String) : Class
        {
            if ($className == null || $className == "")
            {
                return null;
            }
            if (ApplicationDomain.currentDomain.hasDefinition($className))
            {
                return ApplicationDomain.currentDomain.getDefinition($className) as Class;
            }		
            Logger.info("RslLoaderManager.getClass: 类“" + $className + "”不存在");
            return null;
        }
		public static function hasDefinition($className:String):Boolean{
			return ApplicationDomain.currentDomain.hasDefinition($className);
		}
		
		/**
		 * 通过类名，构造参数获取实例
		 * @param $className 类名
		 * @param args 构造参数
		 * @return 实例
		 * 
		 */
        public static function getInstance($className:String, ... args):*
        {
			var temp:Class = getClass($className);
            return getInstanceByClass(temp, args);
        }
		/**
		 * 通过类，构造参数获取实例
		 * @param $class 类
		 * @param args 构造参数
		 * @return 实例
		 * 
		 */
        public static function getInstanceByClass($class:Class, args:Array):*
        {
            var instance:* = undefined;
            if ($class == null)
            {
                return null;
            }
            var len:int = args ? (args.length) : (0);
            switch(len)
            {
                case 0:
                {
                    instance = new $class;
                    break;
                }
                case 1:
                {
                    instance = new $class(args[0]);
                    break;
                }
                case 2:
                {
                    instance = new $class(args[0], args[1]);
                    break;
                }
                case 3:
                {
                    instance = new $class(args[0], args[1], args[2]);
                    break;
                }
                case 4:
                {
                    instance = new $class(args[0], args[1], args[2], args[3]);
                    break;
                }
                case 5:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4]);
                    break;
                }
                case 6:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5]);
                    break;
                }
                case 7:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
                    break;
                }
                case 8:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
                    break;
                }
                case 9:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
                    break;
                }
                case 10:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
                    break;
                }
                case 11:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
                    break;
                }
                case 12:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
                    break;
                }
                case 13:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
                    break;
                }
                case 14:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
                    break;
                }
                case 15:
                {
                    instance = new $class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return instance;
        }
		/**
		 * 主要使用方法 
		 * @param $loadList 加载队列 loaddata
		 * @param $callBack 所有加载完成后的队列
		 * @param $priority 优先级
		 * 
		 */
        public static function load($loadList:Array, $callBack:Function = null, $priority:int = 0) : void
        {
            if (!$loadList || $loadList.length == 0)
            {
                if ($callBack != null)
                {
                    $callBack();
                }
                return;
            }
            $loadList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
            var loadInfo:RslLoadingInfo = new RslLoadingInfo($loadList, $callBack, $priority);
            var rslLoader:RslLoader = getFreeLoader(loadInfo.priority);
            if (rslLoader != null)
            {
                rslLoader.rslLoadingInfo = loadInfo;
                loadNext(rslLoader);
            }
            else
            {
                waitLoadList.push(loadInfo);
                waitLoadList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
            }
            return;
        }
		/**
		 * 懒惰加载，相关使用参考bulkloader 
		 * @param $callBack 回调
		 * @param $decode 解密方法
		 * @param args 参数
		 * 存在问题
		 */
        public static function lazyLoad($callBack:Function = null, $decode:Function = null, ... args) : void
        {
			
			var callBack:Function = $callBack;
			var decode:Function = $decode;
			var loadList:Array = args;
			if (!loadList || loadList.length == 0)
			{
				if ( callBack != null)
				{
					callBack();
				}
				return;
			}
//			临时注释
			var ldList:Array = [];
			var ld:LoadData ;
			for (var i:int = 0; i < loadList.length; i++) 
			{
				ld = new LoadData(loadList[i],callBack);
				ldList.push(ld);
			}            
			load( ldList , callBack );
			return;
        }
		/**
		 * 取消所有加载 
		 * 
		 */
		public static function cancelLoadAll():void{
			waitLoadList.length = 0 ;
			
		}
		/**
		 * 取消指定url 的加载 
		 * @param $url
		 */		
        public static function cancelLoadByUrl($url:String) : void
        {
            var _rslLoader:RslLoader = null;
            var loadInfo:RslLoadingInfo = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var loadData:LoadData = null;
            var _loadInfo:RslLoadingInfo = null;
            var _len2:int = 0;
            var _loadlistIndex:int = 0;
            var _loaddata:LoadData = null;
            var len:int = waitLoadList.length;
            var index:int = len - 1;
            while (index >= 0)
            {
                
                loadInfo = waitLoadList[index];
                _loc_6 = loadInfo.loadList.length;
                _loc_7 = _loc_6 - 1;
                while (_loc_7 >= 0)
                {
                    
                    loadData = loadInfo.loadList[_loc_7];
                    if (loadData.url == $url)
                    {
                        loadInfo.loadList.splice(_loc_7, 1);
                    }
                    _loc_7 = _loc_7 - 1;
                }
                if (loadInfo.loadList.length == 0)
                {
                    waitLoadList.splice(index, 1);
                }
                index = index - 1;
            }
            for each (_rslLoader in loaderList)
            {
                _loadInfo = _rslLoader.rslLoadingInfo;
                if (_loadInfo != null && _loadInfo.loadList.length > 0)
                {
                    _len2 = _loadInfo.loadList.length;
                    _loadlistIndex = _len2 - 1;
                    while (_loadlistIndex >= 0)
                    {
                        _loaddata = _loadInfo.loadList[_loadlistIndex];
                        if (_loaddata.url == $url)
                        {
                            _loadInfo.loadList.splice(_loadlistIndex, 1);
                        }
                        _loadlistIndex = _loadlistIndex - 1;
                    }
                    if (_rslLoader.isLoading)
                    {
                        if (_rslLoader.rslLoadData.url == $url)
                        {
                            _rslLoader.stop();
                            loadNext(_rslLoader);
                        }
                    }
                }
            }
            return;
        }
		/**
		 * 通过回调取消加载 
		 * @param $callBack 回调function
		 * 
		 */
        public static function cancelLoadByUrlCallBack($callBack:Function) : void
        {
            var _loc_4:RslLoader = null;
            var _loc_5:RslLoadingInfo = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:LoadData = null;
            var _loc_9:RslLoadingInfo = null;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:LoadData = null;
            var _loc_2:* = waitLoadList.length;
            var _loc_3:* = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_5 = waitLoadList[_loc_3];
                _loc_6 = _loc_5.loadList.length;
                _loc_7 = _loc_6 - 1;
                while (_loc_7 >= 0)
                {
                    
                    _loc_8 = _loc_5.loadList[_loc_7];
                    if (_loc_8.onComplete == $callBack)
                    {
                        _loc_5.loadList.splice(_loc_7, 1);
                    }
                    _loc_7 = _loc_7 - 1;
                }
                if (_loc_5.loadList.length == 0)
                {
                    waitLoadList.splice(_loc_3, 1);
                }
                _loc_3 = _loc_3 - 1;
            }
            for each (_loc_4 in loaderList)
            {
                
                _loc_9 = _loc_4.rslLoadingInfo;
                if (_loc_9 != null && _loc_9.loadList.length > 0)
                {
                    _loc_10 = _loc_9.loadList.length;
                    _loc_11 = _loc_10 - 1;
                    while (_loc_11 >= 0)
                    {
                        
                        _loc_12 = _loc_9.loadList[_loc_11];
                        if (_loc_12.onComplete == $callBack)
                        {
                            _loc_9.loadList.splice(_loc_11, 1);
                        }
                        _loc_11 = _loc_11 - 1;
                    }
                    if (_loc_4.isLoading)
                    {
                        if (_loc_4.rslLoadData.onComplete == $callBack)
                        {
                            _loc_4.stop();
                            loadNext(_loc_4);
                        }
                    }
                }
            }
            return;
        }

        public static function cancelLoadByUrlAndUrlCallBack($url:String, $callBack:Function) : void
        {
            var _loc_5:RslLoader = null;
            var _loc_6:RslLoadingInfo = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:LoadData = null;
            var _loc_10:RslLoadingInfo = null;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:LoadData = null;
            var _loc_3:* = waitLoadList.length;
            var _loc_4:* = _loc_3 - 1;
            while (_loc_4 >= 0)
            {
                
                _loc_6 = waitLoadList[_loc_4];
                _loc_7 = _loc_6.loadList.length;
                _loc_8 = _loc_7 - 1;
                while (_loc_8 >= 0)
                {
                    
                    _loc_9 = _loc_6.loadList[_loc_8];
                    if (_loc_9.url == $url && _loc_9.onComplete == $callBack)
                    {
                        _loc_6.loadList.splice(_loc_8, 1);
                    }
                    _loc_8 = _loc_8 - 1;
                }
                if (_loc_6.loadList.length == 0)
                {
                    waitLoadList.splice(_loc_4, 1);
                }
                _loc_4 = _loc_4 - 1;
            }
            for each (_loc_5 in loaderList)
            {
                
                _loc_10 = _loc_5.rslLoadingInfo;
                if (_loc_10 != null && _loc_10.loadList.length > 0)
                {
                    _loc_11 = _loc_10.loadList.length;
                    _loc_12 = _loc_11 - 1;
                    while (_loc_12 >= 0)
                    {
                        
                        _loc_13 = _loc_10.loadList[_loc_12];
                        if (_loc_13.url == $url && _loc_13.onComplete == $callBack)
                        {
                            _loc_10.loadList.splice(_loc_12, 1);
                        }
                        _loc_12 = _loc_12 - 1;
                    }
                    if (_loc_5.isLoading)
                    {
                        if (_loc_5.rslLoadData.url == $url && _loc_5.rslLoadData.onComplete == $callBack)
                        {
                            _loc_5.stop();
                            loadNext(_loc_5);
                        }
                    }
                }
            }
            return;
        }

        public static function cancelLoadByGroupCallBack($callBack:Function) : void
        {
            var _loc_4:RslLoader = null;
            var _loc_5:RslLoadingInfo = null;
            var _loc_6:RslLoadingInfo = null;
            var _loc_2:* = waitLoadList.length;
            var _loc_3:* = _loc_2 - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_5 = waitLoadList[_loc_3];
                if (_loc_5.callBack == $callBack)
                {
                    waitLoadList.splice(_loc_3, 1);
                }
                _loc_3 = _loc_3 - 1;
            }
            for each (_loc_4 in loaderList)
            {
                
                _loc_6 = _loc_4.rslLoadingInfo;
                if (_loc_6 != null && _loc_6.callBack == $callBack)
                {
                    _loc_6.loadList.length = 0;
                    if (_loc_4.isLoading)
                    {
                        _loc_4.stop();
                        loadNext(_loc_4);
                    }
                }
            }
            return;
        }

        private static function getFreeLoader($priority:int = 0) : RslLoader
        {
            var _rslLoader:RslLoader = null;
            var _rslLoader1:RslLoader = null;
            for each (_rslLoader in loaderList)
            {
                if (!_rslLoader.isLocked && !_rslLoader.isLoading)
                {
                    if (_rslLoader.rslLoadingInfo == null || _rslLoader.rslLoadingInfo.loadList.length == 0)
                    {
                        return _rslLoader;
                    }
                }
            }
            if (loaderList.length < MAX_THREAD)
            {
                _rslLoader = new RslLoader();
                loaderList.push(_rslLoader);
                return _rslLoader;
            }
            for each (_rslLoader in loaderList)
            {
                
                if (_rslLoader1 == null || _rslLoader1.rslLoadingInfo.priority > _rslLoader.rslLoadingInfo.priority)
                {
                    _rslLoader1 = _rslLoader;
                }
            }
            if (_rslLoader1.rslLoadingInfo.priority < $priority)
            {
                _rslLoader1.stop();
                waitLoadList.push(_rslLoader1.rslLoadingInfo);
                waitLoadList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
                return _rslLoader1;
            }
            return null;
        }

        private static function loadNext($rslLoader:RslLoader) : void
        {
            var loadInfo:RslLoadingInfo = null;
            if ($rslLoader.isLoading)
            {
                return;
            }
            if ($rslLoader.rslLoadingInfo.loadList.length == 0)
            {
                $rslLoader.isLocked = true;
                if ($rslLoader.rslLoadingInfo.callBack != null)
                {
                    $rslLoader.rslLoadingInfo.callBack();
                }
                $rslLoader.isLocked = false;
                if (waitLoadList.length > 0)
                {
                    loadInfo = waitLoadList.shift();
                    $rslLoader.rslLoadingInfo = loadInfo;
                    loadNext($rslLoader);
                }
                return;
            }
            var ld:LoadData = $rslLoader.rslLoadingInfo.loadList[0] as LoadData;
            initLoadEvent($rslLoader);
            $rslLoader.load(ld);
            return;
        }

        private static function initLoadEvent(rslLoader:RslLoader) : void
        {
            rslLoader.addEventListener(Event.COMPLETE, rslLoaderHandler);
            rslLoader.addEventListener(ProgressEvent.PROGRESS, rslLoaderHandler);
            rslLoader.addEventListener(IOErrorEvent.IO_ERROR, rslLoaderHandler);
            rslLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, rslLoaderHandler);
            return;
        }

        private static function removeLoadEvent(rslLoader:RslLoader) : void
        {
            rslLoader.removeEventListener(Event.COMPLETE, rslLoaderHandler);
            rslLoader.removeEventListener(ProgressEvent.PROGRESS, rslLoaderHandler);
            rslLoader.removeEventListener(IOErrorEvent.IO_ERROR, rslLoaderHandler);
            rslLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, rslLoaderHandler);
            return;
        }

        private static function rslLoaderHandler(event:Event) : void
        {
            var rslLoader:RslLoader = event.target as RslLoader;
            var ld:LoadData = rslLoader.rslLoadingInfo.loadList[0];
            switch(event.type)
            {
                case Event.COMPLETE:
                {
                    removeLoadEvent(rslLoader);
                    rslLoader.rslLoadingInfo.loadList.shift();
                    if (ld.onComplete != null)
                    {
                        rslLoader.isLocked = true;
                        ld.onComplete(ld, event);
                        rslLoader.isLocked = false;
                    }
                    loadNext(rslLoader);
                    break;
                }
                case ProgressEvent.PROGRESS:
                {
                    if (ld.onUpdate != null)
                    {
                        rslLoader.isLocked = true;
                        ld.onUpdate(ld, event);
                        rslLoader.isLocked = false;
                    }
                    break;
                }
                case IOErrorEvent.IO_ERROR:
                case SecurityErrorEvent.SECURITY_ERROR:
                {
                    Logger.info("RslLoaderManager: 加载" + ld.url + "失败");
                    removeLoadEvent(rslLoader);
                    rslLoader.rslLoadingInfo.loadList.shift();
                    if (ld.onError != null)
                    {
                        rslLoader.isLocked = true;
                        ld.onError(ld, event);
                        rslLoader.isLocked = false;
                    }
                    loadNext(rslLoader);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

    }
}
