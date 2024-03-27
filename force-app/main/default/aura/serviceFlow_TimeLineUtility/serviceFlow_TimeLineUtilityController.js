({
    
    toggleAcitivity : function(component, event, helper) {
        $A.util.toggleClass(component.find('expId'), 'slds-is-open');
    },   
    onClick :function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.currentTarget.id,
            "slideDevName": "related"
        });
        navEvt.fire();
    }
})