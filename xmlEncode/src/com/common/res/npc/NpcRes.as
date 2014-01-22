package game.common.res.npc
{
	import com.thinkido.framework.common.utils.ZMath;
	
	import game.common.res.BaseResID;

	public class NpcRes extends BaseResID
	{
		public var name:String;
		public var nickname:String;
		public var sceneid:int;
		public var x:int;
		public var y:int;
		public var findX:int;
		public var findY:int;
		public var direction:int;
		public var can_redirect:int;
		public var simpleTalk:Array;
		public var randomTalk:Array;
		public var npctype:int;
		public var shop_type:int;
		public var functions:Array;
		public var function_task:Array;
		public var function_shop:Array;
		public var function_transfer:Array;
		public var function_activity:Array;
		
		public var targetGoods:int;
		
		//对应的日常副本类型
		public var targetFuben:int = 0;
		
		public function NpcRes()
		{
			this.function_task = [];
			this.function_shop = [];
			this.function_transfer = [];
			this.function_activity = [];
			return;
		}
		
		public function getOneNpcSimpleTalk(param1:Boolean = true) : String
		{
			var _loc_2:* = this.simpleTalk.length > 0 ? (this.simpleTalk[ZMath.getRandomNumber(0, (this.simpleTalk.length - 1))]) : ("");
			var _loc_3:* = new RegExp("{([^}]*?)/([^}]*?)}", "g");
			if (param1)
			{
				_loc_2 = _loc_2.replace(_loc_3, "$1");
			}
			else
			{
				_loc_2 = _loc_2.replace(_loc_3, "$2");
			}
			return _loc_2;
		}
		
		public function getOneNpcRandomTalk(param1:Boolean = true) : String
		{
			var _loc_2:* = this.randomTalk.length > 0 ? (this.randomTalk[ZMath.getRandomNumber(0, (this.randomTalk.length - 1))]) : ("");
			var _loc_3:* = new RegExp("{([^}]*?)/([^}]*?)}", "g");
			if (param1)
			{
				_loc_2 = _loc_2.replace(_loc_3, "$1");
			}
			else
			{
				_loc_2 = _loc_2.replace(_loc_3, "$2");
			}
			return _loc_2;
		}
		
		public function findNeedJump() : Boolean
		{
			return this.findX != this.x || this.findY != this.y;
		}
	}
}