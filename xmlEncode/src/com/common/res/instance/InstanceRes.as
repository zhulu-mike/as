package game.common.res.instance
{
    import game.common.res.lan.*;
    import game.manager.LanResManager;

    public class InstanceRes extends Object
    {
        public var instance_model_id:int;
        public var instance_name:String;
        public var instance_type:int;
        public var lifecycle:int;
        public var population_high_limit:int;
        public var population_lower_limit:int;
        public var level_high_limit:int;
        public var level_lower_limit:int;
        public var open_time_limite:String;
        public var enable:int;
        public var enter_count_limite:int;
        public var instanceOpenTimeDescrip:String;
        public var weekdayshow:String;
        public var groupsum:int;
        public var maxcount:int;
        public var descpt:String;
        public var rewardgrade:int;
        public var team_limite:int;
        public var task_limite:String;
        public var good_limite:String;
        public var revive:int;
        public var transNpcID:int;

        public function InstanceRes()
        {
            return;
        }

        public function showMenPai() : String
        {
            if (this.team_limite == 0)
            {
                return LanResManager.getLanCommonTextWords(Language.getKey("2510"));
            }
            if (this.team_limite == 1)
            {
                return LanResManager.getLanCommonTextWords(Language.getKey("2511"));
            }
            if (this.team_limite == 2)
            {
                return LanResManager.getLanCommonTextWords(Language.getKey("2512"));
            }
            return "";
        }

    }
}
