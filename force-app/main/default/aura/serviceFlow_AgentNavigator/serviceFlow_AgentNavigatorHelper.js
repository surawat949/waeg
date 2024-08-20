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
            "recTypeName": "serviceFlow_Chat",
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
                component.set("v.configObject",data);
                component.set("v.isLoading",false);
            } else {
                component.set("v.isLoading",false);
            }
        });
        $A.enqueueAction(action);                
    },
    createCase: function (component, event, helper) {
        debugger;
        event.preventDefault();
        var accData = component.get("v.currentAccount");
        var isTempPicklist = component.get("v.isTempPicklist");
        
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
        }
        defaultFieldValues.Status = component.find("Status").get("v.value");
        let countryName = component.find("Country").get("v.value");
        let configObject = component.get("v.configObject");
        let recordTypeId = ((countryName === "South Africa") && (subject === "Quality Returns")) ? configObject.recordTypeLenseReturnsId : configObject.recordTypeRegularId;
        //if(defaultFieldValues.Status === "Closed" || defaultFieldValues.Status === "Waiting on Customer"){
            defaultFieldValues.sobjectType = "Case";
            defaultFieldValues.RecordTypeId = recordTypeId;
            component.set("v.isLoading",true);
            var action = component.get("c.createCaseUtility");
            action.setParams({
                caseRec : defaultFieldValues
            })
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        type : 'success',
                        title: 'Case Alert!',
                        message: 'Case Alert!',
                        messageTemplate: '{0} was created! See it {1}!',
                        messageTemplateData: ['Case', {
                            url: '/lightning/r/Case/'+data.Id+'/view',
                            label: 'here',
                        }]
                    });
                    toastEvent.fire();
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
                    component.set("v.isLoading",false);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "message": "Error occured, please try again"
                    });
                    toastEvent.fire();
                    component.set("v.isLoading",false);
                }
            });
            $A.enqueueAction(action);  
        /*}else{
            var navService = component.find("navService");
            var pageRef = {
                type: "standard__objectPage",
                attributes: {
                    objectApiName: "Case",
                    actionName: "new"
                },
                state: {
                    recordTypeId: recordTypeId
                }
            }
            pageRef.state.defaultFieldValues = component.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
            component.set("v.pageReference", pageRef);
            helper.blankUtility(component,event,helper);
            event.preventDefault();
            navService.navigate(pageRef);
        }*/
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
        }else if ($A.util.isEmpty(CaseOrigin)) {
            component.set("v.originRequired", true);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.originRequired", false);
                }), 5000
            );
        } else {
            if (buttonName == "Case") {
                this.createCase(component, event, helper);
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