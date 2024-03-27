({
    doInit: function (component, event, helper) {
        helper.doInit(component, event, helper);
    },
    handleSubmit: function (component, event, helper) {
        component.set("v.isLoading",true);
        let taskRecordData = component.get("v.initConfigData");
        let descriptionAppend = taskRecordData.hasOwnProperty("taskExistingDescription") ? taskRecordData.taskExistingDescription : '';
        let descriptionToSave = component.get("v.description") +"\r\n"+ descriptionAppend;
        if(component.get("v.description")){
            let taskRecord = { 
                'sobjectType': 'Task',
                'Id': component.get("v.recordId"),
                'Description': descriptionToSave
            };
            var action = component.get("c.updateTaskDescription");
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
        }else{
            helper.showToast(component, event, helper,"Warning!","Please add comments","warning");
            component.set("v.isLoading",false);
        }
    },
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    }
})