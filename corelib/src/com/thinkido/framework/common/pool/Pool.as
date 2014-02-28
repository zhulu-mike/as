package com.thinkido.framework.common.pool
{
	import com.thinkido.framework.manager.RslLoaderManager;

    public class Pool extends Object
    {
        private var _name:String;
        private var _maxSize:int;
        private var _objArr:Vector.<IPoolClass>;

        public function Pool($name:String = "", $maxSize:int = 2147483647)
        {
            if ($maxSize < 0)
            {
                throw new Error("Pool constructor error , wrong values!");
            }
            this._name = $name;
            this._maxSize = $maxSize;
            this._objArr = new Vector.<IPoolClass>() ;
            return;
        }

        public function createObj($class:Class, ... args) : IPoolClass
        {
            var temp:IPoolClass ;
            if (this._objArr.length == 0)
            {
				temp = RslLoaderManager.getInstanceByClass($class, args);
            }
            else
            {
				temp = this._objArr.shift();
				temp.reSet(args);
            }
            return temp;
        }

        public function disposeObj(value1:IPoolClass) : void
        {
            if (value1 == null)
            {
                return;
            }
            value1.dispose();
//            if (this._objArr.indexOf(value1) == -1)
//            {
                this._objArr[this._objArr.length] = value1;
                this.resize(this._maxSize);
//            }
            return;
        }

        public function getRestingObjsNum() : int
        {
            return this._objArr.length;
        }

        public function resize(value1:int) : void
        {
            if (value1 < 0)
            {
                return;
            }
            this._maxSize = value1;
            while (this._objArr.length > this._maxSize)
            {
                
                this._objArr.shift();
            }
            return;
        }

        public function removeObj(value1:IPoolClass) : void
        {
            value1.dispose();
            var _loc_2:* = this._objArr.indexOf(value1);
            if (_loc_2 != -1)
            {
                this._objArr.splice(_loc_2, 1);
            }
            return;
        }

        public function removeAllObjs() : void
        {
            var _loc_1:IPoolClass = null;
            for each (_loc_1 in this._objArr)
            {
                _loc_1.dispose();
            }
            this._objArr = new Vector.<IPoolClass>() ;
            return;
        }

        public function get name() : String
        {
            return this._name;
        }

    }
}
