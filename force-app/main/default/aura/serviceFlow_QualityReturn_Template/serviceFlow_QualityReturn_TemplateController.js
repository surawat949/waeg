({
    doInit : function(component, event, helper) {        
        helper.doInitHelper(component, event, helper);
    },
    handleSave: function(component, event, helper) {  
        helper.handleSave(component, event, helper,"save");
    },
    handleEscalationNextLevel: function(component, event, helper) {  
        helper.handleSave(component, event, helper,"esclate_Next_Level");
    },
    handlerSaveSendEmail : function(component, event, helper) {        
        helper.handleSave(component, event, helper,"save_send_email");
    },
    handleChange: function (component, event) {
        console.log(JSON.stringify(component.get("v.parameters_checked_Values")));
    },
    handleAS400Data :function(component, event, helper) {  
        component.set('v.issearching', true);
        component.set("v.showLoader",true);
        component.set("v.showCustomerSales",false);
        let isEnterKey = event.keyCode === 13;
        let latestCustomerCode;
        let formValidationFields = Array.from(component.find("field"));
        for (let i = 0; i < formValidationFields.length; i++) {
            if(formValidationFields[i].get("v.name") === 'serviceFlow_Customer_code__c'){
                latestCustomerCode = formValidationFields[i].get("v.value");
            }
        }
        component.set("v.showCustomerSales",true);
        component.set("v.customerCode",latestCustomerCode);
        component.set('v.issearching', false);
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.showLoader",false);
            }), 5000
        );
        /*
            component.set("v.showLoader",true);
            helper.apexUtil(component,helper,'fetchAS400Data',{
                customerCode : latestCustomerCode
            })
            .then(function(result){   
                if(result && result !=null){
                    component.set("v.as400data",result);
                }
                component.set("v.showLoader",false);
            })
            .catch(function(error) {
                console.log(JSON.stringify(error));
                component.set("v.showLoader",false);
            });
            */
    }
})