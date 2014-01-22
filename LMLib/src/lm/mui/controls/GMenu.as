package lm.mui.controls
{
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	
	import lm.mui.CompCreateFactory;
	import lm.mui.core.GlobalClass;
	import lm.mui.display.ScaleBitmap;
	
	
	public class GMenu extends GUIComponent
	{
		private var _bg:ScaleBitmap;
		private var _menu:GList;
		private var _contentPading:Number = 3;
		
		public function GMenu()
		{
			super();
			_bg = CompCreateFactory.getGeneralToolTip();
			this.addChild(_bg);
			
			_menu = new GList();
			this.addChild(_menu);
			_menu.styleName = "MenuList";
			_menu.verticalScrollPolicy = "off";
			_menu.x = 3;
			_menu.y = 3;
		}
		
		/***/
		public function get dataProvider():DataProvider
		{
			return _menu.dataProvider;
		}
		
		/***/
		public function set dataProvider(value:DataProvider):void
		{
			_menu.dataProvider = value;
		}
		
		public static function createMenu(dataprovider:Array):GMenu
		{
			var menu:GMenu = new GMenu();
			menu.tabEnabled = false;
			menu.dataProvider.removeAll();
			menu.dataProvider.concat(dataprovider);
			return menu;
		}
		
		/***/
		public function get menu():GList
		{
			return _menu;
		}
		
		override public function set width(value:Number) : void
		{
			super.width = value;
			this._bg.width = value;
			_menu.width = value - _contentPading * 2;
			return;
		}// end function
		
		override public function set height(param1:Number) : void
		{
			super.height = param1;
			this._bg.height = param1;
			_menu.height = param1 - _contentPading * 2;
			return;
		}// end function
		
		/***/
		public function get rowHeight():Number
		{
			return _menu.rowHeight;
		}
		
		/***/
		public function set rowHeight(value:Number):void
		{
			 _menu.rowHeight = value;;
		}
		
		/***/
		public function set contentPading(value:Number):void
		{
			_contentPading = value;
			_menu.x = _menu.y = value;
			_menu.width = this.width - value * 2;
			_menu.height = this.height - value * 2;
		}
	}
}