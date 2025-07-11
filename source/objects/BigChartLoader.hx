package objects;

import sys.io.File;
import sys.io.FileInput;
import haxe.io.Input;
import Note; // adjust path if needed (ex: import PlayState.Note or your engine's Note class)

class BigChartLoader {
	public static function loadChart(path:String, callback:Note->Void):Void {
		trace('Loading chart from: ' + path);

		var input:FileInput = File.read(path, false); // text mode
		try {
			while (!input.eof()) {
				var line = input.readLine();
				var parts = line.split(",");

				if (parts.length >= 2) {
					var strumTime = Std.parseFloat(parts[0]);
					var lane = Std.parseInt(parts[1]);
					var note = new Note(strumTime, lane, 0); // adjust constructor if needed
					callback(note);
				}
			}
		} catch (e:Dynamic) {
			trace("Chart loading error: " + e);
		} finally {
			input.close();
		}
	}
}
