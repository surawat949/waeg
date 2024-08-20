({
    /**This class support for Barchart - Get Completed Visits in Last 30 days */

    getVisitDataMap : function(component, recordId, datetime1, VisitStatus, callback){
        var action = component.get('c.getVisitDataList');
        action.setParams({"recordId":recordId,
                            "datetime1":datetime1,
                            "VisitStatus":VisitStatus});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error during the connection.');
            }
        });
        $A.enqueueAction(action);
    },

    getinitVisitsCounting : function(component, recordId, callback){
        var action = component.get('c.initTotalVisits');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());

            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error had occurred during the apex connection.');
            }
        });
        $A.enqueueAction(action);
    },

    getInitsalesdata : function(component, recordId, callback){
        var action = component.get('c.initUserSales');
        action.setParams({"recordId":recordId});

        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state ==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Get initSales : Error during the connection');
            }
        });

        $A.enqueueAction(action);
    },
    /*
    getVisitRollupSummary : function(component, recordId, callback){
        var action = component.get('c.getVisitsRollupSummary');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get Visit Roll-up Summary error : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    */
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
        let searchPhrase = component.get("v.searchByVisitStart");
        
        if (!$A.util.isEmpty(searchPhrase)) {
            let allData = component.get("v.allData");
            let filteredData = allData.filter(record => record.Start_Date_Time__c.includes(searchPhrase));
            component.set("v.filteredData", filteredData);
            this.preparePagination(component, filteredData);
        }
    },
    /*
    getCompletedVisitBySegment : function(component, recordId, callback){
        var action = component.get('c.getCompletedVisitsBySegmentation');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    getCompletedVisitBySubArea : function(component, recordId, callback){
        var action = component.get('c.getCompletedVisitsBySubArea');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred : == >'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },*/

    getVisitStartDate : function(component, recordId, LastVisitDay, Visit_Status, callback){
        var action = component.get('c.getDataSetStartDate');
        action.setParams({"recordId":recordId, "LastVisitDay":LastVisitDay, "Visit_Status":Visit_Status});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state ==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get Error Getting Visit Start Date == >'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    sortData : function(component, fieldName, sortDirection){
        //console.log('XXX Sort Data == > '+JSON.stringify(data));
        var fname = fieldName;
        var data = component.get('v.data');
        var reverse = sortDirection !== 'desc';
        data.sort(this.sortByfield(fname, reverse));
        component.set('v.data', data);
        
    },
    sortByfield : function(field, reverse){
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})