({
    doInit: function(component, event, helper) {             
        component.set("v.isModalOpen", true);  
        helper.fetchOrders(component,event, helper);            
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    saveDetails: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },   
    handleSort: function(component, event, helper) {
        helper.handleSort(component, event, helper);   
    },    
    updateSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    handleNext: function(component, event, helper){        
        component.set("v.currentPageNumber", component.get("v.currentPageNumber") + 1);
        helper.setPaginateData(component);
    },
    
    handlePrevious: function(component, event, helper){
        component.set("v.currentPageNumber", component.get("v.currentPageNumber") - 1);
        helper.setPaginateData(component);
    },
    
    onFirst: function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPaginateData(component);
    },
    
    onLast: function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPaginateData(component);
    },
    handleChange: function (component, event) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedFilterValue",selectedOptionValue);    
    },
    searchTable: function (component, event, helper) {
        let allRecords = component.get("v.listOfOrders"); 
        let selectedFilterField = component.get("v.selectedFilterValue");
        let searchFilter = event.getSource().get("v.value").toLowerCase();
        console.log(selectedFilterField+"***"+searchFilter);
        let tempArray = allRecords.filter(element => {
            return element[selectedFilterField].toLowerCase().indexOf(searchFilter) != -1;
        });
        component.set("v.paginationList",[]);
        helper.preparePaginationTemp(component, tempArray);
    },
    handleDateFilter :function (component, event, helper) {
        let allRecords = component.get("v.listOfOrders");        
        let orderDateFrom = component.get("v.orderDateFrom");
        let orderDateTo = component.get("v.orderDateTo");
        if(!orderDateFrom){
            component.set("v.fromDateRequired",true);
        }else if(!orderDateTo){            
            component.set("v.toDateRequired",true);
        }else{
            let tempArray  = allRecords.filter(element => {
                return (
                new Date(element.orderDate) >= new Date(orderDateFrom) && 
                new Date(element.orderDate) <= new Date(orderDateTo)
                );
            });
            component.set("v.paginationList",[]);
            helper.preparePaginationTemp(component, tempArray);
        }        
    },
    dateFilters1 : function (component, event, helper) {
        component.set("v.fromDateRequired",false);
    },
    dateFilters2 : function (component, event, helper) {
        component.set("v.toDateRequired",false);
    },
    clearFilters :function (component, event, helper) {
        component.set("v.orderDateFrom","");
        component.set("v.orderDateTo","");
        
        let allRecords = component.get("v.listOfOrders");
        helper.preparePagination(component, allRecords);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(JSON.stringify(row));
        component.set("v.isSplitViewEnabled",false);
        switch (action.name) {
            case 'view_details':
                helper.showRowDetails(component, row);
                break;
            default:
                //helper.showRowDetails(row);
                break;
        }
    },
    handleClose : function (component, event, helper) {
        component.set("v.isSplitViewEnabled",true);
    },
    handleSaveEdition: function (component, event, helper) {
        let draftValues = event.getParam('draftValues');
        let action = component.get("c.insertTrackTraceActivities");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "jsonResponse" : JSON.stringify(draftValues)
        })
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                if(result.length){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": result.length + " - Record(s) are saved successfuly!"
                    });
                    toastEvent.fire();
                    component.set("v.isModalOpen", false);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"warning",
                        "title": "Warning!",
                        "message": "Something went wrong!"
                    });
                    toastEvent.fire();
                    component.set("v.isModalOpen", false);
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error",
                    "message": "Error occured, please try again"
                });
                toastEvent.fire();
                component.set("v.isModalOpen", false);
            }
        });
        $A.enqueueAction(action);
    },
    addViewComments: function (component, event, helper) {  
        if(!component.get("v.selectedRecordComment")){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": "Please enter comments"
            });
            toastEvent.fire();
        }else{
            let latestComment = component.get("v.selectedRecordComment") + component.get("v.addComment");
            let action = component.get("c.addComments");
            action.setParams({
                "recordId": component.get("v.recordId"),
                "orderNumber" : component.get("v.selectedRecordOrderNumber"),
                "comments" : latestComment
            })
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let result = response.getReturnValue();
                    if(result.length){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": result.length + " - Record(s) are saved successfuly!"
                        });
                        toastEvent.fire();
                        helper.fetchOrders(component,event, helper); 
                        //component.set("v.isModalOpen", false);
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"warning",
                            "title": "Warning!",
                            "message": "Something went wrong!"
                        });
                        toastEvent.fire();
                        component.set("v.isModalOpen", false);
                    }
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error",
                        "message": "Error occured, please try again"
                    });
                    toastEvent.fire();
                    component.set("v.isModalOpen", false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    handleClick: function (component, event, helper) {
        component.set("v.selectedValue",event.getSource().get("v.title"));        
        component.set("v.isSplitViewEnabled",false);
        component.set("v.selectedRecordOrderNumber",event.getSource().get("v.name"));
        let row = component.get("v.paginationList").find(item => item.orderNumber === event.getSource().get("v.name"));
        component.set("v.addComment", row.comment);
        component.set("v.selectedRecordComment","");
        helper.showRowDetails(component, row);
    },
    activeButton : function(component, event, helper){
        let inputText = component.get("v.addComment");
        if(inputText.length > 0){
            component.set('v.isButtonActive',false);
        }else{
            component.set('v.isButtonActive',true);
        }       
    },
})