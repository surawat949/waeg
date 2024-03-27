({
    handleClick : function (cmp, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
           componentDef : "c:powerBIInvokeContainer",
           componentAttributes: {
              vfpName : 'AaTestBI'
           }
        });
        evt.fire();
        window.open("https://test.salesforce.com/apex/AaTestBI")
    }
});