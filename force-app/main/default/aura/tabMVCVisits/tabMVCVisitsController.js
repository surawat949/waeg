({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var action = component.get('c.getUserDetail'); 
        console.log('>>>here');
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            console.log('>>>state',state);
            if(state == 'SUCCESS') {
                console.log('>>>',a.getReturnValue());
                component.set('v.showTab', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    myAction : function(component, event, helper) {

    }
})