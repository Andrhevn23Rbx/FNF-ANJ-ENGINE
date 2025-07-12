package;

import openfl.Lib;
import openfl.display.Stage;
import openfl.events.Event;

class FpsController {
    public static var targetFPS:Int = 60;
    public static var stage:Stage;
    public static var fixedDeltaTime:Float = 1.0 / 60.0;
    private static var accumulator:Float = 0;
    private static var lastTime:Float = 0;

    public static var updateCallback:Void->Void;

    public static function init(stageRef:Stage, fps:Int = 60, updateFunc:Void->Void = null):Void {
        stage = stageRef;
        targetFPS = fps;
        fixedDeltaTime = 1.0 / fps;
        setFPS(targetFPS);

        updateCallback = updateFunc;

        lastTime = Lib.getTimer() / 1000.0;
        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public static function setFPS(fps:Int):Void {
        targetFPS = fps;
        fixedDeltaTime = 1.0 / fps;
        Lib.current.stage.frameRate = fps;
        trace('FPS locked at: $fps');
    }

    private static function onEnterFrame(event:Event):Void {
        var currentTime = Lib.getTimer() / 1000.0;
        var frameTime = currentTime - lastTime;
        if (frameTime > 0.25) frameTime = 0.25; // avoid spiral of death on lag spikes

        accumulator += frameTime;

        while (accumulator >= fixedDeltaTime) {
            if (updateCallback != null)
                updateCallback();

            accumulator -= fixedDeltaTime;
        }
        lastTime = currentTime;
    }
}
