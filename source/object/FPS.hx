package object;

#if desktop
import flixel.util.FlxStringUtil;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPS extends Sprite
{
	var updating:Bool = true;
	
	var text:TextField;
	var underlay:Bitmap;
	
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	
	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var gcMemory(get, never):Float;
	
	public var taskMemory(get, never):Float;	

	@:noCompletion private var times:Array<Float>;
	
	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();
		
		this.x = x;
		this.y = y;
		
		underlay = new Bitmap();
		underlay.bitmapData = new BitmapData(1, 1, true, 0x6F000000);
		addChild(underlay);
		
		text = new TextField();
		addChild(text);
		
		currentFPS = 0;
		text.selectable = false;
		text.mouseEnabled = false;
		text.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/aller.ttf").fontName, 14, color);
		text.defaultTextFormat.leading = 5;
		text.autoSize = LEFT;
		text.multiline = true;
		text.text = "FPS: ";
		
		times = [];
		
		FlxG.signals.postStateSwitch.add(() -> updateText = __updateTxt);
	}
	
	var deltaTimeout:Float = 0.0;
	
	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000)
			times.shift();
			
		// prevents the overlay from updating every frame, why would you need to anyways @crowplexus
		if (deltaTimeout < 100)
		{
			deltaTimeout += deltaTime;
			return;
		}
		
		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
		updateText();
		underlay.width = text.width + 3;
		underlay.height = text.height;
		
		deltaTimeout = 0.0;
	}
	
	dynamic function updateText():Void
	{
		__updateTxt();
	}
	
	function __updateTxt()
	{
		if (!updating) return;
		
		text.text = 'FPS:$currentFPS • [GC:${FlxStringUtil.formatBytes(gcMemory)} | Task:${FlxStringUtil.formatBytes(taskMemory)}]';
		
		text.textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5) text.textColor = 0xFFFF0000;
	}

	inline function get_gcMemory():Float
	{
		#if cpp
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
		#elseif hl
		return hl.Gc.stats().currentMemory;
		#else
		return (cast openfl.system.System.totalMemoryNumber : UInt);
		#end
	}
	
	inline function get_taskMemory():Float
	{
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
	}
}
#end