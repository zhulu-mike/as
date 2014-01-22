package com.g6game.display
{
	import spark.components.ComboBox;
	
	public class MyComboBox extends ComboBox
	{
		public function MyComboBox()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.textInput.editable = false;
		}
	}
}