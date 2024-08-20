({
    doInit : function(component, event, helper) {
        var accountId = component.get('v.recordId');

        //console.log('Account id is '+accountId);
        
        if(accountId!=null){
            helper.initAccount(component, accountId, function(err, result){
                component.set('v.account', result);
                //console.log('Get Account '+JSON.stringify(result));
            });
        }
    }

})