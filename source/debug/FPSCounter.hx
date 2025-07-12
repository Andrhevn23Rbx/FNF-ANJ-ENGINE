package debug;

import openfl.text.TextField;
import openfl.text.TextFormat;

class FPSCounter extends TextField
{
    public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
    {
        super();

        x = x;
        y = y;

        selectable = false;
        mouseEnabled = false;
        defaultTextFormat = new TextFormat("_sans", 14, color);
        autoSize = LEFT;
        multiline = true;

        updateText();
    }

    public function updateText():Void
    {
        text =
            'FPS: 60' +
            '\nMEM: 0MB/0MB' +
            '\nRAM: 0MB/0MB/0MB' +
            '\nANJE 0.1.3';
        textColor = 0xFFFFFFFF;
    }
}
