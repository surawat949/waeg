({
    sendMail: function (component) {
        var action = component.get("c.sendRegistrationInvite");
        action.setParams({
            'recordId': component.get('v.recordId'),
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                if (response.getReturnValue() === 'Email was successfully sent to the customer.') {
                    toastEvent.setParams({
                        "title": "Email sent",
                        "message": "Email was successfully sent to the customer.",
                        "type": "success"
                    });
                } else {
                    toastEvent.setParams({
                        "title": "Email was not sent",
                        "message": response.getReturnValue(),
                        "type": "error"
                    });
                }
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                var refresh = $A.get("e.force:refreshView");
                refresh.fire();
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                        toastEvent.setParams({
                            "title": "Error sending email",
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