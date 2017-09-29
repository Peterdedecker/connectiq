class StepsCarouselMock extends StepsCarouselView {
    hidden var activityMonitorInfo = new ActivityMonitorInfoMock();

    function initialize() {
        StepsCarouselView.initialize();
    }

    function getValue() {
        return value;
    }

    function getStepsRecorded() {
        return stepsRecorded;
    }

    function getActivityMonitorInfo() {
        return activityMonitorInfo;
    }

    function setActivityMonitorInfo (info) {
        activityMonitorInfo = info;
    }

}

class ActivityMonitorInfoMock {
    var steps = 0;
    var stepGoal = 5000;
}