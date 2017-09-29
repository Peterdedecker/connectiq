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
    hidden var fields;
    hidden var field = [0, 0, 0, 0];
    hidden var carouselSeconds = 0;  // amount of seconds before the carousel gets changed to a new position

    function initialize() {
        DataField.initialize();
		
		fields = 0;
		var app = getApplicationProperties();
        carouselSeconds = app.getProperty("carouselSeconds") == null? 5 : app.getProperty("carouselSeconds");
        if (app.getProperty("showTotal") == null? true : app.getProperty("showTotal")) {
            field[fields] = 1;
            fields++;
        }
        if ((app.getProperty("showSteps") == null? true : app.getProperty("showSteps")) || fields == 0) {
            field[fields] = 2;
            fields++;
        }
        if (app.getProperty("showStepsToGo") == null? true : app.getProperty("showStepsToGo")) {
            field[fields] = 3;
            fields++;
        }
        if (app.getProperty("showGoalPercentage") == null? true : app.getProperty("showGoalPercentage")) {
            field[fields] = 4;
            fields++;
        }
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

        var timerSlot = (ticker % (fields * carouselSeconds));  // modulo the number of fields * number of seconds to show the field 

        if (timerSlot <= carouselSeconds-1) {  // first slot?
			showField(field[0]);
        } else if (timerSlot <= carouselSeconds*2-1) {
			showField(field[1]);
        } else if (timerSlot <= carouselSeconds*3-1) {
			showField(field[2]);
        } else if (timerSlot <= carouselSeconds*4-1) {
			showField(field[3]);
        } else {
            value = 0;
        }
    }
	
    function showField (fieldNr) {
        var activityMonitorInfo = getActivityMonitorInfo();
        if (fieldNr == 1) {
            labelResource = Rez.Strings.TotalSteps;
            value = activityMonitorInfo.steps;
        } else if (fieldNr == 2) {
            labelResource = Rez.Strings.ActiveSteps;
            value = stepsRecorded;
        } else if (fieldNr == 3) {
            value = (activityMonitorInfo.stepGoal - activityMonitorInfo.steps);
            if (value < 0) {
                value = -1 * value;
                var timerSlot = (ticker % carouselSeconds);
                if (timerSlot <= carouselSeconds / 2) {
                    labelResource = Rez.Strings.GoalReached;
                } else {
                    labelResource = Rez.Strings.Congrats;
                }
            } else {
                labelResource = Rez.Strings.StepsToDo;
            }
        } else if (fieldNr == 4) {
            labelResource = Rez.Strings.GoalPercentage;
            value = (activityMonitorInfo.steps * 100.0) / activityMonitorInfo.stepGoal;
            valueFormat = "%.2f";
        }
    }	

    function getActivityMonitorInfo() {
        return Toybox.ActivityMonitor.getInfo();
    }

    function getApplicationProperties() {
        return Application.getApp();
    }
}
