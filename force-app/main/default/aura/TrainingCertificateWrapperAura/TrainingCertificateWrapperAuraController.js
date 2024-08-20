({
    doInit : function(component, event, helper) {
        var accId = component.get("v.pageReference").state.c__recordIdId;
        component.set('v.accountId',accId);
    },
    closeSubtab: function(component, event) {
        var CloseClicked = event.getParam('close');
        //component.set('v.message', 'Close Clicked');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            //var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})