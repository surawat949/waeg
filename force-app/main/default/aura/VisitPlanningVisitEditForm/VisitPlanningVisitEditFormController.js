({
    doInit : function(component, event, helper)
    {
        //console.log('doInit VisitPlanningVisitEdit');
        var visit = component.get('v.visit');
        
        component.set('v.campaignId', visit.Campaign__c);
        component.set('v.opportunityId',visit.Opportunity__c);
        component.set("v.isdisabled", visit.Visit_Status__c === 'Complete');

        helper.getOpportunityByAccountList(component, visit.Account__c, function(err, options){
            if(options.length>1){
                component.set('v.hasOpportunity', true);
                //force opportunity for new visit
                if(visit.Id==null || visit.Id=='' || visit.Id=='undefined'){
                    component.set('v.visit.Opportunity__c', options[1].value);
                    component.set('v.opportunityId',options[1].value);
                }
            } else {
                component.set('v.hasOpportunity', false);
            }
        });
        /*helper.getOpportunityMember(component, visit.Account__c, function(err, result){
            component.set('v.ListOpportunityMember', result);
            component.set('v.hasOpportunity', true);

        });*/
        if(visit.Opportunity__c!=null && visit.Opportunity__c!=''){
            helper.getOpportunity(component, visit.Opportunity__c, function(err, result){
                component.set('v.Opportunity', result[0]);
            });
        }
        helper.getUserCompany(component, visit, function(err, companyName){
            component.set('v.companyName', companyName);
            component.set('v.specificMkgSection', companyName=='HLHK' || companyName=='HOLK' || companyName=='SOC' || companyName=='HLSH' || companyName=='HLSI');
            if(companyName=='HAPL' || companyName=='HLHK' || companyName=='HOLK' || companyName=='ILENS' || companyName=='HOLM'|| companyName=='THAI'|| companyName=='HLSI'|| companyName=='HLSH'
            || companyName=='SOC'|| companyName=='HLPH'|| companyName=='HLID'
            || companyName=='HOLA' || companyName=='HLCA' || companyName=='VEUS' ){
                //component.set('v.displayStartStop',false);
            }
            if(companyName=='HOLA' ||companyName=='HLCA' ||companyName=='VEUS' ||companyName=='SRX'){
                component.set('v.isHVNA', true);
            }
        });
        helper.getUserProfile(component, visit, function(err, profileName){
            component.set('v.profileName', profileName);
        });
        
        helper.getAccCampaignMember(component, visit.Account__c, function(err, result){
            component.set('v.ListCampaignMember', result);

        });

    },
    handleSave : function(component, event, helper)
    {
        component.set('v.spinner',true);
        var picklistField = component.find("picklistFieldPlanning");
        picklistField.set("v.value", "Visit Planning");
        component.find('visitEditForm').submit();
        window.setTimeout(
       $A.getCallback(function() {
        component.set('v.spinner',false);
    }), 3000
);
    },
    handleCancel : function(component, event, helper)
    {
        var compEvent = component.getEvent("decisionresult");
        compEvent.setParams({"result" : 'Cancelled' });
        compEvent.fire();
    },
    handleSuccess: function(component, event, helper) {
        // Show toast
        $A.util.addClass(component.find("spinner"), "slds-hide"); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Visit updated with success"
        });
        toastEvent.fire();
        //var refresh = $A.get("e.force:refreshView");
        //refresh.fire();
        
        var compEvent = component.getEvent("decisionresult");
        compEvent.setParams({"result" : 'Saved' });
        compEvent.fire();
    },
    handleOpportunityChange: function(component, event, helper){
        // update opportunity form
        var value = event.getSource().get("v.value");
        
        if(value!=null && value.toString()!='' && value.toString()!='undefined'){
            component.set('v.opportunityId',value.toString());
            helper.getOpportunity(component, value.toString(), function(err, result){
                component.set('v.Opportunity', result[0]);
            });
        }
    },
    handleCampaignChange: function(component, event, helper){
        // update opportunity form
        var value = event.getSource().get("v.value");
        
        if(value!=null && value.toString()!='' && value.toString()!='undefined'){
            component.set('v.campaignId',value.toString());
        }
    },
    handleLoadOpportunity : function(component, event, helper) {
        console.log("loaded record form");
        let mode = (component.get("v.modeOpportunity")==='view') ? 'edit' : 'view';
        var elements = document.getElementsByClassName("visitButtons");
        if(mode==='edit'){
            elements[0].style.display = 'none';
        } else {
            elements[0].style.display = 'block';
        }
        if(component.get("v.afterSaveOpp")===true){
            component.set('v.afterSaveOpp',false);
            elements[0].style.display = 'block';
            mode='view';
        }
        component.set("v.modeOpportunity",mode);
    },
    handleSuccessOpportunity : function(component, event, helper) {
        component.set('v.modeOpportunity', 'view');
        component.set('v.afterSaveOpp',true);
        var elements = document.getElementsByClassName("visitButtons");
        elements[0].style.display = 'block';
    },
    handleLoadCampaign : function(component, event, helper) {
        console.log("loaded record form");
        let mode = (component.get("v.modeCampaign")==='view') ? 'edit' : 'view';
        var elements = document.getElementsByClassName("visitButtons");
        if(mode==='edit'){
            elements[0].style.display = 'none';
        } else {
            elements[0].style.display = 'block';
        }
        if(component.get("v.afterSaveCamp")===true){
            component.set('v.afterSaveCamp',false);
            elements[0].style.display = 'block';
            mode='view';
        }
        component.set("v.modeCampaign",mode);
    },
    handleSuccessCampaign : function(component, event, helper) {
        component.set('v.modeCampaign', 'view');
        component.set('v.afterSaveCamp',true);
        var elements = document.getElementsByClassName("visitButtons");
        elements[0].style.display = 'block';
    }
})