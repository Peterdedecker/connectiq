class CiqView extends CommonLogicView {
	hidden var message; // I could add this variable to the CommonLogicView class, this is to show that you can define class instance variables at any level in the inheritance tree...

    function initialize() {
        CommonLogicView.initialize();
        
        message = "I'm a CIQ1 device!";
        

    }

}