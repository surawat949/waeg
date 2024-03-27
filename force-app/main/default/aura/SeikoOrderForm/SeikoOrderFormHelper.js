({
    createTask : function(component, orderId, callback) {
        var action= component.get('c.createTask');
        action.setParams({"orderId": orderId});
        
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