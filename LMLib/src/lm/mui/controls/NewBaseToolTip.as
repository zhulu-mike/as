package lm.mui.controls
{
	import fl.core.UIComponent;
	
	import lm.mui.manager.IToolTip;
	
	public class NewBaseToolTip extends UIComponent implements IToolTip
	{
		
		protected var paddingTop:Number = 5;
		protected var paddingBottom:Number = 5;
		protected var paddingLeft:Number = 5;
		protected var paddingRight:Number = 5;
		protected var contentContainer:UIComponent;
		
		public function NewBaseToolTip()
		{
			this.contentContainer = new UIComponent();
			super();
		}
		
		public function set data(param1:Object):void
		{
			this._width = this.contentContainer.width + this.paddingLeft + this.paddingRight;
			this._height = this.contentContainer.height + this.paddingTop + this.paddingBottom;
			this.contentContainer.y = this.paddingTop;
			this.contentContainer.x = this.paddingLeft;
			this.updateSize(this._width, this._height);
			return;
		}
		
		protected function updateSize(param1:Number, param2:Number) : void
		{
			
			return;
		}
		
		override public function get width() : Number
		{
			return this._width;
		}
		
		override public function get height() : Number
		{
			return this._height;
		}
		
	}
}