package debug;

import openfl.text.TextField;
import openfl.text.TextFormat;

class FPSCounter extends TextField
{
    private var fixedX:Float;
    private var fixedY:Float;

    public function new(posX:Float = 10, posY:Float = 10, color:Int = 0xFFFFFF)
    {
        super();

        fixedX = posX;
        fixedY = posY;

        selectable = false;
        mouseEnabled = false;
        defaultTextFormat = new TextFormat("_sans", 14, color);
        autoSize = LEFT;
        multiline = true;

        this.x = fixedX;
        this.y = fixedY;

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
