using Toybox.Application as App;

class PetersWatchfaceApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // Return the initial view of your application here
    function getInitialView() {
    	// depending on the resource exclude this will actually instantiate another class!
        return [ new DeviceView() ];  
    }

}