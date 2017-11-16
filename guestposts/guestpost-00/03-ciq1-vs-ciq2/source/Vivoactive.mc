using Toybox.Graphics as Gfx;

// inherit from the view that contains the commonlogic
class DeviceView extends CiqView {

	// it's good practice to always have an initialize, make sure to call your parent class here!
    function initialize() {
        CiqView.initialize();
    }

	function onUpdate(dc) {
		// call the parent function in order to execute the logic of the parent
		CiqView.onUpdate(dc);
		
		// do the device specific drawings
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(width / 2, height / 2, Gfx.FONT_NUMBER_THAI_HOT, timeString, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
		dc.drawText(width / 2, 110, Gfx.FONT_MEDIUM, message, Gfx.TEXT_JUSTIFY_CENTER);
	}

}