package com.thinkido.framework.utils
{
	import flash.utils.ByteArray;
	/**
	 * 字符串工具，常用方法 
	 * @author thinkido
	 * 
	 */
	public class StringUtil
	{
		public function StringUtil()
		{
		}
		/**
		 * 
		 * @param sourceStr 原始字符串,可以是字符串或者整形
		 * @param len 格式化后字符串长度
		 * @return 格式化后字符串
		 * 如果长度为0直接返回字符串，避免在方法外判断字符长度的工作
		 */		
		public static function formatLength(sourceStr:* , len:int = 0,repl:String = "0" ):String{
			sourceStr = String(sourceStr);
			if( len ==0 ){
				return sourceStr ;
			}
			for (var i:int = len - sourceStr.length  ; i > 0  ; i--) 
			{
				sourceStr = repl + sourceStr ;
			}
			return sourceStr ;
		}
		/**
		 * 获取中文、英文字符字节长度 
		 * @param source
		 * @param charset
		 * @return 
		 * windows 和 linux 中获取的中文长度不一样
		 */		
		public static function getLength(source:String,charset:String="utf-8"):uint
		{
			var by :ByteArray = new ByteArray();
			by.writeMultiByte(source,charset);
			return by.length;
		}
		/**
		 * 获取固定长度字符串
		 * @param source
		 * @param charset
		 * @return 
		 * 
		 */		
		public static function getSourceByLen(source:String,len:int= 60):String
		{
			var by :ByteArray = new ByteArray();
			by.writeMultiByte(source,"utf-8");
			by.position = 0 ;
			var str:String ;
			str = by.readMultiByte(Math.min(len,by.length),"utf-8");
			return str ;
		}
		
		/** 
		 * 把字符串中的占位符 {0} {1} 用数组中的字符串替换 
		 * @param   source  源字符串 
		 * @param   args    待替换字符串数组 
		 * @return  替换后的字符串 
		 */  
		public static function replacePlaceholder(source:String, args:Array):String  
		{  
			var pattern:RegExp = /{(\d)}/g;  
			
			source =  source.replace(pattern, function():String {  
				return args[arguments[1]];  
			});  
			return source;  
		}
			
		/**
		 *  使用传入的各个参数替换指定的字符串内的 <code>{n}</code> 标记。
		 *
		 *  @param str  - 用来进行替换的源字符串。
		 *  @param rest  - 可在 str 参数中的每个 <code>{n}</code> 位置被替换的值。
		 *  如果第一个参数是一个数组，则该数组将用作参数列表。若第一个参数为数据对象，则会进行全局替换，否则为顺序替换。
		 *
		 *  <p>源字符串可包含 <code>{n}</code> 形式的特殊标记，其中 n 为任意标识符（由字母、数字、下划线组成），
		 *  它将被替换成具体的值。</p>
		 *  <p>因为允许 rest 第一个参数为数组，因此允许在其它想要使用... rest 参数的方法中重复使用此例程。例如:
		 *         <table><tr><td style="padding:10px;color:#334455"><code>
		 *     public function myTracer(str:String, ... rest):void<br>
		 *     {<br>
		 *                     label.text += printf(str, rest) + "\n";<br>
		 *     }
		 *         </code></td></tr></table><p>
		 *
		 *  @return 使用指定的各个参数替换了所有 <code>{n}</code> 标记的新字符串。
		 *
		 *  <table><tr><td style="padding:10px;color:#334455"><code>
		 *  var str:String = "here is some info {number} and {boolean}";<br>
		 *  trace(printf(str, 15.4, true));<br>
		 *  <br>
		 *  // this will output the following string:<br>
		 *  // "here is some info 15.4 and true"<br>
		 *        </code></td></tr></table>
		 */
		public static function printf( str:String, ... rest ):String
		{
			if( str == null || str == "" )
				return "";
			
			var lng:int; // 最终需要计算替换的次数
			var args:Array; // 最终需要替换的数据
			var i:int;
			
			switch( typeof( rest[ 0 ]))
			{
				case "number":
				case "boolean":
				case "string":
				{
					lng = rest.length;
					args = rest;
					
					for( i = 0; i < lng; i++ )
					{
						str = str.replace( PATTERN_PRINTF, args[ i ]);
					}
					break;
				}
				case "object":
				{
					if( rest[ 0 ] is Array )
					{
						args = rest[ 0 ] as Array;
						lng = args.length;
						
						for( i = 0; i < lng; i++ )
						{
							str = str.replace( PATTERN_PRINTF, args[ i ]);
						}
					}
					else
					{
						var reg:RegExp;
						
						for( var prop:String in rest[ 0 ])
						{
							reg = new RegExp( "\{" + prop + "\}", "ig" );
							str = str.replace( reg, rest[ 0 ][ prop ]);
						}
					}
					break;
				}
			}
			
			return str;
		}
		
		public static const PATTERN_PRINTF:RegExp = /\{[a-z0-9_]+\}/i;
		/**
		 * 获取url 路径中的文件信息。 
		 * @param $url
		 * @return 
		 * 服务器、路径、文件名、类型
		 */		
		public static function getFileObject($url:String):Object{
			var temp:Object = {} ;
			temp.url = $url ;
			$url = $url.replace("http://","") ;
			var index:int = $url.indexOf("/") ;
			temp.baseUrl = index == -1 ? $url : $url.substring(0,index) ;
			var last:int = $url.lastIndexOf("/") ;
			temp.path = (index == -1 || last == -1) ? "" : $url.substring( index ,last + 1) ;
			var ts:String = $url.substring( last +1 ) ;
			var ta:Array = ts.split(".") ;
			temp.name = last == -1 ? "" : ta[0] ;
			temp.type = ta.length >= 2 ? ( ta[1].indexOf("?") == -1 ?ta[1] :ta[1].substring(0,ta[1].indexOf("?"))) : "" ;
			return temp ;
		}
	}
}