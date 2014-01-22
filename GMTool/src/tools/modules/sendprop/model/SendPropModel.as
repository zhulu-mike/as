package tools.modules.sendprop.model
{
	public class SendPropModel
	{
		public function SendPropModel()
		{
		}
		
		private static var _instance:SendPropModel;
		
		public static function getInstance():SendPropModel
		{
			if (_instance == null)
				_instance = new SendPropModel();
			return _instance;
		}
		
		public var prop:String='';
		
		public var arrProp:Array=[];//道具数组
		public var arrEqup:Array=[];//装备数组
		
		public var arrCheck:*;
		public var propNum:int=0;//道具数量
		public var equiNum:int=0;//装备数量
		
		public var selectProp:Array=[];//所选道具数据
		public var selectEqui:Array=[];//所选装备数组
		
		public var propData:Object=new Object();
		public var permiss:int=0;
		
		/////发送协议内容
		public var type:int=1;
		public var range_type:int=1;
		public var range:String='';
		public var rangeNum:String='';
		public var simplePlayer:String='';
		public var morePlayer:String='';
		public var serverList:Array=[];
		public var checkArr:Array=[];//对比数组
		public var propList:String='';
		public var arrLength:int=0;
		///
		public var yuanbao:int=0;
		public var tongqian:int=0;
		public var tili:int=0;
		
		public var deleteId:int=0;
		//
		public var titleTxt:String='';//记录发送道具标题
		
	}
}