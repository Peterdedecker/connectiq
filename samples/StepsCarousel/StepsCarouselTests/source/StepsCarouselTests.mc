
(:test)
function initialStepsTotalIsZero(logger) {
    var view = new StepsCarouselMock();
    var value = view.getValue();
    //logger.debug("value = " + value);
    Toybox.Test.assertEqualMessage(value,0.0,"Initial Steps Total is expected to be 0.0");
    return true;
}

(:test)
function intialLabelIsSetToStepsTotal(logger) {
    var view = new StepsCarouselMock();
    var label = view.getLabel();
    //logger.debug("label = " + label + "(" + Toybox.WatchUi.loadResource(label) + ")");
    Toybox.Test.assertEqualMessage(label,Rez.Strings.TotalSteps,"Initial Label is expected to be the Total Steps Resource");
    return true;
}

(:test)
function whenTimerRunsRecordedStepsIncrease(logger) {
    var view = new StepsCarouselMock();
    var activityMonitorInfo = new ActivityMonitorInfoMock();
    view.setActivityMonitorInfo(activityMonitorInfo);
    Toybox.Test.assertEqualMessage(activityMonitorInfo.steps,0,"Steps are initially 0");

    // set 15
    activityMonitorInfo.steps = 15;
    view.setActivityMonitorInfo(activityMonitorInfo);
    view.onTimerStart();
    view.compute(null);
    Toybox.Test.assertEqualMessage(activityMonitorInfo.steps,15,"Steps are 15");
    Toybox.Test.assertEqualMessage(view.getStepsRecorded(),0,"Recorded Steps are 0");

    // set 55
    activityMonitorInfo.steps = 55;
    view.setActivityMonitorInfo(activityMonitorInfo);
    view.compute(null);
    Toybox.Test.assertEqualMessage(activityMonitorInfo.steps,55,"Steps are 55");
    Toybox.Test.assertEqualMessage(view.getStepsRecorded(),40,"Recorded Steps are 40");

    // set 100
    view.onTimerStop();
    activityMonitorInfo.steps = 100;
    view.setActivityMonitorInfo(activityMonitorInfo);
    view.compute(null);
    Toybox.Test.assertEqualMessage(activityMonitorInfo.steps,100,"Steps are 100");
    Toybox.Test.assertEqualMessage(view.getStepsRecorded(),40,"Recorded Steps are 40");

    // set 150
    view.onTimerStart();
    activityMonitorInfo.steps = 150;
    view.setActivityMonitorInfo(activityMonitorInfo);
    view.compute(null);
    Toybox.Test.assertEqualMessage(activityMonitorInfo.steps,150,"Steps are 150");
    Toybox.Test.assertEqualMessage(view.getStepsRecorded(),90,"Recorded Steps are 90");

    return true;
}

(:test)
function labelDoesNotChangeWhenNoTimer(logger) {
    var label;
    var view = new StepsCarouselMock();
    for( var i = 1; i < 20; i += 1 ) {
        var label = view.getLabel();
        view.compute(null);
        //logger.debug("label = " + label + "(" + Toybox.WatchUi.loadResource(label) + ")");
        Toybox.Test.assertEqualMessage(view.getLabel(),label,"Label does not change when timer stopped");
    }
    return true;
}

(:test)
function whenTimerStoppedTotalStepsIsShown(logger) {
    var label;
    var view = new StepsCarouselMock();
    view.onTimerStart();
    for( var i = 1; i < 10; i += 1 ) {
        view.compute(null);
    }
    Toybox.Test.assertNotEqualMessage(view.getLabel(),Rez.Strings.TotalSteps,"Label is not equal to Total Steps");
    view.onTimerStop();
    view.compute(null);
    Toybox.Test.assertEqualMessage(view.getLabel(),Rez.Strings.TotalSteps,"Label is equal to Total Steps");
    return true;
}

(:test)
function whenOneActiveFieldLabelDoesNotChange(logger) {
    var label;
    var view = new StepsCarouselMock();
    var app = new ApplicationPropertiesMock();
    app.setProperty("showTotal", false);
    app.setProperty("showSteps", true);
    app.setProperty("showStepsToGo", false);
    app.setProperty("showGoalPercentage", false);
    view.setApplicationProperties(app);
    view.initialize();
    view.compute(null);
    label = view.getLabel();
    //logger.debug("label = " + label + "(" + Toybox.WatchUi.loadResource(label) + ")");
    Toybox.Test.assertEqualMessage(view.getLabel(),Rez.Strings.ActiveSteps,"Label is equal to Active Steps");
    view.onTimerStart();
    for( var i = 1; i < 10; i += 1 ) {
        view.compute(null);
    }
    label = view.getLabel();
    //logger.debug("label = " + label + "(" + Toybox.WatchUi.loadResource(label) + ")");
    Toybox.Test.assertEqualMessage(view.getLabel(),Rez.Strings.ActiveSteps,"Label is equal to Active Steps");
    return true;
}

(:test)
function everyXTicksTheLabelChanges(logger) {
    var xSeconds = 3;
    var view = new StepsCarouselMock();
    var app = new ApplicationPropertiesMock();
    app.setProperty("carouselSeconds", xSeconds);
    view.setApplicationProperties(app);
    view.initialize();


    var label;
    view.onTimerStart();
    view.compute(null);
    label = view.getLabel();
    //logger.debug("label = " + label + "(" + Toybox.WatchUi.loadResource(label) + ")");
    for( var i = 1; i < xSeconds * 4; i += 1 ) {
        for (var j = 1; j <= xSeconds - 1; j+=1) {
            view.compute(null);
            label = view.getLabel();
            //logger.debug("label = " + label + "(" + Toybox.WatchUi.loadResource(label) + ")");
        }
        view.compute(null);
        //logger.debug("label changed = " + view.getLabel() + "(" + Toybox.WatchUi.loadResource(view.getLabel()) + ")");
        Toybox.Test.assertNotEqualMessage(view.getLabel(),label,"Label changes every xth tick");
    }
    return true;
}

