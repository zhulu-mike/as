package com.manager.load
{

    public class LoadData extends Object
    {
        private var _url:String;
        private var _name:String;
        private var _key:String;
        private var _priority:int;
        private var _onComplete:Function;
        private var _onUpdate:Function;
        private var _onError:Function;
        private var _decode:Function;
        private var _userData:Object;

        public function LoadData($url:String, compFun:Function = null, progressFun:Function = null, errorFun:Function = null, $name :String = "", $key:String = "", $priority:int = 0, decodeFun:Function = null)
        {
            this._url = $url;
            this._name = $name;
            this._key = $key;
            this._priority = $priority;
            this._onComplete = compFun;
            this._onUpdate = progressFun;
            this._onError = errorFun;
            this._decode = decodeFun;
            return;
        }

        public function get userData() : Object
        {
            if (this._userData == null)
            {
                this._userData = {};
            }
            return this._userData;
        }

        public function get url() : String
        {
            return this._url;
        }

        public function get name() : String
        {
            return this._name;
        }

        public function get key() : String
        {
            return this._key;
        }

        public function get priority() : int
        {
            return this._priority;
        }

        public function get onComplete() : Function
        {
            return this._onComplete;
        }

        public function get onUpdate() : Function
        {
            return this._onUpdate;
        }

        public function get onError() : Function
        {
            return this._onError;
        }

        public function get decode() : Function
        {
            return this._decode;
        }

    }
}
