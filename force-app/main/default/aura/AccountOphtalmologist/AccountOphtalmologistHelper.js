({
    getContactList : function(component, accountId, callback ) {

        var action= component.get('c.getContactList');
        action.setParams({"accountId": accountId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let data = [];
                response.getReturnValue().forEach((row)=>{
                    
                        let obj = {
                            Id:'https://hoya.lightning.force.com/'+row.ContactId,
                            Name: row.Contact.Name,
                            Type: row.Contact.Contact_Record_Type__c,
                            isDirect: row.IsDirect,
                            Role: row.Roles,
                            Education : row.Contact.Education__c,
                            accountName: row.Contact.Account.Name,
                            Title: row.Contact.Salutation,
                            City:row.Contact.Account.ShippingCity,
                            PostalCode:row.Contact.Account.ShippingPostalCode,
                            recordId:  row.Id
                        }
                        
                        data.push(obj);
                    
                });
                component.set('v.contactList', data);
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