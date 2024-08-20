({
    doInit: function (component, event, helper) { 
        var action = component.get("c.getDashboardDetails");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "eventType" : component.get("v.eventType")
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data******"+JSON.stringify(data));
                component.set("v.dashboardDetails",data);
            } else {
                console.log(response + ' -- ' + response.getState() + ' -- ' + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);   
    },
})