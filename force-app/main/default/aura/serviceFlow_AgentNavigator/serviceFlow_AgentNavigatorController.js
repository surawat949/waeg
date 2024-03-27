({
    doInit: function (component, event, helper) {
        component.set("v.currentUserId",$A.get("$SObjectType.CurrentUser.Id"));
        helper.doInit(component, event, helper);
        component.set("v.selectedSubSubject", component.find("SubSubject").get("v.value"));        
    },
    createCase: function (component, event, helper) {
        helper.validateInputFields(component, event, helper, "Case");
    },
    handleComponentEvent: function (component, event, helper) {
        helper.handleToggleModal(component, event, helper, false, false);
    },
    resetErrors: function (component, event, helper) {
        helper.resetErrors(component, event, helper);
    },
    invokeTempPicklists: function (component, event, helper) {
        helper.invokeTempPicklists(component, event, helper);        
    },
    UploadFinished : function(component, event, helper) {  
        let uploadedFiles = event.getParam("files");  
        component.set("v.selectedFileName",uploadedFiles[0].name);
        component.set("v.selectedDocumentId",uploadedFiles[0].documentId);
    },
    getOrders: function(component, event, helper) {   
        component.set("v.isModalOpen", true);
        component.find("Subject").set("v.value","Track and Trace");
    },
})