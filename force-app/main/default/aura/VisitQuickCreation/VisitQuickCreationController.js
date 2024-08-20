({
    doInit : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var pvalue = myPageRef.state.c__ent;
        component.set("v.ent", pvalue);


        helper.initAccount(component, function(err, result){
            component.set('v.account', result);
        });
        helper.initVisit(component, function(err, result){
            component.set('v.visit', result);
        });
    },
    handleSave : function(component, event, helper){
        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, 'slds-show');

        //component.set("v.Spinner", true);
        var v = component.get('v.visit');
        helper.handleSave(component, v, function(err, result){
            component.set('v.visit', result);
        });
       //$A.util.removeClass(spinner, 'slds-show');
        //$A.util.toggleClass(spinner, 'slds-hide');
        
    },
    gotoVisit : function(component,event, helper){
        var v = component.get('v.visit');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": v.Id,
            "slideDevName": "detail"
        });
        navEvt.fire();
    }
        
})