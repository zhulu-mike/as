package game.common.res.skill
{
    import game.common.res.*;

    public class BuffRes extends BaseResID
    {
        public var name:String;
        public var buff_flag:int;
        public var target:int;
        public var user_scope:int;
        public var scope_radius:int;
        public var use_limit:int;
        public var aoe_type:int;
        public var hurt_consideration_way:int;
        public var type:int;
        public var hurt_value:int;
        public var duration:int;
        public var pre_duration:int;
        public var effect_repeat_option:int;
        public var effect_repeat_count:int;
        public var special_effect_change:int;
        public var effect_repeat_type:int;
        public var desc:String;
        public var desc_short:String;
        public var hurt_adds:int;
        public var percent:int;
        public var type_pn:int;
        public var jitui_distance:int;
//		buff 对应特效id 
		public var sid:int ;

        public function BuffRes()
        {
            return;
        }

    }
}
