//Created by Action Script Viewer - http://www.buraks.com/asv
package com.thinkido.framework.common.proxy {
    import flash.events.*;
    import flash.net.*;

    public class HTTP {

        private var _loader:URLLoader;
        private var _method:String;
        public var url:String;
        public var data:Object;
        public var onComplete:Function;
        public var onError:Function;

        public function HTTP(_arg1:String="text", _arg2:String="get"){
            this._loader = new URLLoader();
            this._loader.dataFormat = _arg1;
            this._method = _arg2;
        }
        public function load(_arg1:String=""):void{
            var _local3:URLVariables;
            var _local4:String;
            if ((((_arg1 == "")) && ((this.url == "")))){
                throw (new Error("无效的url！"));
            };
            if (_arg1){
                this.url = _arg1;
            };
            this.addEvent();
            var _local2:URLRequest = new URLRequest(this.url);
            _local2.method = this._method;
            if (this.data){
                _local3 = new URLVariables();
                for (_local4 in this.data) {
                    _local3[_local4] = this.data[_local4];
                };
                _local2.data = _local3;
            };
            this._loader.load(_local2);
        }
        private function addEvent():void{
            this._loader.addEventListener(Event.COMPLETE, this.complete);
            this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._loader.addEventListener(Event.OPEN, this.openHandler);
            this._loader.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        }
        private function removeEvent():void{
            this._loader.removeEventListener(Event.COMPLETE, this.complete);
            this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._loader.removeEventListener(Event.OPEN, this.openHandler);
            this._loader.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        }
        private function progressHandler(_arg1:ProgressEvent):void{
        }
        private function openHandler(_arg1:Event):void{
        }
        private function complete(_arg1:Event):void{
            this.removeEvent();
            if ((this.onComplete is Function)){
                this.onComplete(_arg1.target.data);
            };
        }
        private function httpStatus(_arg1:HTTPStatusEvent):void{
        }
        private function ioErrorHandler(_arg1:IOErrorEvent):void{
            this.removeEvent();
            if ((this.onError is Function)){
                this.onError();
            };
        }
        private function securityErrorHandler(_arg1:SecurityErrorEvent):void{
            this.removeEvent();
            if ((this.onError is Function)){
                this.onError();
            };
        }
        public function get loader():URLLoader{
            return (this._loader);
        }

    }
}//package com.haloer.net 
