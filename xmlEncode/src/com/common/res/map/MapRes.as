package game.common.res.map
{
	public class MapRes
	{
		public var pathName:String;
		public var id:int;
		public var name:String;
		public var bgSoundID:int;
		public var allowPvp:Boolean;
		public var allowJump:Boolean;
		public var allowMountRide:Boolean;
		public var allowMountShow:Boolean;
		public var exercise_desc:String;
		public var isFuben:int;
		public var transOutResArr:Array;
		public var isClearPkProtect:Boolean;
		public var grid_v:int ;
		public var grid_h:int ;
		/**loader加载图片*/
		public var loadImg:int = 0;
		
		/**
		 * 禁用技能
		 */		
		public var forbidSkill:Array = [];
		
		/**
		 * 禁用道具 
		 */		
		public var forbidTool:Array = [];
		
		public function MapRes()
		{
			this.transOutResArr = [];
			return;
		}
	}
}