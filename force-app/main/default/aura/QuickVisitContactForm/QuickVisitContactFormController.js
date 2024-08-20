({
    doInit : function(component, event, helper) {
        var contactId = component.get('v.recordId');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userId', userId);
        component.set('v.contactId', contactId);
        helper.getContact(component, contactId, function(err, result){
            component.set('v.showLookup',true);
            component.set('v.accountId', result.AccountId);
        });
         helper.getStarndardVisit(component, function(err, result){
            component.set('v.standardRecType', result);
        });
    },
    handleSuccess: function(component, event, helper) {
        // Show toast
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Visit created with success."
        });
        toastEvent.fire();
        
        //reload calendar
        helper.updateCalenderEvents(component, event, helper);
    },
    jsLoaded : function(component, event, helper)
    {
        var date = new Date();
        //console.log(date);
    },
    onViewChange: function(component, event, helper) {
        helper.updateCalenderEvents(component, event, helper);
    },
    getValueFromLwc : function(component, event, helper){
        //console.log('getValueFromLwc selectedRecord'+JSON.stringify(event.getParam('selectedRecord')));
        component.set('v.accountId', null);
        if( event.getParam('selectedRecord')){
            var AccountIdValue = event.getParam('selectedRecord').AccountId;
            //console.log('AccountIdValue'+AccountIdValue);
            component.set('v.accountId', AccountIdValue);
        }
    }
})