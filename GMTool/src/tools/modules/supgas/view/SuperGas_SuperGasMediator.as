package tools.modules.supgas.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.common.vo.ImmortalGasVO;
	import tools.managers.ImmortalGasManager;
	import tools.managers.LayerManager;
	import tools.managers.ResizeManager;
	import tools.modules.supgas.SuperGas_ApplicationFacade;
	import tools.modules.supgas.model.SuperGas_MsgSendProxy;
	import tools.modules.supgas.view.components.SuperGasPanel;

	public class SuperGas_SuperGasMediator extends Mediator
	{

		private var _msgSenderProxy:SuperGas_MsgSendProxy;
		public static const NAME:String = "SuperGas_SuperGasMediator";

		public function SuperGas_SuperGasMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			mainUI.close.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		protected function onClose(event:MouseEvent):void
		{
			LayerManager.higherLayer.removeElement(mainUI);			
		}
		
		protected function get mainUI() : SuperGasPanel
		{
			return viewComponent as SuperGasPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [SuperGas_ApplicationFacade.SHOW_MAINUI,SuperGas_ApplicationFacade.RESE_SUPER_GAS];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case SuperGas_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case SuperGas_ApplicationFacade.RESE_SUPER_GAS:
				{
					handleSuperGasResq(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function handleSuperGasResq(data:Object):void
		{
			var arr:Array=data.v_immortal;
			var immortalGasVo:ImmortalGasVO;
			var arr1:Array=[];
			var arr2:Array=[];
			for (var i:int = 0; i < arr.length; i++) 
			{
				immortalGasVo = ImmortalGasManager.getImmortalGasVO(arr[i].immortal,arr[i].levle);
				if(immortalGasVo!=null)
				{
					//身上已经穿戴的仙气
					arr[i].gasName=immortalGasVo.name;//仙气名字
					arr[i].que=immortalGasVo.qua;//仙气品质
					arr[i].value=immortalGasVo.exp+arr[i].exp;//仙力值
					//属性加成
					if(immortalGasVo.attack>0){
						arr[i].attribute=immortalGasVo.attack;
					}
					else if(immortalGasVo.defense>0){
						arr[i].attribute=immortalGasVo.defense;
					}
					else if(immortalGasVo.hp>0){
						arr[i].attribute=immortalGasVo.hp;
					}
					else if(immortalGasVo.baoji>0){
						arr[i].attribute=immortalGasVo.baoji;
					}
					else if(immortalGasVo.kangbaodengji>0){
						arr[i].attribute=immortalGasVo.kangbaodengji;
					}
					else{
						arr[i].attribute=immortalGasVo.killLevel;
					}
				}
				else
				{
					arr[i].gasName = Language.UNKNOW;
				}
				immortalGasVo = ImmortalGasManager.getImmortalGasVO(arr[i].immortal,arr[i].levle+1);
				if(immortalGasVo!=null)
				{
					arr[i].gasExpUp=arr[i].exp+"/"+immortalGasVo.upExp;//经验/仙气经验
				}
				else
				{
					arr[i].gasExpUp="0/0";
				}
//				arr[i].gasExpUp="0/0";
				if(arr[i].site>=200)
				{
					arr2.push(arr[i]);
					mainUI.bodyGas.dataProvider = new ArrayList(arr2);
					mainUI.gasValue.text=arr[i].value;
				}
				else
				{
					arr1.push(arr[i]);
					mainUI.packGas.dataProvider = new ArrayList(arr1);
				}

				
			}
			
			
		}		
		
		private function get msgSenderProxy() : SuperGas_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(SuperGas_MsgSendProxy.NAME) as SuperGas_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(param0:Object):void
		{
			msgSenderProxy.send_20015(param0.id,param0.ismain,param0.pid);
			LayerManager.higherLayer.addElement(mainUI);
			ResizeManager.registerResize(mainUI);
		}
	}
}