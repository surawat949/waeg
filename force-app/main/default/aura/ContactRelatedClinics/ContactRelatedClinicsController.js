({
    doInit : function(component, event, helper) {
      var recordId = component.get('v.recordId');
        /*component.set('v.mycolumns', [
            {label: 'Account', fieldName: 'AccountId',wrapText: true, typeAttributes: {
                label: { fieldName: 'AccountName' }
              }, type: 'url',target: 'blank'},
            {label: 'Clinic Name', fieldName: 'ClinicName', type: 'text', wrapText: true},
            {label: 'Account Owner', fieldName: 'OwnerId',wrapText: true, typeAttributes: {
                label: { fieldName: 'OwnerName' }
              }, type: 'url',target: 'blank'},
            {label: 'Preferred Place for Visit', fieldName: 'PreferredPlace', type: 'boolean', wrapText: true},
            {label: 'Shipping City', fieldName: 'City', type: 'text', wrapText: true},
            {label: 'Shipping State', fieldName: 'State', type: 'text', wrapText: true},
            {label: 'Shipping Street', fieldName: 'Street', type: 'text', wrapText: true},
            {label: 'Activity Phone', fieldName: 'ActivityPhone', type: 'text', wrapText: true},
            {label: 'Preferred Contact day-time', fieldName: 'PreferredDay', type: 'text', wrapText: true},
            {label: 'Relation Id', fieldName: 'RelationName', wrapText: true, typeAttributes: {
                label: { fieldName: 'Id' }
              }, type: 'url',target: 'blank'}
            ]);*/
      component.set('v.mycolumns', [
          {label: 'Account', fieldName: 'AccountId',wrapText: true, typeAttributes: {
              label: { fieldName: 'AccountName' }
          }, type: 'url',target: 'blank'},
          {label: 'Clinic Name', fieldName: 'ClinicName', type: 'text', wrapText: true},
          {label: 'Preferred Place for Visit', fieldName: 'PreferredPlace', type: 'boolean', wrapText: true},
          {label: 'Shipping Street', fieldName: 'Street', type: 'text', wrapText: true},
          {label: 'Shipping City', fieldName: 'City', type: 'text', wrapText: true},
          {label: 'Shipping State', fieldName: 'State', type: 'text', wrapText: true}
      ]);
      component.set('v.columns', [
            {label: 'Account', fieldName: 'AccountId',wrapText: true, typeAttributes: {
                label: { fieldName: 'AccountName' }
            }, type: 'url',target: 'blank'},
            {label: 'Clinic Name', fieldName: 'ClinicName', type: 'text', wrapText: true},
            {label: 'Contact Role', fieldName: 'ContactRole', type: 'text'},
            {label: 'Activity Phone', fieldName: 'ActivityPhone', type: 'text', wrapText: true},
            {label: 'Preferred Contact day-time', fieldName: 'PreferredDay', type: 'text'},
            {label: 'Relation Id', fieldName: 'RelationName', wrapText: true, typeAttributes: {
                    label: { fieldName: 'Id' }
            }, type: 'url',target: 'blank'}
      ]);      

        if(recordId!=null){
            helper.getAccountList(component, recordId, function(err,result){
                
            });
        }
    }
})