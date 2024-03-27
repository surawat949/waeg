({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if(recordId!=null){
            helper.initSeikoData(component, recordId, function(err, result){
                component.set('v.seikoData', result);
            });
            
            helper.initAccount(component, recordId, function(err, result){
                component.set('v.account', result);
            });
            helper.initRelatedAccount(component, recordId, function(err, result){
                component.set('v.relatedAccount', result);
            });
        }
    }
})