package game.common.res.npcFriend
{

    public class NpcFriendResManager extends Object
    {
        private static var npcFriendResContainer:Object = new Object();

        public function NpcFriendResManager()
        {
            return;
        }

        public static function parseRes(param1:String) : void
        {
            var _loc_3:int = 0;
            var _loc_6:NpcFriendRes = null;
            var _loc_2:* = XML(param1);
            if (!_loc_2)
            {
                return;
            }
            var _loc_4:* = _loc_2.children();
            var _loc_5:* = _loc_2.children().length();
            var _loc_7:Array = [];
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                _loc_6 = new NpcFriendRes();
                _loc_6.id_kind = _loc_4[_loc_3].@id;
                _loc_6.name = String(_loc_4[_loc_3].@name).split("_")[0];
                _loc_6.attack_interval = _loc_4[_loc_3].@attack_interval;
                _loc_6.id_ico = _loc_4[_loc_3].@headiconId;
                _loc_6.id_m = _loc_4[_loc_3].@avatarId;
                _loc_6.id_sound_char_attack = _loc_4[_loc_3].@attack_audio;
                _loc_6.id_sound_char_injured = _loc_4[_loc_3].@hurt_audio;
                _loc_6.id_sound_char_death = _loc_4[_loc_3].@die_audio;
                npcFriendResContainer[_loc_6.id_kind] = _loc_6;
                _loc_3++;
            }
            return;
        }

        public static function getNpcFriendRes(param1:int) : NpcFriendRes
        {
            return npcFriendResContainer[param1];
        }

    }
}
