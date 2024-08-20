/**
 * Created by thomas.schnocklake on 16.02.18.
 */
({
    handleSelectedAccountFieldListChange: function(component, event, helper) {

    },
    handleCancel : function(component, event, helper)
    {
        var compEvent = component.getEvent("decisionresult");
        compEvent.setParams({"result" : 'Cancelled' });
        compEvent.fire();
    },
    handleSave : function(component, event, helper)
    {
        var compEvent = component.getEvent("decisionresult");
        compEvent.setParams({"result" : 'Saved' });
        compEvent.fire();
    },

})