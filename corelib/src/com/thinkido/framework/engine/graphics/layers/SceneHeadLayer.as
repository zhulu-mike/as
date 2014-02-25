package com.thinkido.framework.engine.graphics.layers
{
	import com.thinkido.framework.engine.Scene;
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.SceneRender;
	import com.thinkido.framework.engine.graphics.tagger.HeadFace;
	import com.thinkido.framework.utils.SystemUtil;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * 人物头像层,统一显示人物上方内容。如名字 
	 * @author Administrator
	 * 
	 */
	public class SceneHeadLayer extends Sprite
	{
		private var _scene:Scene;
		
		public function SceneHeadLayer(value1:Scene)
		{
			this._scene = value1;
			mouseEnabled = false;
			mouseChildren = false;
			return;
		}
		
		public function dispose() : void
		{
			SystemUtil.clearChildren(this, false, false);
			return;
		}
		
		public function run() : void
		{
			var sc:SceneCharacter = null;
			var rec:Rectangle = null;
			var yy:Number = 0 ;
			var nowTime:int = SceneRender.nowTime;
			var scs:Array = this._scene.sceneCharacters;
			for each (sc in scs)
			{
				
				if (sc.headFace != null && !sc.headFace.specialPostion && sc.isInView)
				{
					rec = sc.mouseRect || sc.oldMouseRect;
					yy = rec != null ? (sc.bodyPosition - sc.pixel_y - HeadFace.HEADFACE_SPACE) : (HeadFace.DEFAULT_HEADFACE_Y);
					
					if (sc.headFace.y != yy)
					{
						sc.headFace.y = yy;
					}
					sc.headFace.checkTalkTime();
					if (sc.isSelected)
					{
						if (!sc.avatar.visible && sc.headFace.parent != null)
						{
							sc.headFace.swapShine();
						}
						else
						{
							sc.headFace.swapShine(true);
						}
					}else{
						sc.headFace.swapShine(true);
					}
				}
				if (sc.headFace != null && sc.headFace.updateNow&&sc.isInView)
				{
					sc.headFace.drawMain();
				}
			}
			return;
		}
		
	}
}

