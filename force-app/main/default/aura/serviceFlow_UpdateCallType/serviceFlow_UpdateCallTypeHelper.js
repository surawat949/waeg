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
                let countryName = data["UserData"].Country_for_Customer_Support__c;
                let fieldMapping = {
                    'subject' : 'SFlow_Subject__c',//countryName ? 'SF_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'SFlow_Subject__c',
                    'subSubject' : 'SFlow_Sub_Subject__c', //countryName ? 'SF_Sub_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'SFlow_Sub_Subject__c',
                    'uiSubject' : 'serviceFlow_UI_Subject__c', //countryName ? 'SF_UI_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'serviceFlow_UI_Subject__c',
                    'uiSubSubject' : 'serviceFlow_UI_Sub_Subject__c' //countryName ? 'SF_UI_Sub_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'serviceFlow_UI_Sub_Subject__c'
                };
                component.set("v.fieldMapping",fieldMapping);
                component.set("v.currentUser", data["UserData"]);
                component.set("v.recTypeId", data["recordTypeId"]);
                component.set("v.taskRTId", data["taskRecTypeId"]);
                component.set("v.taskRecordData", data["taskRecordData"]);
                window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.isLoading", false);
                }), 3000);
            } else {
                window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.isLoading", false);
                }), 3000);
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