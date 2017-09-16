using Toybox.Application as App;
using Toybox.Background;
using Toybox.WatchUi as Ui;
using Toybox.System as System;
using Toybox.Communications as Comm;
using Toybox.Math;

// I'm including 2 classes within 1 file here because then I only have to do 1 file exclude
// If you wish you can store a file per class, be sure to do a file exclude of each file then. 

// CIQ2 Version
(:background)
class PetersWatchfaceApp extends App.AppBase {
	var backgroundMessage = "What should I do?";

    function initialize() {
        AppBase.initialize();
    }

    // Return the initial view of your application here
    function getInitialView() {
    	// register for temporal events, we don't need to check whether this is supported, we know we have a Connect IQ 2 device here!
		Background.registerForTemporalEvent(new Time.Duration(5 * 60));		    	
        return [ new DeviceView() ];  
    }
    
    function onBackgroundData(data) {
    	// store the data from the background event in a class level variable
    	backgroundMessage = data;
    	
    	// we received a new todo item, invoke a request to update the screen
    	Ui.requestUpdate();
    }

    function getServiceDelegate(){
        return [new BackgroundServiceDelegate()];
    }
}

// The Service Delegate is the main entry point for background processes 
(:background)
class BackgroundServiceDelegate extends System.ServiceDelegate {
	function initialize() {
		System.ServiceDelegate.initialize();
	}
	
	// this is called every time the periodic event is triggered by the system.
    function onTemporalEvent() {
    	var time = System.getClockTime();
        Comm.makeWebRequest(
            "https://jsonplaceholder.typicode.com/todos/" + (Math.rand() % 100 + 1),  // get a random number between 1 and 100...
            {},
            { "Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED },
            method(:onReceive)
        );    
    }
    
    // receive the data from the web request
    function onReceive(responseCode, data) {
        if (responseCode == 200) {
            Background.exit(data["title"]); // get the title part of the todo list...
        } else {
            Background.exit("Error " + responseCode);
        }
    }    
}


