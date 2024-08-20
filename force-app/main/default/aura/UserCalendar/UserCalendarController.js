({
    doInit : function(component, event, helper)
    {
        var accountId = event.getParam("accountId");
        var opportunityId = component.get('v.recordId');
        if(opportunityId!=null){
            helper.getAccount(component, opportunityId, function(err, result){
                component.set('v.accountId', result.Id);
                component.set('v.userId', result.ownerId); 
            });
            component.set('v.opportunityId', opportunityId);
        }
        
    },
    jsLoaded : function(component, event, helper)
    {
        var date = new Date();
        //console.log(date);
    },
    onViewChange: function(component, event, helper) {
        var start = event.getParam("start");
        var end = event.getParam("end");
        var userId = component.find("userId").get("v.value");
        component.set('v.userId', userId);
        //console.log('onViewChange', start, end);
        helper.updateCalenderEvents(component, event, helper);
    },
    handleUserChange : function(component, event, helper) {        
        //var lookupId = event.getParam("value")[0];
        //component.set('v.userVisitId', lookupId);
        var childCmp = component.find("uCalendar");
        childCmp.reload();
        
        var start = event.getParam("start");
        var end = event.getParam("end");
        //console.log('onViewChange', start, end);
        helper.updateCalenderEvents(component, event, helper);
    },
    handleSuccess: function(component, event, helper) {
        // Show toast
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Visit created with success. Select user again to see the visit in the agenda."
        });
        toastEvent.fire();
        //reload calendar
        
        var start = event.getParam("start");
        var end = event.getParam("end");
        //console.log('onViewChange', start, end);
        helper.updateCalenderEvents(component, event, helper);
    }
})