package tools.modules.chat
{
	import flash.display.Sprite;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ChatModule extends Sprite
	{

		public function ChatModule()
		{
			trace(Chat_ApplicationFacade.NAME);
			if (!Facade.hasCore(Chat_ApplicationFacade.NAME))
				new Chat_ApplicationFacade(Chat_ApplicationFacade.NAME);
		}
	}
}