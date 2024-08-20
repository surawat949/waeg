({
    doInit : function(component, event, helper) {
        helper.getActiveCampaignMemberControler(component, function(err, result){
            component.set('v.memberList', result);
        });
    },
})