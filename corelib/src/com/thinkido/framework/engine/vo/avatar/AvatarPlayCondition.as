package com.thinkido.framework.engine.vo.avatar
{
	/**
	 * 播放条件,用于控制动画是否停在特征帧。如死亡后停在 最后一帧
	 * @author Administrator
	 * 
	 */
    public class AvatarPlayCondition extends Object
    {
        public var playAtBegin:Boolean;
        public var stayAtEnd:Boolean;
        public var showEnd:Boolean;

        public function AvatarPlayCondition(atBegin:Boolean = false, atEnd:Boolean = false, $showEnd:Boolean = false)
        {
            playAtBegin = atBegin;
            stayAtEnd = atEnd;
            showEnd = $showEnd;
            return;
        }

        public function clone() : AvatarPlayCondition
        {
            return new AvatarPlayCondition(playAtBegin, stayAtEnd, showEnd) ;
        }

    }
}
