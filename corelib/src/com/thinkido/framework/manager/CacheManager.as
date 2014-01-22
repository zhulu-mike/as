package com.thinkido.framework.manager
{
    
    import com.thinkido.framework.common.cache.Cache;
    
    import org.osflash.thunderbolt.Logger;
	/**
	 * 缓存管理器 
	 * @author thinkido
	 * 
	 */
    public class CacheManager extends Object
    {
        private static var _cacheArr:Array = [];

        public function CacheManager()
        {
            throw new Error("Can not New!");
        }

		public static function hasCache($cache:Cache) : Boolean
        {
            return _cacheArr.indexOf($cache) != -1;
        }

        public static function hasNamedCache($name:String) : Boolean
        {
            var cache:Cache = null;
            for each (cache in _cacheArr)
            {
                
                if (cache.name == $name)
                {
                    return true;
                }
            }
            return false;
        }

        public static function getCache($name:String) : Cache
        {
            var cache:Cache = null;
            for each (cache in _cacheArr)
            {
                
                if (cache.name == $name)
                {
                    return cache;
                }
            }
            return null;
        }
		/**
		 *  
		 * @see Cache#Cache()
		 */
        public static function creatNewCache($name:String = "", $maxSize:int = 2147483647) : Cache
        {
            var temp:Cache = new Cache($name, $maxSize);
            _cacheArr[_cacheArr.length] = new Cache($name, $maxSize);
            
            Logger.info("CacheManager.creatNewCache::_cacheArr.length:" + getCachesNum());
            return temp;
        }

        public static function deleteCache($cache:Cache) : void
        {
            var cache:Cache = null;
            for each (cache in _cacheArr)
            {
                
                if (cache == $cache)
                {
                    _cacheArr.splice(_cacheArr.indexOf($cache), 1);
                    Logger.info("CacheManager.deleteCache::_cacheArr.length:" + getCachesNum());
                    cache.dispose();
                    break;
                }
            }
            return;
        }

        public static function deleteCacheByName($name:String) : void
        {
            var cache:Cache = null;
            for each (cache in _cacheArr)
            {
                
                if (cache.name == $name)
                {
                    _cacheArr.splice(_cacheArr.indexOf(cache), 1);
                    Logger.info("CacheManager.deleteCacheByName::_cacheArr.length:" + getCachesNum());
                    cache.dispose();
                    break;
                }
            }
            return;
        }

        public static function deleteAllCaches() : void
        {
            var cache:Cache = null;
            for each (cache in _cacheArr)
            {
                
                cache.dispose();
            }
            _cacheArr = [];
            Logger.info("CacheManager.deleteAllCaches::_cacheArr.length:0");
            return;
        }

        public static function getCachesNum() : int
        {
            return _cacheArr.length;
        }

    }
}
