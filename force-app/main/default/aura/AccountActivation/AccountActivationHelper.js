({
    initSeikoData : function(component, accountId, callback) {
        var action= component.get('c.getSeikoData');
        
        action.setParams({"recordId": accountId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    initNmuTool : function(component, accountId, tool, callback) {
        var action= component.get('c.getLastMediaUsage');
        action.setParams({"accountId": accountId, "tool":tool});
        //action.setParam({"tool": tool});
        //alert ('calling getLastMediaUsage(' + accountId + ', ' + tool+')' );
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {callback(null, response.getReturnValue());}
            else if (component.isValid() && state === "ERROR") { callback(response.getError(), response.getReturnValue());}
        });
        $A.enqueueAction(action);
    },
    initLastTrainingDate : function(component, accountId, training, callback) {
        var action= component.get('c.getLastTrainingDate');
        action.setParams({"accountId": accountId, "training":training});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {callback(null, response.getReturnValue());}
            else if (component.isValid() && state === "ERROR") { callback(response.getError(), response.getReturnValue());}
        });
        $A.enqueueAction(action);
    },
    initSocialMedia : function(component, accountId, callback) {
        var action= component.get('c.isSocialMediaActive');
        action.setParams({"accountId": accountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {callback(null, response.getReturnValue());}
            else if (component.isValid() && state === "ERROR") { callback(response.getError(), response.getReturnValue());}
        });
        $A.enqueueAction(action);
    },
    initSeikoPro : function(component, accountId, callback) {
        var action= component.get('c.isSeikoProActive');
        action.setParams({"accountId": accountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {callback(null, response.getReturnValue());}
            else if (component.isValid() && state === "ERROR") { callback(response.getError(), response.getReturnValue());}
        });
        $A.enqueueAction(action);
    },
	
    initSeikoXtraNet : function(component, recordId, callback){
        var action = component.get('c.isSeikoXtraNetNMU');
        action.setParams({"accountId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error has occured during the connection.');
            }
        });
        $A.enqueueAction(action);
    },
    
    iniSeikoXperienceIpad : function(component, recordId, callback){
        var action = component.get('c.SeikoXIpad');
        action.setParams({"accountId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error has occured during the connection.');
            }
        });
        $A.enqueueAction(action);
    }
})