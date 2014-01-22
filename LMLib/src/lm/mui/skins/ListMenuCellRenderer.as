package lm.mui.skins
{
	import fl.controls.listClasses.CellRenderer;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lm.mui.controls.GLabel;
	import lm.mui.core.GlobalClass;

    public class ListMenuCellRenderer extends CellRenderer
    {
		private var _textField:GLabel;
		
        public function ListMenuCellRenderer()
        {
			var rect:Rectangle =  new Rectangle(4,4,200,14);
            setSize(54, 20);
            this.setStyle("downSkin", GlobalClass.getScaleBitmap("GeneralMenuBg", rect));
            this.setStyle("overSkin", GlobalClass.getScaleBitmap("GeneralMenuBg", rect));
            this.setStyle("upSkin", new Bitmap());
            this.setStyle("selectedDownSkin", GlobalClass.getScaleBitmap("GeneralMenuBg", rect));
            this.setStyle("selectedOverSkin",GlobalClass.getScaleBitmap("GeneralMenuBg", rect));
            this.setStyle("selectedUpSkin", GlobalClass.getScaleBitmap("GeneralMenuBg", rect));
            this.setStyle("textFormat", new TextFormat(null, 12, 0xffffff));
			
			
			this._textField = new GLabel();
			this._textField.selectable = false;
			this._textField.width = 250;
			_textField.height = 18;
			this._textField.mouseEnabled = false;
			this.addChild(this._textField);
			_textField.setStyle("textFormat", new TextFormat(null, 12, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT));
			_textField.validateNow();
            return;
        }
		
		override public function set data($data:Object):void
		{
			super.data = $data;
			this._textField.text = $data.name;
		}
//		
		override public function set label(arg0:String):void
		{
			return;
		}		

    }
}
