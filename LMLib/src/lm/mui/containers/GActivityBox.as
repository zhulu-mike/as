package lm.mui.containers
{
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class GActivityBox extends Container
	{
		/***/
		public static const LEFT:String = "left";
		/***/
		public static const RIGHT:String = "right";	
		
		public var layChildChanged:Boolean = false;
		protected var _numChildChanged:Boolean = false;
		private var _direction:String = "left";
		private var _horizontalGap:Number = 0;
		private var _verticalGap:Number = 0;
		private var _colCount:int = 5;
		
		public function GActivityBox()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			this.updateDisplayList();
		}
		
		override public function addChild(param1:DisplayObject) : DisplayObject
		{
			this._numChildChanged = true;
			//          return super.addChild(param1);
			var child:DisplayObject = super.addChild(param1);
			this.invalidate(InvalidationType.ALL);
			return child;
		}
		
		override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
		{
			this._numChildChanged = true;
			
			var child:DisplayObject = super.addChildAt(param1, param2);
			this.updateDisplayList();
			return child;
		}
		
		override public function removeChild(param1:DisplayObject) : DisplayObject
		{
			this._numChildChanged = true;
			var child:DisplayObject =  super.removeChild(param1);
			this.updateDisplayList();
			return child;
		}
		
		override public function removeChildAt(param1:int) : DisplayObject
		{
			this._numChildChanged = true;
			this.updateDisplayList();
			return super.removeChildAt(param1);
		}
		
		public function get horizontalGap() : Number
		{
			return this._horizontalGap;
		}
		
		public function set horizontalGap(param1:Number) : void
		{
			if (this._horizontalGap == param1)
			{
				return;
			}
			this._horizontalGap = param1;
			invalidate(InvalidationType.ALL);
			return;
		}
		
		public function get verticalGap() : Number
		{
			return this._verticalGap;
		}
		
		public function set verticalGap(param1:Number) : void
		{
			if (this._verticalGap == param1)
			{
				return;
			}
			this._verticalGap = param1;
			invalidate(InvalidationType.ALL);
			return;
		}
		
		protected function resetPosition() : void
		{
			_colCount = _colCount <= 0 ? 1 : _colCount;
			var _index:int = 0;
			var _child:DisplayObject = null;
			var _temp:int = 0, maxWidth:Number;
			var _tempy:Number = 0, maxHeight:Number = 0;
			var len:int = this.numChildren;
			var totalRow:int = Math.floor(len / _colCount);
			var flag:Boolean;
			if (direction == RIGHT)
			{
				_index = 0;
				while (_index < len)
				{
					if (_index%_colCount == 0)
					{
						_temp = 0;
						_tempy = _tempy + maxHeight + int(_index/_colCount)*verticalGap;
					}
					_child = this.getChildAt(_index);
					maxHeight = _child.height > maxHeight ? _child.height : maxHeight;
					_child.x = _temp - _child.width;
					if (_index%_colCount == _colCount - 1)
					{
						maxWidth = maxWidth < _child.x ? _child.x : maxWidth;
					}
					_child.y = _tempy;
					_temp = _child.x -horizontalGap;
					_index++;
				}
				if (len < _colCount)
				{
					maxWidth = this.getChildAt(len-1).x;
				}
				_index = 0;
				while (_index < len)
				{
					_child = this.getChildAt(_index);
					_child.x -= maxWidth;
					_index++;
				}
			}
			else
			{
				_index = 0;
				while (_index < len)
				{
					if (_index%_colCount == 0)
					{
						_temp = 0;
						_tempy = _tempy + maxHeight + int(_index/_colCount)*verticalGap;
					}
					_child = this.getChildAt(_index);
					_child.x = _temp;
					_child.y = _tempy;
					maxHeight = _child.height > maxHeight ? _child.height : maxHeight;
					_temp = _child.x + horizontalGap;
					_index++;
				}
			}
			return;
		}
		
		override protected function updateDisplayList() : void
		{
			if (this._numChildChanged || this.layChildChanged)
			{
				this._numChildChanged = false;
				this.layChildChanged = false;
				this.resetPosition();
			}
			super.updateDisplayList();
			return;
		}
		
		override public function get height() : Number
		{
			return super.height;
		}
		
		override public function get width() : Number
		{
			return super.width;
		}

		/**列数*/
		public function get colCount():int
		{
			return _colCount;
		}

		public function set colCount(value:int):void
		{
			if (_colCount != value)
			{
				_colCount = value;
				invalidate(InvalidationType.ALL);
			}
		}

		/**排列方向,从右到左，或者从左到右*/
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			if (value != RIGHT && value != LEFT)
			{
				throw new Error("不能给direction赋值right或者left之外的值");
				return;
			}
			if (_direction != value)
			{
				_direction = value;
				invalidate(InvalidationType.ALL);
			}
		}

		
	}
}