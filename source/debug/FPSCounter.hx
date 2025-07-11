package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.display.DisplayObject;

class FPSCounter extends TextField
{
    public var currentFPS(default, null):Int;
    public var memoryMegas(get, never):Float;

    @:noCompletion private var times:Array<Float>;

    private var fixedX:Float;
    private var fixedY:Float;

    // Track peak usage
    private var peakMemMB:Int = 0;
    private var peakRamMB:Int = 0;

    public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
    {
        super();

        fixedX = x;
        fixedY = y;

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
        // Lock position safely only if added to stage
        if (this.stage != null) {
            this.x = fixedX;
            this.y = fixedY;
        }

        // Lock FPS at 60 regardless of actual frame timing
        currentFPS = 60;

        // Throttle updates to about every 50ms
        deltaTimeout += deltaTime;
        if (deltaTimeout < 50) return;
        deltaTimeout = 0.0;

        updateText();
    }

    public dynamic function updateText():Void
    {
        var usedMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
        var maxMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_RESERVED);
        var totalRAM:Float = System.totalMemory;

        var memUsedMB = Std.int(usedMem / 1024 / 1024);
        var memMaxMB = Std.int(maxMem / 1024 / 1024);
        var ramUsedMB = Std.int(totalRAM / 1024 / 1024);

        // Update peak memory and RAM
        if (memUsedMB > peakMemMB) peakMemMB = memUsedMB;
        if (ramUsedMB > peakRamMB) peakRamMB = ramUsedMB;

        text =
            'FPS: ${currentFPS}' +
            '\nMEM: ${memUsedMB}MB/${memMaxMB}MB' +
            '\nRAM: ${ramUsedMB}MB/${memMaxMB}MB' +
            '\nRAM-P (${peakRamMB}MB)' + // Peak RAM usage
            '\nMEM-P (${peakMemMB}MB)' + // Peak MEM usage
            '\nANJE (VER 0.1.1)';

        textColor = 0xFFFFFFFF;
        if (currentFPS < FlxG.drawFramerate * 0.5)
            textColor = 0xFFFF0000;
    }

    inline function get_memoryMegas():Float
        return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
}
