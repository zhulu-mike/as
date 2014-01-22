package com.thinkido.framework.common.linkedlist
{
	import com.thinkido.framework.common.pool.IPoolClass;

	/**
	 * 链表 
	 * @author thinkido
	 * 数据结构链表存储，加快存取速度
	 */
    public class LNode extends Object implements IPoolClass
    {
        private var _id:String;
        private var _data:Object;
        private var _pre:LNode;
        private var _next:LNode;

        public function LNode($bounds:Object, $id:String = null)
        {
			reSet([$bounds,$id,null,null]);
            return;
        }

        public function get pre() : LNode
        {
            return this._pre;
        }

        public function set pre(value1:LNode) : void
        {
            this._pre = value1;
            return;
        }

        public function get next() : LNode
        {
            return this._next;
        }

        public function set next(value1:LNode) : void
        {
            this._next = value1;
            return;
        }

        public function get data() : Object
        {
            return this._data;
        }

        public function set data(value1:Object) : void
        {
            this._data = value1;
            return;
        }

        public function get id() : String
        {
            return this._id;
        }

		public function dispose():void
		{
			this._data = null;
			this._id = "";
			this._next = null;
			this._pre = null;
		}

		public function reSet($inins:Array):void
		{
			this._data = $inins[0];
			this._id = $inins[1] ;
			this._next = $inins[2] ;
			this._pre = $inins[3] ;
		}


    }
}
