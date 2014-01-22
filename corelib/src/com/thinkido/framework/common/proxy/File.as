//Created by Action Script Viewer - http://www.buraks.com/asv
package com.thinkido.framework.common.proxy {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class File {

        public static const limit:int = 3;

        public static var onVersion:Function;
        private static var _temp:Dictionary = new Dictionary();
        private static var _id:int = 0;
        private static var _processes:Object = {};

        private var _uri:String;
        private var _loader:Loader;
        private var _applicationDomain:ApplicationDomain;
        private var _useNewDomain:Boolean = false;
        public var onProgress:Function;
        public var onComplete:Function;
        public var onError:Function;
        private var _lastBytes:uint = 0;
        private var _speed:Number = 0;
        private var _urlRnd:int = 0;
        private var _timer:Timer;
        private var _reloadCount:int = 3;

        public function File(){
            this._loader = new Loader();
            this.addTemp();
            this._reloadCount = File.limit;
        }
        public static function loadList(_arg1:Array, _arg2:Function, _arg3:Function=null, _arg4:Function=null, _arg5:Function=null):int{
            _id++;
            _processes[_id] = true;
            loadOne(_arg1, 0, [], _arg2, _arg3, _arg4, _arg5, _id);
            return (_id);
        }
        public static function stopLoadList(_arg1:int):void{
            if (((_arg1) && (_processes[_arg1]))){
                _processes[_arg1] = false;
            };
        }
        private static function loadOne(_arg1:Array, _arg2:int, _arg3:Array, _arg4:Function, _arg5:Function=null, _arg6:Function=null, _arg7:Function=null, _arg8:int=0):void{
            var len:* = 0;
            var list:* = _arg1;
            var index:* = _arg2;
            var temp:* = _arg3;
            var callback:* = _arg4;
            var progress:Function = _arg5;
            var oneCompleted:Function = _arg6;
            var error:Function = _arg7;
            var id:int = _arg8;
            var file:* = new (File)();
            temp.push(file);
            len = list.length;
            file.onComplete = function ():void{
                if (false == _processes[id]){
                    delete _processes[id];
                    return;
                };
                if ((index + 1) >= len){
                    delete _processes[id];
                    callback(temp);
                } else {
                    if ((oneCompleted is Function)){
                        oneCompleted(index);
                    };
                    loadOne(list, (index + 1), temp, callback, progress, oneCompleted, error, id);
                };
            };
            file.onProgress = function (_arg1:int, _arg2:int, _arg3:String):void{
                var _local4:int;
                if ((progress is Function)){
                    _local4 = Math.floor(((_arg2 / _arg1) * 100));
                    _local4 = Math.min(100, _local4);
                    if (progress.length == 4){
                        progress(len, index, _local4, _arg3);
                    } else {
                        if (progress.length == 3){
                            progress(index, _local4, _arg3);
                        } else {
                            progress(index, _local4);
                        };
                    };
                };
            };
            file.onError = function ():void{
                if ((error is Function)){
                    error(index);
                };
            };
            file.load(list[index]);
        }

        private function addEvent():void{
            var _local1:LoaderInfo = this._loader.contentLoaderInfo;
            _local1.addEventListener(Event.COMPLETE, this.complete);
            _local1.addEventListener(ProgressEvent.PROGRESS, this.progress);
            _local1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            _local1.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _local1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }
        private function removeEvent():void{
            var _local1:LoaderInfo = this._loader.contentLoaderInfo;
            _local1.removeEventListener(Event.COMPLETE, this.complete);
            _local1.removeEventListener(ProgressEvent.PROGRESS, this.progress);
            _local1.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatus);
            _local1.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _local1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }
        public function load(_arg1:String):void{
            this._uri = _arg1;
            var _local2:String = "";
            if ((onVersion is Function)){
                _local2 = onVersion(_arg1);
                if (_local2 != ""){
                    _local2 = ("?v=" + _local2);
                };
            };
            if (this._urlRnd){
                _local2 = (_local2 + (((_local2) ? "&" : "?" + "r=") + this._urlRnd));
            };
            var _local3:URLRequest = new URLRequest((this._uri + _local2));
            var _local4:LoaderContext = new LoaderContext();
            _local4.checkPolicyFile = true;
            _local4.applicationDomain = (this._useNewDomain) ? new ApplicationDomain() : new ApplicationDomain(ApplicationDomain.currentDomain);
            this.addEvent();
            this._loader.load(_local3, _local4);
        }
        private function complete(_arg1:Event):void{
            this._applicationDomain = this._loader.contentLoaderInfo.applicationDomain;
            if ((this.onComplete is Function)){
                this.onComplete();
            };
            this.removeEvent();
            this.removeTemp();
        }
        private function progress(_arg1:ProgressEvent):void{
            var _local2:int;
            var _local3:int;
            if ((this.onProgress is Function)){
                if (this.onProgress.length == 3){
                    if ((_arg1.bytesLoaded - this._lastBytes) > 0){
                        this._speed = (_arg1.bytesLoaded - this._lastBytes);
                        this._lastBytes = _arg1.bytesLoaded;
                        _local2 = (this._speed / 0x0400);
                        _local3 = (this._speed % 0x0400);
                        this._speed = (_local2 + (Math.floor(((_local3 / 0x0400) * 10)) / 10));
                    };
                    this.onProgress(_arg1.bytesTotal, _arg1.bytesLoaded, (this._speed + "kb/s"));
                } else {
                    this.onProgress(_arg1.bytesTotal, _arg1.bytesLoaded);
                };
            };
        }
        private function httpStatus(_arg1:HTTPStatusEvent):void{
        }
        private function securityErrorHandler(_arg1:SecurityErrorEvent):void{
            this.delayToLoad();
        }
        private function ioErrorHandler(_arg1:IOErrorEvent):void{
            this.delayToLoad();
        }
        private function addTemp():void{
            File._temp[this] = 1;
        }
        private function removeTemp():void{
            delete File._temp[this];
        }
        private function delayToLoad():void{
            this._loader.unload();
            if (this._reloadCount <= 0){
                this.stopLoad();
                this.removeEvent();
                this.removeTemp();
                if ((this.onError is Function)){
                    this.onError();
                };
                return;
            };
            this._reloadCount--;
            this._timer = new Timer(100, 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.startLoad);
            this._timer.start();
        }
        private function startLoad(_arg1:TimerEvent):void{
            this.stopLoad();
            this._urlRnd++;
            if (this._urlRnd == 3){
                this._urlRnd = (Math.random() * 100);
            };
            this.load(this._uri);
        }
        private function stopLoad():void{
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.startLoad);
        }
        public function getClassByName(_arg1:String):Class{
            var className:* = _arg1;
            try {
                return ((this._applicationDomain.getDefinition(className) as Class));
            } catch(e:Error) {
                throw (new Error(((((className + " not found in ") + _uri) + "\n") + e)));
            };
            return (null);
        }
        public function getClassObject(_arg1:String):Object{
            var _local2:Class = (this.getClassByName(_arg1) as Class);
            return (new (_local2)());
        }
        public function get loader():Loader{
            return (this._loader);
        }
        public function get applicationDomain():ApplicationDomain{
            return (this._applicationDomain);
        }
        public function set useNewDomain(_arg1:Boolean):void{
            this._useNewDomain = _arg1;
        }
        public function get bytes():ByteArray{
            return (this._loader.contentLoaderInfo.bytes);
        }
        public function get bitmap():Bitmap{
            return ((this._loader.content as Bitmap));
        }

    }
}//package com.haloer.net 
