({
    CSV2JSON: function (component,csv) {
        //  console.log('Incoming csv = ' + csv);
        
        //var array = [];
        var arr = []; 
        
        arr =  csv.split('\n');
        //console.log('Array  = '+array);
        // console.log('arr = '+arr);
        //arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
                //console.log('obj headers = ' + obj[headers[j].trim()]);
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        //console.log('json = '+ json);
        return json;
        
        
    },
    initTemplate: function(component, helper, callback){
        var action = component.get("c.getMasterTemplate");
        action.setCallback(this, function(response){
            callback(null, response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    initLanguage: function(component, helper, callback){
        var action = component.get("c.getLanguageList");
        action.setCallback(this, function(response){
            callback(null, response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    initPortal: function(component, helper, callback){
        var action = component.get("c.getPortalList");
        action.setCallback(this, function(response){
            callback(null, response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    initSystemEmail: function(component, helper, callback){
        var action = component.get("c.getSystemEmailList");
        action.setCallback(this, function(response){
            callback(null, response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    CreateAccount : function (component,jsonstr){
        // console.log('jsonstr' + jsonstr);
        var action = component.get('c.insertData');
        //alert('templateId=' + component.get('v.template')) ;
        action.setParams({
            strfromle : jsonstr,
            masterTemplateId: component.get('v.template'),
            language: component.get('v.language'),
            portal: component.get('v.portal'),
            systemEmail: component.get('v.systemEmail')
        });
        
        component.set("v.toggleSpinner", true); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                var result=response.getReturnValue();
                component.set('v.hasError', true);
                component.set('v.errorList', result);
            }
            else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                    }
                } else {
                    //console.log("Unknown error");
                    //alert('Unknown');
                }
            }
            component.set("v.toggleSpinner", false); 
        }); 
        
        $A.enqueueAction(action);    
        
    },
    
    
    //export helper start from here
    onLoad: function(component, event) {
        //call apex class method
        var action = component.get('c.fetchContact');
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfContact attribute on component.
                component.set('v.ListOfContact', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})