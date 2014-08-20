package modules.scene.views
{
	public interface ISceneBase
	{
		
		function update():void;
		function destroy():void;
		function pauseGame():void;
		function restart():void;
	}
}