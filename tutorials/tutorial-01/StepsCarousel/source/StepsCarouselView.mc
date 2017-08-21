using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class StepsCarouselView extends Ui.DataField {

    hidden var mValue;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
        }

        return true;
    }


    hidden var label = "Total";  // intial value for the label

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

        // Set the foreground color and value
        var value = View.findDrawableById("value");
        if (getBackgroundColor() == Gfx.COLOR_BLACK) {
            value.setColor(Gfx.COLOR_WHITE);
        } else {
            value.setColor(Gfx.COLOR_BLACK);
        }
        value.setText(mValue.format("%.2f"));

        // label also needs to be updated regularly
        View.findDrawableById("label").setText(label);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
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
