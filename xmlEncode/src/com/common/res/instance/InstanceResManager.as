package game.common.res.instance
{

    public class InstanceResManager extends Object
    {
        private static var instanceResContainer:Object = new Object();

        public function InstanceResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:InstanceRes = null;
            var _loc_4:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.instances.instance)
            {
                
                _loc_3 = new InstanceRes();
                _loc_3.instance_model_id = _loc_4.@instance_model_id;
                _loc_3.instance_name = _loc_4.instance_name;
                _loc_3.instance_type = _loc_4.@instance_type;
                _loc_3.lifecycle = _loc_4.@lifecycle;
                _loc_3.population_high_limit = _loc_4.@population_high_limit;
                _loc_3.population_lower_limit = _loc_4.@population_lower_limit;
                _loc_3.level_high_limit = _loc_4.@level_high_limit;
                _loc_3.level_lower_limit = _loc_4.@level_lower_limit;
                _loc_3.open_time_limite = _loc_4.@open_time_limite;
                _loc_3.enable = _loc_4.@enable;
                _loc_3.enter_count_limite = _loc_4.@enter_count_limite;
                _loc_3.instanceOpenTimeDescrip = _loc_4.instanceOpenTimeDescrip;
                _loc_3.weekdayshow = _loc_4.@weekdayshow;
                _loc_3.groupsum = _loc_4.@groupsum;
                _loc_3.maxcount = _loc_4.@maxcount;
                _loc_3.descpt = _loc_4.descpt;
                _loc_3.rewardgrade = _loc_4.@rewardgrade;
                _loc_3.team_limite = _loc_4.@team_limite;
                _loc_3.task_limite = _loc_4.@task_limite;
                _loc_3.good_limite = _loc_4.@good_limite;
                _loc_3.revive = _loc_4.@revive;
                _loc_3.transNpcID = _loc_4.@transNpcID;
                instanceResContainer[_loc_3.instance_model_id] = _loc_3;
            }
            return;
        }

        public static function getInstanceRes(param1:int) : InstanceRes
        {
            return instanceResContainer[param1];
        }

        public static function getInstanceTotal() : Array
        {
            var _loc_1:String = null;
            var _loc_2:Array = [];
            for (_loc_1 in instanceResContainer)
            {
                
                if (instanceResContainer[_loc_1] is InstanceRes)
                {
                    _loc_2.push(instanceResContainer[_loc_1]);
                }
            }
            return _loc_2;
        }

    }
}
