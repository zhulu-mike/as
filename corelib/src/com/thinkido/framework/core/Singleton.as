package com.thinkido.framework.core
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	/**
	 * 单例类,作为基类使用 
	 * @author Administrator
	 * 
	 */
    public class Singleton extends EventDispatcher
    {
        private static var dict:Dictionary = new Dictionary();

        public function Singleton()
        {
            var _className:Class = this["constructor"] as Class;
            if (dict[_className])
            {
                throw new IllegalOperationError(getQualifiedClassName(this) + " 只允许实例化一次！");
            }
            dict[_className] = this;
            return;
        }

        public function destory() : void
        {
            var _className:Class = this["constructor"] as Class;
            delete dict[_className];
            return;
        }

        public static function getInstance($className:Class):*
        {
            return dict[$className];
        }

        public static function getInstanceOrCreate($className:Class):*
        {
            var _intance:* = dict[$className];
            if (!_intance)
            {
                _intance = new $className;
                dict[$className] = _intance;
            }
            return _intance;
        }

        public static function create($class:Class):*
        {
            var _intance:* = new $class;
            dict[$class] = _intance;
            return _intance;
        }

    }
}
