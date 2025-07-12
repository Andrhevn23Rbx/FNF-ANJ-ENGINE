package debug;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import cpp.vm.Gc;
import haxe.Timer;
import haxe.Http;

class FPSCounter extends TextField
{
    public var currentFPS:Int = 60;

    private var peakMem:Float = 0;
    private var lastPing:Float = 0;
    private var deltaTimeout:Float = 0;
    private var frameTimes:Array<Float> = [];
    private var lastTime:Float = 0;

    public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
    {
        super();

        this.x = x;
        this.y = y;
        selectable = false;
        mouseEnabled = false;
        multiline = true;
        autoSize = LEFT;
        defaultTextFormat = new TextFormat("_sans", 14, color);

        updateText();
        ping("https://www.google.com");
    }

    public function update(elapsed:Float):Void
    {
        // FPS tracking
        var now = Timer.stamp();
        if (lastTime > 0) {
            var dt = now - lastTime;
            frameTimes.push(dt);
            if (frameTimes.length > 60) frameTimes.shift();

            var avg = 0.0;
            for (f in frameTimes) avg += f;
            avg /= frameTimes.length;

            currentFPS = Math.round(1.0 / avg);
        }
        lastTime = now;

        // Update info every 0.5s
        deltaTimeout += elapsed;
        if (deltaTimeout >= 0.5)
        {
            deltaTimeout = 0;
            updateText();
            ping("https://www.google.com");
        }
    }

    function updateText():Void
    {
        // Real memory usage (in MB)
        var usedMem:Float = Gc.memInfo64(Gc.MEM_INFO_USAGE) / 1024 / 1024;
        var reservedMem:Float = Gc.memInfo64(Gc.MEM_INFO_RESERVED) / 1024 / 1024;

        if (usedMem > peakMem) peakMem = usedMem;

        // Format ping nicely
        var formattedPing:String = (lastPing >= 0)
            ? StringTools.lpad(Std.string(Math.fround(lastPing * 1000)), "0", 8)
            : "000000.00";

        text =
            'FPS: $currentFPS\n' +
            'MEM: ${Std.int(usedMem)}MB/${Std.int(reservedMem)}MB\n' +
            'RAM: ${Std.int(usedMem)}MB/${Std.int(reservedMem)}MB\n' +
            'PING: $formattedPing MS\n' +
            'ANJE: 0.1.4';
    }

    function ping(url:String):Void
    {
        var start = Timer.stamp();
        var http = new Http(url);

        http.onError = function(e) lastPing = -1;
        http.onStatus = function(_) lastPing = Timer.stamp() - start;

        http.request(false);
    }
}
