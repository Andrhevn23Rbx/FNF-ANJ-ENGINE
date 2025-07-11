package options;

import objects.Character;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxSprite;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	var optimizedOption:Int;

	// New options indexes
	var comboPopupOption:Int;
	var comboRatingPopupOption:Int;
	var comboNumPopupOption:Int;
	var garbageCollectOption:Int;
	var notePoolingOption:Int;
	var noteRecyclingOption:Int;
	var noBotplayLagOption:Int;

	public function new()
	{
		title = Language.getPhrase('graphics_menu', 'Graphics Settings');
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		// Optimized Settings option
		var optimizedOptionObj:Option = new Option('Optimized Settings',
			'Enables a set of performance-friendly settings optimized for smoother gameplay on low-end PCs.',
			'optimizedSettings',
			BOOL);
		optimizedOptionObj.onChange = onChangeOptimizedSettings;
		addOption(optimizedOptionObj);
		optimizedOption = optionsArray.length - 1;

		var option:Option = new Option('Low Quality', //Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', //Description
			'lowQuality', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Anti-Aliasing',
			'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
			'antialiasing',
			BOOL);
		option.onChange = onChangeAntiAliasing;
		addOption(option);
		antialiasingOption = optionsArray.length-1;

		var option:Option = new Option('Shaders', //Name
			"If unchecked, disables shaders.\nIt's used for some visual effects, and also CPU intensive for weaker PCs.", //Description
			'shaders',
			BOOL);
		addOption(option);

		var option:Option = new Option('GPU Caching', //Name
			"If checked, allows the GPU to be used for caching textures, decreasing RAM usage.\nDon't turn this on if you have a weak Graphics Card.", //Description
			'cacheOnGPU',
			BOOL);
		addOption(option);

		#if !html5
		var option:Option = new Option('Framerate',
			"Pretty self explanatory, isn't it?",
			'framerate',
			INT);
		addOption(option);

		final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		option.minValue = 60;
		option.maxValue = 240;
		option.defaultValue = Std.int(FlxMath.bound(refreshRate, option.minValue, option.maxValue));
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		// === New optimization options ===
		var opt:Option;

		opt = new Option('Combo Popup',
			"Toggle combo popups on/off for performance optimization.",
			'comboPopup',
			BOOL);
		opt.onChange = onChangeComboPopup;
		addOption(opt);
		comboPopupOption = optionsArray.length - 1;

		opt = new Option('Combo Rating Popup',
			"Toggle combo rating popups on/off to reduce CPU usage.",
			'comboRatingPopup',
			BOOL);
		opt.onChange = onChangeComboRatingPopup;
		addOption(opt);
		comboRatingPopupOption = optionsArray.length - 1;

		opt = new Option('Combo Number Popup',
			"Toggle combo number popups on/off for performance.",
			'comboNumPopup',
			BOOL);
		opt.onChange = onChangeComboNumPopup;
		addOption(opt);
		comboNumPopupOption = optionsArray.length - 1;

		opt = new Option('Garbage Collect',
			"Enables manual garbage collection to reduce memory usage.",
			'garbageCollect',
			BOOL);
		opt.onChange = onChangeGarbageCollect;
		addOption(opt);
		garbageCollectOption = optionsArray.length - 1;

		opt = new Option('Note Pooling',
			"Enable note pooling to reuse note objects and improve performance.",
			'notePooling',
			BOOL);
		opt.onChange = onChangeNotePooling;
		addOption(opt);
		notePoolingOption = optionsArray.length - 1;

		opt = new Option('Note Recycling',
			"Enable note recycling to reduce lag during gameplay.",
			'noteRecycling',
			BOOL);
		opt.onChange = onChangeNoteRecycling;
		addOption(opt);
		noteRecyclingOption = optionsArray.length - 1;

		opt = new Option('No Botplay Lag',
			"Optimizes the game to reduce lag when botplay is active.",
			'noBotplayLag',
			BOOL);
		opt.onChange = onChangeNoBotplayLag;
		addOption(opt);
		noBotplayLagOption = optionsArray.length - 1;

		super();
		insert(1, boyfriend);
	}

	// === onChange Handlers for new options (implement your logic here) ===

	function onChangeComboPopup()
	{
		// TODO: Add logic to enable/disable combo popup
		trace("Combo Popup: " + ClientPrefs.data.comboPopup);
	}

	function onChangeComboRatingPopup()
	{
		// TODO: Add logic to enable/disable combo rating popup
		trace("Combo Rating Popup: " + ClientPrefs.data.comboRatingPopup);
	}

	function onChangeComboNumPopup()
	{
		// TODO: Add logic to enable/disable combo number popup
		trace("Combo Num Popup: " + ClientPrefs.data.comboNumPopup);
	}

	function onChangeGarbageCollect()
	{
		// You can manually call garbage collection here if needed
		trace("Garbage Collect: " + ClientPrefs.data.garbageCollect);
		if (ClientPrefs.data.garbageCollect)
		{
			// Manual GC trigger example (works only on some targets)
			try
			{
				System.gc();
			}
			catch(e:Dynamic) {}
		}
	}

	function onChangeNotePooling()
	{
		// TODO: Enable or disable note pooling logic
		trace("Note Pooling: " + ClientPrefs.data.notePooling);
	}

	function onChangeNoteRecycling()
	{
		// TODO: Enable or disable note recycling logic
		trace("Note Recycling: " + ClientPrefs.data.noteRecycling);
	}

	function onChangeNoBotplayLag()
	{
		// TODO: Add botplay lag reduction logic
		trace("No Botplay Lag: " + ClientPrefs.data.noBotplayLag);
	}

	function onChangeOptimizedSettings()
	{
		if (ClientPrefs.data.optimizedSettings)
		{
			// Enable optimized config
			ClientPrefs.data.lowQuality = true;
			ClientPrefs.data.antialiasing = false;
			ClientPrefs.data.shaders = false;
			ClientPrefs.data.cacheOnGPU = false;
			ClientPrefs.data.framerate = 60;

			ClientPrefs.data.comboPopup = false;
			ClientPrefs.data.comboRatingPopup = false;
			ClientPrefs.data.comboNumPopup = false;
			ClientPrefs.data.garbageCollect = true;
			ClientPrefs.data.notePooling = true;
			ClientPrefs.data.noteRecycling = true;
			ClientPrefs.data.noBotplayLag = true;

			// Apply changes to UI & call handlers
			setOptionValue('lowQuality', true);
			setOptionValue('antialiasing', false);
			setOptionValue('shaders', false);
			setOptionValue('cacheOnGPU', false);
			setOptionValue('framerate', 60);

			setOptionValue('comboPopup', false);
			setOptionValue('comboRatingPopup', false);
			setOptionValue('comboNumPopup', false);
			setOptionValue('garbageCollect', true);
			setOptionValue('notePooling', true);
			setOptionValue('noteRecycling', true);
			setOptionValue('noBotplayLag', true);

			onChangeAntiAliasing();
			onChangeFramerate();

			onChangeComboPopup();
			onChangeComboRatingPopup();
			onChangeComboNumPopup();
			onChangeGarbageCollect();
			onChangeNotePooling();
			onChangeNoteRecycling();
			onChangeNoBotplayLag();

			disableOtherOptions(true);
		}
		else
		{
			// Disable optimized config: restore defaults (simple example)
			ClientPrefs.data.lowQuality = false;
			ClientPrefs.data.antialiasing = true;
			ClientPrefs.data.shaders = true;
			ClientPrefs.data.cacheOnGPU = true;
			ClientPrefs.data.framerate = 60;

			ClientPrefs.data.comboPopup = true;
			ClientPrefs.data.comboRatingPopup = true;
			ClientPrefs.data.comboNumPopup = true;
			ClientPrefs.data.garbageCollect = false;
			ClientPrefs.data.notePooling = false;
			ClientPrefs.data.noteRecycling = false;
			ClientPrefs.data.noBotplayLag = false;

			setOptionValue('lowQuality', false);
			setOptionValue('antialiasing', true);
			setOptionValue('shaders', true);
			setOptionValue('cacheOnGPU', true);
			setOptionValue('framerate', 60);

			setOptionValue('comboPopup', true);
			setOptionValue('comboRatingPopup', true);
			setOptionValue('comboNumPopup', true);
			setOptionValue('garbageCollect', false);
			setOptionValue('notePooling', false);
			setOptionValue('noteRecycling', false);
			setOptionValue('noBotplayLag', false);

			onChangeAntiAliasing();
			onChangeFramerate();

			onChangeComboPopup();
			onChangeComboRatingPopup();
			onChangeComboNumPopup();
			onChangeGarbageCollect();
			onChangeNotePooling();
			onChangeNoteRecycling();
			onChangeNoBotplayLag();

			disableOtherOptions(false);
		}
	}

	function disableOtherOptions(disable:Bool)
	{
		// Disable or enable all other options except Optimized Settings
		for (i in 0...optionsArray.length)
		{
			if (i == optimizedOption) continue;
			var opt = optionsArray[i];
			if (opt != null) opt.disabled = disable;
		}
	}

	function setOptionValue(name:String, value:Dynamic)
	{
		for (opt in optionsArray)
		{
			if (opt.name == name)
			{
				opt.value = value;
				break;
			}
		}
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		boyfriend.visible = (antialiasingOption == curSelected);
	}
}
