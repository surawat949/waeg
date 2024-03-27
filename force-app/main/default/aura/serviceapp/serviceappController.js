({
    init: function (cmp,event,helper) {
        cmp.set('v.updatedCount', 12);
        cmp.set('v.selectedItem', 'my_cases');
        cmp.set('v.currentContent', 'my_cases');
        
        helper.setColumns(cmp);
        helper.setData(cmp);
    },
    
    handleSelect: function(component, event, helper) {
        let selected = event.getParam('name');
        component.set('v.currentContent', selected);
    },
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    }
});