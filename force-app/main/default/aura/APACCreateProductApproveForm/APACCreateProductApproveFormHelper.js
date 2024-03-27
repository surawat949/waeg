({
    /*
    getListView : function(component, callback) {
        var action = component.get('c.getListViews');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error was occured during the connection.');
            }
        });
        $A.enqueueAction(action);
    }*/
})