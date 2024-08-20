({
    
    getUserCompany: function(component, visit, callback){
        var action = component.get("c.getUserCompany");
        action.setParams({"userId":visit.assigned_to__c});
        action.setParam('campaignId', component.get("v.campaignId"));
        action.setParam('campaignList', component.get("v.campaignList"));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },

    getUserProfile: function(component, visit, callback){
        var action = component.get("c.getUserProfile");
        action.setParams({"userId":visit.assigned_to__c});
        action.setParam('campaignId', component.get("v.campaignId"));
        action.setParam('campaignList', component.get("v.campaignList"));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    getOpportunityByAccountList: function(component, accountId, callback) {
        var action = component.get("c.getOpportunityByAccountList");
        action.setParams({"accountId" : accountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getOpportunityMember : function(component, accountId, helper){
        var action = component.get("c.getOpportunityMember");
        action.setParams({"accountId":accountId});
        action.setCallback(this, function(response){

            var result = response.getReturnValue();
            component.set('v.ListOpportunityMember', result[0]);
        });
        $A.enqueueAction(action);
    },
    getOpportunity : function(component, oppId, callback){
        var action = component.get("c.getOpportunity");
        action.setParams({"oppId":oppId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action)
    },
    getAccCampaignMember : function(component, accountId, helper){
        var action = component.get("c.getAccCampaignMember");
        action.setParams({
            "accountId" : accountId
        });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            component.set('v.ListCampaignMember', result);

        });
        $A.enqueueAction(action);
    }
})