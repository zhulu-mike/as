package com.g6game.display
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 背景层
	 */
	public final class BackGround extends BaseGround
	{
		public function BackGround()
		{
			setMouseEnable(false);
		}
		
		private var backImage:Bitmap;
		
		public function setBackImage(img:Bitmap=null):void
		{
			if (!img)
				return;
			if (backImage)
			{
				this.removeChild(backImage);
				backImage.bitmapData.dispose();
			}
			this.addChildAt(img, 0);
			backImage = img;
		}
		
		public function init():void
		{
			if (backImage)
			{
				this.removeChild(backImage);
				backImage.bitmapData.dispose();
				backImage = null;
			}
		}
	}
}