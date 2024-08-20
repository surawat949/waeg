/**
 * Created by thomas.schnocklake on 14.02.18.
 */
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
    getAccount: function(component, accountId, callback){
        var action = component.get("c.getAccount");
        action.setParams({"accid" : accountId});
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
    getTranslations: function(component, event, helper, callback) {
		// https://fullcalendar.io/docs/event_data/Event_Object/
		console.log('getTranslations');

        var action = component.get("c.getTranslations");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('got translations: ' , response.getReturnValue());
                callback(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})