({
    doInit : function(component, event, helper) {
       component.find('ReferenceNumber').set('v.value', '***PLEASE DO NOT CHANGE***');
	},
    handleLoad : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
    },

    handleSuccess: function(component, event, helper) {
        // Show toast
        var recordId = component.get('v.recordId');
        component.set('v.reloadForm',false);
        component.set('v.reloadForm', true);
        $A.util.addClass(component.find("spinner"), "slds-hide"); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "New Product was added Successfully."
        });
        toastEvent.fire();
        //var refresh = $A.get("e.force:refreshView");
        //refresh.fire();
        //window.location.reload()

        var params = event.getParams();
        component.find("navService").navigate({
            "type": "standard__recordPage",
            "attributes": {
                "recordId": params.response.id,
                "objectApiName": "APAC_Product__c",
                "actionName": "view"
            }
        });
        
    },
    toggleAcitivity : function(component, event, helper) {
        // toggle ‘slds-is-open’ class to expand/collapse activity section
        $A.util.toggleClass(component.find('expId'), 'slds-is-open');
    },
    closeButton : function(component, event, helper){
        component.set('v.displayModal', false);
    },
    cancelButton : function(component, event, helper){
        component.set('v.displayModal', false);
    },
    gotoList : function (component, event, helper) {
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "APAC_Product__c"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    RequestTypeChange : function(component, event, helper){
        var RequestType = component.find('RequestType').get('v.value');
        console.log('Request type is '+RequestType);

        if(RequestType == '' || RequestType==null){
            component.set('v.displaySection', '');
            component.set('v.displayInvent', '');

        }else if(RequestType == 'New Product Introduction'){
            component.set('v.displaySection', 'section1');
            component.set('v.displayInvent', '');
        }else if(RequestType == 'Product Conversion'){
            component.set('v.displaySection', 'section3');
            component.set('v.displayInvent', '');
        }else if(RequestType == 'Product Removal'){
            component.set('v.displaySection', 'section2');
            component.set('v.displayInvent', 'section1');
        }else{
            component.set('v.displaySection', '');
            component.set('v.displayInvent', '');
        }
    }
})