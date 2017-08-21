using Toybox.System;
using Toybox.Math;
using Toybox.Lang;

function assertEqualMessage(actual, expected, text) {
	if (Math has :round) {
		Toybox.Test.assertEqualMessage(actual,expected,text);
		return true;
	} else {
		if (actual == expected) {
			System.println("actual == expected - " + text);
			return true;
		} else {
			System.println("actual <> expected - " + text);
			return false;
		}
	}		
}

function assertFloatMessage(actual, expected, message) {
    var floatdeviation = 0.001;
    Toybox.Test.assertMessage(actual >= expected - floatdeviation && actual <= expected + floatdeviation, message);
}

(:test)
function powerTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("2^3");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 8, "powerTest - Actual value matches expected value.");
    return true;
}

(:test)
function operatorOrderTest3(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("145+5*2");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 155, "operatorOrderTest3");
    return true;
}

(:test)
function operatorOrderTest2(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("3*(1+1)");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 6, "operatorOrderTest2");
    return true;
}

(:test)
function operatorOrderTest1(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12+3*4+5");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 29, "operatorOrderTest1");
    return true;
}


(:test)
function divideTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12/3");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 4, "divideTest - Actual value matches expected value.");
    return true;
}

(:test)
function multiplyTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12*3");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 36, "multiplyTest - Actual value matches expected value.");
    return true;
}

(:test)
function minusTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12-3");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 9, "minusTest - Actual value matches expected value.");
    return true;
}

(:test)
function plusplusplusTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12+(3+5.2)+10");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 30.2, "plusplusTest - Actual value matches expected value.");
    return true;
}


(:test)
function plusplusTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12+3+5.2");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 20.2, "plusplusTest - Actual value matches expected value.");
    return true;
}

(:test)
function plusTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12+3");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 15, "plusTest - Actual value matches expected value.");
    return true;
}

(:test)
function nullTest(logger) {
   var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	var value = view.compute(info);
	logger.debug(value);
	Toybox.Test.assert(value.equals("no formula set"));
    return true;
}

(:test)
function integerTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 12, "integerTest - Actual value matches expected value.");
    return true;
}

(:test)
function floatTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12.34");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 12.34, "floatTest - Actual value matches expected value.");
    return true;
}

(:test)
function strangeFloatTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("12.");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 12, "strangFloatTest - Actual value matches expected value.");
    return true;
}

(:test)
function unaryPlusTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("+12.34");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 12.34, "floatTest - Actual value matches expected value.");
    return true;
}

(:test)
function unaryMinusTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("-12.34");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), -12.34, "floatTest - Actual value matches expected value.");
    return true;
}

(:test)
function simpleBracketTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("(12.34)");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 12.34, "floatTest - Actual value matches expected value.");
    return true;
}

(:test)
function doubleBracketTest(logger) {
    var view = new CalculatedFieldMock();
	var info = new ActivityInfoMock();
	view.setFormula("((12.34))");
	var value = view.compute(info);
	logger.debug(value);
	assertFloatMessage(value.toFloat(), 12.34, "floatTest - Actual value matches expected value.");
    return true;
}




