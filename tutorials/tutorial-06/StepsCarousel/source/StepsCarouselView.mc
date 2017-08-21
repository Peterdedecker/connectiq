using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class StepsCarouselView extends Ui.DataField {
    hidden var value = 0.0f;
    hidden var valueFormat = "%d";
    hidden var labelResource = Rez.Strings.TotalSteps;
    hidden var timerRunning = 0;   // did the user press the start button?
    hidden var stepsNonActive = 0; // todays steps - steps of the current activity
    hidden var stepsRecorded = 0;  // the number of steps recorded by the current activity
    hidden var ticker = 0;         // amount of seconds the timer is in the "active" state

    function initialize() {
        DataField.initialize();
    }

    function isSingleFieldLayout() {
        return (DataField.getObscurityFlags() == OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_BOTTOM | OBSCURE_RIGHT);
    }

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
            dc.drawText(width / 2, height / 2 - 40, Gfx.FONT_TINY, Ui.loadResource(labelResource), textCenter);
            dc.drawText(width / 2, height / 2 + 7, Gfx.FONT_NUMBER_THAI_HOT, value.format(valueFormat), textCenter);
        } else {
            dc.drawText(width / 2, 5 + (height - 55) / 2, Gfx.FONT_TINY, Ui.loadResource(labelResource), textCenter);
            dc.drawText(width / 2, (height - 23) - (height - 55) / 2 - 1, Gfx.FONT_NUMBER_HOT, value.format(valueFormat), textCenter);
        }
    }

    //! Timer transitions from stopped to running state
    function onTimerStart() {
        if (!timerRunning) {
            var activityMonitorInfo = getActivityMonitorInfo();
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

    // The given info object contains all the current workout
    // information. Calculate a value and save it locally in this method.
    function compute(info) {
        var activityMonitorInfo = getActivityMonitorInfo();
        if (timerRunning) {
            stepsRecorded = activityMonitorInfo.steps - stepsNonActive;
             ticker++;
        }

        var timerSlot = (ticker % 20);  // modulo the number of fields (4) * number of seconds to show the field (5)

        if (timerSlot <= 4) {  // first slot?
            labelResource = Rez.Strings.TotalSteps;
            value = activityMonitorInfo.steps;
        } else if (timerSlot <= 9) {
            labelResource = Rez.Strings.ActiveSteps;
            value = stepsRecorded;
        } else if (timerSlot <= 14) {
            labelResource = Rez.Strings.StepsToDo;
            value = (activityMonitorInfo.stepGoal - activityMonitorInfo.steps);
            if (value < 0) {
                value = 0;
            }
        } else if (timerSlot <= 19) {
            labelResource = Rez.Strings.GoalPercentage;
            value = (activityMonitorInfo.steps * 100.0) / activityMonitorInfo.stepGoal;
        } else {
            value = 0;
        }
    }

    function getActivityMonitorInfo() {
        return Toybox.ActivityMonitor.getInfo();
    }

}
