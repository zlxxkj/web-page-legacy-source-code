package;

import flixel.FlxGame;
import object.FunkinSoundTray;

class Main extends Sprite
{
	var win = Application.current.window;

	public function new()
	{
		super();

		var game = new FlxGame(1280,720, PlayState,-1,60,60,true,false);
		
		@:privateAccess
		game._customSoundTray = FunkinSoundTray;

		addChild(game);
        
		#if desktop
		win.height = 780;
		// Native.fixScaling();
		Native.setDarkMode();

		var fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		#end
	}
}