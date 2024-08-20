({
    doInit : function(component, event, helper){
        var recordId = component.get('v.recordId');
        helper.getUserCommentList(component, recordId, function(err, result){
            component.set('v.UserCommentList', result);
            console.log('Fetch data for User Comment == > '+JSON.stringify(result));
        });
    },

    handleLoad : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
    },

    handleSuccess: function(component, event, helper) {
        // Show toast
        var recordId = component.get('v.recordId');
        component.set('v.reloadForm',false);
        component.set('v.reloadForm', true);
        $A.util.addClass(component.find("spinner"), "slds-hide"); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Comment was added Successfully."
        });
        toastEvent.fire();
        //var refresh = $A.get("e.force:refreshView");
        //refresh.fire();
        //window.location.reload()
        helper.getUserCommentList(component, recordId, function(err, result){
            component.set('v.UserCommentList', result);
        });
    },
    toggleAcitivity : function(component, event, helper) {
        // toggle ‘slds-is-open’ class to expand/collapse activity section
        $A.util.toggleClass(component.find('expId'), 'slds-is-open');
    }
})