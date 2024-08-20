({
    getUserCompany: function(component, visit, callback){
        var action = component.get("c.getUserCompany")
        action.setParams({"userId":visit.assigned_to__c});
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
        var action = component.get("c.getUserProfile")
        action.setParams({"userId":visit.assigned_to__c});
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
    
    getUserRegion : function(component, visit, callback){
        var action = component.get('c.getUserRegion');
        action.setParams({"userId":visit.assigned_to__c});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    getAccount: function(component, accountId, callback){
        var action = component.get("c.getAccount");
        action.setParams({"accId" : accountId});
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
    
    
    getContactsForAccount: function(component, accountId, callback) {
        var action = component.get("c.getContactsForAccount");
        action.setParams({
            "accountId" : accountId
        });
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

    getOpportunityByAccount:function(component, accountId, callback){
        var action = component.get("c.getOpportunityByAccountList");
        action.setParams({
            "accountId" : accountId
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === "ERROR"){
                callback(response.getError(), response.getReturnValue());
            }

        });
        $A.enqueueAction(action);
    },
    
    getVisit: function(component,visitId, callback) {

        var action = component.get("c.getVisit");
        action.setParams({
            "visitId": visitId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getAccountCampaignMember : function(component, accountId, helper){
        var action = component.get("c.getAccCampaignMember");
        action.setParams({
            "accountId" : accountId

        });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            component.set("v.ListCampaignMember", result);

        });
        $A.enqueueAction(action);
    }
})