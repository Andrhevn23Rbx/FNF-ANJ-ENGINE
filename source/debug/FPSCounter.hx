package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
 * A customizable FPS and memory counter for Windows builds.
 */
class FPSCounter extends TextField
{
	public var currentFPS(default, null):Int;
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	private override function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		// Update once every 50ms to prevent spam
		if (deltaTimeout < 50) {
			deltaTimeout += deltaTime;
			return;
		}

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
		updateText();
		deltaTimeout = 0.0;
	}

	public dynamic function updateText():Void
	{
		var usedMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);        // Used GC memory (bytes)
		var maxMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_RESERVED);      // Reserved GC memory (bytes)
		var totalRAM:Float = System.totalMemory;                                  // Total system memory used (bytes)

		// Convert to MB
		var memUsedMB = Std.int(usedMem / 1024 / 1024);
		var memMaxMB = Std.int(maxMem / 1024 / 1024);
		var ramUsedMB = Std.int(totalRAM / 1024 / 1024);

		text =
			'FPS: ${currentFPS}' +
			'\nMEM: ${memUsedMB}MB/${memMaxMB}MB' +
			'\nRAM: ${ramUsedMB}MB/${memMaxMB}MB' +
			'\nRAM-P (${ramUsedMB}MB)' + // Using totalRAM again since private RAM is unsupported
			'\nMEM-P (${memUsedMB}MB)' +
			'\nANJE (VER 0.1.0)';

		textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
}
