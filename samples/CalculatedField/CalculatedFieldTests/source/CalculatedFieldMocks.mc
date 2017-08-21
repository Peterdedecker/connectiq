using Toybox.WatchUi as Ui;

class CalculatedFieldMock extends CalculatedFieldView {
    var applicationProperties = new ApplicationPropertiesMock();
    var deviceSettings = new DeviceSettingsMock();

    // Set the label of the data field here.
    function initialize() {
        CalculatedFieldView.initialize();
        format = "%.2f";
    }
    
    function setFormula(f) {
    	formulaOrig = f;
    }
    
    function setFormat(f) {
    	format = f;
    }

    function getApplicationProperties() {
        return applicationProperties;
    }

    function setApplicationProperties(value) {
        applicationProperties = value;
    }
    
    function getSystemSettings() {
        return deviceSettings;
    }

    function setSystemSettings(value) {
        deviceSettings = value;
    }
}

class ActivityInfoMock {
    var averageCadence = 0;
	var averageHeartRate = 0;
	var averagePower = 0;
    var averageSpeed = 0;
    var currentLocationAccuracy = 4;
	var elapsedTime = 0;
	var energyExpenditure = 0;
    var timerTime = 0; // time in milliseconds
    var totalAscent = 0;
    var totalDescent = 0;
    var trainingEffect = 0;
    var maxCadence = 0;
    var maxHeartRate = 0;
    var maxPower = 0;
    var maxSpeed = 0;
    var currentHeartRate = 0;
    var altitude = 0;
    var elapsedDistance = 0;
    var currentSpeed = 0;
    var currentCadence = 0;
    var currentPower = 0;
    var calories = 0;
    var currentHeading = 0;
}

class DeviceSettingsMock {
    var paceUnits = System.UNIT_METRIC;
    var distanceUnits = System.UNIT_METRIC;
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
