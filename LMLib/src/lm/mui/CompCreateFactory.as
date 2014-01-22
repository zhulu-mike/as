package lm.mui
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import lm.mui.controls.GButton;
	import lm.mui.controls.GCheckBox;
	import lm.mui.controls.GImageBitmap;
	import lm.mui.controls.GLabel;
	import lm.mui.controls.GList;
	import lm.mui.controls.GScrollPane;
	import lm.mui.controls.GTabBar;
	import lm.mui.controls.GTextArea;
	import lm.mui.controls.GTextFiled;
	import lm.mui.controls.GTextInput;
	import lm.mui.controls.GTileList;
	import lm.mui.controls.GprogressBar;
	import lm.mui.core.GlobalClass;
	import lm.mui.display.ScaleBitmap;

	public class CompCreateFactory
	{
		public static const textFormat1:TextFormat = new TextFormat("宋体", 12, 0xffffff);  //默认文字样式
		public static const FILTERS_UNLIGHT:Array = [new GlowFilter(3148544, 1, 2, 2, 15, BitmapFilterQuality.LOW)];
		public static const FILTERS_DROPSHADOW:Array = [new DropShadowFilter(1,45,0,1,0,0)];
		
		
		public function CompCreateFactory()
		{
			
		}
		
		/**
		 * 创建TextField
		 */		
		public static function createTextField($x:int, $y:int, $width:int, $height:int, format:TextFormat = null):TextField
		{
			var tf:TextField = new TextField();
			tf.x = $x;
			tf.y = $y;
			tf.width = $width;
			tf.height = $height;
			tf.defaultTextFormat = format ? format : textFormat1;
			tf.filters = [new GlowFilter(0x000000,1,2,2,50,1)];
			return tf;
		}
		
		/**
		 * 创建GTextField
		 */		
		public static function createGTextField($x:int, $y:int, $width:int, $height:int, format:TextFormat = null):GTextFiled
		{
			var tf:GTextFiled = new GTextFiled();
			tf.x = $x;
			tf.y = $y;
			tf.width = $width;
			tf.height = $height;
			tf.defaultTextFormat = format ? format : textFormat1;
			tf.filters = [new GlowFilter(0x000000,1,2,2,50,1)];
			return tf;
		}
		/**
		 * 创建GTextArea
		 */		
		public static function createGTextArea($x:int, $y:int, $width:int, $height:int):GTextArea
		{
			var tf:GTextArea = new GTextArea();
			tf.x = $x;
			tf.y = $y;
			tf.width = $width;
			tf.height = $height;
			tf.filters = [new GlowFilter(0x000000,1,2,2,50,1)];
			return tf;
		}
		
		
		/**
		 * 创建GButton
		 */		
		public static function createGButton($x:int, $y:int, $width:int, $height:int,$text:String = '',$filters:Array = null):GButton
		{
			var btn:GButton = new GButton();
			btn.move($x,$y);
			btn.setSize($width, $height);
			btn.textField.filters = $filters == null ? FILTERS_DROPSHADOW : $filters;
			btn.label = $text;
			return btn;
		}
		
		/**
		 * 创建GLabel
		 */		
		public static function createGLabel($x:int, $y:int, $width:int, $height:int = 22, $text:String = '', $format:TextFormat = null):GLabel
		{
			var lab:GLabel = new GLabel();
			lab.x = $x;
			lab.y = $y;
			lab.width = $width;
			lab.height = $height;
			lab.text = $text;
			var format:TextFormat = $format ? $format : textFormat1;
			lab.setStyle('textFormat',format);
			lab.filters = [new GlowFilter(0x000000,1,2,2,50,1)];
			return lab;
		}
		
		/**
		 * 创建GTabBar
		 */		
		public static function createGTabBar($x:int, $y:int, $buttonWidth:int, $buttonHeight:int):GTabBar
		{
			var gTabBar:GTabBar = new GTabBar();
			gTabBar.x = $x;
			gTabBar.y = $y;
			gTabBar.buttonWidth = $buttonWidth;
			gTabBar.buttonHeight = $buttonHeight;
			return gTabBar;
		}
		
		/**
		 * 创建GTextInput
		 */		
		public static function createGTextInput($x:int, $y:int, $width:int, $height:int):GTextInput
		{
			var textInput:GTextInput = new GTextInput();
			textInput.x = $x;
			textInput.y = $y;
			textInput.width = $width;
			textInput.height = $height;
			textInput.styleName = 'GTextInput';
			textInput.filters = [new GlowFilter(0x000000,1,2,2,50,1)];
			return textInput;
		}
		
		/**
		 * 创建GImageBitmap
		 */		
		public static function createGImageBitmap($x:int, $y:int, $width:int = 0, $height:int = 0,url:String = ''):GImageBitmap
		{
			var img:GImageBitmap = new GImageBitmap();
			img.x = $x;
			img.y = $y;
			if($width != 0) img.width = $width;
			if($height != 0) img.height = $height;
			if(url != '') img.imgUrl = url;
			return img;
		}
		
		/**
		 * 创建GList
		 */		
		public static function createGList($x:int, $y:int, $width:int, $height:int, rowCount:int = 8, rowHeight:int = 20):GList
		{
			var list:GList = new GList();
			list.x = $x;
			list.y = $y;
			list.width = $width;
			list.height = $height;
			list.rowHeight = rowHeight;
			list.rowCount = rowCount;
			return list;
		}
		
		/**
		 *	 创建 GTIleList
		 * @param $x
		 * @param $y
		 * @param $rowHeight
		 * @param $colWidth
		 * @param $hGap
		 * @param vGap
		 * @param hScrollPolicy
		 * @param vScrollPolicy
		 * @return 
		 * 
		 */		
		public static function createGTileList($x:int, $y:int,$width:int, $height:int, $colWidth:int, $rowHeight:int, $hGap:int = 0, $vGap:int = 0, $hScrollPolicy:String = 'off', $vScrollPolicy:String = 'off'):GTileList
		{
			var tileList:GTileList = new GTileList();
			tileList.x = $x;
			tileList.y = $y;
			tileList.width = $width;
			tileList.height = $height;
			tileList.rowHeight = $rowHeight;
			tileList.horizontalGap = $hGap;
			tileList.verticalGap = $vGap;
			tileList.columnWidth = $colWidth;
			tileList.verticalScrollPolicy = $vScrollPolicy;
			tileList.horizontalScrollPolicy = $hScrollPolicy;
			return tileList;
		}
		
		/**
		 * 创建GCheckBox
		 */		
		public static function createGCheckBox($x:int, $y:int, txt:String = ''):GCheckBox
		{
			var cb:GCheckBox = new GCheckBox();
			cb.move($x, $y);
			cb.label = txt;
			return cb;
		}
		
		/**
		 * 创建GScrollPane
		 */	
		public static function createGScrollPane($x:int, $y:int, $width:int, $height:int,vScrollPolicy:String = 'auto',hScrollPolicy:String ='off'):GScrollPane
		{
			var scrollPane:GScrollPane = new GScrollPane();
			scrollPane.move($x, $y);
			scrollPane.setSize($width, $height);
			scrollPane.styleName = 'GScrollPane';
			return scrollPane;
		}
		
		/**
		 *	创建ScaleBitmap 
		 * @param $x
		 * @param $y
		 * @param $width
		 * @param $height
		 * @param linkClassName
		 * @param rect
		 * @return 
		 * 
		 */		
		public static function createScaleBitmap($x:int, $y:int, $width:int, $height:int,linkClassName:String,rect:Rectangle):ScaleBitmap
		{
			var bm:ScaleBitmap = new ScaleBitmap();
			bm.bitmapData = GlobalClass.getBitmapData(linkClassName);
			bm.scale9Grid = rect;
			bm.x = $x;
			bm.y = $y;
			bm.width = $width;
			bm.height = $height;
			return bm;
		}
		
		/**
		 * 创建GprogressBar
		 */
		public static function createGprogressBar($x:int, $y:int, $width:int, $height:int):GprogressBar
		{
			var pBar:GprogressBar = new GprogressBar();
			pBar.move($x, $y);
			pBar.width = $width;
			pBar.height = $height;
//			pBar.setSize($width, $height);
			return pBar;
		}
		
		/***/
		public static function getGeneralComponentBG():ScaleBitmap
		{
			return GlobalClass.getScaleBitmap("GeneralComponentBG", new Rectangle(10, 10, 80, 80))
		}
		/***/
		public static function getGeneralComponentOverBG():ScaleBitmap
		{
			return GlobalClass.getScaleBitmap("GeneralComponentOverBG", new Rectangle(10, 10, 30, 30))
		}
		
		/***/
		public static function getGeneralToolTip():ScaleBitmap
		{
			return GlobalClass.getScaleBitmap("GeneralToolTip", new Rectangle(10, 10, 30, 30))
		}
		
		
	}
}