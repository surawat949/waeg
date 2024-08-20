({
    doInit: function (component, event, helper) {
        helper.doInit(component, event, helper);
    },
    handleSubmit: function (component, event, helper) {
        component.set("v.isLoading",true);
        var Subject = component.find("Subject").get("v.value");
        var SubSubject = component.find("SubSubject").get("v.value");
        let taskRecordData = component.get("v.taskRecordData");
        let taskRecord = { 
            'sobjectType': 'Task',
            'Id': component.get("v.recordId"),
            'CallType': taskRecordData.CallType == 'Inbound' ? 'Outbound' : 'Inbound',
            'Subject':Subject ? Subject : taskRecordData.SFlow_Subject__c,
            'SFlow_Subject__c':Subject ? Subject : taskRecordData.SFlow_Subject__c,
            'SFlow_Sub_Subject__c':SubSubject ? SubSubject : taskRecordData.SFlow_Sub_Subject__c
        };
        var action = component.get("c.updateTask");
        action.setParams({
            taskRec : taskRecord
        })
        action.setCallback(this, function (response) {            
            var state = response.getState();            
            if (state === "SUCCESS") {
                var returnMessage = response.getReturnValue();
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();     
                if(returnMessage === "Success"){
                    helper.showToast(component, event, helper,"Success!","Task updated successfully","success");
                }else{
                    helper.showToast(component, event, helper,"Error!",returnMessage,"error");
                }       
                component.set("v.isLoading",false);
            } else {
                $A.get('e.force:refreshView').fire();                
                $A.get("e.force:closeQuickAction").fire(); 
                helper.showToast(component, event, helper,"Error!",returnMessage,"error");
                component.set("v.isLoading",false);
            }
        });
        $A.enqueueAction(action);  
    },
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    }
})