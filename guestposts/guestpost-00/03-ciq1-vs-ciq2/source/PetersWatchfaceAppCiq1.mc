using Toybox.Application as App;

// CIQ1 Version
class PetersWatchfaceApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new DeviceView() ];  
    }

}