({
    initSales : function(component, accountId, callback) {
        var action = component.get('c.initSales');
        console.log('XXX Get Data for Account Id : '+accountId);
        action.setParams({"accountId":accountId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection.');
            }

        });
        $A.enqueueAction(action);
    },

    initAccount : function(component, accountId, callback){
        var action = component.get('c.getAccount');
        console.log('XXX Get data initAccount == > '+accountId);

        action.setParams({"accountId":accountId});

        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Error during the connection XXX.');
            }
        });
        $A.enqueueAction(action);
    },

    initRelatedSales: function(component, accountId, currentFiscalYear, callback){
        var action= component.get('c.getRelatedSalesList');
        action.setParams({"recordId": accountId, "currentFiscalyear": currentFiscalYear});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('Success to pull data');
                callback(null, response.getReturnValue());
                
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection');
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
    }
})