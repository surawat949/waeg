({
    doInit : function(component, event, helper)
    {
        var accountId = event.getParam("accountId");
        var opportunityId = event.getParam("opportunityId");
        if(accountId!=null && opportunityId!=null){
            component.set('v.accountId', accountId);
            component.set('v.opportunityId', opportunityId);
        }
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
    },
    handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('orderEditForm').submit(fields);
    },handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Command created with success"
        });
        toastEvent.fire();
        helper.createTask(component, myRecordId, function(err, result){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "success",
                "title": "Success!",
                "message": "Task created with success"
            });
        });
    }
})