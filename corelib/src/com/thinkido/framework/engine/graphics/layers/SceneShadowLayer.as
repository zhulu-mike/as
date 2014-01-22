package com.thinkido.framework.engine.graphics.layers
{
	import com.thinkido.framework.engine.Scene;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.SceneRender;
	import com.thinkido.framework.engine.graphics.tagger.ShadowShape;
	import com.thinkido.framework.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 人物实时阴影层
	 * @author wangjianglin
	 * 
	 */	
	public class SceneShadowLayer extends Sprite
	{
		
		private var _scene:Scene;
		public function SceneShadowLayer(value1:Scene)
		{
			this._scene = value1;
			mouseEnabled = false;
			mouseChildren = false;
			return;
		}
		
		
		
		public function dispose() : void
		{
			var child:ShadowShape;
			while(this.numChildren)
			{
				child = this.getChildAt(0) as ShadowShape;
				this.removeChild(child);
			}
			return;
		}
		
	}
}