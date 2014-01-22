package com.thinkido.framework.engine.vo.avatar
{
	/**
	 * AvatarParamData 回调方法 
	 * @author thinkido
	 * 
	 */
    public class AvatarPlayCallBack extends Object
    {
        public var onPlayBeforeStart:Function;
        public var onPlayStart:Function;
        public var onPlayUpdate:Function;
        public var onPlayComplete:Function;
        public var onAdd:Function;
        public var onRemove:Function;

        public function AvatarPlayCallBack()
        {
            return;
        }

        public function clone() : AvatarPlayCallBack
        {
            var temp:AvatarPlayCallBack = new AvatarPlayCallBack();
            temp.onPlayBeforeStart = this.onPlayBeforeStart;
            temp.onPlayStart = this.onPlayStart;
            temp.onPlayUpdate = this.onPlayUpdate;
            temp.onPlayComplete = this.onPlayComplete;
            temp.onAdd = this.onAdd;
            temp.onRemove = this.onRemove;
            return temp;
        }

    }
}
