({
    onChatEnded: function(component, event, helper) {
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;
            component.set("v.isModalOpen",true);
            component.set("v.currentUserId",$A.get("$SObjectType.CurrentUser.Id"));
            helper.doInit(component, event, helper);
            //component.set("v.selectedSubSubject", component.find("SubSubject").get("v.value"));
            window.setTimeout(
                $A.getCallback(function() {
                    workspaceAPI.closeTab( { tabId: focusedTabId } );
                }), 600000
            );
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
        });
    },
    handleProceedWithNewCase : function(component, event, helper) {
        component.set("v.isProceedWithNewCaseSelected",true);
        component.set("v.isProceedWithExistingCaseSelected",false);        
    },
    handlePrevious : function(component, event, helper) {
        component.set("v.isProceedWithNewCaseSelected",false);
        component.set("v.isProceedWithExistingCaseSelected",false);
    },
    handleRadioChange: function(component, event, helper) {
        let selectedCaseId = event.getSource().get("v.value");
        console.log("Selected Case Id: " + selectedCaseId);
        component.set("v.selecteCaseRecordId",selectedCaseId);
        let caseRecordsList = component.get("v.openCaseList");
        let selectedRecord = caseRecordsList.find(item => item.Id===selectedCaseId);
        console.log(JSON.stringify(selectedRecord));
        
        component.set("v.isProceedWithNewCaseSelected",true);
        component.set("v.isProceedWithExistingCaseSelected",true);
        
        component.find("Country").set("v.value",selectedRecord.User_country__c);
        component.find("Subject").set("v.value", selectedRecord.SFlow_Subject__c);
        component.find("SubSubject").set("v.value",selectedRecord.SFlow_Sub_Subject__c);
        component.find("Description").set("v.value", selectedRecord.Description);
        component.find("Origin").set("v.value",selectedRecord.serviceFlow_Origin__c);
        component.find("ecpPatient").set("v.value", selectedRecord.serviceFlow_ECP_patient_order_number__c);
        component.find("hoyaRef").set("v.value", selectedRecord.serviceFlow_Hoya_reference_number__c);
        component.find("Status").set("v.value", selectedRecord.Status);
    },
    closeModel: function(component, event, helper) {        
       helper.closeModel(component, event, helper);
    },
    handleNewCase: function (component, event, helper) {
        helper.validateInputFields(component, event, helper, "Case",undefined);
    },
    handleExistingCase: function (component, event, helper) {
        helper.validateInputFields(component, event, helper, "Case",component.get("v.selecteCaseRecordId"));
    },
    resetErrors: function (component, event, helper) {
        helper.resetErrors(component, event, helper);
    },
    UploadFinished : function(component, event, helper) {  
        let uploadedFiles = event.getParam("files");  
        component.set("v.selectedFileName",uploadedFiles[0].name);
        component.set("v.selectedDocumentId",uploadedFiles[0].documentId);
    }
})