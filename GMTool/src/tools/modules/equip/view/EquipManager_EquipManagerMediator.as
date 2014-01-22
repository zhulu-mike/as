package tools.modules.equip.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.common.staticdata.EquipPosition;
	import tools.events.PipeEvent;
	import tools.managers.EquipManager;
	import tools.managers.PipeManager;
	import tools.managers.ResizeManager;
	import tools.modules.equip.EquipManager_ApplicationFacade;
	import tools.modules.equip.model.EquipManager_MsgSendProxy;
	import tools.modules.equip.model.EquipModel;
	import tools.modules.equip.view.components.EquipManagerPanel;

	public class EquipManager_EquipManagerMediator extends Mediator
	{

		private var _msgSenderProxy:EquipManager_MsgSendProxy;
		public static const NAME:String = "EquipManager_EquipManagerMediator";
		private var model:EquipModel=EquipModel.getInstance();

		public function EquipManager_EquipManagerMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			mainUI.addEventListener(FlexEvent.CREATION_COMPLETE, initUI);
		}
		
		protected function initUI(event:FlexEvent):void
		{
			//按钮
			mainUI.sendBtn.addEventListener(MouseEvent.CLICK,onSend);
		}
		
		protected function onSend(event:MouseEvent):void
		{
			PipeManager.sendMsg(PipeEvent.SHOW_SEND_PROP_MAINUI,model.permiss);
		}
		
		protected function get mainUI() : EquipManagerPanel
		{
			return viewComponent as EquipManagerPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [EquipManager_ApplicationFacade.SHOW_MAINUI];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case EquipManager_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		
		private function get msgSenderProxy() : EquipManager_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(EquipManager_MsgSendProxy.NAME) as EquipManager_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(data:Object):void
		{
			if(data!=3)
			{
				model.permiss=data.permission;
			}
			else
			{
				model.permiss=int(data);
			}
			ResizeManager.registerResize(mainUI);
			PipeManager.sendMsg(PipeEvent.ADD_CHILD_TO_MAINUI, mainUI);
			var equipArr:Array=EquipManager.getInstance().getAllEquipInfo();
			//----处理装备信息
			for (var i:int = 0; i < equipArr.length; i++) 
			{
				equipArr[i].fujia=Language.POWER+"+"+equipArr[i].power+Language.TILI+"+"+equipArr[i].bp+Language.NAILI+"+"+equipArr[i].ep;
				
				if(equipArr[i].quaility==1){
				equipArr[i].pinzhi=Language.GREEN}
				else if(equipArr[i].quaility==2){
				equipArr[i].pinzhi=Language.PURPLE}
				else{equipArr[i].pinzhi=Language.GLOD}
				
				if(equipArr[i].career==1){
					equipArr[i].zhiye=Language.QIANGHAO}
				else if(equipArr[i].career==2){
					equipArr[i].zhiye=Language.YINGWU}
				else{equipArr[i].zhiye=Language.XIANLING}
				
				if(equipArr[i].attack>0){
					equipArr[i].jiben=Language.ONATTACK+"+"+equipArr[i].attack;
				}
				else if(equipArr[i].defense>0){
					equipArr[i].jiben=Language.ONDEFENSE+"+"+equipArr[i].defense;
				}
				else{
					equipArr[i].jiben=Language.HP+"+"+equipArr[i].hp;
				}
				
				if(equipArr[i].equipType==EquipPosition.FABAO){
					equipArr[i].posi=Language.FABAO;
				}
				else if(equipArr[i].equipType==EquipPosition.HUTUI){
					equipArr[i].posi=Language.HUTUI;
				}
				else if(equipArr[i].equipType==EquipPosition.HUWAN){
					equipArr[i].posi=Language.HUWAN;
				}
				else if(equipArr[i].equipType==EquipPosition.SHIZHUANG){
					equipArr[i].posi=Language.SHIZHUANG;
				}
				else if(equipArr[i].equipType==EquipPosition.TOUSHI){
					equipArr[i].posi=Language.TOUSHI;
				}
				else if(equipArr[i].equipType==EquipPosition.WUQI){
					equipArr[i].posi=Language.WUQI;
				}
				else if(equipArr[i].equipType==EquipPosition.XIANGLIAN){
					equipArr[i].posi=Language.XIANGLIAN;
				}
				else if(equipArr[i].equipType==EquipPosition.XIEZI){
					equipArr[i].posi=Language.XIEZI;
				}
				else if(equipArr[i].equipType==EquipPosition.YAODAI){
					equipArr[i].posi=Language.YAODAI;
				}
				else if(equipArr[i].equipType==EquipPosition.YIFU){
					equipArr[i].posi=Language.YIFU;
				}
				else if(equipArr[i].equipType==EquipPosition.YUJIAN){
					equipArr[i].posi=Language.YUJIAN;
				}
				
			}
			var dataArr:ArrayCollection=new ArrayCollection(equipArr);
			dataArr.sort=new Sort();
			dataArr.sort.fields=[new SortField("consume_num",false,true)];
			dataArr.refresh();
			mainUI.dg.dataProvider =dataArr;
		}

	}
}