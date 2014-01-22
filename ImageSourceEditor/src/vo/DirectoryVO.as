package vo
{
	import flash.filesystem.File;

	public class DirectoryVO
	{
		
		/**skill1是战魂技*/
		public static const ACTIONNAME:Array = ["attack","death", "injured", "skill", "stand", "walk", "sit", "skill1"];
		
		public function DirectoryVO()
		{
			var i:int = 0;
			for (i;i<ACTIONNAME.length;i++)
			{
				imgArr.push(new ActionVO());
				imgArr[i].name = ACTIONNAME[i];
			}
		}
		
		
		public var url:String = "";
		
		public var fileName:String = "";
		
		public var file:File;
		
		public var imgArr:Array = [];
		
		public var standFile:File;
		
		public var standName:String = "";
		
		public var standUrl:String = "";
	}
}