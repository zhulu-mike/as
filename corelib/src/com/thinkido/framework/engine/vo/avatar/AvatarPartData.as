package com.thinkido.framework.engine.vo.avatar
{
	/**
	 * 单个动作图片数据,某个方向的某一个帧
	 * @param $data 单个动作帧 xml 值
	 * <p a="0" f="0" sx="176" sy="0" w="29" h="101" tx="15" ty="70" ox="0" oy="0"/>
	 */
    public class AvatarPartData extends Object
    {
        public var angle:int;
        public var frame:int;
        public var sx:int;	//原单帧图片在整图中的x,
        public var sy:int;	//原单帧图片在整图中的y
        public var width:int;	//单帧图片中的w
        public var height:int;	//单帧图片中的h
        public var tx:int;	//某整个动作的图片在整张图片中的x
        public var ty:int;	//某整个动作的图片在整张图片中的y
//		ox 坐骑偏移量 x 
//		oy 坐骑偏移量 y 现在查看ox,oy 在坐骑里面都为0
		/**
		 * 单个动作图片数据
		 * @param $data 单个动作帧 xml 值
		 * <p a="0" f="0" sx="176" sy="0" w="29" h="101" tx="15" ty="70" ox="0" oy="0"/>
		 */
        public function AvatarPartData($data:XML)
        {
            this.angle = $data.@a;
            this.frame = $data.@f;
            this.sx = $data.@sx;
            this.sy = $data.@sy;
            this.width = $data.@w;
            this.height = $data.@h;
            this.tx = parseInt($data.@tx) + parseInt($data.@ox);
            this.ty = parseInt($data.@ty) + parseInt($data.@oy);
            return;
        }

    }
}
