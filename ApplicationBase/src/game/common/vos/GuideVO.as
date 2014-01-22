package game.common.vos
{
	import game.common.staticdata.GuideCompleteState;

	public class GuideVO
	{
		/**
		 * 新手引导配置数据
		 * 
		 */		
		public function GuideVO()
		{
		}
		
		public var id:int = 0;
		
		public var dir:int = 0;
		
		/**
		 * 气泡框里的文字
		 */		
		public var text:String = "";
		
		/**
		 * 引导箭头的父容器
		 */		
		public var container:String = "";
		
		/**
		 * 箭头坐标参考组件，箭头的坐标将会根据改组件来确定
		 */		
		public var posReferComponent:String = "";
		
		/**
		 * 相对于container的x偏移
		 */		
		public var offsetX:int = 0;
		
		/**
		 * 相对于container的y偏移
		 */		
		public var offsetY:int = 0;
		
		/**
		 * 所要引导的面板的名字 
		 */		
		public var panelName:String = "";
		
		/**
		 * 该引导的状态
		 * @default 结束
		 */		
		public var state:int = GuideCompleteState.END;
		
		/**
		 * 前一个引导ID
		 */		
		public var prevID:int = 0;
		
		/**
		 * 下一个引导ID，只有当本引导的结束会导致下一个引导的开启的时候，才有效
		 */		
		public var nextID:int = 0;
		
		/**
		 * 引导开启条件
		 */		
		public var guideCondition:Vector.<GuideCondition> = new Vector.<GuideCondition>();
		
		/**
		 * 结束类型,0表示不用等待结束条件立即结束，1表示延迟结束，2表示自动触发组件事件
		 */		
		public var endTpye:int = 1;
		
		/**
		 * 结束条件1表示事件类型，2表示任务类型
		 */		
		public var endCondition:Vector.<GuideCondition> = new Vector.<GuideCondition>();
		
	}
}