({
    updateTime : function(component, accountId, jsonStr, callback) {
        var action = component.get('c.updateOpeningTimes');
        action.setParams({"accountId": accountId, "jsonStr":jsonStr});
        
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
    getTime : function(component, accountId, callback){
        var action = component.get('c.getOpeningTimes');
        action.setParams({"accountId": accountId});
        
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
    }
})