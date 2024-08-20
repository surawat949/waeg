({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Id', typeAttributes: {
                label: { fieldName: 'Name' }
              }, type: 'url',target: 'blank'},
            /*{label: 'Name', fieldName: 'Name', type: 'text'},*/
            /*{label: 'Title', fieldName: 'Title', type: 'text'},*/
            /*{label: 'Roles', fieldName: 'Role', type: 'text'},*/
            {label: 'Education', fieldName: 'Education', type: 'text'},
            /*{label: 'Type', fieldName: 'Type', type: 'text'},*/
            /*{label: 'isdirect', fieldName: 'isDirect', type: 'Boolean'},*/
            {label: 'Account Name', fieldName: 'accountName', type: 'text'},
            {label: 'Postal Code', fieldName: 'PostalCode', type: 'text'},
            {label: 'City', fieldName: 'City', type: 'text'},
            {label: 'Delete', type: 'button', initialWidth: 135, typeAttributes: { label: 'Delete', name: 'Delete', title: 'Delete record'}}
            ]);

        if(recordId!=null){
            helper.getContactList(component, recordId, function(err,result){
                
            });
        }
    },
    handlSuccess: function(component, event, helper) {
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
        helper.getContactList(component, recordId, function(err,result){
                
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
        helper.getContactList(component, recordId, function(err,result){
        });
    }
})