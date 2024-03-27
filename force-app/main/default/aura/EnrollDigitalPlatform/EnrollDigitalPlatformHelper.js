({
    activate : function(component) {
        var action = component.get("c.enroll");
        action.setParams({
            'accountId': component.get('v.recordId'),
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                if (response.getReturnValue() === 'ok') {
                    toastEvent.setParams({
                        "title": "Activation done successfully",
                        "message": "Customer activation is done",
                        "type": "success"
                    });
                } else {
                    toastEvent.setParams({
                        "title": "Error:" + response.getReturnValue(),
                        "message": response.getReturnValue(),
                        "type": "error"
                    });
                }
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                var refresh = $A.get("e.force:refreshView");
                refresh.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                        toastEvent.setParams({
                            "title": "Error digital activation",
                            "message": errors[0].message,
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})