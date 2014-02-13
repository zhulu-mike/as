package com.thinkido.framework.common.share
{

    public class CountShareData extends Object
    {
        public var count:int = 0;

        public function CountShareData()
        {
            return;
        }

        public function destroy() : void
        {
            throw Error("此方法必须被复写");
        }

    }
}
