package com.leman.view
{
	import flash.events.Event;
	
	import mx.controls.ProgressBar;
	
	import spark.components.Group;
	
	public class ProBar extends Group
	{
		private static var _instance:ProBar;
		
		private var bar:ProgressBar;
		
		public function ProBar()
		{
			super();
			bar = new ProgressBar();
			bar.width = 200;
			bar.height = 30;
			bar.x = 300;
			bar.y = 300;
			this.addElement(bar);
			
			resize();
		}
		
		public function resize(event:Event = null):void
		{
//			bar.x = this.
			this.graphics.beginFill(0xcccccc,0.5);
			this.graphics.drawRect(0,0,800,700);
			this.graphics.endFill();
		}
		
		public function update(currNum:int, total:int):void
		{
			bar.setProgress(currNum, total);
			bar.label = '正在创建swf : ' + currNum + '/' + total;
		}
		
//		public static show()
	}
}