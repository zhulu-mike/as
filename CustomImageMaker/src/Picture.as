package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Picture extends Sprite
	{
		public var content:TextField;
		public function Picture()
		{
			content = new TextField();
			content.defaultTextFormat = new TextFormat(null, 12, 0xffffff, null, null, null, null, null, TextFormatAlign.CENTER);
			addChild(content);
			content.height = 22;
			content.width  = 10;
		}
	}
}