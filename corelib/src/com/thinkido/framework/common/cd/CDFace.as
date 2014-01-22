package com.thinkido.framework.common.cd
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.thinkido.framework.common.pool.IPoolClass;
	import com.thinkido.framework.common.utils.ZMath;
	import com.thinkido.framework.common.vo.StyleData;
	import com.thinkido.framework.utils.DrawUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * 冷却类，如技能冷却 
	 * @author thinkido
	 * 
	 */
    public class CDFace extends Sprite implements IPoolClass
    {
        private var _bindings:Array;
        private var _now:Number = 0;
        private var _cd:Number = 0;
        public var parentCDFace:CDFace;
        public var userData:Object;
        private var _obj:Object;
        private var _line:Shape;
        private var _black:Shape;
        private var _mask:Shape;
        private var _r:Number;
        private var _w:Number;
        private var _h:Number;
        private var _onComplete:Function;
        private var _this:CDFace;
		/**
		 * @param $width 宽
		 * @param $height 高
		 * @param $complateFun 冷却完成后的回调函数
		 */
        public function CDFace($width:Number, $height:Number, $complateFun:Function = null)
        {
            this._bindings = [];
            this._obj = {angle:0};
            this._this = this;
            this.reSet([$width, $height, $complateFun]);
            return;
        }
		/**
		 * 释放 
		 */
        public function dispose() : void
        {
            this._bindings = [];
            this._now = 0;
            this._cd = 0;
            this._obj = {angle:0};
            this._onComplete = null;
            this.parentCDFace = null;
            return;
        }
		/**
		 * 设定值,常用语初始化值
		 * @param value
		 * 
		 */
        public function reSet(value:Array) : void
        {
            this._w = value[0] / 2;
            this._h = value[1] / 2;
            this._onComplete = value[2];
            if (!this._mask)
            {
                this._mask = new Shape();
                this.addChild(this._mask);
            }
            if (!this._black)
            {
                this._black = new Shape();
                this.addChild(this._black);
            }
			if (!this._line)
			{
				this._line = new Shape();
				this.addChild(this._line);
			}
            this._line.x = this._w;
            this._line.y = this._h;
            this._mask.x = this._w;
            this._mask.y = this._h;
            DrawUtil.drawRect(_black, new Point(0, 0), new Point(value[0], value[1]), new StyleData(0, 0, 0, 0, 0.5), true);
			_black.mask = this._mask;
            return;
        }

        public function hasBindingChild($cdFace:CDFace) : Boolean
        {
            return this._bindings && this._bindings.indexOf($cdFace) != -1;
        }

        public function addBindingChild($cd:CDFace, $clear:Boolean = false, value3:Boolean = true) : void
        {
            if ($clear)
            {
                this.removeAllBindingChildren(value3);
            }
            else if (this.hasBindingChild($cd))
            {
                return;
            }
            if ($cd.parentCDFace)
            {
                $cd.parentCDFace.removeBindingChild($cd);
            }
            $cd.stop(false);
            $cd.parentCDFace = this;
            $cd.now = this._now;
            $cd.cd = this._cd;
            $cd.update(this._cd != 0 ? (this._now / this._cd * 360) : (360));
            this._bindings.push($cd);
            return;
        }

        public function removeBindingChild(value1:CDFace, value2:Boolean = true) : void
        {
            var _loc_3:Array = null;
            if (value1 && this._bindings.indexOf(value1) != -1)
            {
                _loc_3 = this._bindings.splice(this._bindings.indexOf(value1), 1);
                if (_loc_3[0].parentCDFace == this)
                {
                    _loc_3[0].parentCDFace = null;
                }
                if (value2)
                {
                    _loc_3[0].update(360);
                }
            }
            return;
        }
		/**
		 * 删除所有cd绑定的效果
		 * @param $complate 是否跳到完成完成状态
		 * 
		 */
        public function removeAllBindingChildren($complate:Boolean = true) : void
        {
            var _cdFace:CDFace = null;
            while (this._bindings.length > 0)
            {
                
                _cdFace = this._bindings.shift();
                if (_cdFace.parentCDFace == this)
                {
                    _cdFace.parentCDFace = null;
                }
                if ($complate)
                {
                    _cdFace.update(360);
                }
            }
            return;
        }
		/**
		 *  播放cd 效果,并开始计时.以“秒”为单位
		 * @param $cd 总时间
		 * @param $start 开始时间
		 * 
		 */
        public function play($cd:Number, $start:Number = 0) : void
        {
            this.stop(false);
            this._now = $start;
            this._cd = $cd;
            if (this._bindings && this._bindings.length > 0)
            {
                this._bindings.forEach(function (value1:*, value2:int, value3:Array) : void
            {
                if (value1.parentCDFace == _this)
                {
                    value1.now = _now;
                    value1.cd = _cd;
                }
                else
                {
                    _bindings.splice(value2, 1);
                }
                return;
            }
            );
            }
            this._obj.angle = this._cd != 0 ? (this._now / this._cd * 360) : (360);
            if (this.getLosttime() > 0)
            {
                this.onUpdate();
                TweenLite.to(this._obj, this.getLosttime(), {angle:360, onUpdate:this.onUpdate, onComplete:this.onComplete, ease:Linear.easeNone});
            }
            else
            {
                this.onComplete();
            }
            return;
        }
		/**
		 * 冷却中更新 
		 */
        private function onUpdate() : void
        {
			this.update(this._obj.angle);
            return;
        }
		/**
		 * 冷却完成 
		 */
        private function onComplete() : void
        {
            this.update(360);
            if (this._onComplete != null)
            {
                this._onComplete(this);
            }
            return;
        }
		/**
		 * 停止动画 
		 * @param $complate 是否触发完成状态
		 * 
		 */
        public function stop($complate:Boolean = true) : void
        {
            TweenLite.killTweensOf(this._obj, $complate);
            return;
        }
		/**
		 * 获取剩下的时间 
		 * @return 
		 * 
		 */
        public function getLosttime() : Number
        {
            return this._cd - this._now;
        }
		/**
		 * 获取现在经过了多长时间 
		 * @return 
		 * 
		 */
        public function get now() : Number
        {
            return this._now;
        }
		/**
		 * 设置现在经过了多长时间 
		 * @param value
		 * 开始播放时间节点为0
		 */
        public function set now(value:Number) : void
        {
            this._now = value;
            return;
        }
		/**
		 * 获取总的cd时间 
		 * @return 
		 * 
		 */
        public function get cd() : Number
        {
            return this._cd;
        }
		/**
		 * 设置总的cd时间 
		 * @param value
		 * 
		 */
        public function set cd(value:Number) : void
        {
            this._cd = value;
            return;
        }
		/**
		 * 获取绑定的个数 
		 * @return 
		 * 
		 */
        public function get bindingNum() : int
        {
            return this._bindings.length;
        }

        private function update($angle:Number = 0) : void
        {
            var xx:Number;
            var yy:Number;
            this._now = $angle / 360 * this._cd;
            if (this._bindings && this._bindings.length > 0)
            {
                this._bindings.forEach(function (value1:*, value2:int, value3:Array) : void
							            {
							                if (value1.parentCDFace == _this)
							                {
							                    value1.update($angle);
							                }
							                else
							                {
							                    _bindings.splice(value2, 1);
							                }
							                return;
							            }
						            );
            }
            this._mask.graphics.clear();
			_line.graphics.clear();
            if ($angle < 0 || $angle >= 360)
            {
                if ($angle == 0)
                {
                    DrawUtil.drawCircle(this._mask, new Point(0, 0), new Point(this._w, this._h), new StyleData(0, 0, 0, 0, 0), true);
                }
                return;
            }
            var tanA:* = Math.tan($angle * ZMath.toRad);
            var g:* = this._mask.graphics;
            g.clear();
            g.lineStyle(0, 0, 0);
            g.beginFill(0, 0);
            g.moveTo(0, 0);
            if ($angle >= 0 && $angle < 45)
            {
                xx = this._w * tanA;
                yy = -this._h;
                g.lineTo(xx, yy);
                g.lineTo(this._w, -this._h);
                g.lineTo(this._w, this._h);
                g.lineTo(-this._w, this._h);
                g.lineTo(-this._w, -this._h);
            }
            else if ($angle >= 45 && $angle < 135)
            {
                xx = this._w;
                yy = (-this._w) / tanA;
                g.lineTo(xx, yy);
                g.lineTo(this._w, this._h);
                g.lineTo(-this._w, this._h);
                g.lineTo(-this._w, -this._h);
            }
            else if ($angle > 135 && $angle < 225)
            {
                xx = (-this._h) * tanA;
                yy = this._h;
                g.lineTo(xx, yy);
                g.lineTo(-this._w, this._h);
                g.lineTo(-this._w, -this._h);
            }
            else if ($angle >= 225 && $angle < 315)
            {
                xx = -this._w;
                yy = this._w / tanA;
                g.lineTo(xx, yy);
                g.lineTo(-this._w, -this._h);
            }
            else if ($angle >= 315 && $angle < 360)
            {
                xx = this._w * tanA;
                yy = -this._h;
                g.lineTo(xx, yy);
            }
            g.lineTo(0, -this._h);
            g.lineTo(0, 0);
            g.endFill();
			_line.graphics.lineStyle(2, 0x111111, 1);
			_line.graphics.moveTo(0, 0);
			_line.graphics.lineTo(xx, yy);
			_line.graphics.moveTo(0, 0);
			_line.graphics.lineTo(0, -this._h);
            return;
        }

    }
}
