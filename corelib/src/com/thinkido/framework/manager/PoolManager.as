package com.thinkido.framework.manager
{
    
    import com.thinkido.framework.common.pool.Pool;
    
    import org.osflash.thunderbolt.Logger;
	/**
	 * 对象池管理工具，统一管理pool
	 * @author thinkido
	 * 
	 */
    public class PoolManager extends Object
    {
        private static var _poolArr:Array = [];

        public function PoolManager()
        {
            throw new Error("Can not New!");
        }

        public static function hasPool(param1:Pool) : Boolean
        {
            return _poolArr.indexOf(param1) != -1;
        }

        public static function hasNamedPool(param1:String) : Boolean
        {
            var _loc_2:Pool = null;
            for each (_loc_2 in _poolArr)
            {
                
                if (_loc_2.name == param1)
                {
                    return true;
                }
            }
            return false;
        }

        public static function getPool(param1:String) : Pool
        {
            var _loc_2:Pool = null;
            for each (_loc_2 in _poolArr)
            {
                
                if (_loc_2.name == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }

        public static function creatPool(param1:String = "", param2:int = 2.14748e+009) : Pool
        {
            var _loc_3:Pool = null;
            if (!hasNamedPool(param1))
            {
                var _loc_4:* = new Pool(param1, param2);
                _poolArr[_poolArr.length] = new Pool(param1, param2);
                _loc_3 = _loc_4;
                Logger.info("PoolManager.creatPool::_poolArr.length:" + getPoolsNum());
            }
            else
            {
                _loc_3 = getPool(param1);
                _loc_3.resize(param2);
            }
            return _loc_3;
        }

        public static function deletePool(param1:Pool) : void
        {
            if (!param1)
            {
                return;
            }
            var _loc_2:* = _poolArr.indexOf(param1);
            if (_loc_2 != -1)
            {
                _poolArr.splice(_loc_2, 1);
            }
            param1.removeAllObjs();
            return;
        }

        public static function deletePoolByName(param1:String) : void
        {
            var _loc_2:Pool = null;
            for each (_loc_2 in _poolArr)
            {
                
                if (_loc_2.name == param1)
                {
                    _poolArr.splice(_poolArr.indexOf(_loc_2), 1);
                    _loc_2.removeAllObjs();
                    break;
                }
            }
            return;
        }

        public static function deleteAllPools() : void
        {
            var _loc_1:Pool = null;
            for each (_loc_1 in _poolArr)
            {
                
                _loc_1.removeAllObjs();
            }
            _poolArr = [];
            return;
        }

        public static function getPoolsNum() : int
        {
            return _poolArr.length;
        }

    }
}
