package game.common.res.activity
{
	public class AidanceRes
	{
		public var id:int;
		public var name:String;
		public var type:int;		//类型	1、升级	2、变强	3、赚钱	4、灵气	5、道行
		public var desc:String;
		public var recommend:int;   // 1:推荐  	0：不推荐
//		public var count:int;		//当前次数
//		public var maxCount:int;	//总次数
//		public var starLevel:int;	//星级
		public var operateType:int;	//操作类型 	
		public var targetNPC:int;
		public var path:String;   	//sceneID_x_y_dist;
		
		public var label:String = '';
		public var icon:int = 0;
		
		public function AidanceRes()
		{
		}
	}
}