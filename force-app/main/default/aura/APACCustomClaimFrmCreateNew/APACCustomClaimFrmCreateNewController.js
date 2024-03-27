({
	doInit : function(component, event, helper) {
        var createNewOne = $A.get("e.force:createRecord");
        createNewOne.setParams({
            "entityApiName" : "RejectAndReturn_CS__c",
            "defaultFieldValues" : {
                'Name' : '***PLEASE NOT CHANGE THIS VALUE***'
            }
        });
        createNewOne.fire();
	}
})