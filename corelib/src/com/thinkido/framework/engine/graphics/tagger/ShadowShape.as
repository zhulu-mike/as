package com.thinkido.framework.engine.graphics.tagger
{
	import com.thinkido.framework.common.pool.IPoolClass;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.config.GlobalConfig;
	import com.thinkido.framework.engine.staticdata.AvatarPartType;
	import com.thinkido.framework.engine.tools.ScenePool;
	import com.thinkido.framework.engine.vo.avatar.AvatarFaceData;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class ShadowShape extends Sprite implements IPoolClass
	{
		private var _sc:SceneCharacter;
		
		public static const DEFAULT_SHADOW_Y:int = -100;
		
		public function ShadowShape(ss:SceneCharacter)
		{
			reSet([ss]);
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function dispose():void
		{
			this.graphics.clear();
			this._sc = null;
		}
		
		public function reSet($inits:Array):void
		{
			_sc = $inits[0];
		}
		
		public function drawShadow(ss:SceneCharacter):void
		{
			if (this._sc.scene == null)
				return;
			if (this._sc.scene.mapConfig == null)
				return;
			 if (!_sc.visible || !_sc.inViewDistance() || !_sc.enabledShadow)
			 {
				 if (this.parent)
				 {
					 this.parent.removeChild(this);
				 }
			 }else{
				 if (this.parent == null)
				 {
					 this._sc.scene.sceneShadowLayer.addChild(this);
				 }
				 this.graphics.clear();
				 var rec:Rectangle = null;
				 var yy:Number = 0 ,xx:Number = 0;
				 rec = _sc.mouseRect || _sc.oldMouseRect;
				 yy = _sc.pixel_y;
				 xx = _sc.pixel_x;
				 if (this.y != yy)
					 this.y = yy;
				 if (this.x != xx)
					 this.x = xx;
				 var faceList:Array = null;
				 var _len:int = 0;
				 faceList = this._sc.getNowAvatarFaceList();
				 _len = faceList.length;
				 if (_len == 0)
				 {
					 return;
				 }
				 var _mat:Matrix = null;
				 _mat = new Matrix();
				 _mat.identity();
				 _mat.scale(1, GlobalConfig.shadowYScale);
				 var _index:int = 0;
				 _index = _len - 1;
				 var face:AvatarFaceData = null;
				 var needDraw:Boolean = false;
				 var _loc_11:Number = NaN;
				 var _loc_12:int = 0;
				 var _loc_13:int = 0;
				 var _col:ColorTransform = null;
				 var _angle:Number = NaN;
				 
				 while (_index >= 0)
				 {
					 face = faceList[_index];
					 if (face.ap.type == AvatarPartType.MAGIC_RING || face.ap.type == AvatarPartType.MAGIC || face.ap.type == AvatarPartType.MAGIC_PASS)
					 {
						 _index--;
						 continue;
					 }
					 if (face.ap.enableShadow)
					 {
						 if (!face.cutRect.isEmpty())
						 {
							 needDraw = true;
							 _loc_11 = 1;
							 _loc_12 = -face.cutRect.x + this._sc.pixel_x;
							 _loc_13 = -face.cutRect.y + this._sc.pixel_y;
							 _mat.tx = -face.sourcePoint.x - _loc_11 - _loc_12 - _loc_11;
							 _mat.ty = (-face.sourcePoint.y - _loc_11 - _loc_13) * GlobalConfig.shadowYScale;
							 this.graphics.beginBitmapFill(face.sourceBitmapData, _mat, false);
							 this.graphics.drawRect(-_loc_12, (-_loc_13) * GlobalConfig.shadowYScale, face.cutRect.width - _loc_11 * 2, Math.floor((face.cutRect.height - _loc_11 * 2)* GlobalConfig.shadowYScale));
							 this.graphics.endFill();
						 }
					 }
					 _index = _index - 1;
				 }
				 
				 if (needDraw)
				 {
					 _col = new ColorTransform();
					 _col.color = 0;
					 _col.alphaMultiplier = GlobalConfig.shadowAlpha;
					 this.transform.colorTransform = _col;
					 _mat.identity();
					 _mat.tx = this.x;
					 _mat.ty = this.y;
					 _angle = GlobalConfig.shadowAngle / 180 * Math.PI;
					 _mat.c = Math.tan(_angle);
					 this.transform.matrix = _mat;
				 }
				 
			 }
		}
		
		public static function createShadowShape(sc:SceneCharacter):ShadowShape
		{
			return ScenePool.shadowPool.createObj(ShadowShape, sc) as ShadowShape;
		}
		
		public static function recycleShadowShape(ss:ShadowShape) : void
		{
			ScenePool.shadowPool.disposeObj(ss);
			return;
		}
	}
}