package modules.scene.views
{
	import managers.DoorUtil;
	import managers.ResManager;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Door extends Sprite
	{
		
		private var shape:DisplayObject; 
		
		public var state:int = 0;
		
		public var passed:Boolean = false;
		
		private var dizuo:Image;
		
		/**
		 * 是否是相反的
		 */		
		public var isReverse:Boolean = false;
		
		public function Door(state:int, need:Boolean=false)
		{
			this.state = state;
			isReverse = need;
			shape = DoorUtil.getDoorShape(state,isReverse);
			this.addChild(shape);
			dizuo = new Image(ResManager.assetsManager.getTexture("dizuo.png"));
			this.addChild(dizuo);
			dizuo.y = shape.height;
			dizuo.x = shape.width - dizuo.width >> 1;
		}
		
		private var _speed:int = 5;

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function updatePos():void
		{
			this.x -= _speed;
		}
		
		
	}
}