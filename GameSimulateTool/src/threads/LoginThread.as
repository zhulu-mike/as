package threads
{
	import com.adobe.crypto.MD5;
	import com.thinkido.framework.common.observer.Notification;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.events.ResizeEvent;
	
	import configs.GameConfig;
	
	import managers.LogManager;
	import managers.NetWorkManager;
	
	import net.NProtocol;
	import net.TSocketEvent;

	/**
	 * 登陆模拟线程
	 * @author Administrator
	 * 
	 */	
	public class LoginThread
	{
		
		public var uid:int = 1;
		
		public var platid:int = 1;
		
		public var sid:int = 1;
		
		public var adult:int = 1;
		
		public var loader:HTMLLoader;
		
		private var netUtil:NetWorkManager;
		
		public static var totalConnect:int = 0;
		
		public static var logined:int = 0;
		
		/**服务器人数已满,请稍后登录*/
		public static const PLAYER_FULL_CODE:int = 1045;
		
		private var phpResp:Boolean = false;
		
		
		public function LoginThread($uid:int, $platid:int=1)
		{
			uid = $uid;
			platid = $platid;
		}
		
		private var stage:Stage;
		private var window:NativeWindow;
		private var text:TextField;
		
		/**
		 * 只模拟socket协议，不加载资源
		 * 
		 */		
		public function startSimulateSocket($s:Stage):void
		{
			logTrace("开始模拟"+uid+","+getTimer());
			stage = $s;
			phpResp = false;
			urlRequest = makeRequest();
			urlLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderCom);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onUrlLoaderIO);
			setTimeout(havePhpResp,10000);
			return;
			if (window == null)
			{
				var option:NativeWindowInitOptions = new NativeWindowInitOptions();
				option.resizable = true;
				window = new NativeWindow(option);
				window.activate();
				
				text = new TextField();
				text.width = 800;
				text.height = 500;
				text.x = 0;
				text.y = 0;
				window.stage.addChild(text);
				text.defaultTextFormat = new TextFormat(null,12,0x000000);
				text.text = "日记：";
				text.background = true;
				text.backgroundColor = 0xff0000;
				text.wordWrap = true;
			}
		}
		
		private function havePhpResp():void
		{
			if (!phpResp)
			{
				try
				{
					urlLoader.close();
				}catch(e:Error){
					
				}
				urlLoader.load(urlRequest);
			}
		}
		
		protected function onUrlLoaderIO(event:IOErrorEvent):void
		{
			logTrace(event.text);
			phpResp = false;
			urlLoader.load(urlRequest);
		}
		
		protected function onUrlLoaderCom(event:Event):void
		{
			var ret:int = int(urlLoader.data);
			if (ret < 0)
			{
				//重试
				phpResp = false;
				urlLoader.load(urlRequest);
			}else{
				phpResp = true;
				urlLoader.removeEventListener(Event.COMPLETE, onUrlLoaderCom);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onUrlLoaderIO);
				connect();
			}
		}
		
		private function connect():void
		{
			if (netUtil == null){
				netUtil = new NetWorkManager();
				netUtil.registerMsg(20002,received_20002,"LoginThread"+uid);
				netUtil.registerMsg(20004,received_20004,"LoginThread"+uid);
				netUtil.registerMsg(20005,received_20005,"LoginThread"+uid);
			}
			netUtil.init(stage);
			netUtil.mainSocket.addEventListener(TSocketEvent.LOGIN_SUCCESS, connectSuccess);
			netUtil.mainSocket.addEventListener(TSocketEvent.LOGIN_FAILURE, connectFailure);
			netUtil.mainSocket.addEventListener(TSocketEvent.CLOSE, connectClose);
			netUtil.connectMain(GameConfig.mainIP, GameConfig.mainPort);
			logTrace("开始连接"+uid);
		}
		
		protected function connectClose(event:Event):void
		{
			totalConnect--;
			logined--;
			netUtil.connectMain(GameConfig.mainIP, GameConfig.mainPort);
		}
		
		/**
		 * 断开连接重新连接
		 * @param event
		 * 
		 */		
		protected function connectFailure(event:Event):void
		{
			netUtil.connectMain(GameConfig.mainIP, GameConfig.mainPort);
		}
		
		/**连接成功*/
		private function connectSuccess(evt:TSocketEvent=null):void
		{
			totalConnect++;
			logTrace("连接成功"+uid);
			netUtil.sendAuthString();
			netUtil.registerMsg(20044, loginHandler, "SWFLoader");
			netUtil.sendMsgData(20043, {platuid:uid, platid:platid,ukey:"",sid:sid});
		}
		
		/** */
		private function loginHandler(noti:Notification):void
		{
			var np:NProtocol = noti.body as NProtocol;
			var data:Object = np.body;
			if (data.ret != 0)
			{
				if(data.ret == PLAYER_FULL_CODE)
				{
					logTrace("服务器人数已满，"+uid);
					netUtil.mainSocket.close();
					totalConnect--;
					setTimeout(connect,5000);
				}
				else
				{
					//创建角色
					logTrace("创建角色"+uid);
					createRole();
				}
			}
			else
			{//进入游戏
				logTrace("有角色，直接进入游戏"+uid);
				setTimeout(enterMainApp,20000);
			}
		}
		
		private var surName:Array;        //姓
		private var manName:Array;
		private var womanName:Array;
		/**
		 * 创建角色
		 * 
		 */		
		private function createRole():void
		{
			if (surName == null)
			{
				var surNameStr:String   = "赵 钱 孙 李 周 吴 郑 王 冯 陈 褚 卫 蒋 沈 韩 杨 朱 秦 尤 许 何 吕 施 张 孔 曹 严 华 金 魏 陶 姜 戚 谢 邹 喻 柏 水 窦 章 云 苏 潘 葛 奚 范 彭 郎 鲁 韦 昌 马 苗 凤 花 方 俞 任 袁 柳 鲍 史 唐 费 廉 岑 薛 雷 贺 倪 汤 滕 殷 罗 毕 郝 邬 安 常 乐 于 时 傅 皮 卞 齐 康 伍 余 元 卜 顾 孟 平 黄 和 穆 萧 尹 姚 邵 湛 汪 祁 毛 狄 米 贝 明 计 伏 成 戴 谈 宋 茅 庞 熊 纪 舒 屈 项 祝 董 梁 杜 阮 蓝 闵 席 季 麻 强 贾 路 娄 危 江 童 颜 郭 梅 盛 林 刁 钟 徐 邱 骆 高 夏 蔡 田 樊 胡 凌 霍 虞 万 支 柯 管 卢 莫 经 房 裘 缪 干 解 应 宗丁 宣 贲 邓 郁 单 杭 洪 包 诸 左 石 崔 吉 钮 龚 程 嵇 邢 滑 裴 陆 荣 翁 荀 羊 於 惠 甄 曲 家 封 芮 羿 储 汲 邴 松 井 段 富 巫 乌 焦 巴 弓 牧 隗 山 谷 车 侯 宓 蓬 全 郗 班 仰 秋 仲 伊 宫 宁 仇 栾 暴 甘 钭 厉 戎 祖 武 符 刘 景 詹 束 龙 叶 幸 司 韶 郜 黎 蓟 薄 印 宿 白 怀 蒲 台 丛 鄂 索 咸 籍 卓 屠 蒙 池 乔 阴 佟 能 苍 双 闻 莘 党 翟 谭 贡 劳 逄 姬 申 扶 堵 冉 宰 郦 雍 却 璩 桑 桂 牛 寿 通 边 扈 燕 冀 郏 浦 尚 农 温 别 庄 晏 柴 瞿 阎 充 慕 连 茹 习 宦 艾 鱼 容 向 古 易 慎 戈 廖 庚 终 暨 居 衡 步 都 耿 满 弘 匡 国 文 寇 广 禄 阙 东 殴 殳 沃 利 蔚 越 隆 师 巩 厍 聂 勾 敖 融 冷 訾 辛 阚 那 简 饶 空 曾 沙 养 鞠 须 丰 关 蒯 相 查 后 荆 红 游 竺 盖 益 桓 公 万 俟 司马 上官 欧阳 夏侯 诸葛 闻人 东方 赫连 皇甫 尉迟 公羊 澹台 公冶 宗政 濮阳 淳于 单于 太叔 申屠 公孙 仲孙 轩辕 令狐 钟离 宇文 长孙 慕容 鲜于 闾丘 司徒 司空 司寇 子车 颛孙 端木 巫马 乐正 壤驷 公良 拓跋 夹谷 宰父 谷梁 晋 楚 闫 法 汝 涂 干 百里 东郭 南门 呼延 归海 羊舌 微生 岳 帅 况 有 琴 梁丘 左丘 东门 西门 商 牟 伯 赏 南宫 墨 年 阳";
				var manNameStr:String   = "如生 傲秋 颖洛 川雅 佑吟 敏原 让庭 沙秀 与雁 昭宁 郎清 千佑 秋言 秋语 阳依 明秋 敏知 晓让 知颜 知秋 绿缘 翩飞 醒沙 紫原 问言 青画 晓来 傲楼 雨恨 南心 南夏 羡楠 楚亭 袭渔 元蓝 守蓝 舒羽 献宁 叔颖 浩林 千洛 川沐 川铭 川林 川柏 沐枫 默昀 默野 均彦 圣杭 凌司 血岩 雪涯 智杭 知枫 连勒 君勒 元照 上尘 天随 景淮 骆亚 哲恺 学宇 尔南 楚樵 昭奇 修淮 傲晓 慕亚 宇儒 慕萧 问野 小符 天许 孝弈 东怀 印风 澈宇 逸凡 腾浩 佳聪 剑峰";
				var womanNameStr:String = "晓献 索萦 芷月 栩栩 紫与 紫语 临韵 紫洛 千习 青寻 恋双 沁雨 临嫣 桐娅 羡冰 涵若 敏依 嫣泺 晴嫣 烟若 以萌 让羽 素苑 晗秀 飘舞 晓茶 小柠 采桑 弄巧 离莹 诗敏 紫柳 小荷 琉璃 笙絮 画柳 琐涵 瑶雨 雪婵 歌晓 浅潆 醒薇 漱儿 心庭 楚宜 晓怀 雅馨 雯倩 梦雨 琬莠 妙菱 蓉亭 楠蝶 珊胭 婕胭 淑谨 妙妗 淑蕊 可蕊 韵婷 诗晴 欣怡 婉莹 思琪 心妍 念凝 秋晴 涵柔 思双 从云 涵蕾 晓芸 谷蕊 曼凡";
				this.surName = surNameStr.split(" ");
				this.manName = manNameStr.split(" ");			
				this.womanName = womanNameStr.split(" ");	
			}
			var sex:int = (Math.random()*10 > 5) ? 1 : 0;
			var career:int = Math.random()*3;
			var index1:int = int(Math.random() * surName.length);
			var index2:int;
			var rName:String = "";
			if(sex == 1){
				index2 = int(Math.random() * manName.length);
				rName = surName[index1] + manName[index2];
			}else{
				index2 = int(Math.random() * womanName.length);
				rName = surName[index1] + womanName[index2];
			}
			netUtil.sendMsgData(20003, {sex:sex, career:career, name:rName, platuid:uid, plat:platid, image:1,ukey:"", sid:sid});
		}
		
		private function enterMainApp():void
		{
			var ukey:String = "";
			var sign:int = platid;
			var sid:int = sid;
			netUtil.sendMsgData(20001,{platuid:uid,platid:sign,ukey:ukey,sid:sid});
			logTrace("开始登陆"+uid+","+getTimer());
			time1 = getTimer();
			return;
		}		
		
		private var time1:int = 0;

		private var urlLoader:URLLoader;

		private var urlRequest:URLRequest;
		
		/**
		 * 创建角色返回
		 * @param e
		 * 
		 */		
		private function received_20004(e:Notification):void
		{
			var data:Object = (e.body as NProtocol).body;
			if (data.ret != 0)
			{
				logTrace("创建失败"+uid);
				createRole();
			}else{
				logTrace("创建成功"+uid);
				enterMainApp();
			}
		}
		
		/**
		 * 登陆返回
		 * @param e
		 * 
		 */		
		private function received_20002(e:Notification):void
		{
			var data:Object = (e.body as NProtocol).body;
			if (data.ret != 0)
			{
				logTrace("登陆失败"+uid);
			}else{
//				logTrace("登陆成功"+uid);
			}
		}
		
		/**
		 * 登陆返回
		 * @param e
		 * 
		 */		
		private function received_20005(e:Notification):void
		{
			logined++;
			logTrace("登陆成功"+uid+","+"花费"+(getTimer()-time1));
			logTrace(logined+"/"+totalConnect);
			netUtil.sendMsgData(20673,{type:2,x:Math.random()*200,id:1001,y:Math.random()*150}); 
		}
		
		/**
		 * 模拟完整的登陆，加载资源
		 * @param htmlHost
		 * 
		 */		
		public function startSimulateWeb(htmlHost:HTMLHost):void
		{
			var request:URLRequest = makeRequest();
			var option:HTMLWindowCreateOptions = new HTMLWindowCreateOptions();
			option.width = 1000;
			option.height = 600;
			option.resizable = true;
			loader = htmlHost.createWindow(option);
			loader.load(request);
			loader.addEventListener(ResizeEvent.RESIZE, resize);
		}
		
		private function makeRequest():URLRequest
		{
			var request:URLRequest = new URLRequest(GameConfig.game_login_url);
			var val:URLVariables = new URLVariables();
			val["uid"] = uid;
			val["platid"] = platid;
			val["sid"] = sid;
			val["time"] = int(new Date().getTime()*0.001);
			val["adult"] = adult;
			val["backurl"] = "";
			val["useraccount"] = uid;
			var mysign:String = MD5.hash(uid+platid.toString()+GameConfig.game_login_key+val["time"]+sid+val["useraccount"]);
			val["sign"] = mysign;
			request.method = URLRequestMethod.GET;
			request.data = val;
			return request;
		}
		
		public function resize(event:ResizeEvent):void
		{
			loader.width = loader.stage.stageWidth;
			loader.height = loader.stage.stageHeight;
		}
		
		public function refresh():void
		{
			loader.reload();
		}
		
		private function logTrace(str:String):void
		{
			LogManager.logTrace(str);
		}
	}
}