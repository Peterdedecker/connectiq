using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class CommonLogicView extends Ui.WatchFace {
	hidden var width;
	hidden var height;

	hidden var timeString;

    function initialize() {
        WatchFace.initialize();
    }

    // this is called whenever the screen needs to be updated
    function onUpdate(dc) {
		// Common update of the screen: Clear the screen with the backgroundcolor.
		clearScreen(dc);
		
        // We can also do common calculations here, in this case we'll just get the current time
        determineClockTime();
    }
    
    // clears the screen and stores the width & height in global variables
    function clearScreen(dc) {
        width = dc.getWidth();
        height = dc.getHeight();

        // clear the screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle (0, 0, width, height);
    }
    
    function determineClockTime() {
        var clockTime = Sys.getClockTime();
        timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
    }
}
