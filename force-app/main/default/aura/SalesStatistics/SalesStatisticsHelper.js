({
    /*initSales : function(component, accountId, callback){
        var action= component.get('c.initSales');
        action.setParams({"recordId": accountId});

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

    },*/
    
    initAccount : function(component, accountId, callback) {
        var action= component.get('c.getAccount');
        
        action.setParams({"recordId": accountId});

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
    }/*,
    initRelatedSales: function(component, accountId, currentFiscalYear, callback){
        var action= component.get('c.getRelatedSalesList');
        action.setParams({"recordId": accountId, "currentFiscalyear": currentFiscalYear});

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
    getAccountIndex: function(list, accountId, type){
        var index = -1;
        var str = accountId;
        if(accountId==='Total CFY'){
            str = 'Total LFY'
        } 

        for(let i=0;i<list.length;i++){
            if(list[i].hoya_account_id == str && list[i].type==type){
                index=i;
            }
        }
        return index;
    }*/
})