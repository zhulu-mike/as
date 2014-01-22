package com.thinkido.framework.common.cache
{
	import com.thinkido.framework.common.linkedlist.LNode;
	
	import flash.utils.Dictionary;
	/**
	 * 缓存类 
	 * @author thinkido
	 * 
	 */
    public class Cache extends Object
    {
        private var _name:String;
        private var _length:int;
        private var _maxSize:int;
        private var _head:LNode;
		/**
		 * 缓存字典 
		 */		
        private var _dict:Dictionary;
        private static var _nextId:int = 0;
		/**
		 *  
		 * @param $name
		 * @param $maxSize 最大个数，默认值2147483647 == 2的31次方-1
		 * 
		 */
        public function Cache($name:String = "", $maxSize:int = 2147483647)
        {
            if ($maxSize < 0)
            {
                throw new Error("缓存个数必须为非负数");
            }
            this._name = $name != "" ? ($name) : ("Cache" + _nextId++);
            this._maxSize = $maxSize;
            this._head = null;
            this._length = 0;
            this._dict = new Dictionary();
            return;
        }

        public function has(key:String) : Boolean
        {
            return this._dict[key] != null;
        }

        public function get(key:String) : Object
        {
            var _value:* = this._dict[key];
            this.promote(_value);
            return _value.data;
        }

        public function remove(key:String) : void
        {
            var ln:LNode = this._dict[key];
            if (ln)
            {
                if (ln == this._head)
                {
                    this._head = this._head.pre;
                }
                ln.pre.next = ln.next;
                ln.next.pre = ln.pre;
                this.destroy(ln);
				_length -= 1  ;
            }
            return;
        }
		/**
		 * 添加缓存数据 ，如果大于最大个数则删除第一个
		 * @param $data 缓存数据
		 * @param $key 缓存数据的id
		 * 
		 */
        public function push($data:Object, $key:String) : void
        {
            var _lNode:LNode = null;
            if (this.has($key))
            {
                this.promote(this._dict[$key]);
                return;
            }
            _lNode = new CacheUnit($data, $key);
            this._dict[$key] = _lNode;
            if (this._length == 0)
            {
                this._head = _lNode;
                this._head.pre = _lNode;
                this._head.next = _lNode;
            }
            else
            {
                _lNode.pre = this._head;
                _lNode.next = this._head.next;
                _lNode.pre.next = _lNode;
                _lNode.next.pre = _lNode;
                this._head = _lNode;
            }
			_length += 1 ;
            if (this._length > this._maxSize)
            {
                _lNode = this._head.next;
                _lNode.pre.next = _lNode.next;
                _lNode.next.pre = _lNode.pre;
                this.destroy(_lNode);
				_length -= 1 ;
            }
            return;
        }
		/**
		 * 重新设置 最大长度个数， 多余的从最后删除
		 * @param $maxSize 最大长度个数
		 * 
		 */
        public function resize($maxSize:int) : void
        {
            var _lNode:LNode = null;
            if ($maxSize < 0 || $maxSize == this._maxSize)
            {
                return;
            }
            while (this._length > $maxSize)
            {
                _lNode = this._head.next;
                _lNode.pre.next = _lNode.next;
                _lNode.next.pre = _lNode.pre;
                this.destroy(_lNode);
				_length -= 1 ;
            }
            this._maxSize = $maxSize;
            return;
        }
		/**
		 * 清空所有数据 ，保持最大个数
		 */
        public function dispose() : void
        {
            var temp:int = this._maxSize;
            this.resize(0);
            this._maxSize = temp;
            return;
        }
		/**
		 * 获取字典中的所有key 
		 * @return keys 数组
		 * 
		 */
        public function getAllKeys() : Array
        {
            var item:CacheUnit = null;
            var keys:Array = [];
            for each (item in this._dict)
            {
                keys.push(item.id);
            }
            return keys;
        }
		/**
		 * 获取所有values  
		 * @return 字典中 的value
		 * 
		 */
        public function getAllValues() : Array
        {
            var item:CacheUnit = null;
            var values:Array = [];
            for each (item in this._dict)
            {
                values.push(item.data);
            }
            return values;
        }

        public function get name() : String
        {
            return this._name;
        }

        public function get length() : int
        {
            return this._length;
        }

        private function promote(cu:CacheUnit) : void
        {
            if (cu == null || cu == this._head)
            {
                return;
            }
            if (cu.pre == this._head)
            {
                this._head = cu;
            }
            else
            {
                cu.next.pre = cu.pre;
                cu.pre.next = cu.next;
                cu.pre = this._head;
                cu.next = this._head.next;
                this._head.next.pre = cu;
                this._head.next = cu;
                this._head = cu;
            }
            return;
        }
		/**
		 * 删除节点 
		 * @param ln
		 * 
		 */
        private function destroy(ln:LNode) : void
        {
            delete this._dict[ln.id];
            (ln as CacheUnit).dispose();
            ln = null;
            return;
        }

    }
}
