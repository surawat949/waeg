({
    doInit: function (component, event, helper) {
        component.set("v.isLoading",true);
        var action = component.get("c.getUserData");
        action.setParams({ 
            "recTypeName": "ServiceFlow Case Create",
            "recordId" : component.get("v.recordId")
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log(JSON.stringify(data));
                component.set("v.taskRecordData", data["taskRecordData"]);
                component.set("v.initConfigData", data);
                
                let description = (data.hasOwnProperty("taskExistingDescription") && data.taskExistingDescription)  ? data.taskExistingDescription.split('--') : [];
                component.set("v.descriptionTokens",description);
                component.set("v.isLoading", false);
            } else {
                component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action);                
    },
    showToast : function(component, event, helper,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }
})