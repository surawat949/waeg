({
    doInit: function (component, event, helper) {
        component.set("v.isLoading",true);
        const options = [
            {'label': $A.get("$Label.c.serviceFlow_Inbound"), 'value': $A.get("$Label.c.serviceFlow_Inbound") },                                           
            {'label': $A.get("$Label.c.serviceFlow_Outbound"), 'value': $A.get("$Label.c.serviceFlow_Outbound") }
        ];
        component.set('v.options', options);
        var action = component.get("c.getUserData");
        action.setParams({
            "recTypeName": "ServiceFlow Case Create",
            "accId": component.get("v.recordId")
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
                component.set("v.fieldMapping",fieldMapping);
                component.set("v.currentUser", data["UserData"]);
                component.set("v.recTypeId", data["recordTypeId"]);
                component.set("v.currentAccount", data["accountData"]);
                component.set("v.taskRTId", data["taskRecTypeId"]);
                
                const callStatus = [
                    {'label': $A.get("$Label.c.serviceFlow_Closed"), 'value': $A.get("$Label.c.serviceFlow_Closed") },                                         
                    {'label': $A.get("$Label.c.serviceFlow_In_Progress"), 'value': $A.get("$Label.c.serviceFlow_In_Progress") }                    
                ];
                if((countryName && countryName === "United Kingdom")){
                    //callStatus.push({'label': "Awaiting customer", 'value': "Awaiting customer"});
                }else{
                    callStatus.push({'label': $A.get("$Label.c.serviceFlow_New"), 'value': $A.get("$Label.c.serviceFlow_New")});                    
                }
                component.set('v.callStatus', callStatus);
                
                component.set("v.isLoading",false);
            } else {
                component.set("v.isLoading",false);
            }
        });
        $A.enqueueAction(action);                
    },
    createCase: function (component, event, helper) {
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
        }else if(bound === "CaseTask"){
            subject     = component.find("Subject").get("v.value");
            sub_subject = component.find("SubSubject").get("v.value");
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
                AccountId: component.get("v.recordId"),                
                serviceFlow_Account_Shop_email_address__c: accData.Shop_email_address__c,
                serviceFlow_Account_Shop_number__c: accData.Phone,
                serviceFlow_ECP_patient_order_number__c: component.find("ecpPatient").get("v.value"),
                serviceFlow_Hoya_reference_number__c: component.find("hoyaRef").get("v.value")
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
                AccountId: component.get("v.recordId"),
                User_country__c: component.find("Country").get("v.value"),
                serviceFlow_Account_Shop_email_address__c: accData.Shop_email_address__c,
                serviceFlow_Account_Shop_number__c: accData.Phone,
                serviceFlow_ECP_patient_order_number__c: component.find("ecpPatient").get("v.value"),
                serviceFlow_Hoya_reference_number__c: component.find("hoyaRef").get("v.value")
            };
            if(component.find("Country").get("v.value") === "South Africa"){
                defaultFieldValues.Status = "Arrived";
            }
        }
        pageRef.state.defaultFieldValues = component.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
        component.set("v.pageReference", pageRef);
        helper.blankUtility(component,event,helper);
        event.preventDefault();
        navService.navigate(pageRef);
        component.set("v.isEndChatClicked",false);
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
    createTask: function (component, event, helper) {
        var navService = component.find("navService");
        var pageRef = {
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Task",
                actionName: "new"
            },
            state: {
                recordTypeId: component.get("v.taskRTId")
            }
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
        }else if(bound === "CaseTask"){
            subject     = component.find("Subject").get("v.value");
            sub_subject = component.find("SubSubject").get("v.value");
        }
        let userCountry = component.find("Country").get("v.value");
        let numberOfJobs = "";
        if(userCountry === "USA"){
            numberOfJobs = component.find("Number_of_Jobs").get("v.value");
        }
        var defaultFieldValues = {
            WhatId: component.get("v.recordId"),
            Account__c: component.get("v.recordId"),
            Actions_Needed__c : component.get("v.selectedDocumentId"),
            serviceFlow_Origin__c: component.find("Origin").get("v.value"),
            SFlow_Subject__c: subject,
            serviceFlow_Number_of_Jobs__c : numberOfJobs,
            SFlow_Sub_Subject__c: sub_subject,
            Description: component.find("Description").get("v.value"),
            serviceFlow_Origin__c: component.find("Origin").get("v.value"),
            serviceFlow_User_Country__c: component.find("Country").get("v.value"),
            Subject: subject,
            serviceFlow_ECP_patient_order_number__c: component.find("ecpPatient").get("v.value"),
            serviceFlow_Hoya_reference_number__c: component.find("hoyaRef").get("v.value") 
        };
        pageRef.state.defaultFieldValues = component.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
        component.set("v.pageReference", pageRef);
        helper.blankUtility(component,event,helper);
        event.preventDefault();
        navService.navigate(pageRef);
        component.set("v.isEndChatClicked",false);
    },
    handleChange: function (component, event, helper, callType) {
        component.set("v.selectedCallType", callType);
    },
    handleChangeStatus: function (component, event, helper, callStatus) {
        component.set("v.selectedCallStatus", callStatus);
    },
    createCall: function (component, event, helper, isCallTypeStatic) {
        event.preventDefault();
        var callId;
        if($A.util.isEmpty(component.get("v.selectedCallType"))){
            component.set("v.selectedCallType", "Inbound");
        }
        let selectedCallStatus = component.get("v.selectedCallStatus");
        if(isCallTypeStatic){
            selectedCallStatus = "Closed";
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
        }else if(bound === "CaseTask"){
            subject     = component.find("Subject").get("v.value");
            sub_subject = component.find("SubSubject").get("v.value");
        }
        let userCountry = component.find("Country").get("v.value");
        let numberOfJobs = "";
        if(userCountry === "USA"){
            numberOfJobs = component.find("Number_of_Jobs").get("v.value");
        }
        var callData = {
            "WhatId": component.get("v.recordId"),
            "Actions_Needed__c" : component.get("v.selectedDocumentId"),
            "Account__c": component.get("v.recordId"),
            "SFlow_Call_Type__c": component.find("radioGroup").get("v.value"),
            "CallType": component.find("radioGroup").get("v.value"),
            "SFlow_Subject__c": subject,
            "SFlow_Sub_Subject__c": sub_subject,
            "serviceFlow_Number_of_Jobs__c" : numberOfJobs,
            "serviceFlow_Origin__c": component.find("Origin").get("v.value"),
            "Description":component.find("Description").get("v.value"),
            "serviceFlow_User_Country__c":component.find("Country").get("v.value"),
            "Subject": subject,
            "TaskSubtype": "Call",
            "Status": selectedCallStatus,
            "serviceFlow_ECP_patient_order_number__c": component.find("ecpPatient").get("v.value"),
            "serviceFlow_Hoya_reference_number__c": component.find("hoyaRef").get("v.value")
        };
        var action = component.get("c.createTaskforCall");
        action.setParams({
            "taskCallData": JSON.stringify(callData)
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var workspaceAPI = component.find("workspace");
                workspaceAPI.isConsoleNavigation().then(function(isConsoleTab) {
                    if(isConsoleTab){
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            var focusedTabId = response.tabId;
                            workspaceAPI.closeTab({tabId: focusedTabId});
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                    }
                })
                .catch(function(error) {
                    console.log(error);
                });
                helper.blankUtility(component,event,helper);
                window.location.href = "/lightning/page/home";
                window.history.back();
            } else {
                console.log(response + ' -- ' + response.getState() + ' -- ' + response.getReturnValue());
            }
            component.set("v.isLoading",false);            
            component.set("v.isCall",false);
        });
        $A.enqueueAction(action);        
    },
    handleToggleModal: function (component, event, helper, isCallOpen, isCreateRecordOpen) {
        component.set("v.isCall", isCallOpen);
        component.set("v.isCreateRecord", isCreateRecordOpen);
    },
    validateInputFields: function (component, event, helper, buttonName) {
        var Subject = component.find("Subject").get("v.value");
        var SubSubject = component.find("SubSubject").get("v.value");
        var CaseOrigin = component.find("Origin").get("v.value");
        var radio = component.find("radioGroup").get("v.value");
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
        } else if (buttonName == "Call" && bound == "Inbound" && $A.util.isEmpty(Subject)) {
            component.set("v.subjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subjectRequired", false);
                }), 5000
            );
        }else if (buttonName == "Call" && bound == "Outbound" && $A.util.isEmpty(UISubject)) {
            component.set("v.subjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subjectRequired", false);
                }), 5000
            );
        } else if (buttonName == "Call" && bound == "Inbound" && $A.util.isEmpty(SubSubject) && Subject != "Other" && userCountry != "USA") {
            component.set("v.subSubjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subSubjectRequired", false);
                }), 5000
            );
        } else if (radio == "CaseTask" && $A.util.isEmpty(SubSubject) && userCountry != "USA") {
            component.set("v.subSubjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subSubjectRequired", false);
                }), 5000
            );
        } else if ($A.util.isEmpty(CaseOrigin)) {
            component.set("v.originRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.originRequired", false);
                }), 5000
            );
        } else {
            if (buttonName == "Case") {
                this.createCase(component, event, helper);
            } else if (buttonName == "Task") {
                this.createTask(component, event, helper);
            } else if (buttonName == "Call") {
                let userCountry = component.find("Country").get("v.value");
                if(userCountry === "South Africa"){
                    helper.createCall(component, event, helper, true);
                }else{
                    this.handleToggleModal(component, event, helper, true, false);
                }
            }
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
    invokeTempPicklists: function (component, event, helper) {
        var radio = component.find("radioGroup").get("v.value");
        let userCountry = component.find("Country").get("v.value");
        if(radio == "Outbound") {
            component.set("v.isBoundSelected",true);
            component.set("v.isBoundSelectedDisabled",true);
            
            component.set("v.picklistLoad",true);
            component.set("v.isTempPicklist",true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.picklistLoad",false);
                }), 1000
            );
        } else {
            if(radio == "Inbound"){
                component.set("v.isBoundSelected",true);
                component.set("v.isBoundSelectedDisabled",true);
            }else {
                if(userCountry === "USA"){
                    component.set("v.isBoundSelected",true);
                }else{
                    component.set("v.isBoundSelected",false);
                }
                component.set("v.isBoundSelectedDisabled",false);
            }
            component.set("v.picklistLoad",true);
            component.set("v.isTempPicklist",false);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.picklistLoad",false);
                }), 1000
            );
        }
    },
})