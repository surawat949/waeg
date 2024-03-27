({
    getNearAccount : function(component, contactId, callback) {
        var action= component.get('c.getAllContacts');
        var pdistance = component.get('v.distance');
        var miyosmartAttitude = component.get('v.miyosmartAttitude');
        var prescriptionPotential = component.get('v.prescriptionPotential');
        var preferredMethod = component.get('v.preferredMethod');
        action.setParams({"contactId": contactId, "distance": pdistance, "miyosmartAttitude": miyosmartAttitude, "prescriptionPotential": prescriptionPotential, "preferredMethod": preferredMethod});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})