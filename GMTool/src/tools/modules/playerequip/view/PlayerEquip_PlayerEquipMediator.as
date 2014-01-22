package tools.modules.playerequip.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tools.common.staticdata.EquipPosition;
	import tools.common.vo.EquipBase;
	import tools.managers.EquipManager;
	import tools.managers.LayerManager;
	import tools.managers.ResizeManager;
	import tools.modules.playerequip.PlayerEquip_ApplicationFacade;
	import tools.modules.playerequip.model.PlayerEquip_MsgSendProxy;
	import tools.modules.playerequip.view.components.PlayerEquipPanel;

	public class PlayerEquip_PlayerEquipMediator extends Mediator
	{

		private var _msgSenderProxy:PlayerEquip_MsgSendProxy;
		public static const NAME:String = "PlayerEquip_PlayerEquipMediator";

		public function PlayerEquip_PlayerEquipMediator(viewComponent:Object)
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
		
		protected function get mainUI() : PlayerEquipPanel
		{
			return viewComponent as PlayerEquipPanel;
		}

		override public function onRegister() : void
		{
			return;
		}

		override public function listNotificationInterests() : Array
		{
			return [PlayerEquip_ApplicationFacade.SHOW_MAINUI,PlayerEquip_ApplicationFacade.RESE_EQUIP];
		}

		override public function handleNotification(param1:INotification) : void
		{
			var data:Object = param1.getBody();
			switch(param1.getName())
			{
				case PlayerEquip_ApplicationFacade.SHOW_MAINUI:
				{
					showMainUi(data);
					break;
				}
				case PlayerEquip_ApplicationFacade.RESE_EQUIP:
				{
					handleSearchResp(data);
					break;
				}
				default:
				{
					break;
				}
			}
			return;
		}
		
		private function handleSearchResp(data:Object):void
		{
			
			var arr:Array=data.v_equ;
			var equipBase:EquipBase;
			for (var i:int = 0; i < arr.length; i++) 
			{
				equipBase = EquipManager.getInstance().getEquipConfigInfo(arr[i].config_id);
				if(equipBase!=null)
				{
					arr[i].name = equipBase.name;
					if(equipBase.equipType==EquipPosition.FABAO){
						arr[i].equipType=Language.FABAO;
					}
					else if(equipBase.equipType==EquipPosition.HUTUI){
						arr[i].equipType=Language.HUTUI;
					}
					else if(equipBase.equipType==EquipPosition.HUWAN){
						arr[i].equipType=Language.HUWAN;
					}
					else if(equipBase.equipType==EquipPosition.SHIZHUANG){
						arr[i].equipType=Language.SHIZHUANG;
					}
					else if(equipBase.equipType==EquipPosition.TOUSHI){
						arr[i].equipType=Language.TOUSHI;
					}
					else if(equipBase.equipType==EquipPosition.WUQI){
						arr[i].equipType=Language.WUQI;
					}
					else if(equipBase.equipType==EquipPosition.XIANGLIAN){
						arr[i].equipType=Language.XIANGLIAN;
					}
					else if(equipBase.equipType==EquipPosition.XIEZI){
						arr[i].equipType=Language.XIEZI;
					}
					else if(equipBase.equipType==EquipPosition.YAODAI){
						arr[i].equipType=Language.YAODAI;
					}
					else if(equipBase.equipType==EquipPosition.YIFU){
						arr[i].equipType=Language.YIFU;
					}
					else if(equipBase.equipType==EquipPosition.YUJIAN){
						arr[i].equipType=Language.YUJIAN;
					}
					arr[i].other = Language.DETAILS;
					arr[i].quaility = equipBase.quaility;
					arr[i].dressLev = equipBase.dressLev;
					arr[i].career = equipBase.career;
					arr[i].salePrice = equipBase.salePrice;
					arr[i].buyPrice = equipBase.buyPrice;
					arr[i].power = equipBase.power;
					arr[i].bp = equipBase.bp;
					arr[i].ep = equipBase.ep;
					/////
					arr[i].attack = equipBase.attack;
					arr[i].attackUp = equipBase.attackUp;
					
					
					arr[i].defense = equipBase.defense;
					arr[i].defenseUp = equipBase.defenseUp;
					
					arr[i].hp = equipBase.hp;
					arr[i].hpUp = equipBase.hpUp;
				}
				else
				{
					arr[i].name = Language.UNKNOW;
				}
				
			}
			mainUI.skillDg.dataProvider = new ArrayList(arr);
			
			
			
		}		
		
		private function get msgSenderProxy() : PlayerEquip_MsgSendProxy
		{
			if (this._msgSenderProxy == null)
			{
				this._msgSenderProxy = facade.retrieveProxy(PlayerEquip_MsgSendProxy.NAME) as PlayerEquip_MsgSendProxy;
			}
			return this._msgSenderProxy;
		}
		
		private function showMainUi(param0:Object):void
		{
			msgSenderProxy.send_20009(param0.id,param0.ismain,param0.pid);
			LayerManager.higherLayer.addElement(mainUI);
			ResizeManager.registerResize(mainUI);
		}
	}
}