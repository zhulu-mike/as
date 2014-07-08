package com.thinkido.framework.common.observer
{

    public class Notification extends Object
    {
        public var name:String;
        public var body:Object;

        public function Notification($name:String, $body:* = null):void
        {
            this.name = $name;
            this.body = $body;
            return;
        }

    }
}
