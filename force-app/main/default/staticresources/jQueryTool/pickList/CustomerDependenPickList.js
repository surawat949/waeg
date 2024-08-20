sforce.connection.sessionId = getSfSessionId();
var describeResults = sforce.connection.describeSObject(getPicklistSobjectName());
function getPicklistValues(field) {
    var returnObj = new returnObject();
    try{
        var validField = false;
        for(var i = 0; i < describeResults.fields.length; i++){
            var fieldList = describeResults.fields[i];
            var fieldName = fieldList.name;
     
            if(fieldName.toLowerCase() == field.toLowerCase()){
                validField = true;
                for(var j = 0; j < fieldList.picklistValues.length; j++){
                    
                    var newValue = new Object();
                    newValue.label = fieldList.picklistValues[j].label;
                    newValue.value = fieldList.picklistValues[j].value;
                    newValue['default'] = fieldList.picklistValues[j].defaultValue;
                    if(fieldList.picklistValues[j].hasOwnProperty('validFor')){
                        newValue.validFor = fieldList.picklistValues[j].validFor;
                    }
                    returnObj.values.push(newValue);
                }
                break;
            }
        }
        if(!validField){
            throw 'Invalid field '+field+' specified for object ' + params.object;
        }
    }
    catch(exception){
        returnObj.message = exception;
        returnObj.success = false;
    }
    return returnObj;
}


function getDependentValues(field, value) {
    var returnObj = new returnObject();
    try{     
        var dependencyCode = new Array();          
        var getValues = getPicklistValues(field);        
        if(!getValues.success){
            throw getValues.message;
        }
        var picklistValues =  getValues.values;
        var getController = getControllerName(field);
                
        if(!getController.success){
            throw getController.message;
        }              
        var controller = getController.values;
        function isDependentValue(index, validFor){
            var base64 = new sforce.Base64Binary("");
            var decoded = base64.decode(validFor);
            var bits = decoded.charCodeAt(index>>3);
            return ((bits & (0x80 >> (index%8))) != 0);
        }
        var controllerFields =getPicklistValues(controller);
        for(var item = 0; item < controllerFields.values.length; item++){
            if(controllerFields.values[item].value.toLowerCase() == value.toLowerCase()){
                for(var i = 0; i < picklistValues.length; i++){
                    if(isDependentValue(item, picklistValues[i].validFor)){
                        var newValue = new Object();
                        newValue.label = picklistValues[i].label;
                        newValue.value = picklistValues[i].value;
                        newValue['default'] = picklistValues[i].defaultValue;
                        newValue.validFor = picklistValues[i].validFor;
                        newValue.validForName =controllerFields.values[item].value;
                        returnObj.values.push(newValue);                                                               
                    }
                }
            }
        }
    }

    catch(exception){
        returnObj.success = false;
        returnObj.message = exception;
    }
    return returnObj;        
}

function getControllerName(field) {
    var returnObj = new returnObject();
    try{
        var isValid = false;
        for(var i = 0; i < describeResults.fields.length; i++){
            var fieldList = describeResults.fields[i];
            var fieldName = fieldList.name;
    
            if(fieldName.toLowerCase() == field.toLowerCase()){
                if(fieldList.controllerName == undefined){
                    throw 'Field has no controller';
                }
                else{
                    returnObj.values = fieldList.controllerName;
                    isValid = true;
                }
                break;
            }
        }
        
        if(!isValid){
            throw 'Invalid field '+field+' specified';
        }
    }
    catch(exception){
        returnObj.success = false;
        returnObj.message = exception;
    }
    return  returnObj;
}

function returnObject(){
    this.success = true;
    this.message = 'Operation Ran Successfully';
    this.values = new Array();
}

function setPickVals(field,optionsArray){
	var options = '<option value="">--None--</option>';
	for(var i = 0; i < optionsArray.length; i++){
		options += '<option value="'+optionsArray[i].value+'">'+optionsArray[i].label+'</option>';
	}         
	$(field).html(options);
}