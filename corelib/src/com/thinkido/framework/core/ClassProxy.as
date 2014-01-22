package com.thinkido.framework.core
{

    public class ClassProxy extends Object
    {

        public function ClassProxy()
        {
            return;
        }

        public function write(param1:Object) : void
        {
            var _loc_2:* = undefined;
            for (_loc_2 in param1)
            {
                
                if (this.hasOwnProperty(_loc_2))
                {
                    this[_loc_2] = param1[_loc_2];
                }
            }
            return;
        }

    }
}
