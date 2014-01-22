package com.g6game.display
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MyTextFiled extends TextField
	{
		
		private var textFormat:TextFormat;
		
		public function MyTextFiled(c:uint=0x000000, s:Number=12)
		{
			textFormat = new TextFormat();
			textFormat.color = c;
			textFormat.size  = s;
			textFormat.align = "center";
			this.defaultTextFormat = textFormat;
			//this.background = true;
			//this.backgroundColor = 0xff0000;
			height = 20;
			width  = 60;
		}
		
	}
}