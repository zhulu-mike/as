package com.thinkido.framework.common.observer
{

    public class Observer extends Object
    {
        public var notifyMethod:Function;
        public var notifyContext:Object;

        public function Observer($method:Function, $context:Object):void
        {
            this.notifyMethod = $method;
            this.notifyContext = $context;
            return;
        }

        public function notifyObserver($notification:Notification) : void
        {
            this.notifyMethod.apply(this.notifyContext, [$notification]);
            return;
        }

        public function compareNotifyContext($nontext:*) : Boolean
        {
            return $nontext === this.notifyContext;
        }

    }
}
