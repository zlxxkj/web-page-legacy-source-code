package states;

class MJState extends FlxState
{
	//bg
	var grid:FlxBackdrop;

	//mj
    var mj:FlxSprite;
    var mjControl = true;
    var lol = false;

	//kfc
	var kfc1 = false;
	var kfc2 = false;
	var kfcControl = true;
	var kfc:FlxSprite;

    override function create()
    {
		grid = new FlxBackdrop(Paths.image('menus/gunmu'));
		grid.velocity.set(40, 40);
		add(grid);

		mj = new FlxSprite(250, 0);
		mj.frames = Paths.getSparrowAtlas('emoji/mj/mj');
		mj.animation.addByPrefix('idle', 'idle', 24, false);
		mj.scale.set(2.5,2.5);
		mj.updateHitbox();
		// mj.cameras = [camText];
		add(mj);  

		kfc = new FlxSprite(0, 0);
		kfc.frames = Paths.getSparrowAtlas('emoji/kfc/kfc');
		kfc.animation.addByPrefix('idle', 'idle', 24, false);
		// kfc.animation.play('idle');
		kfc.scale.set(6,6);
		kfc.updateHitbox();
		// kfc.cameras = [camText];
		add(kfc);  

        super.create();

    }


	override function update(elapsed:Float)
	{
		kFC();
		mJ();
   		super.update(elapsed);
     
    }

	function kFC()
	{
		if (FlxG.keys.justPressed.K && kfcControl && !kfc1)
		{
			kfc1 = true;
		}

		if (FlxG.keys.justPressed.F && kfcControl && !kfc2 && !kfc1)
		{
			kfc2 = true;
		}

		if (FlxG.keys.justPressed.C && kfcControl)
		{
			kfc.animation.play('idle');
			FlxG.sound.play(Paths.music("kfc"), 1, false);
			kfcControl = false;
			new FlxTimer().start(3, function(tmr:FlxTimer){
				kfc1 = false;
				kfc2 = false;
				kfcControl = true;
			});
		}

	}


	function mJ()
	{
		if (FlxG.keys.justPressed.M && mjControl)
		{
			lol = true;
		}

		if (FlxG.keys.justPressed.J && lol && mjControl)
		{
			var mjRandom = RandomUtil.fromArray(['mj','mj1']);
			mj.frames = Paths.getSparrowAtlas('emoji/mj/' + mjRandom);
			mj.animation.addByPrefix('idle', 'idle', 24, false);
			mj.animation.play('idle');
			FlxG.sound.play(Paths.music(mjRandom), 1, false);
			mjControl = false;
			new FlxTimer().start(3, function(tmr:FlxTimer){
				mjControl = true;
			});
			lol = false;
		}

	}
}