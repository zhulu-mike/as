package lm.mui.controls
{
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarMode;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lm.mui.manager.IToolTipItem;
	import lm.mui.manager.ToolTipsManager;
	import lm.mui.skins.SkinManager;
	
	public class GprogressBar extends UIComponent implements IToolTipItem
	{
		public const CLASSNAME:String = "GProgressBar";
		protected var _toolTipData:Object;
		protected var _styleName:String;
		protected var _isStyleChange:Boolean = false;
		private var _label:GLabel;
		private var pBar:ProgressBar;
		private var format:TextFormat = new TextFormat();
		
		
		public function GprogressBar()
		{
			super();
			pBar = new ProgressBar;
			pBar.mode = ProgressBarMode.MANUAL;
			this.addChild(pBar);
			this._label = new GLabel();
			format.bold = true;
			format.color = 0xff0000;
			format.align = TextFormatAlign.CENTER;
			this._label.setStyle('textFormat',format);
			this.addChild(this._label);
			this._label.x = (this.width - this._label.width) / 2;
			this._label.y = (this.height - this._label.height) / 2;
		}
		
		override public function set width($width:Number):void
		{
			super.width = $width;
			this.pBar.width = $width;
			this._label.x = (this.width - this._label.width) / 2;
		}
		
		override public function set height($height:Number):void
		{
			super.height = $height;
			this.pBar.height = $height;
			this._label.y = (this.height - this._label.height) / 2;
		}
		
		public function setProgress(value:Number, maxValue:Number):void
		{
			if(value / maxValue < 0.01)
			{
				value = maxValue * 0.01;
			}
			pBar.setProgress(value,maxValue);
			this._label.text = int(value) + ' / ' + int(maxValue);
		}
		
		public function get percentComplete():Number
		{
			return this.pBar.percentComplete;
		}
		
		public function set label(str:String):void
		{
			this._label.text = str;
		}
		
		public function get toolTipData():Object
		{
			return this._toolTipData;
		}
		
		public function set toolTipData(param1:Object) : void
		{
			if (param1 == null || param1 == "")
			{
				ToolTipsManager.unregister(this);
			}
			else
			{
				ToolTipsManager.register(this);
			}
			this._toolTipData = param1;
			return;
		}
		
		public function get styleName() : String
		{
			return this._styleName;
		}
		
		public function set styleName(param1:String) : void
		{
			if (this._styleName != param1)
			{
				this._styleName = param1;
				invalidate(InvalidationType.STYLES);
				this._isStyleChange = true;
			}
			return;
		}
		
		final override protected function draw() : void
		{
			if (isInvalid(InvalidationType.STYLES))
			{
				if (this._isStyleChange)
				{
					SkinManager.setComponentStyle(this.pBar, this._styleName);
					this._isStyleChange = false;
				}
				this.updateStyle();
			}
			if (isInvalid(InvalidationType.DATA))
			{
				this.updateDate();
			}
			if (isInvalid(InvalidationType.SIZE))
			{
				this.updateSize();
			}
			if (isInvalid(InvalidationType.SIZE, InvalidationType.SELECTED, InvalidationType.DATA))
			{
				this.updateDisplayList();
			}
			try
			{
				super.draw();
			}
			catch (e:Error)
			{
			}
			return;
		}
		
		protected function createChildren() : void
		{
			return;
		}
		
		protected function updateStyle() : void
		{
			return;
		}
		
		protected function updateSize() : void
		{
			return;
		}
		
		protected function updateDate() : void
		{
			return;
		}
		
		protected function updateDisplayList() : void
		{
			return;
		}
	}
}