({
    doInitHelper: function(component, event, helper) {
        component.set("v.showLoader",true);
        component.set("v.as400Columns", [
            {label: 'Receive N°', fieldName: 'RCVNO__c', type: Text},
            {label: 'Tray N°', fieldName: 'TRAYNO__c', type: Text},
            {label: 'AA Receive', fieldName: 'YEARRCV__c', type: Text},
            {label: 'MM Receive', fieldName: 'MONTHRCV__c', type: Text},
            {label: 'DD Receive', fieldName: 'DAYRCV__c', type: Text},
            {label: 'Customer', fieldName: 'CUSTOMER__c', type: Text},
            {label: 'Lens Type', fieldName: 'LENSTYPE__c', type: Text},
            {label: 'Colour', fieldName: 'COLOR__c', type: Text},
            {label: 'Coat', fieldName: 'COAT__c', type: Text},
            {label: 'Sph', fieldName: 'SPHSIGN__c', type: Text},
            {label: 'Sph Value', fieldName: 'SPHVAL__c', type: Text},
            {label: 'Cyl', fieldName: 'CILSIGN__c', type: Text},
            {label: 'Cyl Value', fieldName: 'CILVAL__c', type: Text},
            {label: 'Axis', fieldName: 'AXIS__c', type: Text},
            {label: 'Addition', fieldName: 'ADD__c', type: Text},
            {label: 'AA Deliveri', fieldName: 'YEARDLVRY__c', type: Text},
            {label: 'Depo Delivery', fieldName: 'DEPODLVRY__c', type: Text},
            {label: 'Mag Delivery', fieldName: 'MAGADLVRY__c', type: Text},
            {label: 'Delivery N°', fieldName: 'NUMDLVRY__c', type: Text}
        ]);
        helper.apexUtil(component,helper,'fetchUserConfigDetails',{
            recordId: component.get("v.recordId")
        })
        .then(function(result){   
            if(result && result !=null){
                component.set("v.defectOption",result.caseInfo.serviceFlow_Defect__c);  
                if(result.caseInfo.hasOwnProperty('serviceFlow_Customer_code__c') && result.caseInfo.serviceFlow_Customer_code__c){
                    
                    component.set("v.showCustomerSales",true);
                    component.set("v.customerCode",result.caseInfo.serviceFlow_Customer_code__c);
                }
                let Parameters_checked = result.caseInfo.serviceFlow_Parameters_checked__c;
                if(Parameters_checked){
                    component.set("v.parameters_checked_Values",Parameters_checked.replaceAll(" ", "_").split(";"));
                }
                component.set("v.as400data",result.as400data);
                component.set("v.userCaseConfigObj",result);     
                let caseObj = result.caseInfo;
                caseObj.serviceFlow_Customer_Email__c = result.hasOwnProperty('customerEmailPopulate') ? result.customerEmailPopulate : '';  
                component.set("v.caseObj",caseObj);                 
                component.set("v.showLoader",false);
            }
        })
        .catch(function(error) {
            console.log(JSON.stringify(error));
            component.set("v.showLoader",false);
        });
    },
    handleSave : function(component, event, helper,eventType) {
        let requiredLabels = [];
        let formValidationFields = Array.from(component.find("field"));
        for (let i = 0; i < formValidationFields.length; i++) {
            if (!formValidationFields[i].reportValidity()) {
                requiredLabels.push(formValidationFields[i].get("v.label"));
            }
        }
        if (requiredLabels.length > 0) {
            let errorMessage = '';
            requiredLabels.forEach(function(value, index) {
                index++;
                errorMessage += index + "." + value + "\n"
            });
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": requiredLabels.length + " Required fields are missing.",
                "message": errorMessage,
                "type": "error"
            });
            toastEvent.fire();            
        }else{
            component.set("v.showLoader",true);
            let caseObject = {};
            caseObject.sobjectType = 'Case';
            caseObject.Id = component.get("v.recordId");
            caseObject.Italy_Queue__c = 'Marked as Closed'; 
            let userCaseConfigObj = component.get("v.userCaseConfigObj");
            if(userCaseConfigObj){
                caseObject.OwnerId = userCaseConfigObj.teamInfo[0].Id;
            }
            let formFields = Array.from(component.find("field"));
            for (let i = 0; i < formFields.length; i++) {  
                caseObject[formFields[i].get("v.name")] = formFields[i].get("v.value") ? formFields[i].get("v.value") : '';            
            }
            if(caseObject.serviceFlow_Parameters_checked__c){
                let parameters = caseObject.serviceFlow_Parameters_checked__c.toString().replaceAll(',',';').replaceAll('_',' ');
                caseObject.serviceFlow_Parameters_checked__c = parameters;
            }
            helper.apexUtil(component,helper,'doUpsertCase',{
                caseRecord: [caseObject],
                eventType : eventType
            })
            .then(function(result){   
                if(result && result !=null){
                    window.location.reload(true) 
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get("e.force:refreshView").fire(); 
                    component.set("v.showLoader",false);
                }
            })
            .catch(function(error) {
                console.log(JSON.stringify(error));
                window.location.reload(true) 
                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire(); 
                component.set("v.showLoader",false);
            }); 
        }
    },
    apexUtil: function(component, helper, apexMethod, params) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get("c." + apexMethod + "");
            if (params) {
                action.setParams(params);
            }
            action.setCallback(this, function(response) {
                if (response.getState() == 'SUCCESS') {
                    resolve(response.getReturnValue());
                } else if (response.getState() == 'ERROR') {
                    helper.errorUtil(component, 'Error', response.getError()[0].message, 'error');
                    component.set("v.showLoader", false);
                }
            });
            $A.enqueueAction(action);
        }));
    },
    errorUtil: function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            duration: '1000',
            key: 'error_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
        component.set("v.showLoader", false);
    },
})