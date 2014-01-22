package game.common.res.monster
{
	public class MonsterResManager
	{
		private static var monsterResContainer:Object = new Object();
		
		public function MonsterResManager()
		{
			return;
		}
		
		public static function parseRes(xmlString:String) : void
		{
			var index:int = 0;
			var mr:MonsterRes = null;
			var xmlData:XML = XML(xmlString);
			if (!xmlData)
			{
				return;
			}
			for each(var item:XML in xmlData.monster)
			{
				mr = new MonsterRes();
				mr.desc = String(item.@desc);
				mr.headimg = int(item.@headimg);
				mr.Hp_max = int(item.@maxHP);
				mr.id_kind = int(item.@cid);
				mr.model = int(item.@model);
				mr.isattack = int(item.@isattack);
				mr.level = int(item.@level);
				mr.name = String(item.@name);
				mr.sex = int(item.@sex);
				mr.sound = int(item.@sound);
				mr.star_level = int(item.@star_level);
				mr.type = int(item.@type);
				
//				mr.talks = String(item.@speaks).split(";");
				monsterResContainer[mr.id_kind] = mr;
				index++;
			}
			return;
		}
		
		public static function getMonsterRes($id_kind:int) : MonsterRes
		{
			return monsterResContainer[$id_kind];
		}
	}
}