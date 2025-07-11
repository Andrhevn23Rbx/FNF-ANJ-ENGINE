package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
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

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();
		
		// Update every ~50ms to prevent overload
		if (deltaTimeout < 50) {
			deltaTimeout += deltaTime;
			return;
		}

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
		updateText();
		deltaTimeout = 0.0;
	}

	public dynamic function updateText():Void { // customizable
		var usedMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE); // bytes
		var maxMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_RESERVE); // reserved GC mem

		var totalRAM:Float = System.totalMemory;       // total RAM
		var privateRAM:Float = System.privateMemory;   // private RAM

		// Convert all to MB
		var memUsedMB = Std.int(usedMem / 1024 / 1024);
		var memMaxMB = Std.int(maxMem / 1024 / 1024);
		var ramUsedMB = Std.int(totalRAM / 1024 / 1024);
		var ramPrivMB = Std.int(privateRAM / 1024 / 1024);

		text =
			'FPS: ${currentFPS}' +
			'\nMEM: ${memUsedMB}MB/${memMaxMB}MB' +
			'\nRAM: ${ramUsedMB}MB/${memMaxMB}MB' +
			'\nRAM-P (${ramPrivMB}MB)' +
			'\nMEM-P (${memUsedMB}MB)' +
			'\nANJE (VER 0.1.0)';

		textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
}
