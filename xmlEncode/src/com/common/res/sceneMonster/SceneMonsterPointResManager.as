package game.common.res.sceneMonster
{

    public class SceneMonsterPointResManager extends Object
    {
        private static var sceneMonsterPointResContainer:Object = new Object();

        public function SceneMonsterPointResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:SceneMonsterPointRes = null;
            var _loc_4:XML = null;
            var _loc_5:MonsterPointRes = null;
            var _loc_6:XML = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            for each (_loc_4 in _loc_2.scene)
            {
                
                _loc_3 = new SceneMonsterPointRes();
                _loc_3.sceneId = int(Number(_loc_4.@id));
                _loc_3.monsterPoints = [];
                for each (_loc_6 in _loc_4.children())
                {
                    
                    _loc_5 = new MonsterPointRes();
                    _loc_5.id = int(Number(_loc_6.@id));
                    _loc_5.tileX = int(Number(_loc_6.@x));
                    _loc_5.tileY = int(Number(_loc_6.@y));
                    _loc_3.monsterPoints.push(_loc_5);
                }
                sceneMonsterPointResContainer[_loc_3.sceneId] = _loc_3;
            }
            return;
        }

        public static function getSceneMonsterPointRes(param1:int) : SceneMonsterPointRes
        {
            return sceneMonsterPointResContainer[param1];
        }

    }
}
