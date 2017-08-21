/*
credits: algorithm: Shunting-yard algorithm, based on bartl's expression parser http://users.telenet.be/bartl/expressionParser/expressionParser.html
         Peter De Decker: conversion to MonkeyC, optimizations, test cases.
*/

using Toybox.WatchUi as Ui;
using Toybox.System as System;
using Toybox.Math as Math;

class StackElement {
	var value;
	var operator = "";
	var precedence = 0;
	var assoc = "L";
	
	function initialize(o, p, a, v) {
		value = v;
		operator = o;
	  	precedence = p;
	  	assoc = a;
	}
}

class CalculatedFieldView extends Ui.SimpleDataField {
    hidden var unitD = 1000.0;
    hidden var unitP = 1000.0;

	var formulaOrig;
	var formula;
	var format;
	var formulaOffset;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();

        // system settings
        var deviceSettings = getSystemSettings();
        if (deviceSettings.paceUnits == System.UNIT_STATUTE) {
            unitP = 1609.344;
        }
        if (deviceSettings.distanceUnits == System.UNIT_STATUTE) {
            unitD = 1609.344;
        }

        // application settings
        var app = getApplicationProperties();
        label = app.getProperty("label") == null? "Formula" : app.getProperty("label");
        formulaOrig = app.getProperty("formula");
        format = app.getProperty("format") == null? "%d" : app.getProperty("format");
        if (formulaOrig != null) {
        	formulaOrig = replaceAll(formulaOrig," ","").toLower();
        }
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
    	if ((formulaOrig == null) || (formulaOrig.equals(""))) {
    		return "no formula set";
    	} 
		formula = formulaOrig;
    	formulaOffset = 0;
    	formula = replaceAll(formula,"averagecadence",(info.averageCadence == null? "0" : info.averageCadence.toString()));
    	formula = replaceAll(formula,"averageheartrate",(info.averageHeartRate == null? "0" : info.averageHeartRate.toString()));
    	formula = replaceAll(formula,"averagepower",(info.averagePower == null? "0" : info.averagePower.toString()));
    	formula = replaceAll(formula,"averagespeed",(info.averageSpeed == null? "0" : (info.averageSpeed * 3600 / unitP).toString()));
    	formula = replaceAll(formula,"locationaccuracy",(info.currentLocationAccuracy == null? "0" : info.currentLocationAccuracy.toString()));
    	formula = replaceAll(formula,"elapsedtime",(info.elapsedTime == null? "0" : (info.elapsedTime / 1000).toString()));
    	formula = replaceAll(formula,"energyexpenditure",(info.energyExpenditure == null? "0" : info.energyExpenditure.toString()));
    	formula = replaceAll(formula,"timertime",(info.timerTime == null? "0" : (info.timerTime / 1000).toString()));
    	formula = replaceAll(formula,"totalascent",(info.totalAscent == null? "0" : info.totalAscent.toString()));
    	formula = replaceAll(formula,"totaldescent",(info.totalDescent == null? "0" : info.totalDescent.toString()));
    	formula = replaceAll(formula,"trainingeffect",(info.trainingEffect == null? "0" : info.trainingEffect.toString()));
    	formula = replaceAll(formula,"maxcadence",(info.maxCadence == null? "0" : info.maxCadence.toString()));
    	formula = replaceAll(formula,"maxheartrate",(info.maxHeartRate == null? "0" : info.maxHeartRate.toString()));
    	formula = replaceAll(formula,"maxpower",(info.maxPower == null? "0" : info.maxPower.toString()));
    	formula = replaceAll(formula,"maxspeed",(info.maxSpeed == null? "0" : (info.maxSpeed * 3600 / unitP).toString()));
    	formula = replaceAll(formula,"heartrate",(info.currentHeartRate == null? "0" : info.currentHeartRate.toString()));
    	formula = replaceAll(formula,"altitude",(info.altitude == null? "0" : info.altitude.toString()));
    	formula = replaceAll(formula,"distance",(info.elapsedDistance == null? "0" : (info.elapsedDistance / unitD).toString()));
    	formula = replaceAll(formula,"cadence",(info.currentCadence == null? "0" : info.currentCadence.toString()));
    	formula = replaceAll(formula,"speed",(info.currentSpeed == null? "0" : (info.currentSpeed * 3600 / unitP).toString()));
    	formula = replaceAll(formula,"power",(info.currentPower == null? "0" : info.currentPower.toString()));
    	formula = replaceAll(formula,"calories",(info.calories == null? "0" : info.calories.toString()));
    	formula = replaceAll(formula,"heading",(info.currentHeading == null? "0" : info.currentHeading.toString()));
        // See Activity.Info in the documentation for available information.
        return parse();
    }
    
    
    function parse() {
    	var value = parseExpr();
    	if (!eos()) {
    		return "offset " + formulaOffset.toString() + ": Unexpected characters";
    	}
    	return value.format(format);
    }
    
	function getOperator(value) {
		var op;
		if (!eos()) {
			op = parseOp(value);
		} else {
			op = null;
		}	
		return op;
	}
	
	function stackCanBePopped(stack, key, op) {
		if (key > 0) {
			if (op == null) {
	         	return true;
			}
			if ((op.precedence < stack.get(key-1).precedence) ||
		        (op.precedence == stack.get(key-1).precedence) &&
		         op.assoc.equals("L")) {
		         	return true;
			} else {
				return false;
			}		         	
		} else {
			return false;
		}	
	}
	
	function applyOperator (op, value) {
		if (op.operator.equals("+")) {
			value = op.value.toFloat() + value.toFloat();
		} else if (op.operator.equals("-")) {
			value = op.value.toFloat() - value.toFloat();
		} else if (op.operator.equals("*")) {
			value = op.value.toFloat() * value.toFloat();
		} else if (op.operator.equals("/")) {
			value = op.value.toFloat() / value.toFloat();
		} else if (op.operator.equals("^")) {
			value = Math.pow(op.value.toFloat(), value.toFloat());
		}				
		return value;	
	}	

	function parseExpr() {
		var stack = {};
		var key = 0;
		var op;
		
		// first value on the left
		var value = parseVal(); 
		while (true) {
			op = getOperator(value);
			var top = op;

			while (stackCanBePopped(stack, key, op)) {
				// pop the stack
				key--;
				op = stack.get(key);
				stack.remove(key);				
			       
				// reduce - apply the operator
				value = applyOperator (op, value);				       
			}
			
			if (top == null) {
				op = top;
				while (stackCanBePopped(stack, key, op)) {
					// pop the stack
					key--;
					op = stack.get(key);
					stack.remove(key);				
				       
					// reduce - apply the operator
					value = applyOperator (op, value);				       
				}

				return value;
			}

			top.value = value;
	    	stack.put(key, top);
	    	key++;			
					
			// value on the right
			value = parseVal(); 	
		}
	}
    
    function parseOp(v) {
    	if (nextChar().equals("+")) {
    		formulaOffset++;
			return new StackElement("+",10,"L",v);    	
    	} else if (nextChar().equals("-")) {
    		formulaOffset++;
			return new StackElement("-",10,"L",v);
		} else if (nextChar().equals("*")) {
			formulaOffset++;
			return new StackElement("*",20,"L",v);
		} else if (nextChar().equals("/")) {
			formulaOffset++;
			return new StackElement("/",20,"L",v);
		} else if (nextChar().equals("^")) {
			formulaOffset++;
			return new StackElement("^",20,"R",v);
		}
    	return null; //"Expected operator at offset " + formulaOffset.toString();
    }
    
    // first value on the left.
    function parseVal() {
		var startOffset = formulaOffset;
   
		// floating point number
		while (isNumeric(nextChar()) && !eos()) {
			formulaOffset++;
		}    	
		if (nextChar().equals(".")) {
			formulaOffset++;
			while (isNumeric(nextChar()) && !eos()) {
				formulaOffset++;
			}   
		}
		if (formulaOffset > startOffset) {   // floating point value...
			return formula.substring(startOffset, formulaOffset).toFloat();
		} else if (nextChar().equals("+")) { // unary +
			formulaOffset++;
			return parseVal();
		} else if (nextChar().equals("-")) { // unary -
			formulaOffset++;
			return -1 * parseVal();
		} else if (nextChar().equals("(")) { // expression inside parentheses
			formulaOffset++; // eat "("
			var value = parseExpr();
			if (nextChar().equals(")")) {
				formulaOffset++; // eat ")"
				return value;
			} else {
	    		return "Expected ')' at offset " + formulaOffset.toString();
			}
		} else {
	        if(eos()) {
	        	return "At end of string, expected a value. Offset: " + formulaOffset.toString();
	        } else  {
	            return "Unrecognized value at offset: " + formulaOffset.toString();
	        }		
		}
		
		return 0;
    } 
    
    function nextChar() {
    	return formula.substring(formulaOffset, formulaOffset + 1);
    }
    
    function eos() {
    	return formulaOffset == formula.length();
    }
    
    function isNumeric(value) {
        var index = 0;
        var len = value.length();
        while (index < value.length()) {
            var x = value.substring(index, index+1);
            if (x.find("0") == null && x.find("1") == null && x.find("2") == null && x.find("3") == null && x.find("4") == null && x.find("5") == null && x.find("6") == null && x.find("7") == null && x.find("8") == null && x.find("9") == null ) {
                return false;
            }
            index++;
        }
        return true;
    }

	function replaceAll(text, search, replace) {
		var index = text.find(search);
		while (index != null) {
			text = text.substring(0, index) + replace + text.substring(index + search.length(), text.length());
			index = text.find(search);
		} 
		return text;
	}

	// functions to mock
    function getApplicationProperties() {
        return Application.getApp();
    }
    
    function getSystemSettings() {
        return System.getDeviceSettings();
    }
}

