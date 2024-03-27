({
    getUserCommentList : function(component, recordId, callback){
        var action = component.get('c.getUserCommentId');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Error during the connection.');
            }
        });
        $A.enqueueAction(action);
    }
})