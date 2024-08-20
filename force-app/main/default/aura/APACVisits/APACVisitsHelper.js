({
    initAccount : function(component, accountId, callback) {
        var action = component.get('c.getAccount');
        action.setParams({"accountId":accountId});

        action.setCallback(this, function(response){
            var state = response.getState();

            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                //console.log('Error during the connection.');
            }

        });
        $A.enqueueAction(action);
    }
})