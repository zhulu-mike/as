//Created by Action Script Viewer - http://www.buraks.com/asv
package com.thinkido.framework.common.proxy {
    import flash.events.*;
    import flash.net.*;

    public class Cookie {

        private var _so:SharedObject;

        public function Cookie(_arg1:String){
            if (_arg1 == ""){
                throw (new Error("name must not be empty!"));
            };
            this._so = SharedObject.getLocal(_arg1);
            this._so.addEventListener(NetStatusEvent.NET_STATUS, this.handler);
        }
        private function handler(_arg1:NetStatusEvent):void{
        }
        public function setCookie(_arg1:String, _arg2:Object):void{
            var name:* = _arg1;
            var value:* = _arg2;
            try {
                this._so.data[name] = value;
                this._so.flush(5000);
            } catch(e:Error) {
            };
        }
        public function getCookie(_arg1:String):Object{
            return (this._so.data[_arg1]);
        }
        public function clear(_arg1:String=""):void{
            if (_arg1){
                this._so.data[_arg1] = "";
            } else {
                this._so.clear();
            };
        }

    }
}//package com.haloer.net 
