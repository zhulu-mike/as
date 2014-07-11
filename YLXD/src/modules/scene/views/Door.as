package modules.scene.views
{
	import managers.DoorUtil;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class Door extends Sprite
	{
		
		private var shape:DisplayObject; 
		
		public var state:int = 0;
		
		public var passed:Boolean = false;
		
		public function Door(state:int)
		{
			this.state = state;
			shape = DoorUtil.getDoorShape(state);
			this.addChild(shape);
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