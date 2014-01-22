package com.g6game.managers
{
	import mx.effects.Effect;
	
	import vo.MapVO;

	public final class EditorConfig
	{
		public var app:RPGMapEditor;
		
		public function EditorConfig()
		{
			if (instance)
				throw new Error("单例");
		}
		
		private static var instance:EditorConfig;
		
		public static function getInstance():EditorConfig
		{
			if (!instance)
				instance = new EditorConfig();
			return instance;
		}
		
		[Bindable]
		public var mapVO:MapVO = new MapVO();
		
		public function createNewMap():void
		{
			app.createNewMap();
		}
		
	}
}