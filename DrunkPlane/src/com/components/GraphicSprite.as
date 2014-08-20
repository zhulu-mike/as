package  com.components
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
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
			if (image != null)
			{
				image.removeFromParent(true);
			}
			if (shape.width < 1 || shape.height < 1)
			{
				return;
			}
			var rect:Rectangle = shape.getBounds(shape);
			var bmd:BitmapData = new BitmapData(shape.width, shape.height,true,0);
			var matrix:Matrix = new Matrix();
			matrix.translate(-rect.x,-rect.y);
			bmd.draw(shape,matrix);
			image = new Image(Texture.fromBitmapData(bmd));
			this.addChild(image);
			image.x = rect.x;
			image.y = rect.y;
		}
		
		public function destroy():void
		{
			if (image)
			{
				image.removeFromParent(true);
				shape = null;
			}
		}
		
	}
}