using Toybox.Application as App;

class CiqView extends CommonLogicView {
	hidden var message;  

    function initialize() {
        CommonLogicView.initialize();
    }

	function onUpdate(dc) {
		// call the parent onUpdate to do the base logic
		CommonLogicView.onUpdate(dc);
		
		// pick up the message from the application class
		message = App.getApp().backgroundMessage;
	}
}

