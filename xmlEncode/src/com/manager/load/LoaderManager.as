package com.manager.load
{
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.loadingtypes.LoadingItem;
    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    

    public class LoaderManager extends Object
    {
        private static var _defaultLoader:BulkLoader = new BulkLoader("default");

        public function LoaderManager()
        {
            throw new Event("静态类");
        }// end function

		/**
		 * 创建  bulkLoader 
		 * @param name id
		 * @param comFun complete handler
		 * @param progressFun progress handler
		 * @param errorFun error handler
		 * @param numConn numConnections:int — numConnections The number of maximum simultaneous connections to be open.
		 * @param logLevel logLevel:int — logLevel At which level should traces be outputed. By default only errors will be traced. 
		 * @return bulkLoader
		 * 
		 */		
        public static function creatNewLoader(name:String, comFun:Function = null, progressFun:Function = null, errorFun:Function = null, numConn:int = 7, logLevel:int = 4) : BulkLoader
        {
			var tempBulk:BulkLoader = BulkLoader.getLoader(name) ;
			if( !tempBulk ){
				tempBulk = new BulkLoader(name, numConn, logLevel);
			}
            if (comFun != null)
            {
                tempBulk.addEventListener(BulkLoader.COMPLETE, comFun);
            }
            if (progressFun != null)
            {
                tempBulk.addEventListener(BulkLoader.PROGRESS, progressFun);
            }
            if (errorFun != null)
            {
                tempBulk.addEventListener(BulkLoader.ERROR, errorFun);
                tempBulk.addEventListener(IOErrorEvent.IO_ERROR, errorFun);
            }
            addLoaderEventListeners(tempBulk);
            return tempBulk;
        }// end function
		
		/**
		 * @return BulkLoader("default");
		 */
        public static function getDefaultLoader() : BulkLoader
        {
            return _defaultLoader;
        }// end function
		/**
		 * 
		 * @param loadData 加载数组队列
		 * @param $loader 加载器
		 * @param param3  ture:队列加载  false:同时加载
		 * @return 
		 * 
		 */
        public static function load(loadData:Array, $loader:BulkLoader = null, isQueue:Boolean = false) : BulkLoader
        {
            var item:LoadData = null;
            $loader = $loader || _defaultLoader;
            addLoaderEventListeners($loader);
            if (!loadData || loadData.length == 0)
            {
                return $loader;
            }
            if (isQueue)
            {
                loadNext($loader, loadData);
            }
            else
            {
                for each (item in loadData)
                {
                    loadNext($loader, [item]);
                }
            }
            if ($loader.itemsTotal != 0 && !$loader.isRunning)
            {
                $loader.start();
            }
            return $loader;
        }// end function

        public static function lazyLoad(loadComplete:Function = null, loader:BulkLoader = null, isQueue:Boolean = false, ... args) : BulkLoader
        {
            var $onItemLoadComplete:Function = loadComplete;
            var $loader:BulkLoader = loader;
            var $oneByOne:Boolean = isQueue;
            var loadDataArr:Array = args;
            $loader =  $loader || _defaultLoader;
            if (!loadDataArr || loadDataArr.length == 0)
            {
                return $loader;
            }
//			临时注释
			var loadList:Array = [];
			var ld:LoadData ;
			for (var i:int = 0; i < loadDataArr.length; i++) 
			{
				ld = new LoadData(loadDataArr[i],$onItemLoadComplete);
				loadList.push(ld);
			}            
            return load( loadList , $loader , $oneByOne);
        }// end function
		/**
		 * 
		 * @param key 要取消的url 或者 id loadingItem
		 * @param loader 要取消的loader
		 * 
		 */
        public static function cancelLoadByKey(key:*, loader:BulkLoader = null) : void
        {
            loader = loader || _defaultLoader;
            loader.remove(key, false);
            return;
        }// end function
		/**
		 *  取消loader加载
		 * @param loader 默认为空时调用 default loader
		 * 
		 */
        public static function cancelLoadAll(loader:BulkLoader = null) : void
        {
            loader = loader || _defaultLoader;
            loader.removeAll();
            return;
        }// end function

        private static function loadNext(loader:BulkLoader, loadData:Array) : void
        {
            var ld:LoadData;
            var $loader:BulkLoader = loader;
            var $oneByOneLoadDataArr:Array = loadData;
            if (!$loader || !$oneByOneLoadDataArr || $oneByOneLoadDataArr.length == 0)
            {
                return;
            }
            ld = $oneByOneLoadDataArr.shift();
            if (ld == null)
            {
                return;
            }
            var loadItem:LoadingItem = $loader.add(ld.url, {id:ld.key});
            loadItem.addEventListener(Event.COMPLETE, function (event:Event) : void
	            {
	                if (ld.onComplete != null)
	                {
	                    ld.onComplete(event);
	                }
	                loadNext($loader, $oneByOneLoadDataArr);
	                return;
	            }// end function
            );
            loadItem.addEventListener(ErrorEvent.ERROR, function (event:ErrorEvent) : void
	            {
	                if (ld.onError != null)
	                {
	                    ld.onError(event);
	                }
	                loadNext($loader, $oneByOneLoadDataArr);
	                return;
	            }// end function
            );
            if (ld.onUpdate != null)
            {
                loadItem.addEventListener(ProgressEvent.PROGRESS, ld.onUpdate);
            }
            $loader.loadNow(loadItem);
            changeItemPriority($loader, loadItem, ld.priority);
            return;
        }// end function

        private static function changeItemPriority($loader:BulkLoader, key:*, $priority:int) : Boolean
        {
            if (!$loader)
            {
                return false;
            }
            var item:LoadingItem = $loader.get(key);
            if (!item)
            {
                return false;
            }
            item._priority = $priority;
            $loader.sortItemsByPriority();
            return true;
        }// end function

        private static function addLoaderEventListeners($loader:BulkLoader) : void
        {
            if (!$loader)
            {
                return;
            }
            $loader.addEventListener(BulkLoader.COMPLETE, loaderHandle, false, -int.MAX_VALUE);
            $loader.addEventListener(BulkLoader.PROGRESS, loaderHandle, false, -int.MAX_VALUE);
            $loader.addEventListener(BulkLoader.ERROR, loaderHandle, false, -int.MAX_VALUE);
            $loader.addEventListener(IOErrorEvent.IO_ERROR, loaderHandle, false, -int.MAX_VALUE);
            return;
        }// end function

        private static function loaderHandle(evt:*) : void
        {
            if (evt == null || evt.type == null)
            {
                return;
            }
            switch(evt.type)
            {
                case BulkLoader.COMPLETE:
                {
                    BulkLoader(evt.target).removeAll();
                    break;
                }
                case BulkLoader.PROGRESS:
                {
                    break;
                }
                case BulkLoader.ERROR:
                case IOErrorEvent.IO_ERROR:
                {
                    BulkLoader(evt.target).removeFailedItems();
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
