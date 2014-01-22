package tools.managers
{
	import tools.modules.addserver.AddServerModule;
	import tools.modules.announce.AnnounceModule;
	import tools.modules.application.ApplicationModule;
	import tools.modules.charge.ChargeModule;
	import tools.modules.chargecount.ChargeCountModule;
	import tools.modules.chargerank.ChargeRankModule;
	import tools.modules.chat.ChatModule;
	import tools.modules.consum.ConsumModule;
	import tools.modules.equip.EquipManagerModule;
	import tools.modules.fightspirit.FightSpiritModule;
	import tools.modules.load.LoadResModule;
	import tools.modules.login.LoginModule;
	import tools.modules.mainui.MainUIModule;
	import tools.modules.passport.PassportModule;
	import tools.modules.player.PlayerModule;
	import tools.modules.playerequip.PlayerEquipModule;
	import tools.modules.playerlevel.PlayerLevelModule;
	import tools.modules.prop.PropModule;
	import tools.modules.sendprop.SendPropModule;
	import tools.modules.supgas.SuperGasModule;
	import tools.modules.user.UserModule;
	import tools.modules.useronline.UserOnlineModule;
	import tools.modules.vipcareer.VipCareerModule;

	public class ModuleBindManager
	{
		public function ModuleBindManager()
		{
		}
		
		public static function init():void
		{
			new LoginModule();
			new MainUIModule();
			new ChargeModule();
			new LoadResModule();
			new UserModule();
			new PlayerModule();
			new PlayerEquipModule();
			new SuperGasModule();
			new FightSpiritModule();
			new ChatModule();
			new PassportModule();
			new PropModule();
			new SendPropModule();
			new EquipManagerModule();
			new ApplicationModule();
//			new PlayerCardModule();
			new CheckCardTypeModule();
			new UserOnlineModule();
			new ConsumModule();
			new AddServerModule();
			new AnnounceModule();
			new ChargeRankModule();
			new ChargeCountModule();
			new VipCareerModule();
			new PlayerLevelModule();
		}
	}
}