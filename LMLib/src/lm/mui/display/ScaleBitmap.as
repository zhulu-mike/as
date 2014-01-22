package lm.mui.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

    public class ScaleBitmap extends Bitmap
    {
        protected var _originalBitmap:BitmapData;
        protected var _scale9Grid:Rectangle = null;

        public function ScaleBitmap(param1:BitmapData = null, param2:String = "auto", param3:Boolean = false)
        {
            super(param1, param2, param3);
            if (param1)
            {
                this._originalBitmap = param1.clone();
            }
            return;
        }

        override public function set bitmapData(param1:BitmapData) : void
        {
			try
			{
				if (param1 == null)
				{
					super.bitmapData = null;
					return;
				}
	            this._originalBitmap = param1.clone();
	            if (this._scale9Grid != null)
	            {
	                if (!this.validGrid(this._scale9Grid))
	                {
	                    this._scale9Grid = null;
	                }
	                this.setSize(param1.width, param1.height);
	            }
	            else
	            {
	                this.assignBitmapData(this._originalBitmap.clone());
	            }
			}catch(e:Error)
			{
				
			}
            return;
        }

        override public function set width(param1:Number) : void
        {
            if (param1 != width)
            {
                this.setSize(param1, height);
            }
            return;
        }

        override public function set height(param1:Number) : void
        {
            if (param1 != height)
            {
                this.setSize(width, param1);
            }
            return;
        }

        override public function set scale9Grid(param1:Rectangle) : void
        {
            var $width:Number = NaN;
            var $height:Number = NaN;
            if (this._scale9Grid == null && param1 != null || this._scale9Grid != null && !this._scale9Grid.equals(param1))
            {
                if (param1 == null)
                {
					$width = width;
					$height = height;
                    this._scale9Grid = null;
                    this.assignBitmapData(this._originalBitmap.clone());
                    this.setSize($width, $height);
                }
                else
                {
                    if (!this.validGrid(param1))
                    {
                        throw new Error("#001 - The _scale9Grid does not match the original BitmapData");
                    }
                    this._scale9Grid = param1.clone();
                    this.resizeBitmap(width, height);
                    scaleX = 1;
                    scaleY = 1;
                }
            }
            return;
        }

        private function assignBitmapData(param1:BitmapData) : void
        {
            if(super.bitmapData) super.bitmapData.dispose();
            super.bitmapData = param1;
            return;
        }

        private function validGrid(param1:Rectangle) : Boolean
        {
            return param1.right <= this._originalBitmap.width && param1.bottom <= this._originalBitmap.height;
        }

        override public function get scale9Grid() : Rectangle
        {
            return this._scale9Grid;
        }

        public function setSize(param1:Number, param2:Number) : void
        {
            if (param1 == 0 || param2 == 0 || this._scale9Grid == null)
            {
                super.width = param1;
                super.height = param2;
            }
            else
            {
                param1 = Math.max(param1, this._originalBitmap.width - this._scale9Grid.width);
                param2 = Math.max(param2, this._originalBitmap.height - this._scale9Grid.height);
                this.resizeBitmap(param1, param2);
            }
            return;
        }

        public function getOriginalBitmapData() : BitmapData
        {
            return this._originalBitmap;
        }

        protected function resizeBitmap(param1:Number, param2:Number) : void
        {
            var originRect:Rectangle;
            var targetRect:Rectangle;
            var bmd:BitmapData = new BitmapData(param1, param2, true, 0);
            var v_arr:Array = [0, this._scale9Grid.top, this._scale9Grid.bottom, this._originalBitmap.height];
            var h_arr:Array = [0, this._scale9Grid.left, this._scale9Grid.right, this._originalBitmap.width];
            var v_target_arr:Array = [0, this._scale9Grid.top, param2 - (this._originalBitmap.height - this._scale9Grid.bottom), param2];
            var h_target_arr:Array = [0, this._scale9Grid.left, param1 - (this._originalBitmap.width - this._scale9Grid.right), param1];
            var matrix:Matrix = new Matrix();
            var row:int = 0;
            var col:int = 0;
            while (col < 3)
            {
				row = 0;
                while (row < 3)
                {
					originRect = new Rectangle(h_arr[col], v_arr[row], h_arr[(col + 1)] - h_arr[col], v_arr[(row + 1)] - v_arr[row]);
					targetRect = new Rectangle(h_target_arr[col], v_target_arr[row], h_target_arr[(col + 1)] - h_target_arr[col], v_target_arr[(row + 1)] - v_target_arr[row]);
					matrix.identity();
					matrix.a = targetRect.width / originRect.width;
					matrix.d = targetRect.height / originRect.height;
					matrix.tx = targetRect.x - originRect.x * matrix.a;
					matrix.ty = targetRect.y - originRect.y * matrix.d;
					bmd.draw(this._originalBitmap, matrix, null, null, targetRect, smoothing);
					row++;
                }
				col++;
            }
            this.assignBitmapData(bmd);
            return;
        }

    }
}
