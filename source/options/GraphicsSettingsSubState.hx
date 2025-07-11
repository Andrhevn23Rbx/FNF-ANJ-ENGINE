package options;

#if DISCORD_ALLOWED
import DiscordClient;
#end

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import objects.Character;

using StringTools;

class AllOptimizationMenu extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	var limitCount:Option;
	var cacheCount:Option;

	public function new()
	{
		title = 'All Optimizations';
		rpcTitle = 'All Optimization Settings';

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("All Optimization Menu", null);
		#end

		// Graphics Settings
		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		addOption(new Option('Low Quality', 'Disables background details to improve performance.', 'lowQuality', BOOL));
		var antiAlias = new Option('Anti-Aliasing', 'Disables anti-aliasing for better performance.', 'antialiasing', BOOL);
		antiAlias.onChange = onChangeAntiAliasing;
		addOption(antiAlias);
		antialiasingOption = optionsArray.length-1;
		addOption(new Option('Shaders', 'Disables shader effects.', 'shaders', BOOL));
		addOption(new Option('GPU Caching', 'Caches textures on GPU to reduce RAM use.', 'cacheOnGPU', BOOL));

		#if !html5
		var fpsOption = new Option('Framerate', 'Set the desired framerate.', 'framerate', INT);
		fpsOption.minValue = 60;
		fpsOption.maxValue = 240;
		fpsOption.defaultValue = Std.int(FlxMath.bound(FlxG.stage.application.window.displayMode.refreshRate, 60, 240));
		fpsOption.displayFormat = '%v FPS';
		fpsOption.onChange = onChangeFramerate;
		addOption(fpsOption);
		#end

		// Optimization Visual Toggles
		addOption(new Option('Chars & BG', 'Disables characters and background.', 'charsAndBG', BOOL));
		addOption(new Option('Enable GC', 'Toggles garbage collection.', 'enableGC', BOOL));
		addOption(new Option('Light Opponent Strums', 'Disables opponent strum lighting.', 'opponentLightStrum', BOOL));
		addOption(new Option('Light Botplay Strums', 'Disables botplay strum lighting.', 'botLightStrum', BOOL));
		addOption(new Option('Light Player Strums', 'Disables player strum lighting.', 'playerLightStrum', BOOL));
		addOption(new Option('Show Ratings & Combo', 'Toggles ratings/combo display.', 'ratesAndCombo', BOOL));
		addOption(new Option('Show Unused Combo Popup', 'Toggles unused combo popup display.', 'comboPopup', BOOL));
		addOption(new Option('Load Songs', 'Toggles PlayState song loading.', 'songLoading', BOOL));
		addOption(new Option('Even LESS Botplay Lag', 'Reduces botplay lag.', 'lessBotLag', BOOL));

		// Advanced Engine/Note Optimizations
		addOption(new Option('Show Notes', 'Disables all notes visually and forces botplay.', 'showNotes', BOOL));
		addOption(new Option('Show Notes again after Skip', 'Restores notes after skipping.', 'showAfter', BOOL));
		addOption(new Option('Keep Notes in Screen', 'Keeps notes always visible.', 'keepNotes', BOOL));
		addOption(new Option('Sort Notes:', 'Toggles how notes are sorted.', 'sortNotes', STRING,
			['Never', 'After Note Spawned', 'After Note Processed', 'After Note Finalized', 'Reversed', 'Chaotic', 'Random', 'Shuffle']));
		addOption(new Option('Faster Sort', 'Only sort visible notes.', 'fastSort', BOOL));
		addOption(new Option('Better Recycling', 'Use NoteGroup recycling.', 'betterRecycle', BOOL));

		var limitNotes = new Option('Max Notes Shown:', 'Limit how many notes are shown.', 'limitNotes', INT);
		limitNotes.scrollSpeed = 30;
		limitNotes.minValue = 0;
		limitNotes.maxValue = 99999;
		limitNotes.changeValue = 1;
		limitNotes.decimals = 0;
		limitNotes.onChange = onChangeLimitCount;
		limitCount = limitNotes;
		addOption(limitNotes);

		var overlap = new Option('Invisible overlapped notes:', 'Hides overlapping notes.', 'hideOverlapped', FLOAT);
		overlap.displayFormat = "%v pixel";
		overlap.scrollSpeed = 10.0;
		overlap.minValue = 0.0;
		overlap.maxValue = 10.0;
		overlap.changeValue = 0.1;
		overlap.decimals = 1;
		addOption(overlap);

		addOption(new Option('Process Notes before Spawning', 'Process notes early for better perf.', 'processFirst', BOOL));
		addOption(new Option('Skip Process for Spawned Note', 'Skip spawn process logic.', 'skipSpawnNote', BOOL));
		addOption(new Option('Break on Time Limit Exceeded', 'Stops processing if taking too long.', 'breakTimeLimit', BOOL));
		addOption(new Option('Optimize Process for Spawned Note', 'Optimize post-spawn logic.', 'optimizeSpawnNote', BOOL));

		addOption(new Option('noteHitPreEvent', 'Send Lua pre-hit event.', 'noteHitPreEvent', BOOL));
		addOption(new Option('noteHitEvent', 'Send Lua hit event.', 'noteHitEvent', BOOL));
		addOption(new Option('spawnNoteEvent', 'Send Lua spawn event.', 'spawnNoteEvent', BOOL));
		addOption(new Option('noteHitEvent for stages', 'Send stage note hit event.', 'noteHitStage', BOOL));
		addOption(new Option('noteHitEvents for Skipped Notes', 'Send hit events for skipped notes.', 'skipNoteEvent', BOOL));
		addOption(new Option('Disable Garbage Collector', 'Disable GC for smoother play.', 'disableGC', BOOL));

		super();
		insert(1, boyfriend);
	}

	function onChangeLimitCount() {
		limitCount.scrollSpeed = interpolate(30, 50000, (holdTime - 0.5) / 10, 3);
	}

	function onChangeAntiAliasing() {
		for (sprite in members) {
			var sprite:FlxSprite = cast sprite;
			if (sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeFramerate() {
		if (ClientPrefs.data.framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		} else {
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	inline function interpolate(start:Float, end:Float, t:Float, power:Float = 1):Float {
		return start + Math.pow(t, power) * (end - start);
	}

	override function changeSelection(change:Int = 0) {
		super.changeSelection(change);
		boyfriend.visible = (antialiasingOption == curSelected);
	}
}
