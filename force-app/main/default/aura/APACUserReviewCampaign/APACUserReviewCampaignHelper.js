({
    callActionAsPromise : function(component, helper, actionName, params) {
        return new Promise($A.getCallback(function(resolve, reject) {
            let action = component.get(actionName);
            action.setParams(params);
            action.setCallback(helper, function(actionResult) {
                if (actionResult.getState() === 'SUCCESS') {
                    resolve({'component':component, 'helper':helper, 'result':actionResult.getReturnValue()});
                } else {
                    let errors = actionResult.getError();
                    reject(new Error(errors && Array.isArray(errors) && errors.length === 1 ? errors[0].message : JSON.stringify(errors)));
                }
            });
            $A.enqueueAction(action);
        }));
    },

    getActiveCampaign : function(component, recordId, callback) {
        var action = component.get('c.getActiveAccCampaign');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred == >'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    getCampaignNotPresented : function(component, recordId, callback){
        var action = component.get('c.getCampaignNotPresented');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state ==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred == >'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    getLevelInterested : function(component, recordId, callback){
        var action = component.get('c.getCampaignLevelInterested');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred == >'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    getTargetCampaign : function(component, recordId, callback){
        var action = component.get('c.getActiveTargetCampaign');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred == >'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    preparePagination: function (component, records, recordId) {
        var recordId = component.get('v.recordId');
        let countTotalPage = Math.ceil(records.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
 
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        console.log('XXX Get Visit Data == >'+JSON.stringify(data));
        component.set("v.data", data);
    },
    
    searchRecordsBySearchPhrase : function (component) {
        let searchPhrase = component.get("v.searchByPicklist");
        
        if (!$A.util.isEmpty(searchPhrase)) {
            let allData = component.get("v.allData");
            let filteredData = allData.filter(record => record.Campaign_Name__c.includes(searchPhrase));
            component.set("v.filteredData", filteredData);
            this.preparePagination(component, filteredData);
        }
    },

    getCentralCampaignName : function(component, recordId, callback){
        var action = component.get('c.getDataSetCampaignName');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error was occurred during == >'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})