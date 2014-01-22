package lm.mui.containers 
{	
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	
	import lm.mui.containers.globalVariable.GBoxDirection;

    public class GBox extends Container
    {
        public var layChildChanged:Boolean = false;
        protected var _numChildChanged:Boolean = false;
        private var _direction:String = "horizontal";
        private var _horizontalGap:Number = 0;
        private var _verticalGap:Number = 0;

        public function GBox()
        {
            return;
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
            return super.removeChildAt(param1);
        }

        public function get direction() : String
        {
            return this._direction;
        }

        public function set direction(param1:String) : void
        {
            if (this._direction == param1)
            {
                return;
            }
            this._direction = param1;
            invalidate(InvalidationType.ALL);
            return;
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
            var _index:int = 0;
            var _child:DisplayObject = null;
            var _temp:int = 0;
            var len:int = this.numChildren;
            if (this.direction == GBoxDirection.VERTICAL)
            {
                _index = 0;
                while (_index < len)
                {
                    
                    _child = this.getChildAt(_index);
                    _child.x = 0;
                    _child.y = _temp + this.verticalGap;
                    _temp = _child.y + _child.height;
                    _index++;
                }
            }
            else if (this.direction == GBoxDirection.HORIZONTAL)
            {
                _index = 0;
                while (_index < len)
                {
                    
                    _child = this.getChildAt(_index);
                    _child.x = _temp;
                    _child.y = 0;
                    _temp = _child.x + _child.width + this.horizontalGap;
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
            var _dis:DisplayObject = null;
            if (this.direction == GBoxDirection.HORIZONTAL)
            {
                return super.height;
            }
            if (this.direction == GBoxDirection.VERTICAL)
            {
				var h:int = 0;
				var num:int = this.numChildren;
				for(var i:int = 0; i < num; i++)
				{
					h += this.getChildAt(i).height + this.verticalGap;
				}
				return h;
               /* if (this.numChildren > 0)
                {
                    _dis = this.getChildAt((this.numChildren - 1));
                    return _dis.y + _dis.height;
                }
                return 0;*/
            }
            return super.height;
        }

        override public function get width() : Number
        {
            var displayObj:DisplayObject = null;
            if (this.direction == GBoxDirection.HORIZONTAL)
            {
                if (this.numChildren > 0)
                {
					displayObj = this.getChildAt((this.numChildren - 1));
                    return displayObj.x + displayObj.width;
                }
                return 0;
            }
            else if (this.direction == GBoxDirection.VERTICAL)
            {
                return super.width;
            }
            return super.width;
        }

    }
}
