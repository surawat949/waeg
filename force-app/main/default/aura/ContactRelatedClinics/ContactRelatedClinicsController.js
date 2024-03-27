({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set('v.mycolumns', [
            {label: 'Account', fieldName: 'AccountId', typeAttributes: {
                label: { fieldName: 'AccountName' }
              }, type: 'url',target: 'blank'},
            {label: 'Street', fieldName: 'Street', type: 'text'},
            {label: 'Postal Code', fieldName: 'PostalCode', type: 'text'},
            {label: 'City', fieldName: 'City', type: 'text'},
            ]);

        if(recordId!=null){
            helper.getAccountList(component, recordId, function(err,result){
                
            });
        }
    }
})