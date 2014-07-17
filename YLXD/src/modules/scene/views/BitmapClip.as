package modules.scene.views
{
	import configs.GameInstance;
	
	import managers.ResManager;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	public class BitmapClip extends Sprite
	{
		public function BitmapClip()
		{
			var mc:MovieClip = new MovieClip(ResManager.assetsManager.getTextures());
			mc.loop = true;
			
		}
	}
}