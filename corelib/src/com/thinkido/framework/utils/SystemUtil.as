package com.thinkido.framework.utils {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.net.LocalConnection;
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 系统工具 
	 * @author thinkido
	 * gc,clearChildren 最为有用
	 */
	public class SystemUtil {
		/**
		 * 水平反转 内容
		 * @param source 显示对象
		 * 
		 */		
		public static function flipH(source : DisplayObject) : void {
			var matrix : Matrix = source.transform.matrix;
			matrix.a = -1;
			matrix.tx = source.width + source.x;
			source.transform.matrix = matrix;
		}
		/**
		 * 垂直反转 内容
		 * @param source 显示对象
		 */
		public static function flipV(source : DisplayObject) : void {
			var matrix : Matrix = source.transform.matrix;
			matrix.d = -1;
			matrix.ty = source.height + source.y;
			source.transform.matrix = matrix;
		}
		/**
		 * 获取当前 fp 的版本信息 
		 * @return 
		 * 
		 */
		public static function getVersion() : String {
			var result : String = "";
			result += "Version:" + Capabilities.version;
			result += ",Debugger:" + Capabilities.isDebugger;
			result += ",PlayerType:" + Capabilities.playerType;
			return result;
		}

		public static function xmlEncode(value : String) : String {
			var result : String = value;
			result = result.replace(/\x38/g, "&amp;");
			result = result.replace(/\x60/g, "&lt;");
			result = result.replace(/\x62/g, "&gt;");
			result = result.replace(/\x27/g, "&apos;");
			result = result.replace(/\x22/g, "&quot;");
			return result;
		}

		public static function isDebug() : Boolean {
			return new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
		}
		/**
		 * 清楚所有子对象 
		 * @param target 目标显示对象
		 * @param isBitmap 是否是位图
		 * @param isRemoveAll 是否便利删除所有子对象
		 * 
		 */		
		public static function clearChildren(target:DisplayObject, isBitmap:Boolean = false, isRemoveAll:Boolean = true) : void
		{
			var num:int = 0;
			if (target == null)
			{
				return;
			}
			if (target is DisplayObjectContainer)
			{
				num = (target as DisplayObjectContainer).numChildren;
				while (num-- > 0)
				{
					if (isRemoveAll)
					{
						clearChildren((target as DisplayObjectContainer).getChildAt(num), isBitmap, isRemoveAll);
					}
					if (!(target is Loader))
					{
						(target as DisplayObjectContainer).removeChildAt(num);
					}
				}
			}
			else if (isBitmap && target is Bitmap && (target as Bitmap).bitmapData)
			{
				(target as Bitmap).bitmapData.dispose();
			}
			return;
		}
		/**
		 * 
		 * 根据名字清楚子对象 
		 * @param target 目标显示对象
		 * @param isBitmap 是否是位图
		 * @param isRemoveAll 是否便利删除所有子对象
		 * 
		 */		
		public static function clearChildrenByName(target:DisplayObject, childName:String, isBitmap:Boolean = false, isRemoveAll:Boolean = true) : void
		{
			if (!target)
			{
				return;
			}
			var _loc_5:* = target as DisplayObjectContainer;
			var _loc_6:* = (target as DisplayObjectContainer).getChildByName(childName);
			if ((target as DisplayObjectContainer).getChildByName(childName) != null)
			{
				_loc_5.removeChild(_loc_6);
				clearChildren(_loc_6, isBitmap, isRemoveAll);
			}
			return;
		}
		/**
		 * 判断child 是否为parent 的 孩子节点
		 * @param parent 
		 * @param child
		 * @return 
		 * 
		 */		
		public static function isParentChild(parent:DisplayObjectContainer, child:DisplayObject) : Boolean
		{
			if (child == null || parent == null || child.parent == null)
			{
				return false;
			}
			if (child.parent == parent)
			{
				return true;
			}
			return isParentChild(parent, child.parent);
		}
		/**
		 * 根据显示对象、及parent visible 返回该对象是否可见
		 * @param target 目标对象
		 * @return 是否可见
		 * 
		 */		
		public static function isVisible(target:DisplayObject) : Boolean
		{
			if (target == null || target.visible == false)
			{
				return false;
			}
			if (target is Stage)
			{
				return true;
			}
			return isVisible(target.parent);
		}
		/**
		 * 强制回收内存 
		 * 执行时，编译检查所有节点
		 * 会占用一定cpu ，不建议使用
		 */		
		public static function gc() : void {
			try { 
				new LocalConnection().connect("gc"); 
				new LocalConnection().connect("gc"); 
				System.gc();
			}catch (e : Error) { 
			} 
		}
		/**
		 * 向bytearray中写入固定长度字符内容 
		 * @param $byte
		 * @param value
		 * @param len
		 * @return 
		 * 
		 */		
		public static function writeUTFBytesBylen($byte:ByteArray ,value:String , len:int):ByteArray{
			$byte.writeMultiByte(value,"utf-8");
			var strSize:int = StringUtil.getLength(value,"utf-8");
			if(strSize>len)
			{
				throw(new Error("数据过大"));
			}
			for(var i:uint=strSize; i < len; i++)
			{
				$byte.writeByte(0);
			}
			return $byte;
		}
		/**
		 * 复制对象，支持数据类型 
		 * @param source
		 * @return 新的数据类型
		 * 
		 */		
		public static function cloneObject(source:Object) :* {
			var typeName:String = getQualifiedClassName(source);//获取全名
//			trace("输出类的结构"+typeName);
			//return;
			var packageName:String = typeName.split("::")[0];//切出包名
//			trace("类的名称"+packageName);
			var type:Class = getDefinitionByName(typeName) as Class;//获取Class
//			trace(type);
			registerClassAlias(packageName, type);//注册Class
			//复制对象
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return copier.readObject();
		}
		/**
		 * 获取function名 
		 * @param fun
		 * @return 
		 * 
		 */		
		public static function getFunctionName(fun:Function):String{
			try{
				var k:Sprite = Sprite(fun);
			}catch(err:Error){
				var fn:String = err.message.replace(/.+::(\w+\/\w+)\(\)\}\@.+/,"$1");
				return fn==err.message?(err.message.replace(/.+ (function\-\d+) .+/i,"$1")):fn;
			}
			return null;
		}
	}
}