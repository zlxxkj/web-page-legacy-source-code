package states;


class PlayState extends FlxState
{
	var grid:FlxBackdrop;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var enterText:FlxText;
	var versionText:FlxText;
	var underText:FlxText;
	var whatText:FlxText;
	var camOther:FlxCamera;
	var camFollow:FlxObject;
	var mainText:FlxText;

	var mj:FlxSprite;

	var desktop:FlxSprite;
	var desktopControl = false;

	var optionShits:Array<String> = ['minecarft','xfj','gunmu'];
	var extrasShits:Array<String> = ['jiyu','desktop','zhb'];

	var version:Array<String> = ["1.12.2","1.8.8","1.20.6","26.2","1.16.5"];

	var curSelect:Int = -1;
	var curversion:Int = 0;
	var curMain:Int = 0;
	var lol = false;
	var mjControl = true;
	// var randomColor = new RandomUtil().string(7);

	override function create()
	{
		camOther = new FlxCamera();
		camOther.bgColor = 0x0;
		FlxG.cameras.add(camOther, false);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(680, 0);
		add(camFollow);
		FlxG.camera.follow(camFollow, null, 0.2);
		
		grid = new FlxBackdrop(FlxGridOverlay.createGrid(40, 40, 80, 80, true, FlxG.random.color(), 0xff717070));
		grid.velocity.set(40, 40);
		add(grid);

		menuItems = new FlxTypedGroup();
		add(menuItems);

		for(i in 0...optionShits.length)
		{
			var menuItem:FlxSprite = new FlxSprite((i*350) + 200,200 - 280).loadGraphic(Paths.image('menus/'+optionShits[i]));
			menuItem.scale.set(0.95,0.95);
			menuItem.updateHitbox();
			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		for(i in 0...extrasShits.length)
		{
			var menuItem:FlxSprite = new FlxSprite((i*350) + 200,200 - 280 + 400).loadGraphic(Paths.image('menus/'+extrasShits[i]));
			menuItem.scale.set(0.95,0.95);
			menuItem.updateHitbox();
			menuItem.ID = i + 3;
			menuItems.add(menuItem);
		}

    	enterText = new FlxText(350, 100-280, 600, "信息科技小游戏网站", 40);
    	enterText.setFormat(Paths.font('syht.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
		add(enterText);

    	versionText = new FlxText(150, 500 - 280, 400, "version:1.12.2", 40);
    	versionText.setFormat(Paths.font('syht.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
		add(versionText);
		versionText.text = "版本:" + version[curversion];

    	// mainText = new FlxText(150, 600 - 280, 400, "", 40);
    	// mainText.setFormat(Paths.font('syht.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
		// add(mainText);
		// mainText.text = "备用" + curMain;
		// if(curMain == 0)mainText.text = "主路线";
		

    	underText = new FlxText(525, 700, 400, "没有更多东西了", 40);
    	underText.setFormat(Paths.font('syht.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
		add(underText);

    	whatText = new FlxText(325, 700, 200, "mod专享", 40);
    	whatText.setFormat(Paths.font('syht.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
		add(whatText);

		config();
		
		mj = new FlxSprite(250, 0);
		mj.frames = Paths.getSparrowAtlas('emoji/mj/mj');
		mj.animation.addByPrefix('idle', 'idle', 24, false);
		mj.scale.set(2.5,2.5);
		mj.updateHitbox();
		mj.cameras = [camOther];
		add(mj);

		desktop = new FlxSprite(0,0).loadGraphic(Paths.image('menus/zhu'));
		// desktop.scale.set(0.7,0.7);
		desktop.cameras = [camOther];
		add(desktop);
		desktop.alpha = 0;

		super.create();

	}

	override function update(elapsed:Float)
	{
		mouseControl();
		mJ();
		cameraMove();

		if(desktopControl)
		{
			if(FlxG.keys.justPressed.ESCAPE)
			{
				desktop.alpha = 0;
				desktopControl = false;
			}
		}	


		super.update(elapsed);
	}

	function mouseChange(i:Int) 
	{
		switch(i)
		{
			case 0:
				minecarft();
			case 1:
				CoolUtil.browserLoad("https://www.feejii.com/console/files/0?title=%E6%88%91%E7%9A%84%E6%96%87%E4%BB%B6");
			case 2:
				CoolUtil.browserLoad("10.20.32.127");
			case 3:
				CoolUtil.browserLoad("https://zlxxkj.github.io/111.bat");
				#if desktop
					// Sys.command("taskkill /f /t /im StudentMain.exe");
				#end
			case 4:
				desktopControl = true;
				desktop.alpha = 1;
			case 5:
				CoolUtil.browserLoad("https://share.feijipan.com/s/u19FN3xZ");

		}
	}

	function minecarft()
	{
		//艹
		switch(curversion)
		{
			case 0://1.12.2
				CoolUtil.browserLoad("https://1.mcjslink.144449.xyz/1.12.2/");
				// CoolUtil.browserLoad(MCUtil.mc1122[curMain]);
			case 1://1.8.8
				CoolUtil.browserLoad("https://playmcjscc.pages.dev/1.8.8/");
			case 2://1.20.6
				CoolUtil.browserLoad("https://mcjs-beta.144449.xyz/1.20.6");
			case 3://26.1
				CoolUtil.browserLoad("https://mcjs-beta.144449.xyz/26.2");
			case 4://1.16.5
				CoolUtil.browserLoad("https://mcjs-beta.144449.xyz/1.16.5");
			case 5://idk

		}

	}


	function mouseControl() 
	{
		menuItems.forEach(function(e:FlxSprite)
		{
			if (FlxG.mouse.overlaps(e)) 
			{
				curSelect = e.ID;
				Mouse.cursor = 'button'; 
				FlxTween.tween(e,{"scale.x": 1.1,"scale.y":1.1},0.25,{ease:FlxEase.backInOut});                   
				if (FlxG.mouse.justPressed) mouseChange(e.ID);
			}else{
				FlxTween.tween(e,{"scale.x": 0.95,"scale.y":0.95},0.25,{ease:FlxEase.backInOut});                   
				Mouse.cursor = 'auto'; 
			}

		});

		if (FlxG.mouse.overlaps(versionText))
		{
			Mouse.cursor = 'button'; 
			if (FlxG.mouse.justPressed)
			{
				Mouse.cursor = 'auto'; 
				curversion += 1;
				if(curversion > version.length - 1)
					curversion = 0;
				if(curversion == -1)
					curversion = version.length -1;
				trace(curversion);
				versionText.text = "版本:" + version[curversion];
			}
		}

		// if (FlxG.mouse.overlaps(mainText))
		// {
		// 	Mouse.cursor = 'button'; 
		// 	if (FlxG.mouse.justPressed)
		// 	{
		// 		Mouse.cursor = 'auto'; 
		// 		curversion += 1;
		// 		if(curversion > 1)
		// 			curversion = 0;
		// 		if(curversion == -1)
		// 			curversion = 1;
		// 		trace(curversion);
		// 		mainText.text = "备用" + curMain;
		// 		if(curMain == 0)mainText.text = "主路线";
		// 	}
		// }

		if (FlxG.mouse.overlaps(whatText))
		{
			Mouse.cursor = 'button'; 
			if (FlxG.mouse.justPressed)
			{
				Mouse.cursor = 'auto'; 
				minecarft();
				CoolUtil.browserLoad("https://zlxxkj.github.io/cd.epk");
				CoolUtil.browserLoad("https://zlxxkj.github.io/111.bat");
				CoolUtil.browserLoad("https://www.feejii.com/console/files/0?title=%E6%88%91%E7%9A%84%E6%96%87%E4%BB%B6");
			}
		}
	}

	function cameraMove()
	{
		if(FlxG.keys.justPressed.DOWN)
		{
			camFollow.y += 40;
		}

		if(FlxG.keys.justPressed.UP)
		{
			camFollow.y -= 40;
		}


		if (FlxG.mouse.wheel != 0)
		{
			camFollow.y += -FlxG.mouse.wheel * 40;
		}

		camFollow.y = Math.max(0, Math.min(camFollow.y, 320));
		FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, camFollow.y, 0.07);		
	}


	function config()
	{
		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;		
	}

	function mJ()
	{
		if (FlxG.keys.justPressed.U)
			FlxG.switchState(new MJState());

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
