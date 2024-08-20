({
  	initSales : function(component, accountId, callback){
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

    },
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
    },
  	initRelatedSales: function(component, accountId, callback){
        var action= component.get('c.getRelatedSalesList');
        action.setParams({"recordId": accountId});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            console.log(response.getReturnValue());
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