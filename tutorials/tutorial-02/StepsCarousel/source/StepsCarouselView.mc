using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class StepsCarouselView extends Ui.DataField {

    hidden var mValue;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
    }

    hidden var label = "Total";  // intial value for the label

    function isSingleFieldLayout() {
        return (DataField.getObscurityFlags() == OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_BOTTOM | OBSCURE_RIGHT);
    }

    hidden var valueFormat = "%d";

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var textCenter = Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER;
        var backgroundColor = getBackgroundColor();
        // set background color
        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle (0, 0, width, height);
        // set foreground color
        dc.setColor((backgroundColor == Gfx.COLOR_BLACK) ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // do layout
        if (isSingleFieldLayout()) {
            dc.drawText(width / 2, height / 2 - 40, Gfx.FONT_TINY, label, textCenter);
            dc.drawText(width / 2, height / 2 + 7, Gfx.FONT_NUMBER_THAI_HOT, mValue.format(valueFormat), textCenter);
        } else {
            dc.drawText(width / 2, 5 + (height - 55) / 2, Gfx.FONT_TINY, label, textCenter);
            dc.drawText(width / 2, (height - 23) - (height - 55) / 2 - 1, Gfx.FONT_NUMBER_HOT, mValue.format(valueFormat), textCenter);
        }
    }

    hidden var timerRunning = 0;   // did the user press the start button?
    hidden var stepsNonActive = 0; // todays steps - steps of the current activity
    hidden var stepsRecorded = 0;  // the number of steps recorded by the current activity

    //! Timer transitions from stopped to running state
    function onTimerStart() {
        if (!timerRunning) {
            var activityMonitorInfo = Toybox.ActivityMonitor.getInfo();
            stepsNonActive = activityMonitorInfo.steps - stepsRecorded;
            timerRunning = true;
        }
    }

    //! Timer transitions from running to stopped state
    function onTimerStop() {
        timerRunning = false;
        ticker = 0;
    }

    //! Activity is ended
    function onTimerReset() {
        stepsRecorded = 0;
    }

    hidden var ticker = 0;         // amount of seconds the timer is in the "active" state

    // The given info object contains all the current workout
    // information. Calculate a value and save it locally in this method.
    function compute(info) {
        var activityMonitorInfo = Toybox.ActivityMonitor.getInfo();
        if (timerRunning) {
            stepsRecorded = activityMonitorInfo.steps - stepsNonActive;
             ticker++;
        }

        var timerSlot = (ticker % 20);  // modulo the number of fields (4) * number of seconds to show the field (5)

        if (timerSlot <= 4) {  // first slot?
            label = "Total Steps";
            mValue = activityMonitorInfo.steps;
        } else if (timerSlot <= 9) {
            label = "Active Steps";
            mValue = stepsRecorded;
        } else if (timerSlot <= 14) {
            label = "Steps To Go";
            mValue = (activityMonitorInfo.stepGoal - activityMonitorInfo.steps);
            if (mValue < 0) {
                mValue = 0;
            }
        } else if (timerSlot <= 19) {
            label = "Goal (%)";
            mValue = (activityMonitorInfo.steps * 100.0) / activityMonitorInfo.stepGoal;
        } else {
            mValue = 0;
        }
    }

}
