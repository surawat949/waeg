({
    getAccountList : function(component, contactId, callback ) {

        var action= component.get('c.getRelatedClinicsByContactId');
        action.setParams({"contactId": contactId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let data = [];
                response.getReturnValue().forEach((row)=>{
                        console.log('>>>>>>',row);
                        let obj = {
                           
                            Brand: row.Account.Brand__c,
                            AccountId: 'https://hoya.lightning.force.com/'+row.Account.Id,
                            AccountName: row.Account.Name,
                            OwnerId: 'https://hoya.lightning.force.com/'+row.Account.OwnerId,
                            OwnerName: row.Account.Owner.Name,
                            Street: row.Account.ShippingStreet,
                            PostalCode : row.Account.ShippingPostalCode,
                            City: row.Account.ShippingCity,
                            State: row.Account.ShippingState,
                            SeikoNetwork: row.Account.Seiko_Network__c,
                            ContactRole: row.Contact_Role__c,
                            recordId:  row.Id,
                            ClinicName: row.Account.Clinic_Name__c,
                            PreferredPlace: row.Preferred_place_for_visit__c,
                            ActivityPhone: row.Activity_Phone__c,
                            PreferredDay: row.Preferred_contact_day_time__c,
                            Id: row.Id,
                            RelationName: 'https://hoya.lightning.force.com/'+row.Id
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