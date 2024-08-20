({
    doInit : function(component, event, helper) {
        helper.getActiveCampaignMemberControler(component, function(err, result){
            component.set('v.memberList', result);
        });
    },

    updatePresented: function(component, event, helper){
        var memberList = component.get('v.memberList');
        //alert ('array size=' + memberList.length);
        var confirmMessage = $A.get("$Label.c.Confirm_update");
        var userconfirm = confirm(confirmMessage + ' ?');
        if(userconfirm==true) {
            for (var i = 0; i<memberList.length; i++ ){
                component.set('v.presented', memberList[i].Campaign_Presented__c);
                component.set('v.cmId', memberList[i].Id);
                helper.savePresented(component, function(err, result){

                });
            }
        } else {
            helper.getActiveCampaignMemberControler(component, function(err, result){
                component.set('v.memberList', result);
            });
        }
    }


})