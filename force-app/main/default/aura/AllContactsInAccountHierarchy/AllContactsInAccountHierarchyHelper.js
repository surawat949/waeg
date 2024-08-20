({
    getContactList : function(component, accountId, callback ) {
        var action= component.get('c.getAllContactsInHierarchy');
        action.setParams({"accountId": accountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let data = [];
                
                response.getReturnValue().forEach((row)=>{
                    let obj = {
                        ContactId:'https://hoya.lightning.force.com/'+row.contactId,
                        ContactName: row.ContactName,
                        AccountId: 'https://hoya.lightning.force.com/'+row.AccountId,
                        AccountName: row.AccountName,
                        OwnerId: 'https://hoya.lightning.force.com/'+row.OwnerId,
                        OwnerName: row.OwnerName,
                        PreferredPlace: row.PreferredPlace,
                        Street: row.Street,
                        City: row.City,
                        State: row.State,
                        Phone: row.Phone,
                        Role: row.Role
                    }
                    data.push(obj);     
                });
                
                component.set('v.contactList', data);
                callback(null, response.getReturnValue());

            } else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getOpthalmologistCONTACT_RT : function(component, callback){
        var action = component.get('c.getRecordTypeIdOpthalmologist');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})