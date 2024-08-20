({
    initVisit : function(component, callback){
        var action= component.get('c.initVisit');
        action.setParams({"accId": component.get('v.ent')});

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
    initAccount : function(component, callback){
        window.setTimeout(
            $A.getCallback(function(){
                var action= component.get('c.getAccount');
                action.setParams({"accId": component.get('v.ent')});

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
        }),0);
    },
    handleSave : function(component, visit, callback){
        //window.setTimeout(
            //$A.getCallback(function(){
                var action= component.get('c.saveVisit');
                action.setParams({"visit": visit});
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
        //}),2000);
    }
})