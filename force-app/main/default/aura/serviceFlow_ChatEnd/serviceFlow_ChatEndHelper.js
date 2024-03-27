({
    doInit: function (component, event, helper) {
        component.set("v.isLoading",true);
        var action = component.get("c.getUserData");
        action.setParams({
            "recTypeName": "serviceFlow_Chat",
            "recordId": component.get("v.recordId")
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                let countryName = data["UserData"].Country_for_Customer_Support__c;
                let fieldMapping;
                if(countryName === 'Spain'){
                    fieldMapping = {
                        'subject'      : 'SFlow_Subject__c',
                        'subSubject'   : 'SFlow_Sub_Subject__c',
                        'uiSubject'    : 'serviceFlow_UI_Subject__c',
                        'uiSubSubject' : 'serviceFlow_UI_Sub_Subject__c'
                    };
                }else{
                    fieldMapping = {
                        'subject' : countryName ? 'Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'SFlow_Subject__c',
                        'subSubject' : countryName ? 'Sub_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'SFlow_Sub_Subject__c',
                        'uiSubject' : countryName ? 'UI_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'serviceFlow_UI_Subject__c',
                        'uiSubSubject' : countryName ? 'UI_Sub_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'serviceFlow_UI_Sub_Subject__c'
                    };
                } 	
                
                component.set("v.openCaseList",data["openCases"]);
                component.set("v.fieldMapping",fieldMapping);
                component.set("v.currentUser", data["UserData"]);
                component.set("v.recTypeId", data["recordTypeId"]);
                component.set("v.currentAccount", data["accountData"]);
                component.set("v.isLoading",false);
            } else {
                component.set("v.isLoading",false);
            }
        });
        $A.enqueueAction(action);                
    },
    createCase: function (component, event, helper,existingRecordId) {
        debugger;
        var accData = component.get("v.currentAccount");
        var isTempPicklist = component.get("v.isTempPicklist");
        var navService = component.find("navService");
        let userCountry = component.find("Country").get("v.value");
        let numberOfJobs = "";
        if(userCountry === "USA"){
            numberOfJobs = component.find("Number_of_Jobs").get("v.value");
        }
        var bound = component.get("v.selectedBound");
        let subject = "";
        let sub_subject = "";
        if(bound === "Inbound"){
            subject     = component.find("Subject").get("v.value");
            sub_subject = component.find("SubSubject").get("v.value");
        }else if(bound === "Outbound"){
            subject     = component.find("UISubject").get("v.value");
            sub_subject = component.find("UISubSubject").get("v.value");
        }
        var pageRef = {
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Case",
                actionName: "new"
            },
            state: {
                recordTypeId: component.get("v.recTypeId")
            }
        }
        if (isTempPicklist) {
            var defaultFieldValues = {
                Description: component.find("Description").get("v.value"),
                DocumentID__c : component.get("v.selectedDocumentId"),
                User_country__c: component.find("Country").get("v.value"),
                SFlow_Subject__c: subject,
                Subject: subject,
                SFlow_Sub_Subject__c: sub_subject,
                Origin: component.find("Origin").get("v.value"),
                serviceFlow_Number_of_Jobs__c : numberOfJobs,
                serviceFlow_Origin__c: component.find("Origin").get("v.value"),
                AccountId: accData.Id,    
                RecordTypeId: component.get("v.recTypeId"),
                serviceFlow_Account_Shop_email_address__c: accData.Shop_email_address__c,
                serviceFlow_Account_Shop_number__c: accData.Phone,
                serviceFlow_ECP_patient_order_number__c: component.find("ecpPatient").get("v.value"),
                serviceFlow_Hoya_reference_number__c: component.find("hoyaRef").get("v.value"),
                Status :component.find("Status").get("v.value")
            };
            if(component.find("Country").get("v.value") === "South Africa"){
                defaultFieldValues.Status = "Arrived";
            }
        } else {
            var defaultFieldValues = {
                Description: component.find("Description").get("v.value"),
                DocumentID__c : component.get("v.selectedDocumentId"),
                SFlow_Subject__c: subject,
                Subject: subject,
                SFlow_Sub_Subject__c: sub_subject,            
                Origin: component.find("Origin").get("v.value"),
                serviceFlow_Number_of_Jobs__c : numberOfJobs,
                serviceFlow_Origin__c: component.find("Origin").get("v.value"),
                AccountId: accData.Id, 
                RecordTypeId: component.get("v.recTypeId"),
                User_country__c: component.find("Country").get("v.value"),
                serviceFlow_Account_Shop_email_address__c: accData.Shop_email_address__c,
                serviceFlow_Account_Shop_number__c: accData.Phone,
                serviceFlow_ECP_patient_order_number__c: component.find("ecpPatient").get("v.value"),
                serviceFlow_Hoya_reference_number__c: component.find("hoyaRef").get("v.value"),
                Status :component.find("Status").get("v.value")
            };
            if(component.find("Country").get("v.value") === "South Africa"){
                defaultFieldValues.Status = "Arrived";
            }
            defaultFieldValues.sobjectType = "Case";
            if(existingRecordId){
                defaultFieldValues.Id = existingRecordId;
            }
        }
        /*
        pageRef.state.defaultFieldValues = component.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
        component.set("v.pageReference", pageRef);
        helper.blankUtility(component,event,helper);
        event.preventDefault();
        navService.navigate(pageRef);
        */
        console.log("selected object******"+JSON.stringify(defaultFieldValues))
        component.set("v.isLoading",true);
        var action = component.get("c.createCaseRecord");
        action.setParams({
            "caseDetails": JSON.stringify(defaultFieldValues)
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let caseRecId = response.getReturnValue();
                /*
                let caseRecId = response.getReturnValue();
                var caseRecordEdit = $A.get("e.force:editRecord");
                caseRecordEdit.setParams({
                    "recordId": caseRecId
                });
                caseRecordEdit.fire();
                */
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    type : 'success',
                    title: 'Case Alert!',
                    message: 'Case Alert!',
                    messageTemplate: '{0} was created or updated! See it {1}!',
                    messageTemplateData: ['Case', {
                        url: '/lightning/r/Case/'+caseRecId+'/view',
                        label: 'here',
                    }]
                });
                toastEvent.fire();
                if(caseRecId){
                    helper.handleChat(component, event, helper);
                    component.set("v.isLoading",false);  
                }else{
                    component.set("v.isLoading",false);  
                }
                component.set("v.isLoading",false);
            } else {
                component.set("v.isLoading",false);  
                console.log(response + ' -- ' + response.getState() + ' -- ' + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);  
    },
    blankUtility : function(component,event,helper){        
        component.find("Description").set("v.value","");
        component.find("Subject").set("v.value","");
        component.find("SubSubject").set("v.value","");
        component.find("ecpPatient").set("v.value","");
        component.find("hoyaRef").set("v.value","");
        component.find("UISubject").set("v.value","");
        component.find("UISubSubject").set("v.value","");
        component.set("v.selectedFileName","");
        component.set("v.selectedDocumentId",""); 
        if(component.find("Country").get("v.value") === "USA"){
            component.find("Number_of_Jobs").set("v.value","");
        } 
    },
    validateInputFields: function (component, event, helper, buttonName,existingRecordId) {
        var Subject = component.find("Subject").get("v.value");
        var SubSubject = component.find("SubSubject").get("v.value");
        var CaseOrigin = component.find("Origin").get("v.value");
        var UISubject = component.find("UISubject").get("v.value");
        var UISubSubject = component.find("UISubSubject").get("v.value");
        var bound = component.get("v.selectedBound");
        let userCountry = component.find("Country").get("v.value");
        
        if (buttonName == "Case" && $A.util.isEmpty(Subject)) {
            component.set("v.subjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subjectRequired", false);
                }), 5000
            );
        }else if ($A.util.isEmpty(CaseOrigin)) {
            component.set("v.originRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.originRequired", false);
                }), 5000
            );
        } else {
            this.createCase(component, event, helper,existingRecordId);
        }
    },
    resetErrors:  function (component, event, helper) {
        component.set("v.subjectRequired", false);
        component.set("v.subSubjectRequired", false);
        component.set("v.originRequired", false);
        let userCountry = component.find("Country").get("v.value");
        if(userCountry === "USA"){
            component.set("v.isBoundSelected",true);
        }else{
            component.set("v.isBoundSelected",false);
        }
    },
    closeModel: function(component, event, helper) {        
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: true
            });
            component.set("v.isModalOpen", false);
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
            component.set("v.isModalOpen", false);
        });
    },
    handleChat: function(component, event, helper) {
        event.preventDefault();
        let workspaceAPI = component.find( "workspace");
        workspaceAPI.getFocusedTabInfo().then( function( response ) {
            let focusedTabId = response.tabId;
            let recordId = response.recordId;
            window.setTimeout(
                $A.getCallback(function() {
                    workspaceAPI.closeTab( { tabId: focusedTabId } );
                    component.set("v.isModalOpen",false);
                }), 500
            );
            
        })
        .catch(function( error ) {
            console.log( 'Error is' + JSON.stringify( error ) );
        });
    },
})