({
    getActiveCampaignMemberControler : function(component, callback){
        var action= component.get('c.getCampaignMemberList');
        action.setParams({"accId": component.get("v.recordId")});

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

    savePresented: function(component, callback){
        var action= component.get('c.saveCampaignMember');
        var cmId = component.get("v.cmId");
        var presented = component.get("v.presented");

        action.setParams({"cmId": cmId, "presented": presented});
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
    }
})