({
    doInit : function(component, event, helper) {
        var action = component.get("c.fetchTask");
        action.setParams({"recordId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.lstActivity" , response.getReturnValue()); 
            }
            else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE RESPONSE");                
            }
        });
        $A.enqueueAction(action);
    },   
    ToggleCollapse : function(component, event, helper) { 
		if(component.get("v.collpaseText")=="Show")
			component.set("v.collpaseText","Hide");
		else
			component.set("v.collpaseText","Show");
	}
})