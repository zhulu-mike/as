package game.modules.engine.controller
{
	import com.thinkido.framework.engine.SceneCharacter;
	import com.thinkido.framework.engine.events.SceneEvent;
	import com.thinkido.framework.engine.events.SceneEventAction_status;
	import com.thinkido.framework.engine.vo.avatar.AvatarParamData;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class Engine_statusCommand extends SimpleCommand
	{
		public function Engine_statusCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			var e:SceneEvent = param1.getBody() as SceneEvent;
			var action:String = e.action;
			var data:Array = e.data as Array;
			switch (action)
			{
				case SceneEventAction_status.INVIEW_CHECKANDLOAD:
					checkAndLoad(data[0], data[1]);
					break;
			}
		}
		
		public function checkAndLoad(sc:SceneCharacter, show:Boolean):void
		{
			if (show)
			{
				if(sc.data)
					sc.loadAvatarPart(sc.data.body as AvatarParamData);
			}else{
				sc.removeAllAvatarParts(false);
			}
		}
	}
}