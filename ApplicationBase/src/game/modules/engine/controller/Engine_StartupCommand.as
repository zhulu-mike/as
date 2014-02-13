package game.modules.engine.controller
{
	import game.config.GameInstance;
	import game.modules.engine.Engine_ApplicationFacade;
	import game.modules.engine.model.Engine_MsgReceivedProxy;
	import game.modules.engine.model.Engine_MsgSendProxy;
	import game.modules.engine.view.Engine_EngineMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

    public class Engine_StartupCommand extends SimpleCommand
    {

        public function Engine_StartupCommand()
        {
            return;
        }

        override public function execute(param1:INotification) : void
        {
            facade.registerProxy(new Engine_MsgSendProxy());
            facade.registerProxy(new Engine_MsgReceivedProxy());
			facade.registerMediator(new Engine_EngineMediator(GameInstance.scene));
			facade.registerCommand(Engine_ApplicationFacade.INIT_ENGINE, Engine_InitCommand);
			facade.registerCommand(Engine_ApplicationFacade.SCENE_INTERACTIVE_EVENT, Engine_sceneInteractiveCommand);
			
			facade.sendNotification(Engine_ApplicationFacade.INIT_ENGINE);
            return;
        }

    }
}
