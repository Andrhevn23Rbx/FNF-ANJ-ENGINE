package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

class FPSCounter extends TextField
{
    public var currentFPS(default, null):Int;
    public var memoryMegas(get, never):Float;

    private var fixedX:Float;
    private var fixedY:Float;

    private var peakMemMB:Int = 0;
    private var peakRamMB:Int = 0;

    private var frameTimes:Array<Float>;
    private var lastTime:Float;

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

        frameTimes = [];
        lastTime = 0;
    }

    private override function __enterFrame(deltaTime:Float):Void
    {
        if (stage != null)
        {
            x = fixedX;
            y = fixedY;
        }

        // Track FPS over last second (or ~60 frames)
        var now = Date.now().getTime() / 1000.0;
        if (lastTime > 0)
        {
            var frameTime = now - lastTime;
            frameTimes.push(frameTime);

            // Keep frameTimes for about last 1 second
            var total = 0.0;
            for (ft in frameTimes) total += ft;
            while (total > 1.0 && frameTimes.length > 0)
            {
                total -= frameTimes.shift();
            }

            if (total > 0)
                currentFPS = Math.round(frameTimes.length / total);
        }
        lastTime = now;

        // Update display every ~0.5 seconds to save performance
        deltaTimeout += deltaTime;
        if (deltaTimeout < 0.5) return;
        deltaTimeout = 0;

        updateText();
    }

    private var deltaTimeout:Float = 0;

    public function updateText():Void
    {
        var usedMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
        var maxMem:Float = cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_RESERVED);
        var totalRAM:Float = System.totalMemory;

        var memUsedMB = Std.int(usedMem / 1024 / 1024);
        var memMaxMB = Std.int(maxMem / 1024 / 1024);
        var ramUsedMB = Std.int(totalRAM / 1024 / 1024);

        if (memUsedMB > peakMemMB) peakMemMB = memUsedMB;
        if (ramUsedMB > peakRamMB) peakRamMB = ramUsedMB;

        text =
            'FPS: $currentFPS' +
            '\nMEM: ${memUsedMB}MB/${memMaxMB}MB' +
            '\nRAM: ${ramUsedMB}MB/${memMaxMB}MB' +
            '\nRAM-P ($peakRamMB MB)' +
            '\nMEM-P ($peakMemMB MB)' +
            '\nANJE (VER 0.1.3)';

        textColor = 0xFFFFFFFF;
        if (currentFPS < FlxG.drawFramerate * 0.5)
            textColor = 0xFFFF0000;
    }

    inline function get_memoryMegas():Float
        return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
}
