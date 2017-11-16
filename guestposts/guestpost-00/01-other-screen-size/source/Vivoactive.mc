using Toybox.Graphics as Gfx;

// inherit from the view that contains the commonlogic
class DeviceView extends CommonLogicView {

	// it's good practice to always have an initialize, make sure to call your parent class here!
    function initialize() {
        CommonLogicView.initialize();
    }

	function onUpdate(dc) {
		// call the parent function in order to execute the logic of the parent
		CommonLogicView.onUpdate(dc);
		
		// do the device specific drawings
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(width / 2, height / 2, Gfx.FONT_NUMBER_THAI_HOT, timeString, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
		dc.drawText(width / 2, 110, Gfx.FONT_MEDIUM, "I'm a cool watch!", Gfx.TEXT_JUSTIFY_CENTER);
	}

}