package com.starling
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 含有绘图的精灵
	 * @author Administrator
	 * 
	 */	
	public class GraphicSprite extends Sprite
	{
		private var shape:Shape;
		private var image:Image;
		public function GraphicSprite()
		{
			shape = new Shape();
		}
		
		public function get graphics():Graphics
		{
			return shape.graphics;
		}
		
		public function draw():void
		{
			var bmd:BitmapData = new BitmapData(shape.width, shape.height);
			bmd.draw(shape);
			if (image == null)
			{
				image = new Image(Texture.fromBitmapData(bmd));
				this.addChild(image);
			}else{
				image.texture = Texture.fromBitmapData(bmd);
			}
		}
		
		
	}
}