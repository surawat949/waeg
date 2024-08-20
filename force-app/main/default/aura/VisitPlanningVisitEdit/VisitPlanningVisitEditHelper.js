/**
 * Created by thomas.schnocklake on 14.02.18.
 */
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

    getCampaignMember : function(component, visit, callback){
        var action = component.get("getAccCampaign");
        action.setParams({"campaignId":component.get('v.campaignId')});

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
    
    getOpportunityByAccountList: function(component, accountId, callback) {
        var action = component.get("c.getOpportunityByAccountList");
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
    
    getOppStageByAccountId: function(component, accountId, callback) {
        var action = component.get("c.getOppStageByAccount");
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

    getOppCloseDateByAccountId: function(component, accountId, callback) {
        var action = component.get("c.getOppCloseDateByAccount");
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
    /*
    getCampaignMemberAccount : function(component, accountId, campaignId, helper){
        var action = component.get("c.getAccCampaignMember");
        action.setParams({
            "accountId":accountId,
            "campaignId":campaignId
        });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
                component.set("v.ListAccCamapignMember", result);

        });
        $A.enqueueAction(action);
    },
    */
    getOpportunityMember : function(component, accountId, helper){
        var action = component.get("c.getOpportunityMember");
        action.setParams({
            "accountId":accountId

        });
        action.setCallback(this, function(response){

            var result = response.getReturnValue();
            component.set('v.ListOpportunityMember', result);
        });
        $A.enqueueAction(action);
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
    },
    
    getNewStageOpportunity:function(component, helper){
        var action = component.get("c.getNewStageName");
        action.setCallback(this, function(response){
            var state = response.getState();

            if(state==="SUCCESS"){
                var newStageList = [{}].concat(response.getReturnValue());
                component.set("v.newStageList", newStageList);
            }
        });
        $A.enqueueAction(action);
    },

    getCampaignInterested:function(component, helper){
        var action = component.get("c.getCampaignInterested");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state==='SUCCESS'){

                var CampaignInterested1= [{}].concat(response.getReturnValue());
                component.set("v.CampaignInterested1", CampaignInterested1);
            }
            
        });
        $A.enqueueAction(action);
    },

    getCampaignInterested2:function(component, helper){
        var action = component.get("getCampaignInterested2");
        action.setCallback(this, function(response){
            var state = response.getState();

            if(state==='SUCCESS'){
                var CampaignInterested2 = [{}].concat(response.getReturnValue());
                component.set("v.CampaignIntersted2", CampaignInterested2);
            }

        });
        $A.enqueueAction(action);
    },

    getCampaignInterested3:function(component, helper){
        var action = component.get("getCampaignInterested3");
        action.setCallback(this, function(response){

            var state = response.getState();
            if(state === 'SUCCESS'){
                var CampaignInterested3 = [{}].concat(response.getReturnValue());

            }
        });
        $A.enqueueAction(action);
    },

    getCampaignListByAccount: function(component, accountId, callback) {
        var action = component.get("c.getCampaignListByAccount");
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

    getCampaignList: function(component, helper){
        var action = component.get("c.getCampaignList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var campaignList = [{}].concat(response.getReturnValue());

                component.set('v.campaignList', campaignList);
            }
        });
        $A.enqueueAction(action);
    },
	/*
    getStageName2: function(component, helper){
        var action = component.get("c.getOpportunityStageName2");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var stageList = [{}].concat(response.getReturnValue());
                component.set('v.stageList', stageList);
            }
        });
        $A.enqueueAction(action);
    },
    */
    /*
    getOpportunityList: function(component, helper){

        var action = component.get("c.opportunityList");
        
        action.setCallback(this, function(response){
            var state = response.getState();

            if(state==="SUCCESS") {

                var opportunityList = [{}].concat(response.getReturnValue());
                component.set('v.opportunityList', opportunityList);
            }
        });
        $A.enqueueAction(action);
    },
    */
	upsertVisit: function(component, visit, callback) {
		//console.log('upsertVisit');

// http://salesforce.stackexchange.com/questions/113816/refresh-a-jquery-accordion-in-a-lightning-component
// https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/js_cb_mod_ext_js.htm

        window.setTimeout(
            $A.getCallback(function(){
                var action = component.get("c.upsertVisit");
                action.setParams({
                    "visit" : visit
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (component.isValid() && state === "SUCCESS") {
                        console.log('visit',response.getReturnValue());
                        callback(null, response.getReturnValue());
                    }
                    else if (component.isValid() && state === "ERROR") {
                        console.log('events',response.getReturnValue());
                        callback(response.getError(), response.getReturnValue());
                    }
                });
                $A.enqueueAction(action);
        }),0);

	},
	deleteVisit: function(component, visit, callback) {
		console.log('upsertVisit');

// http://salesforce.stackexchange.com/questions/113816/refresh-a-jquery-accordion-in-a-lightning-component
// https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/js_cb_mod_ext_js.htm

        window.setTimeout(
            $A.getCallback(function(){
                var action = component.get("c.deleteVisit");
                action.setParams({
                    "visit" : visit
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (component.isValid() && state === "SUCCESS") {
                        console.log('visit',response.getReturnValue());
                        callback(null, response.getReturnValue());
                    }
                    else if (component.isValid() && state === "ERROR") {
                        console.log('events',response.getReturnValue());
                        callback(response.getError(), response.getReturnValue());
                    }
                });
                $A.enqueueAction(action);
        }),0);

	}
})