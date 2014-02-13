package game.modules.engine.controller
{
	import com.thinkido.framework.engine.events.SceneEvent;
	import com.thinkido.framework.engine.events.SceneEventAction_interactive;
	import com.thinkido.framework.engine.vo.map.MapTile;
	
	import flash.geom.Point;
	
	import game.config.GameInstance;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class Engine_sceneInteractiveCommand extends SimpleCommand
	{
		public function Engine_sceneInteractiveCommand()
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
				case SceneEventAction_interactive.MOUSE_DOWN:
					GameInstance.scene.mainChar.walk(new Point((data[2] as MapTile).tile_x,(data[2] as MapTile).tile_y));
					break;
			}
		}
		
	}
}