package com.thinkido.framework.common.privatehome
{
	import flash.utils.Dictionary;

    public class PrivateHome extends Object
    {
        private var _objDict:Dictionary;

        public function PrivateHome()
        {
            this._objDict = new Dictionary();
            return;
        }

        public function addObject(value1:Object) : void
        {
            this._objDict[value1] = true;
            return;
        }

        public function removeObject(value1:Object) : void
        {
            this._objDict[value1] = null;
            delete this._objDict[value1];
            return;
        }

        public function clear() : void
        {
            var _loc_1:* = undefined;
            for each (_loc_1 in this._objDict)
            {
                
                this._objDict[_loc_1] = null;
                delete this._objDict[_loc_1];
            }
            return;
        }

    }
}
