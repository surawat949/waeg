({
    doInit: function (component, event, helper) {
        component.set("v.isLoading",true);
        const options = [{'label': $A.get("$Label.c.serviceFlow_Inbound"), 'value': $A.get("$Label.c.serviceFlow_Inbound") },                                           
                         {'label': $A.get("$Label.c.serviceFlow_Outbound"), 'value': $A.get("$Label.c.serviceFlow_Outbound") }
                        ];
        component.set('v.options', options);
        
        const callStatus = [{'label': $A.get("$Label.c.serviceFlow_Closed"), 'value': $A.get("$Label.c.serviceFlow_Closed") },                                           
                            {'label': $A.get("$Label.c.serviceFlow_In_Progress"), 'value': $A.get("$Label.c.serviceFlow_In_Progress") },
                            {'label': $A.get("$Label.c.serviceFlow_New"), 'value': $A.get("$Label.c.serviceFlow_New") }
                           ];
        component.set('v.callStatus', callStatus);
        
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
                let fieldMapping = {
                    'subject' : countryName ? 'SF_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'SFlow_Subject__c',
                    'subSubject' : countryName ? 'SF_Sub_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'SFlow_Sub_Subject__c',
                    'uiSubject' : countryName ? 'SF_UI_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'serviceFlow_UI_Subject__c',
                    'uiSubSubject' : countryName ? 'SF_UI_Sub_Subject_'+countryName.replace(/\s/g, '_')+'__c' : 'serviceFlow_UI_Sub_Subject__c'
                };
                component.set("v.fieldMapping",fieldMapping);
                console.log(JSON.stringify(component.get("v.fieldMapping")));
                component.set("v.currentUser", data["UserData"]);
                component.set("v.recTypeId", data["recordTypeId"]);
                component.set("v.currentAccount", data["accountData"]);
                component.set("v.taskRTId", data["taskRecTypeId"]);
                component.set("v.isLoading",false);
            } else {
                component.set("v.isLoading",false);
                console.log(response + ' -- ' + response.getState() + ' -- ' + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);                
    },
    
    createCase: function (component, event, helper) {
        var accData = component.get("v.selectAccountRecord");
        var isTempPicklist = component.get("v.isTempPicklist");
        var navService = component.find("navService");
        let userCountry = component.find("Country").get("v.value");
        let numberOfJobs = "";
        if(userCountry === "USA"){
            numberOfJobs = component.find("Number_of_Jobs").get("v.value");
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
            //alert(component.find("UISubject").get("v.value"));
            var defaultFieldValues = {
                DocumentID__c : component.get("v.selectedDocumentId"),
                Description: component.find("Description").get("v.value"),
                User_country__c: component.find("Country").get("v.value"),
                SFlow_Subject__c: component.find("UISubject").get("v.value"),
                Subject: component.find("UISubject").get("v.value"),
                SFlow_Sub_Subject__c: component.find("UISubSubject").get("v.value"),
                Origin: component.find("Origin").get("v.value"),
                serviceFlow_Number_of_Jobs__c : numberOfJobs,
                serviceFlow_Origin__c: component.find("Origin").get("v.value"),
                AccountId: component.get("v.selectRecordId"),                
                serviceFlow_Account_Shop_email_address__c: accData.sObjectRec.Shop_email_address__c,
                serviceFlow_Account_Shop_number__c: accData.sObjectRec.Phone,
                serviceFlow_ECP_patient_order_number__c: component.find("ecpPatient").get("v.value"),
                serviceFlow_Hoya_reference_number__c: component.find("hoyaRef").get("v.value")
            };
            if(component.find("Country").get("v.value") === "South Africa"){
                defaultFieldValues.Status = "Arrived";
            }
            
            //alert(JSON.stringify(defaultFieldValues));
        } else {
            var defaultFieldValues = {
                DocumentID__c : component.get("v.selectedDocumentId"),
                Description: component.find("Description").get("v.value"),
                SFlow_Subject__c: component.find("Subject").get("v.value"),
                Subject: component.find("Subject").get("v.value"),
                SFlow_Sub_Subject__c: component.find("SubSubject").get("v.value"),            
                Origin: component.find("Origin").get("v.value"),
                serviceFlow_Origin__c: component.find("Origin").get("v.value"),
                serviceFlow_Number_of_Jobs__c : numberOfJobs,
                AccountId: component.get("v.selectRecordId"),
                User_country__c: component.find("Country").get("v.value"),
                serviceFlow_Account_Shop_email_address__c: accData.sObjectRec.Shop_email_address__c,
                serviceFlow_Account_Shop_number__c: accData.sObjectRec.Phone,
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
    },
    blankUtility : function(component,event,helper){
        component.find("accountLookupValue").set("v.selectRecordName","");
        component.find("accountLookupValue").set("v.selectRecordId","");
        component.find("accountLookupValue").set("v.selectAccountRecord",undefined);
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
        console.log('creattetask helper');
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
        console.log('pageRef : ' + JSON.stringify(pageRef));
        let userCountry = component.find("Country").get("v.value");
        let numberOfJobs = "";
        if(userCountry === "USA"){
            numberOfJobs = component.find("Number_of_Jobs").get("v.value");
        }
        var defaultFieldValues = {
            WhatId: component.get("v.selectRecordId"),
            Actions_Needed__c : component.get("v.selectedDocumentId"),
            Account__c: component.get("v.selectRecordId"),
            serviceFlow_Origin__c: component.find("Origin").get("v.value"),
            SFlow_Subject__c: component.find("Subject").get("v.value"),
            SFlow_Sub_Subject__c: component.find("SubSubject").get("v.value"),
            serviceFlow_Number_of_Jobs__c : numberOfJobs,
            Description: component.find("Description").get("v.value"),
            serviceFlow_Origin__c: component.find("Origin").get("v.value"),
            serviceFlow_User_Country__c: component.find("Country").get("v.value"),
            Subject: component.find("Subject").get("v.value"),
            serviceFlow_ECP_patient_order_number__c: component.find("ecpPatient").get("v.value"),
            serviceFlow_Hoya_reference_number__c: component.find("hoyaRef").get("v.value") 
        };
        console.log('defaultFieldValues : ' + JSON.stringify(defaultFieldValues));
        pageRef.state.defaultFieldValues = component.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
        component.set("v.pageReference", pageRef);
        helper.blankUtility(component,event,helper);
        event.preventDefault();
        navService.navigate(pageRef);
    },
    handleChange: function (component, event, helper, callType) {
        component.set("v.selectedCallType", callType);
    },
    handleChangeStatus: function (component, event, helper, callStatus) {
        component.set("v.selectedCallStatus", callStatus);
    },
    createCall: function (component, event, helper) {
        var callId;
        if($A.util.isEmpty(component.get("v.selectedCallType"))){
            component.set("v.selectedCallType", "Inbound");
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
        let userCountry = component.find("Country").get("v.value");
        let numberOfJobs = "";
        if(userCountry === "USA"){
            numberOfJobs = component.find("Number_of_Jobs").get("v.value");
        }
        var callData = {
            "WhatId": component.get("v.selectRecordId"),
            Actions_Needed__c : component.get("v.selectedDocumentId"),
            "Account__c": component.get("v.selectRecordId"),
            "SFlow_Call_Type__c": component.find("radioGroup").get("v.value"),
            "CallType": component.find("radioGroup").get("v.value"),
            "SFlow_Subject__c": subject,
            "SFlow_Sub_Subject__c": sub_subject,
            "serviceFlow_Origin__c": component.find("Origin").get("v.value"),
            "serviceFlow_Number_of_Jobs__c" : numberOfJobs,
            "Description":component.find("Description").get("v.value"),
            "serviceFlow_User_Country__c":component.find("Country").get("v.value"),
            "Subject": subject,
            "TaskSubtype": "Call",
            "Status": component.get("v.selectedCallStatus"),
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
                callId = response.getReturnValue();
                
                if(component.get("v.selectedCallStatus") === "Closed"){
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/page/home"
                    });
                    urlEvent.fire();
                    window.location.reload(true);
                }else{
                    var navService = component.find("navService");
                    var pageRef = {
                        type: "standard__recordPage",
                        attributes: {
                            objectApiName: "Task",
                            recordId: callId,
                            actionName: "view"
                        },
                        state: {
                        }
                    };
                    console.log(JSON.stringify(pageRef));
                    component.set("v.pageReference", pageRef);
                    helper.blankUtility(component,event,helper);
                    event.preventDefault();
                    navService.navigate(pageRef);
                }
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
        console.log('came to helper');
        var Subject = component.find("Subject").get("v.value");
        var SubSubject = component.find("SubSubject").get("v.value");
        var CaseOrigin = component.find("Origin").get("v.value");
        var radio = component.find("radioGroup").get("v.value");
        var UISubject = component.find("UISubject").get("v.value");
        var UISubSubject = component.find("UISubSubject").get("v.value");
        var bound = component.get("v.selectedBound");
        let accountId = component.get("v.selectRecordId");
        let userCountry = component.find("Country").get("v.value");
        if ($A.util.isEmpty(accountId)) {
            component.set("v.isAccountRecordIdRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.isAccountRecordIdRequired", false);
                }), 5000
            );
        }else if (buttonName == "Case" && $A.util.isEmpty(Subject)) {
            console.log('subject not selected');
            component.set("v.subjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subjectRequired", false);
                }), 5000
            );
        } else if (buttonName == "Call" && bound == "Inbound" && $A.util.isEmpty(Subject)) {
            console.log('subject not selected');
            component.set("v.subjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subjectRequired", false);
                }), 5000
            );
        }else if (buttonName == "Call" && bound == "Outbound" && $A.util.isEmpty(UISubject)) {
            console.log('subject not selected');
            component.set("v.subjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subjectRequired", false);
                }), 5000
            );
        } else if (buttonName == "Call" && bound == "Outbound" && $A.util.isEmpty(UISubSubject) && UISubSubject != "Other" && userCountry === "United Kingdom") {
            console.log('subject not selected');
            component.set("v.subSubjectRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.subSubjectRequired", false);
                }), 5000
            );
        }else if (buttonName == "Call" && bound == "Inbound" && $A.util.isEmpty(SubSubject) && Subject != "Other" && userCountry != "USA") {
            console.log('subject not selected');
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
                //this.handleToggleModal(component, event, helper, false, true);
            } else if (buttonName == "Task") {
                this.createTask(component, event, helper);
            } else if (buttonName == "Call") {
                this.handleToggleModal(component, event, helper, true, false);
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