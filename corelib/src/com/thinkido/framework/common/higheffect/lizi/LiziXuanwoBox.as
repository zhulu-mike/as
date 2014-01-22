package com.thinkido.framework.common.higheffect.lizi
{
	import com.thinkido.framework.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

    public class LiziXuanwoBox extends Sprite
    {
        private var _showArea:Rectangle;
        private var _xuanwoCenter:Point;
        private var _xuanwoWidth:Number;
        private var _xuanwoHeight:Number;
        private var max_r1:Number;
        private var max_r:Number;
        private var min_r:Number;
        private var min_r1:Number;
        private var y_scale:Number;
        private var _shaArr:Array;
        private var _eachSnowCount:Number = 1;
        private var _waitAddSnowCount:Number;
        private var toBig_matrix:Matrix;
        private var toBig_ct:ColorTransform;
        private var drawShape_matrix:Matrix;
        private var drawShape_ct:ColorTransform;
        private var bf:BlurFilter;
        private var alpha_shape:Shape;
        private var alpha_matrix:Matrix;
        private var _drawBMP:Bitmap;
        private var _drawBD:BitmapData;
        private var _isRunning:Boolean = false;
        private static const DENS:Number = 8.33333e-005;
        private static const step_r:Number = 0.997;
        private static const step_an:Number = -0.016;

        public function LiziXuanwoBox(value1:Rectangle, value2:Point, value3:Number = 1000, value4:Number = 580, value5:Number = 100, value6:Number = 50, value7:Boolean = true)
        {
            this.blendMode = BlendMode.LAYER;
            this.alpha_shape = new Shape();
            this.alpha_shape.blendMode = BlendMode.ALPHA;
            this.addChild(this.alpha_shape);
            this.setShowArea(value1);
            this.setDrawArea(value2, value3, value4, value5, value6);
            this._shaArr = [];
            this._waitAddSnowCount = 0;
            if (value7)
            {
                this.start();
            }
            return;
        }

        public function get isRunning() : Boolean
        {
            return this._isRunning;
        }

        public function setShowArea(value1:Rectangle) : void
        {
            this._showArea = value1.clone();
            this.graphics.clear();
            this.graphics.beginFill(0, 1);
            this.graphics.drawRect(this._showArea.x, this._showArea.y, this._showArea.width, this._showArea.height);
            this.graphics.endFill();
            return;
        }

        private function setDrawArea(value1:Point, value2:Number = 1000, value3:Number = 580, value4:Number = 150, value5:Number = 80) : void
        {
            this._xuanwoWidth = value2;
            this._xuanwoHeight = value3;
            this.min_r1 = value4;
            this._xuanwoCenter = value1.clone();
            this.y_scale = this._xuanwoHeight / this._xuanwoWidth;
            this.max_r1 = Math.max(this._xuanwoWidth / 2, this._xuanwoHeight / 2);
            this.max_r = this.max_r1 - value5;
            this.min_r = this.min_r1 + value5;
            if (this.min_r1 + value5 * 2 >= this.max_r1)
            {
                throw Error("最小半径 与 双过度 之和 应小于最大半径!");
            }
            this._eachSnowCount = this.max_r1 * DENS;
            this.toBig_matrix = new Matrix();
            var _loc_6:* = this._xuanwoWidth / 10000;
            var _loc_7:* = this._xuanwoHeight / (10000 * this.y_scale);
            this.toBig_matrix.a = (this._xuanwoWidth + _loc_6) / this._xuanwoWidth;
            this.toBig_matrix.d = (this._xuanwoHeight + _loc_7) / this._xuanwoHeight;
            this.toBig_matrix.tx = (-_loc_6) / 2;
            this.toBig_matrix.ty = (-_loc_7) / 2;
            this.toBig_ct = new ColorTransform(0.999, 0.999, 0.999);
            this.drawShape_matrix = new Matrix(1, 0, 0, 1, this._xuanwoWidth / 2, this._xuanwoHeight / 2);
            this.drawShape_ct = new ColorTransform(1, 1, 1, 1);
            this.bf = new BlurFilter(2, 2, 1);
            var _loc_8:* = this.min_r1;
            var _loc_9:* = new Matrix();
			_loc_9.createGradientBox(_loc_8 * 2, _loc_8 * 2, 0, -_loc_8, -_loc_8);
            this.alpha_shape.graphics.clear();
            this.alpha_shape.graphics.beginGradientFill(GradientType.RADIAL, [0, 0], [0, 1], [0, 255], _loc_9, SpreadMethod.PAD, InterpolationMethod.RGB);
            this.alpha_shape.graphics.drawCircle(0, 0, _loc_8);
            this.alpha_shape.graphics.endFill();
            if (this.y_scale <= 1)
            {
                this.alpha_shape.height = this.alpha_shape.height * this.y_scale;
                this.alpha_shape.x = this._xuanwoCenter.x;
                this.alpha_shape.y = this._xuanwoCenter.y;
            }
            else
            {
                this.alpha_shape.width = this.alpha_shape.width / this.y_scale;
                this.alpha_shape.x = this._xuanwoCenter.x;
                this.alpha_shape.y = this._xuanwoCenter.y;
            }
            return;
        }

        public function start() : void
        {
            if (this._drawBMP == null)
            {
                this._drawBD = new BitmapData(this._xuanwoWidth, this._xuanwoHeight, false, 0);
                this._drawBMP = new Bitmap(this._drawBD);
                this._drawBMP.x = this._xuanwoCenter.x - this._xuanwoWidth / 2;
                this._drawBMP.y = this._xuanwoCenter.y - this._xuanwoHeight / 2;
                addChildAt(this._drawBMP, 0);
            }
            addEventListener(Event.ENTER_FRAME, this.loop);
            this._isRunning = true;
            return;
        }

        public function stop(value1:Boolean) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.loop);
            if (value1)
            {
				SystemUtil.clearChildren(this, true);
                this._drawBD = null;
                this._drawBMP = null;
            }
            this._isRunning = false;
            this._shaArr = [];
            this._waitAddSnowCount = 0;
            return;
        }

        private function getELuojian(value1:Number, value2:Number) : Point
        {
            var _loc_3:* = new Point();
            _loc_3.x = value1 * Math.cos(value2);
            _loc_3.y = value1 * Math.sin(value2);
            return _loc_3;
        }

        private function loop(event:Event) : void
        {
            var _loc_3:int = 0;
            var _loc_5:Shape = null;
            var _loc_6:Array = null;
            var _loc_7:Number = NaN;
            var _loc_8:Point = null;
            var _loc_9:Number = NaN;
            this._waitAddSnowCount = this._waitAddSnowCount + this._eachSnowCount;
            while (this._waitAddSnowCount >= 1)
            {
                
                _loc_5 = new Shape();
                _loc_5.graphics.beginFill(Math.random() * 16777215, 1);
                _loc_5.graphics.drawCircle(0, 0, 8 * Math.max(Math.random(), 0.6));
                _loc_5.graphics.endFill();
                this._shaArr.push([_loc_5, this.max_r1, 2 * Math.PI * Math.random()]);
				_waitAddSnowCount -= 1;
            }
            var _loc_2:* = this._drawBD.clone();
            this._drawBD.draw(_loc_2, this.toBig_matrix, this.toBig_ct, null, null, true);
            var _loc_4:* = this._shaArr.length;
            _loc_3 = this._shaArr.length - 1;
            while (_loc_3 >= 0)
            {
                
                _loc_6 = this._shaArr[_loc_3];
                _loc_5 = _loc_6[0];
                _loc_6[1] = _loc_6[1] * step_r;
                _loc_6[2] = _loc_6[2] + step_an;
                _loc_7 = (-step_an) * _loc_6[1] / this.max_r1;
                _loc_8 = this.getELuojian(_loc_6[1], _loc_6[2] + _loc_7);
                _loc_9 = Point.distance(new Point(this._xuanwoCenter.x + _loc_8.x, this._xuanwoCenter.y + _loc_8.y), this._xuanwoCenter);
                if (_loc_9 > this.min_r1)
                {
                    if (this.y_scale <= 1)
                    {
                        this.drawShape_matrix.tx = this._xuanwoWidth / 2 + _loc_8.x;
                        this.drawShape_matrix.ty = this._xuanwoHeight / 2 + _loc_8.y * this.y_scale;
                    }
                    else
                    {
                        this.drawShape_matrix.tx = this._xuanwoWidth / 2 + _loc_8.x * (1 / this.y_scale);
                        this.drawShape_matrix.ty = this._xuanwoHeight / 2 + _loc_8.y;
                    }
                    if (_loc_9 > this.max_r)
                    {
                        this.drawShape_ct.alphaMultiplier = (this.max_r1 - _loc_9) / (this.max_r1 - this.max_r);
                    }
                    else if (_loc_9 > this.min_r)
                    {
                        this.drawShape_ct.alphaMultiplier = 1;
                    }
                    else
                    {
                        this.drawShape_ct.alphaMultiplier = 1 - (this.min_r - _loc_9) / (this.min_r - this.min_r1);
                    }
                    this._drawBD.draw(_loc_5, this.drawShape_matrix, this.drawShape_ct, null, null, true);
                }
                else
                {
                    this._shaArr.splice(_loc_3, 1);
                }
                _loc_3 = _loc_3 - 1;
            }
            this._drawBD.applyFilter(this._drawBD, this._drawBD.rect, new Point(0, 0), this.bf);
            return;
        }

    }
}
