({
    getAttendeeList : function(component, trainingId, callback ) {
        var action= component.get('c.getAttendeeList');
        action.setParams({"trainingId": trainingId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let data = [];
                response.getReturnValue().forEach((row)=>{
                    
                        let obj = {
                            Salutation: row.Salutation,
                            FirstName: row.FirstName,
                            Lastname: row.LastName,
                            Name : row.Name,
                            contactUrl: 'https://hoya.lightning.force.com/'+row.Id,
                            Email: row.Email,
                            type: row.RecordType.Name,
                            recordId: row.Id
                        }
                        
                        data.push(obj);
                    
                });
                component.set('v.AttendeeList', data);
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getContactList : function(component, trainingId, callback ) {
        var action= component.get('c.getContactList');
        action.setParams({"trainingId": trainingId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let data = [];
                response.getReturnValue().forEach((row)=>{
                        let obj = {
                            Salutation: row.Salutation,
                            FirstName: row.FirstName,
                            Lastname: row.LastName,
                            Name : row.Name,
                            contactUrl: 'https://hoya.lightning.force.com/'+row.Id,
                            Email: row.Email,
                            type: row.RecordType.Name,
                            recordId: row.Id
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
    deleteRow : function(component, row, recordId) {
        
        var action= component.get('c.deleteRelationShip');
        action.setParams({"contactId": row.recordId,"trainingId":recordId});
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
    },
    addRow : function(component, row, recordId) {
        
        var action= component.get('c.addRelationShip');
        action.setParams({"contactId": row.recordId,"trainingId":recordId});
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
                    "message": 'Impossible to add this record'
                });
                toastEvent.fire();
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})