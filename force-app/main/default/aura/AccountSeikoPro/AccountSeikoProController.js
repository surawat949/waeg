({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if(recordId!=null){
            helper.initSeikoData(component, recordId, function(err, result){
                component.set('v.seikoData', result);
            });
            
            helper.initLastTrainingDate(component, recordId, 'SVS Purchase registration', function(err, result){
                component.set('v.purchaseRegistrationLastTraining', result);
            });
            helper.initLastTrainingDate(component, recordId, 'SVS Loyalty Program Emails', function(err, result){
                component.set('v.loyaltyProgramLastTraining', result);
            });
        }
    },
    handleSuccess: function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Record saved with success"
        });
        toastEvent.fire();
    },
    doEnroll: function(component, event, helper) {
        helper.activate(component);
    }
})