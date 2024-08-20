({
    fetchOrders : function(component,event, helper) {
        component.set("v.spinner", true);
        let action = component.get("c.doGetTrackTraceOrders");
        action.setParams({
            "recordId": component.get("v.recordId")
        })
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                let result = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log(JSON.stringify(result));
                if(result && result.returnResult === "SUCCESS" && result.statusCode === 200){
                    let data = result.ordersList;
                    component.set("v.listOfOrders", data);                    
                    helper.preparePagination(component, data);
                    
                    component.set("v.isSplitViewEnabled", true);
                    component.set("v.spinner", false);
                }else{
                    component.set("v.data",[]); 
                    component.set("v.isSplitViewEnabled", true);
                    component.set("v.spinner", false);
                }
                component.set("v.isModalOpen", true);
                component.set("v.isSplitViewEnabled", true);
                component.set("v.spinner", false);
            }else{
                component.set("v.data",[]); 
                component.set("v.isSplitViewEnabled", true);
                component.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    preparePagination: function (component, records) {
        let countTotalPage = Math.ceil(records.length / component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        component.set("v.totalRecords", records.length);
        this.setPaginateData(component);
    },
    
    setPaginateData: function(component){
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let accountData = component.get('v.listOfOrders');
        let currentPageCount = 0;
        let x = (pageNumber - 1) * pageSize;
        currentPageCount = x;
        for (; x < (pageNumber) * pageSize; x++){
            if (accountData[x]) {
                data.push(accountData[x]);
                currentPageCount++;
            }
        }
        component.set("v.paginationList", data);
        component.set("v.currentPageRecords", currentPageCount);
    },
    preparePaginationTemp: function (component, records) {
        let countTotalPage = Math.ceil(records.length / component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        component.set("v.totalRecords", records.length);
        this.setPaginateDataTemp(component,records);
    },
    setPaginateDataTemp: function(component,records){
        let data = []; 
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let accountData = records;
        let currentPageCount = 0;
        let x = (pageNumber - 1) * pageSize;
        currentPageCount = x;
        for (; x < (pageNumber) * pageSize; x++){
            if (accountData[x]) {
                data.push(accountData[x]);
                currentPageCount++;
            }
        }
        component.set("v.paginationList", data);
        component.set("v.currentPageRecords", currentPageCount);
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var fname = fieldName;
        var data = cmp.get("v.listOfOrders");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.listOfOrders", data);
        this.setPaginateData(cmp);
    },
    
    sortBy: function (field, reverse) {
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    handleSort: function(component, event, helper) {
        debugger;
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var cloneData = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        cloneData.sort(this.sortBy(sortedBy, reverse))
        var columns = component.get("v.columns");
        var sortByCol = columns.find(column => sortedBy === column.fieldName);
        var sortedBylabel = sortByCol.label;
        component.set("v.sortedByLabel",sortedBylabel);        
        component.set('v.data', cloneData);
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', sortedBy);
    },
    showRowDetails: function(component, row){
        if(row){
            let detailedDetails = [];
            for (const [key, value] of Object.entries(row)) {
                detailedDetails.push({ label: key.toUpperCase(), value: value });
            }
            //detailedDetails.sort((a, b) => a - b); 
            console.log(JSON.stringify(detailedDetails)); 
            component.set("v.detailedDetails",detailedDetails);
        }
    }
})