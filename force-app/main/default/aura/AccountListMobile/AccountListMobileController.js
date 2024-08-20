/**
 * Created by thomas.schnocklake on 23.01.18.
 */
({
    init: function (component, event, helper) {
    },
    changeValue : function (component, event, helper) {
        component.set('v.columns', [
                {label: 'Hoya Account Id', fieldName:'Hoya_Account_ID__c', type:'text'},
                {label: 'Account name', fieldName: 'Name', type: 'text'},
                {label: 'Account id', fieldName: 'Id', type: 'text'}
            ]);
    },
    colsChange : function (component, event, helper) {
        helper.handleListOrColsChange(component, event, helper);
        
    },
    objectListChange : function (component, event, helper) {
        helper.handleListOrColsChange(component, event, helper);
        component.set('v.fromIndex',0);
    },
    addDND : function (component, event, helper) {
        helper.attachDND(component, event, helper);
    },
    editVisit : function(cmp, event, helper)
    {
        // redirect to visitPlanningVisitEditMobile cmp
        var navService = cmp.find("navService");
        var accountId = event.target.id;
        var visitId = '';//'001b000003z4lNbAAI';
   
        var pageReference = {
            
            "type": "standard__component",
            "attributes": {
                "componentName": "c__VisitPlanningVisitEditMobileForm"    
            },    
            "state": {
                "c__accountId": accountId,
                "c__visitId": visitId
            }
        };
        cmp.set("v.pageReference", pageReference);
        var defaultUrl = "#";

        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            cmp.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));
        event.preventDefault();
        navService.navigate(pageReference);
    },
    toggleSection : function(cmp, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv;
        // get section Div element using aura:id
        try{
            if(sectionAuraId==null) { 
                const items = cmp.find("item_div");
                if (!items) return;
                if ($A.util.isArray(items)) {
                    items.forEach(item => {
                        if (item.getElement().style.display === "none") {
                            item.getElement().style.display = "block";
                        } else {
                            item.getElement().style.display = "none";
                        }
                    })
                }
            } else {
                sectionDiv = cmp.find('item_div')[sectionAuraId].getElement();//document.getElementById(sectionAuraId);
                if (sectionDiv.style.display === "none") {
                sectionDiv.style.display = "block";
            } else {
                sectionDiv.style.display = "none";
            }
            }
        } catch(err){
            console.log(err);
        }
     
    }
})