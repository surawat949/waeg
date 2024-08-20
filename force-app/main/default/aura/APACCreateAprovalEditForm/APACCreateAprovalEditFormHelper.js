({
    getVisitRequestForm : function(component, recordId, callback) {
        var action = component.get('c.getVisitRequesType');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    getApprovalForm : function(component, recordId, callback){
        var action = component.get('c.getApprovedString');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state ==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})