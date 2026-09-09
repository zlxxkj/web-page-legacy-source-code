package object;

import flixel.system.FlxAssets.FlxSoundAsset;

import flixel.system.ui.FlxSoundTray;

/**
 *  Extends the default flixel soundtray, but with some art
 *  and lil polish!
 *
 *  Gets added to the game in Main.hx, right after FlxGame is new'd
 *  since it's a Sprite rather than Flixel related object
 */
class FunkinSoundTray extends FlxSoundTray
{
	var graphicScale:Float = 0.30;
	var lerpYPos:Float = 0;
	var alphaTarget:Float = 0;

	public var volumeUpSound:String = "soundtray/Voldown";
	public var volumeDownSound:String = 'soundtray/Volup';
	public var volumeMaxSound:String = 'soundtray/VolMAX';

	public function new()
	{
		// calls super, then removes all children to add our own
		// graphics
		super();
		removeChildren();
		
		var bg:Bitmap = new Bitmap(BitmapData.fromFile(Paths.getPath('images/soundtray/volumebox.png', IMAGE)));
		bg.scaleX = graphicScale;
		bg.scaleY = graphicScale;
		addChild(bg);
		
		y = -height;
		visible = false;
		
		// makes an alpha'd version of all the bars (bar_10.png)
		var backingBar:Bitmap = new Bitmap(BitmapData.fromFile(Paths.getPath('images/soundtray/bars_10.png', IMAGE)));
		backingBar.x = 9;
		backingBar.y = 5;
		backingBar.scaleX = graphicScale;
		backingBar.scaleY = graphicScale;
		addChild(backingBar);
		backingBar.alpha = 0.4;
		
		// clear the bars array entirely, it was initialized
		// in the super class
		_bars = [];
		
		// 1...11 due to how block named the assets,
		// we are trying to get assets bar_1-10
		for (i in 1...11)
		{
			var bar:Bitmap = new Bitmap(BitmapData.fromFile(Paths.getPath('images/soundtray/bars_$i.png', IMAGE)));
			bar.x = 9;
			bar.y = 5;
			bar.scaleX = graphicScale;
			bar.scaleY = graphicScale;
			addChild(bar);
			_bars.push(bar);
		}
		
		y = -height;
		screenCenter();
		

		
		// trace("Custom tray added!");
	}
	
	override public function update(MS:Float):Void
	{
		y = fpsLerp(y, lerpYPos, 0.1);
		alpha = fpsLerp(alpha, alphaTarget, 0.25);		
		// Animate sound tray thing
		if (_timer > 0)
		{
			_timer -= (MS / 1000);
			alphaTarget = 1;
		}
		else if (y >= -height)
		{
			lerpYPos = -height + 10;
			alphaTarget = 0;
		}
		
		if (y <= -height)
		{
			visible = false;
			active = false;
			
			#if FLX_SAVE
			// Save sound preferences
			if (FlxG.save.isBound)
			{
				FlxG.save.data.mute = FlxG.sound.muted;
				FlxG.save.data.volume = FlxG.sound.volume;
				FlxG.save.flush();
			}
			#end
		}
	}
	
	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	up Whether the volume is increasing.
	 */
	override public function show(up:Bool = false):Void
	{
		showFunkinBar(up);
	}
	
	function showFunkinBar(up:Bool = false)
	{
		_timer = 1;
		lerpYPos = 10;
		visible = true;
		active = true;
		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);
		
		if (FlxG.sound.muted)
		{
			globalVolume = 0;
		}
		
		if (!up)
		{
			var sound = up ? volumeUpSound : volumeDownSound;
			
			if (globalVolume == 10) sound = volumeMaxSound;
			
			if (sound != null) FlxG.sound.play(Paths.sound(sound));
		}
		
		for (i in 0..._bars.length)
			_bars[i].visible = i < globalVolume;
	}
	
	function fpsLerp(v1:Float, v2:Float, ratio:Float) return FlxMath.lerp(v1, v2, FlxMath.getElapsedLerp(ratio, FlxG.elapsed));

}