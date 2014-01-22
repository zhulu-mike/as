package com.thinkido.framework.manager
{
	public class ColorManager
	{
		
		private static var instance : ColorManager;
		
		public function ColorManager() 
		{   
			if ( instance != null )
			{
				throw new Error("ColorManager singleton_error");
			}
			
			instance = this;
		}
		
		public static function getInstance() : ColorManager 
		{
			if ( instance == null )
				instance = new ColorManager();
			
			return instance;
		}
	}
}