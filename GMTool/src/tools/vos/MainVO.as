package tools.vos
{
	public class MainVO
	{
		public function MainVO()
		{
		}
		
		/**
		 * 权限,每一位的数字含义：1表示可读，0表示全不允许，2表示可写，3表示即可读也可写
		 * 从高位到低位对应功能小节点按data值从小到大的排序
		 * 
		 */
		public var permission:String = "33333333";

		/**
		 * 组别，管理员，高级管理员等
		 */		
		public var group:int = 5;
		
		public var userName:String = "";//用户名
		
		public var plantObj:Array=new Array();
		
		public var platChosArr:Array=new Array();
		
		public var serPlatChosArr:Array=new Array();
		
		public var platChosArrA:Array=new Array();
		
		public var userid:int = 0;//用户id
		
		public var platid:int = 0;//平台id
		
		public var registertime:int = 0;//注册时间
		
		public var regip:int = 0;//注册Ip
		
		public var passport:String="";//密码
		
		public var maxPage:int= 0 ;//最大页数
		
		public var level:int= 0;//管理员等级
		
		public var lastLogintTime:int = 0;//上次登陆时间
		
		public var adminPlatId:int= 1;//管理员选择platID
		
		public var adminPlatName:String="乐港";//管理员选择plat名字
		
		public var serverId:int = 1;//服务器id。
		
		public var serverArr:Array=[];//服务器数组
		
	}
}