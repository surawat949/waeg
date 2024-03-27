({
    getAccountList : function(component, contactId, callback ) {

        var action= component.get('c.getAccountsLinkedToContactbyContactId');
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
    },
    deleteRow : function(component, row) {
        //alert("Showing opportunity " + row.Name + " id= " + row.recordId);
        
        var action= component.get('c.deleteRelationShip');
        action.setParams({"recordId": row.recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Record deleted with success"
                });
                toastEvent.fire();
            }else if (component.isValid() && state === "ERROR") {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": 'Impossible to delete this record'
                });
                toastEvent.fire();
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})