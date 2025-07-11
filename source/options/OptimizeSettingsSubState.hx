package options;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import backend.ClientPrefs;
import openfl.system.System;
import states.TitleState;

class OptimizeSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization Settings';
		rpcTitle = 'Optimization Settings Menu'; // For Discord RPC

		super();
	}

	override function addItems():Void
	{
		addOption(new Option(
			"Optimized Settings",
			"Enable all optimization settings in one click.",
			"optimizedSettings",
			"bool"
		));

		addOption(new Option(
			"Combo Popup",
			"Toggle the combo popup animation.",
			"comboPopup",
			"bool"
		));

		addOption(new Option(
			"Combo Rating Popup",
			"Show rating (Sick, Good, etc.) popup when hitting notes.",
			"comboRatingPopup",
			"bool"
		));

		addOption(new Option(
			"Combo Number Popup",
			"Show combo numbers (e.g. 123!) on screen.",
			"comboNumPopup",
			"bool"
		));

		addOption(new Option(
			"Garbage Collect",
			"Force memory cleanup every song or state.",
			"garbageCollect",
			"bool"
		));

		addOption(new Option(
			"Note Pooling",
			"Controls how notes are reused to improve performance.\nNone = Off, Basic = safe pooling, Aggressive = experimental performance boost.",
			"notePooling",
			"string",
			["None", "Basic", "Aggressive"]
		));

		addOption(new Option(
			"Note Recycling",
			"Recycle old notes instead of deleting and spawning new ones.",
			"noteRecycling",
			"bool"
		));

		addOption(new Option(
			"No Botplay Lag",
			"Optimize performance during Botplay.",
			"noBotplayLag",
			"bool"
		));
		
		addOption(new Option(
			"Lock FPS Mode",
			"Set your maximum FPS. Lower values improve stability.\nUnlimited disables the cap (may increase lag).",
			"lockFPSMode",
			"string",
			["60", "120", "144", "240", "Unlimited"]
		));
	}
}
