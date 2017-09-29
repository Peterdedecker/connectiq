class StepsCarouselMock extends StepsCarouselView {
    hidden var activityMonitorInfo = new ActivityMonitorInfoMock();
    hidden var applicationProperties = new ApplicationPropertiesMock();

    function initialize() {
        StepsCarouselView.initialize();
    }
 
    function getLabel() {
        return labelResource;
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
    
    function getApplicationProperties() {
        return applicationProperties;
    }

    function setApplicationProperties(value) {
        applicationProperties = value;
    }
}

class ActivityMonitorInfoMock {
    var steps = 0;
    var stepGoal = 5000;
}

class ApplicationPropertiesMock {
    var properties = {};

    function getProperty(key) {
        if (properties.hasKey(key)) {
            return properties.get(key);
        }
        return null;
    }

    function setProperty(key, value) {
        properties.put(key, value);
    }
}