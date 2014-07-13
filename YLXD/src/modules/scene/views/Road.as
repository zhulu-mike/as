package modules.scene.views
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Road extends Sprite
	{
		public function Road(w:int)
		{
			var r:Quad = new Quad(w,30,0xcccccc);
			this.addChild(r);
		}
	}
}