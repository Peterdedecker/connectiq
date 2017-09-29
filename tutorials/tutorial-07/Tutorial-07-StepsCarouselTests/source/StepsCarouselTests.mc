(:test)
function helloWorld(logger) {
    logger.debug("Hello World");
    return true;
}

(:test)
function initialStepsTotalIsZero(logger) {
    var view = new StepsCarouselMock();
    var value = view.getValue();
    //logger.debug("value = " + value);
    Toybox.Test.assertEqualMessage(value,0.0,"Initial Steps Total is expected to be 0.0");
    return true;
}

(:test)
function whenTimerDoesNotRunRecordedStepsDontIncrease(logger) {
    var view = new StepsCarouselMock();

    // create the ActivityMonitorInfoMock
    var activityMonitorInfo = new ActivityMonitorInfoMock();
    view.setActivityMonitorInfo(activityMonitorInfo);

    // set steps to 15
    activityMonitorInfo.steps = 15;

    // inject the ActivityMonitorInfoMock into the StepsCarouselMock
    view.setActivityMonitorInfo(activityMonitorInfo);

    // execute business logic
    view.compute(null);

    Toybox.Test.assertEqualMessage(activityMonitorInfo.steps,15,"Steps are 15");
    Toybox.Test.assertEqualMessage(view.getStepsRecorded(),0,"Recorded Steps are 0");

    return true;
}

