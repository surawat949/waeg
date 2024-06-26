({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set('v.mycolumns', [
            {label: 'Contact', fieldName: 'ContactId', typeAttributes: {
                label: { fieldName: 'ContactName' }
            }, type: 'url',target: 'blank',wrapText:true},
              {label: 'Contact Owner', fieldName: 'OwnerId', typeAttributes: {
            label: { fieldName: 'OwnerName' }
            }, type: 'url',target: 'blank',wrapText:true},  
            {label: 'Account', fieldName: 'AccountId', typeAttributes: {
                label: { fieldName: 'AccountName' }
              }, type: 'url',target: 'blank',wrapText:true},
            {label: 'Preferred Place for Visit', fieldName: 'PreferredPlace', type: 'text',wrapText:true},
            {label: 'Street', fieldName: 'Street', type: 'text',wrapText:true},
            {label: 'City', fieldName: 'City', type: 'text',wrapText:true},
            {label: 'State', fieldName: 'State', type: 'text',wrapText:true},
            {label: 'Account Phone', fieldName: 'Phone', type: 'text',wrapText:true},
            {label: 'Contact Role', fieldName: 'Role', type: 'text',wrapText:true}
            ]);

        if(recordId!=null){
            helper.getContactList(component, recordId, function(err,result){
                
            });
        }
    }
})