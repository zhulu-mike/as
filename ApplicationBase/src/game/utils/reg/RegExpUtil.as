package game.utils.reg
{
	public class RegExpUtil
	{
		public function RegExpUtil()
		{
		}
		
		/**
		 * 替换所有空格
		 * @param source  要操作的字符
		 * @param replace 替换空格的字符
		 * 
		 */		
		public static function replaceSpace(source:String, replace:String=""):String
		{
			return source.replace(RegExpConst.SPACE, replace);
		}
		
		/**
		 * 替换所有非数字
		 * @param source  要操作的字符
		 * @param replace 替换非数字的字符
		 * 
		 */		
		public static function replaceUnNumber(source:String, replace:String=""):String
		{
			return source.replace(RegExpConst.UNNUMBER, replace);
		}
	}
}