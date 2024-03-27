({
    getAccountList : function(component, contactId, callback ) {

        var action= component.get('c.getRelatedClinicsByContactId');
        action.setParams({"contactId": contactId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let data = [];
                response.getReturnValue().forEach((row)=>{
                    
                        let obj = {
                            Brand: row.Account.Brand__c,
                            AccountId: 'https://hoya.lightning.force.com/'+row.Account.Id,
                            AccountName: row.Account.Name,
                            Street: row.Account.ShippingStreet,
                            PostalCode : row.Account.ShippingPostalCode,
                            City: row.Account.ShippingCity,
                            SeikoNetwork: row.Account.Seiko_Network__c,
                            recordId:  row.Id
                        }
                        
                        data.push(obj);
                    
                });
                component.set('v.accountList', data);
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})