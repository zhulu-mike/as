package game.common.res.skill
{

    public class SkillResManager extends Object
    {
        private static var skillContainer:Object = new Object();
        private static var effectContainer:Object = new Object();

        public function SkillResManager()
        {
            return;
        }

        public static function parseSkillRes(param1:String) : void
        {
			var skillRes:SkillRes;
			var xml:XML;
			var skillXML:XML = XML(param1);
			for each (xml in skillXML.skill)
			{
				skillRes = new SkillRes();
				with (skillRes)
				{
					id_kind = int(xml.@id) * 10000 + int(xml.@level) ;
					level = xml.@level ;
					id_ico = xml.@image;
					id_e0 = xml.@effectResId0;
					id_e1 = xml.@effectResId1;
					id_e2 = xml.@effectResId2;
					id_sound_skill = xml.@sound;
					name = xml.@name;
					coolingtime = xml.@coolingtime;
					depletionMagic = xml.@depletionMagic;
					depletionNuqi = xml.@depletionNuqi;
					distance = xml.@distance;
					public_type = 1;
					public_time = xml.@common_cool_time;
					beatD = xml.@beatD;
					beatS = xml.@beatS;				
					e0d = xml.@e0d ;
					e2d = xml.@e2d ;
					beatType = xml.@beatT ;
					shakeType = xml.@shakeT ;
					actionType = xml.@actionType ;
					rotation = String(xml.@rotation).length == 0 ? 0:xml.@rotation  ;
				};
				skillContainer[skillRes.id_kind] = skillRes ;
			};
        }

        public static function parseBuffRes(effectStr:String) : void
        {
			var buffRes:BuffRes;
			var xml:XML;
			var skillEffectXML:XML = XML(effectStr);
			for each (xml in skillEffectXML.buff)
			{
				buffRes = new BuffRes();
				with (buffRes)
				{
					id_kind = xml.@id;
					name = xml.@name;
					duration = xml.@time;
					desc = xml.@desc;
					id_ico = xml.@icon;	
					sid = xml.@sid ;	
				};
				effectContainer[buffRes.id_kind] = buffRes;
			};
            return;
        }

        public static function getSkillRes($id_kind:int) : SkillRes
        {
            return skillContainer[$id_kind];
        }

        public static function getBuffRes(param1:int) : BuffRes
        {
            return effectContainer[param1];
        }

        public static function getMountSkillResArr() : Array
        {
            var sr:SkillRes = null;
            var temp:Array = [];
            for each (sr in skillContainer)
            {
                if (sr && sr.skilltype == 1)
                {
                    temp.push(sr);
                }
            }
            temp.sortOn("id_kind", Array.NUMERIC);
            return temp;
        }

    }
}
