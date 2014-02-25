package com.thinkido.framework.engine.graphics.tagger
{
    import com.greensock.TweenLite;
    import com.thinkido.framework.common.pool.IPoolClass;
    import com.thinkido.framework.engine.Engine;
    import com.thinkido.framework.engine.SceneRender;
    import com.thinkido.framework.engine.tools.ScenePool;
    import com.thinkido.framework.utils.SystemUtil;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
	/**
	 * 人物头像上方的文字、称号等  
	 * @author thinkido
	 * 
	 */
    public class HeadFace extends Sprite implements IPoolClass
    {
        private var _nickName:String;
        private var _nickNameColor:uint;
        private var _showNickName:Boolean = true;
        private var _customTitle:String;
        private var _showCustomTitle:Boolean = true;
		private var _nickLeftIco:Array = [];
		private var _showNickLeftIco:Boolean = true;
        private var _leftIco:DisplayObject;
        private var _showLeftIco:Boolean = true;
        private var _topIco:DisplayObject;
        private var _showTopIco:Boolean = true;
        private var _barNow:int;
        private var _barTotal:int;
        private var _showBar:Boolean = true;
        private var _talkText:String;
        private var _talkTextColor:int;
        private var _talkTime:int = 0;
        private var _talkTimeDelay:int = 8000;
        private var _showTalkText:Boolean = true;
        private var _isLight:Boolean = false;
        private var _lastShineTime:int = 0;
        private var _mainBitmap:Bitmap;
        private var _barShape:Shape;
        private var _barBackShape:Shape;
        private var _talkBitmap:Bitmap;
		private var _specialPostion:Boolean = false ;
		private var _customFaces:Array = [];
        private static const FILTERS_UNLIGHT:Array = [new GlowFilter(3148544, 1, 2, 2, 15, BitmapFilterQuality.LOW)];
        private static const FILTERS_LIGHT:Array = [new GlowFilter(12568381, 1, 2, 2, 15, BitmapFilterQuality.LOW)];
        public static const HEADFACE_SPACE:int = 5;
        public static const DEFAULT_HEADFACE_Y:int = -100;
        private static const BAR_WIDTH:int = 60;
        private static const BAR_HEIGHT:int = 3;
        private static const LEFT_ICO_SPACE:int = 2;
        private static const TOP_ICO_SPACE:int = 2;
        private static const BOTTOM_BAR_SPACE:int = 2;
		public static const HEADBAR_TWEENLITE_TIME:Number = 0.2;
		
		public var updateNow:Boolean = false;

        public function HeadFace($nickName:String = "", $nickColor:uint = 16777215, $customTitle:String = "", $leftIco:DisplayObject = null, $topIco:DisplayObject = null)
        {
            this.reSet([$nickName, $nickColor, $customTitle, $leftIco, $topIco, this._customFaces, this._nickLeftIco]);
            return;
        }

		/**
		 * 设置特别位置 
		 * @return 
		 * 
		 */
		public function get specialPostion():Boolean
		{
			return _specialPostion;
		}

		public function set specialPostion(value:Boolean):void
		{
			_specialPostion = value;
		}

        public function get nickName() : String
        {
            return this._nickName;
        }

        public function get nickNameColor() : uint
        {
            return this._nickNameColor;
        }

        public function get customTitle() : String
        {
            return this._customTitle;
        }

        public function get leftIco() : DisplayObject
        {
            return this._leftIco;
        }

        public function get topIco() : DisplayObject
        {
            return this._topIco;
        }

        public function get barNow() : int
        {
            return this._barNow;
        }

        public function get barTotal() : int
        {
            return this._barTotal;
        }

        public function get talkText() : String
        {
            return this._talkText;
        }

        public function get talkTextColor() : int
        {
            return this._talkTextColor;
        }

        public function dispose() : void
        {
			SystemUtil.clearChildren(this, true);
            this._nickName = "";
            this._nickNameColor = 16777215;
            this._customTitle = "";
            this._leftIco = null;
            this._topIco = null;
            this._barNow = 0;
            this._barTotal = 0;
            this._showNickName = true;
            this._isLight = false;
            this._showCustomTitle = true;
            this._showLeftIco = true;
            this._showTopIco = true;
            this._showBar = true;
            this._showTalkText = true;
            this._mainBitmap = null;
            this._barShape = null;
            this._barBackShape = null;
            this._talkBitmap = null;
			this._customFaces.length = 0;
			this._nickLeftIco.length = 0;
			this._showNickLeftIco = true;
			this.updateNow = false;
			_specialPostion = false ;
            visible = true;
            return;
        }

        public function reSet(value1:Array) : void
        {
            this._nickName = value1[0];
            this._nickNameColor = value1[1];
            this._customTitle = value1[2];
            this._leftIco = value1[3];
            this._topIco = value1[4];
			if (value1.length > 5)
				this._customFaces = value1[5];
			else 
				this._customFaces.length = 0;
			if (value1.length > 6)
				this._nickLeftIco = value1[6];
			else 
				this._nickLeftIco.length = 0;
//            this.drawMain();
			updateNow = true;
            return;
        }
		
		/**根据自定义称号的深度来排序*/
		private function sortCustomFaces():void
		{
			this._customFaces.sortOn("depth", Array.NUMERIC);
		}

        public function setHeadFaceNickNameVisible(value1:Boolean) : void
        {
            this._showNickName = value1;
//            this.drawMain();
			updateNow = true;
            return;
        }

        public function setHeadFaceCustomTitleVisible(value1:Boolean) : void
        {
            this._showCustomTitle = value1;
//            this.drawMain();
			updateNow = true;
            return;
        }

        public function setHeadFaceLeftIcoVisible(value1:Boolean) : void
        {
            this._showLeftIco = value1;
//            this.drawMain();
			updateNow = true;
            return;
        }
		/**
		 * 设置人物名称同行左边的图标的可见状态
		 * @param value1
		 * 
		 */		
		public function setHeadFaceNickLeftIcoVisible(value1:Boolean) : void
		{
			if (value1 != _showNickLeftIco)
			{
				this._showNickLeftIco = value1;
//				this.drawMain();
				updateNow = true;
			}
			return;
		}

        public function setHeadFaceTopIcoVisible(value1:Boolean) : void
        {
            this._showTopIco = value1;
//            this.drawMain();
			updateNow = true;
            return;
        }

        public function setHeadFaceBarVisible(value1:Boolean) : void
        {
            this._showBar = value1;
            if (this._barBackShape != null)
            {
                this._barBackShape.visible = this._showBar;
            }
            if (this._barShape != null)
            {
                this._barShape.visible = this._showBar;
            }
//            this.drawMain();
			updateNow = true;
            return;
        }

        public function setHeadFaceTalkTextVisible(value1:Boolean) : void
        {
            this._showTalkText = value1;
            this.drawTalk();
            return;
        }

        public function setHeadFaceNickName($nickName:String = "", $nickNameColor:uint = 16777215) : void
        {
            this.reSet([$nickName, $nickNameColor, this._customTitle, this._leftIco, this._topIco, this._customFaces, this._nickLeftIco]);
            return;
        }
		
		/**
		 * 添加一个图标到人物名称左边
		 * @param $nickName
		 * @param $nickNameColor
		 * 
		 */		
		public function addHeadFaceNickNameLeftIcon(value:Array) : void
		{
			var i:int = 0, len:int = value.length, temp:BaseCustomFace;
			for (;i<len;i++)
			{
				temp = value[i];
				deleteSameNickLeftIconByName(temp.name);
				this._nickLeftIco.push(temp);
			}
			this._nickLeftIco.sortOn("depth", Array.NUMERIC);
			this.reSet([this._nickName, this._nickNameColor, this._customTitle, this._leftIco, this._topIco, this._customFaces, this._nickLeftIco]);
			return;
		}
		
		private function deleteSameNickLeftIconByName(value:String):void
		{
			var i:int = 0;
			for each (var vo:BaseCustomFace in this._nickLeftIco)
			{
				if (vo.name == value)
				{
					vo.content = null;
					_nickLeftIco.splice(i,1);
					return;	
				}
				i++;
			}
		}

        public function setHeadFaceCustomTitleHtmlText(value1:String = "") : void
        {
            this.reSet([this._nickName, this._nickNameColor, value1, this._leftIco, this._topIco, this._customFaces, this._nickLeftIco]);
            return;
        }

        public function setHeadFaceLeftIco(value1:DisplayObject = null) : void
        {
            this.reSet([this._nickName, this._nickNameColor, this._customTitle, value1, this._topIco, this._customFaces, this._nickLeftIco]);
            return;
        }

        public function setHeadFaceTopIco(value1:DisplayObject = null) : void
        {
            this.reSet([this._nickName, this._nickNameColor, this._customTitle, this._leftIco, value1, this._customFaces, this._nickLeftIco]);
            return;
        }
		
		public function addCustomHeadFace(value:BaseCustomFace):void
		{
			this._customFaces.push(value);
			this.sortCustomFaces();
			this.reSet([this._nickName, this._nickNameColor, this._customTitle, this._leftIco, this._topIco, this._customFaces, this._nickLeftIco]);
		}
		
		public function hasCustomHeadFace(name:String):Boolean
		{
			for each (var vo:BaseCustomFace in this._customFaces)
			{
				if (vo.name == name)
				{
					return true;
				}
			}
			return false;
		}
		
		public function removeCustomHeadFaceByName(value:String):void
		{
			var i:int = 0;
			for each (var vo:BaseCustomFace in this._customFaces)
			{
				if (vo.name == value)
				{
					vo.content = null;
					_customFaces.splice(i,1);
//					drawMain();
					updateNow = true;
					return;	
				}
				i++;
			}
		}
		
		public function hasNickLeftIcon(name:String):Boolean
		{
			for each (var vo:BaseCustomFace in this._nickLeftIco)
			{
				if (vo.name == name)
				{
					return true;
				}
			}
			return false;
		}
		
		public function removeNickLeftIconByName(value:String):void
		{
			var i:int = 0;
			for each (var vo:BaseCustomFace in this._nickLeftIco)
			{
				if (vo.name == value)
				{
					vo.content = null;
					_customFaces.splice(i,1);
//					drawMain();
					updateNow = true;
					return;	
				}
				i++;
			}
		}
		
		
		/**
		 * 设置血条 
		 * @param $hpNow
		 * @param $hpMax
		 * @param $useTween
		 * 和人数数值无关，纯显示
		 */
        public function setHeadFaceBar($hpNow:int, $hpMax:int, $useTween:Boolean=false) : void
        {
            if ($hpNow < 0)
            {
                $hpNow = 0;
            }
            if ($hpMax < 0)
            {
                $hpMax = 0;
            }
            if ($hpMax == 0)
            {
                return;
            }
            this._barNow = $hpNow;
            this._barTotal = $hpMax;
            if (this._barBackShape == null || this._barShape == null)
            {
                if (this._barBackShape == null)
                {
                    this._barBackShape = new Shape();
                    this._barBackShape.graphics.beginFill(0, 1);
                    this._barBackShape.graphics.drawRect(-1, -1, BAR_WIDTH + 2, BAR_HEIGHT + 2);
                    this._barBackShape.graphics.endFill();
                    this._barBackShape.y = -BAR_HEIGHT;
                    addChild(this._barBackShape);
                    this._barBackShape.visible = this._showBar;
                }
                if (this._barShape == null)
                {
                    this._barShape = new Shape();
                    this._barShape.graphics.beginFill(16711680, 1);
                    this._barShape.graphics.drawRoundRect(0, 0, BAR_WIDTH, BAR_HEIGHT, BAR_HEIGHT / 2, BAR_HEIGHT / 2);
                    this._barShape.graphics.endFill();
                    this._barShape.y = -BAR_HEIGHT;
                    addChild(this._barShape);
                    this._barShape.visible = this._showBar;
                }
                this.resize();
            }
			if ($useTween)
           		TweenLite.to(this._barShape, HEADBAR_TWEENLITE_TIME, {scaleX:this._barNow / this._barTotal});
			else
				this._barShape.scaleX = this._barNow / this._barTotal;
            return;
        }
		/**
		 * 说话 
		 * @param $talkText
		 * @param $color
		 * @param $delay
		 * 
		 */
        public function setHeadFaceTalkText($talkText:String = "", $color:uint = 16777215, $delay:int = 8000) : void
        {
            this._talkText = $talkText;
            this._talkTextColor = $color;
            this._talkTime = SceneRender.nowTime;
            this._talkTimeDelay = $delay;
            this.drawTalk();
            return;
        }

        public function checkTalkTime() : void
        {
            if (this._talkText != "" && SceneRender.nowTime - this._talkTime > this._talkTimeDelay)
            {
                this.setHeadFaceTalkText("");
            }
            return;
        }

        public function swapShine(value1:Boolean = false) : void
        {
            if (value1)
            {
                if (this._isLight == false)
                {
                    return;
                }
            }
            if (SceneRender.nowTime - this._lastShineTime > 200|| this.updateNow)
            {
                this._lastShineTime = SceneRender.nowTime;
                this._isLight = !this._isLight;
                this.drawMain();
            }
            return;
        }
		
		
		/**
		 * @private 
		 * 绘制人物上方文字图片等
		 */		
        public function drawMain() : void
        {
            var _loc_2:Sprite = null;
            var _loc_3:TextField = null;
            var _loc_6:Rectangle = null;
            var _loc_7:Rectangle = null;
            var _loc_8:Rectangle = null;
            var _loc_9:Matrix = null;
            var _loc_1:* = new Sprite();
			var _nick:TextField;
			var nWidth:Number = 0;
			if (this._showNickLeftIco && this._nickLeftIco.length > 0)
			{
				if (_loc_2 == null)
					_loc_2 = new Sprite();
				var n:int = 0, nlen:int = _nickLeftIco.length, tempNickLeft:BaseCustomFace;
				for (;n<nlen;n++)
				{
					tempNickLeft = _nickLeftIco[n];
					if (tempNickLeft.content == null)
						continue;
					_loc_2.addChild(tempNickLeft.content);
					tempNickLeft.content.x = nWidth;
					nWidth += tempNickLeft.content.width;
				}
			}
			if (this._showNickName && this._nickName != "")
			{
				if (_loc_2 == null)
					_loc_2 = new Sprite();
				_nick = new TextField();
				_nick.multiline = true;
				_nick.mouseEnabled = false;
				_nick.defaultTextFormat = new TextFormat(Engine.font_HeadFace, 12, this._nickNameColor, null, null, null, null, null, TextFormatAlign.CENTER);
				_nick.x = nWidth;
				_nick.text = this._nickName;
				_nick.height = _nick.textHeight+4;
				_nick.width = _nick.textWidth + 4;
				if (this._isLight)
				{
					_nick.filters = FILTERS_LIGHT;
				}
				else
				{
					_nick.filters = FILTERS_UNLIGHT;
				}
				_loc_2.addChild(_nick);
			}
            if (this._showCustomTitle && this._customTitle != "")
            {
                _loc_3 = new TextField();
                _loc_3.autoSize = TextFormatAlign.LEFT;
                _loc_3.multiline = true;
                _loc_3.mouseEnabled = false;
                _loc_3.defaultTextFormat = new TextFormat(Engine.font_HeadFace, 12, null, null, null, null, null, null, TextFormatAlign.CENTER, 0, 0, 0, 5);
                _loc_3.width = 0;
                _loc_3.x = 0;
                _loc_3.filters = FILTERS_UNLIGHT;
                _loc_3.htmlText = this._customTitle;
            }
            if (_loc_2 != null)
            {
                _loc_1.addChild(_loc_2);
            }
            if (_loc_3 != null)
            {
                _loc_1.addChild(_loc_3);
            }
            if (this._showLeftIco && this._leftIco != null)
            {
                _loc_1.addChild(this._leftIco);
            }
            if (this._showTopIco && this._topIco != null)
            {
                _loc_1.addChild(this._topIco);
            }
			var customMaxWidth:Number = 0;
			var customMaxHeight:Number = 0;
			if (_customFaces.length > 0)
			{
				var len:int = _customFaces.length, ii:int = 0;
				var tempCustomFace:BaseCustomFace;
				for (;ii<len;ii++)
				{
					tempCustomFace = _customFaces[ii];
					if (tempCustomFace.content == null)
						continue;
					_loc_1.addChild(tempCustomFace.content);
					if (customMaxWidth < tempCustomFace.content.width)
						customMaxWidth = tempCustomFace.content.width;
					if (customMaxHeight < tempCustomFace.content.height)
						customMaxHeight = tempCustomFace.content.height;
				}
			}
            var _loc_4:Number = 0;
            var _loc_5:Number = 0;
            if (_loc_2 != null && _loc_3 != null)
            {
                _loc_4 = Math.max(_loc_2.width, _loc_3.width);
                _loc_5 = _loc_2.height + _loc_3.height;
            }
            else if (_loc_2 != null)
            {
                _loc_4 = _loc_2.width;
                _loc_5 = _loc_2.height;
            }
            else if (_loc_3 != null)
            {
                _loc_4 = _loc_3.width;
                _loc_5 = _loc_3.height;
            }
			_loc_4 = Math.max(_loc_4, customMaxWidth);
			_loc_5 = _loc_5 + customMaxHeight;
			var customBeginHeight:Number = 0;
			
            if (_loc_2 != null)
            {
                _loc_2.x = (_loc_4 - _loc_2.width) / 2;
				_loc_2.x = _loc_2.x - (nWidth >> 1);
				customBeginHeight = _loc_2.y = -_loc_2.height;
            }
            if (_loc_3 != null)
            {
                _loc_3.x = (_loc_4 - _loc_3.width) / 2;
                if (_loc_2 != null)
                {
					customBeginHeight = _loc_3.y = _loc_2.y - _loc_3.height;
                }
                else
                {
					customBeginHeight = _loc_3.y = -_loc_3.height;
                }
            }
			
			if (_customFaces.length > 0)
			{
				for (ii=0;ii<len;ii++)
				{
					tempCustomFace = _customFaces[ii];
					if (tempCustomFace.content == null)
						continue;
					tempCustomFace.content.x = (_loc_4 - tempCustomFace.content.width) / 2;
					customBeginHeight = tempCustomFace.content.y = customBeginHeight - tempCustomFace.content.height;
				}
			}
			
            if (this._showLeftIco && this._leftIco != null)
            {
                _loc_6 = this._leftIco.getBounds(this._leftIco);
                this._leftIco.x = -_loc_6.x - _loc_6.width - 2;
                this._leftIco.y = -_loc_6.y - (_loc_5 - _loc_6.height) / 2 - _loc_6.height;
            }
            if (this._showTopIco && this._topIco != null)
            {
                _loc_7 = this._topIco.getBounds(this._topIco);
                this._topIco.x = (_loc_4 - _loc_7.width) / 2;
                if (this._showLeftIco && this._leftIco != null && _loc_6.height > _loc_5)
                {
                    this._topIco.y = -_loc_7.x - (_loc_6.height / 2 + _loc_5 / 2) - TOP_ICO_SPACE - _loc_7.height;
                }
                else
                {
                    this._topIco.y = -_loc_7.y - _loc_5 - TOP_ICO_SPACE - _loc_7.height;
                }
            }
            if (_loc_1.numChildren > 0)
            {
                if (this._mainBitmap == null)
                {
                    this._mainBitmap = new Bitmap();
                    addChild(this._mainBitmap);
                }
                this._mainBitmap.bitmapData = new BitmapData(_loc_1.width, _loc_1.height, true, 0);
                _loc_8 = _loc_1.getBounds(_loc_1);
                _loc_9 = new Matrix();
                _loc_9.tx = -_loc_8.x;
                _loc_9.ty = -_loc_8.y;
                this._mainBitmap.bitmapData.draw(_loc_1, _loc_9);
            }
            else if (this._mainBitmap)
            {
                this._mainBitmap.bitmapData.dispose();
                if (this._mainBitmap.parent)
                {
                    this._mainBitmap.parent.removeChild(this._mainBitmap);
                }
                this._mainBitmap = null;
            }
            this.resize();
			updateNow = false;
            return;
        }

        private function drawTalk() : void
        {
            var tf:TextField = null;
            var rec:Rectangle = null;
            var mat:Matrix = null;
            var spr:Sprite = new Sprite();
            if (this._showTalkText && this._talkText != "")
            {
                tf = new TextField();
                tf.autoSize = TextFormatAlign.LEFT;
                tf.multiline = true;
                tf.mouseEnabled = false;
                tf.defaultTextFormat = new TextFormat(Engine.font_HeadFace, 12, this._talkTextColor, null, null, null, null, null, TextFormatAlign.CENTER);
                tf.width = 0;
                tf.x = 0;
                tf.filters = FILTERS_UNLIGHT;
                tf.text = this._talkText;
            }
            if (tf != null)
            {
                spr.addChild(tf);
                spr.graphics.beginFill(0, 0.3);
                spr.graphics.drawRect(-2, -2, spr.width + 4, spr.height + 4);
                spr.graphics.endFill();
            }
            if (spr.numChildren > 0)
            {
                if (this._talkBitmap == null)
                {
                    this._talkBitmap = new Bitmap();
                    addChild(this._talkBitmap);
                }
                this._talkBitmap.bitmapData = new BitmapData(spr.width, spr.height, true, 0);
                rec = spr.getBounds(spr);
                mat = new Matrix();
                mat.tx = -rec.x;
                mat.ty = -rec.y;
                this._talkBitmap.bitmapData.draw(spr, mat);
            }
            else if (this._talkBitmap)
            {
                this._talkBitmap.bitmapData.dispose();
                if (this._talkBitmap.parent)
                {
                    this._talkBitmap.parent.removeChild(this._talkBitmap);
                }
                this._talkBitmap = null;
            }
            this.resize();
            return;
        }

        private function resize() : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_1:Boolean = false;
            var _loc_2:Boolean = false;
            var _loc_3:Boolean = false;
            if (this._showBar && this._barBackShape != null && this._barShape != null)
            {
                _loc_1 = true;
                var _half:int = (-BAR_WIDTH) / 2;
                this._barShape.x = (-BAR_WIDTH) / 2;
                this._barBackShape.x = _half;
                this._barShape.y = -BAR_HEIGHT ;
                this._barBackShape.y = -BAR_HEIGHT ;
            }
            if (this._mainBitmap != null)
            {
                _loc_2 = true;
                if (this._showTopIco && this._topIco != null && this._topIco.width == this._mainBitmap.width)
                {
                    this._mainBitmap.x = (-this._mainBitmap.width) / 2;
                }
                else
                {
                    _loc_4 = this._showLeftIco && this._leftIco != null ? (this._leftIco.width + LEFT_ICO_SPACE) : (0);
                    _loc_5 = this._mainBitmap.width - _loc_4;
                    this._mainBitmap.x = -_loc_4 - _loc_5 / 2;
                }
                if (this._showBar && this._barBackShape != null && this._barShape != null)
                {
                    this._mainBitmap.y = -BAR_HEIGHT - BOTTOM_BAR_SPACE - this._mainBitmap.height;
                }
                else
                {
                    this._mainBitmap.y = -this._mainBitmap.height;
                }
            }
            if (this._talkBitmap != null)
            {
                _loc_3 = true;
                this._talkBitmap.x = (-this._talkBitmap.width) / 2;
                if (_loc_2)
                {
                    this._talkBitmap.y = this._mainBitmap.y - BOTTOM_BAR_SPACE - this._talkBitmap.height;
                }
                else if (_loc_1)
                {
                    this._talkBitmap.y = this._barBackShape.y - BOTTOM_BAR_SPACE - this._talkBitmap.height;
                }
                else
                {
                    this._talkBitmap.y = -this._talkBitmap.height;
                }
            }
            return;
        }
		/**
		 * @see HeadFace
		 * 
		 */
        public static function createHeadFace(value1:String = "", value2:uint = 16777215, value3:String = "", value4:DisplayObject = null, value5:DisplayObject = null) : HeadFace
        {
            return ScenePool.headFacePool.createObj(HeadFace, value1, value2, value3, value4, value5) as HeadFace;
        }

        public static function recycleHeadFace(value1:HeadFace) : void
        {
            ScenePool.headFacePool.disposeObj(value1);
            return;
        }

    }
}
