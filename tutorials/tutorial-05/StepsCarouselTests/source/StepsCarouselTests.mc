(:test)
function helloWorld(logger) {
    logger.debug("Hello World");
    return true;
}

/*
(:test)
function initialStepsTotalIsZero(logger) {
    var view = new StepsCarouselMock();
    var value = view.getValue();
    //logger.debug("value = " + value);
    Toybox.Test.assertEqualMessage(value,0.0,"Initial Steps Total is expected to be 0.0");
    return true;
}
*/

