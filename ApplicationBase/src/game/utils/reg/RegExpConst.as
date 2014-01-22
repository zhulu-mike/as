package game.utils.reg
{
	public class RegExpConst
	{
		public function RegExpConst()
		{
		}
		
		/**
		 * 搜索所有空格
		 */		
		public static const SPACE:RegExp = /\s/g;
	
		/**
		 * 非数字字符
		 */		
		public static const UNNUMBER:RegExp = /\D/g;
	}
}