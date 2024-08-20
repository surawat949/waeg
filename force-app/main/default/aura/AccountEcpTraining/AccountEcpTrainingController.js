({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set('v.mycolumns', [
            {label: 'Salutation', fieldName: 'Salutation', type: 'text'},
            {label: 'Contact', fieldName: 'contactUrl', typeAttributes: {
                label: { fieldName: 'Name' }
              }, type: 'url',target: 'blank'},
            {label: 'Email', fieldName: 'Email', type: 'text'},
            {label: 'Type', fieldName: 'type', type: 'text'},
            {label: 'Delete', type: 'button', initialWidth: 135, typeAttributes: { label: 'Delete', name: 'Delete', title: 'Delete record'}}
            ]);
        component.set('v.mycolumns2', [
            {label: 'Salutation', fieldName: 'Salutation', type: 'text'},
            {label: 'Contact', fieldName: 'contactUrl', typeAttributes: {
                label: { fieldName: 'Name' }
                }, type: 'url',target: 'blank'},
            {label: 'Email', fieldName: 'Email', type: 'text'},
            {label: 'Type', fieldName: 'type', type: 'text'},
            {label: 'Add', type: 'button', initialWidth: 135, typeAttributes: { label: 'Add', name: 'Add', title: 'Add'}}
            ]);

        if(recordId!=null){
            helper.getAttendeeList(component, recordId, function(err,result){
                
            });
            helper.getContactList(component, recordId, function(err,result){
                
            });
        }
    },
    handleDeleteRowAction: function (component, event, helper) {
        var row = event.getParam('row');
        var recordId = component.get('v.recordId');
        
        helper.deleteRow(component, row, recordId, function(err,result){
            if(err){
            } else {
            }
        });
        helper.getAttendeeList(component, recordId, function(err,result){
            
        });
        helper.getContactList(component, recordId, function(err,result){
            
        });
    },
    handleAddRowAction: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        var row = event.getParam('row');
        
        helper.addRow(component, row, recordId, function(err,result){
            if(err){
            } else {
            }
        });
        helper.getAttendeeList(component, recordId, function(err,result){
            
        });
        helper.getContactList(component, recordId, function(err,result){
            
        });
    }
})