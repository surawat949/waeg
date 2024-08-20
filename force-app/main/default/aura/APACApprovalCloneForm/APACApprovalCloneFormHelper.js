({
    getProductList : function(component, recordId, callback) {
        var action = component.get('c.getProductListRecord');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get APAC_Product__c list error == > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})