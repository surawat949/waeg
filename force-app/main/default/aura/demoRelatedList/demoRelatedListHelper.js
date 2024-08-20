({
    fetchData : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'firstName', fieldName: 'firstName', type: 'text'},
                {label: 'lastname', fieldName: 'lastname', type: 'text'},
                {label: 'accountId', fieldName: 'accountId', type: 'text'}
        ]);
        var action = component.get("c.fetchAccounts");
        var record = component.get('v.recordId');
        action.setParams({"recordId": record});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    }
})