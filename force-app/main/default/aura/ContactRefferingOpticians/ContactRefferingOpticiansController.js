({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set('v.mycolumns', [
            {label: 'Brand', fieldName: 'Brand', type: 'text'},
            {label: 'Account', fieldName: 'AccountId', typeAttributes: {
                label: { fieldName: 'AccountName' }
              }, type: 'url',target: 'blank'},
            {label: 'Street', fieldName: 'Street', type: 'text'},
            {label: 'Postal Code', fieldName: 'PostalCode', type: 'text'},
            {label: 'City', fieldName: 'City', type: 'text'},
            {label: 'Seiko Network', fieldName: 'SeikoNetwork', type: 'text'},
            {label: 'Delete', type: 'button', initialWidth: 135, typeAttributes: { label: 'Delete', name: 'Delete', title: 'Delete record'}}
            ]);

        if(recordId!=null){
            helper.getAccountList(component, recordId, function(err,result){
                
            });
        }
    },
    handleSuccess: function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
       // var myRecordId = record.id; // ID of updated or created record
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Record saved with success"
        });
        toastEvent.fire();
        var recordId = component.get('v.recordId');
        helper.getAccountList(component, recordId, function(err,result){
                
        });
    },
    handleRowAction: function (component, event, helper) {
        //var action = event.getParam('action');
        var row = event.getParam('row');
        var recordId = component.get('v.recordId');
        
        helper.deleteRow(component, row, function(err,result){
            if(err){
            } else {
            }
        });
        helper.getAccountList(component, recordId, function(err,result){
        });
    }
})