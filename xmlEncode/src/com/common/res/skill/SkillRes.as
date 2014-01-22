package game.common.res.skill
{
    import game.common.res.*;
    import game.common.res.goods.*;

    public class SkillRes extends BaseResID
    {
        public var name:String;
        public var coolingtime:int;
        public var iscommon_cd:String;
        public var depletionMagic:int;
        public var depletionNuqi:int;
        public var level:int;
        public var distance:int;
        public var useway:int;
        public var target:int;
        public var effect_ids:String;
        public var isgeneral:int;
        public var position:int;
        public var char_level:int;
        public var popsinger:int;
        public var desc:String;
        public var grade_limit:int;
        public var skilltype:int;
        public var trigger_probability:int;
        public var public_time:int;
        public var public_type:int;
        public var shortType:int;
        public var wugong_type:int;
        public var source:String;
        public var learningBook:int;
        public var showOrder:int;
        public var is_zuhe:int;
        public var bangGong:int;
        public var mount_use_tuijian:int;
        public var beatD:int;
        public var beatS:int;
		
		public var e0d:int = 0 ;
		public var e2d:int = 0 ;
		
		public var beatType:int = 1 ;
		public var shakeType:int = 1 ;
		/**
		 * 攻击动作 
		 */		
		public var actionType:int = 0 ;
		/**
		 * 技能击中效果是否支持旋转 
		 */		
		public var rotation:int = 0 ;

        public function SkillRes()
        {
            return;
        }

        public function getMijiName() : String
        {
            var gr:GoodsRes = GoodsResManager.getGoodsRes(this.learningBook);
            if (!gr)
            {
                return "";
            }
            return gr.name;
        }

    }
}
