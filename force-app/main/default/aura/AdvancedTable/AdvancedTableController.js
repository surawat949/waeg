/**
 * Created by thomas.schnocklake on 23.01.18.
 */
({
    init: function (component, event, helper) {
        
        
       
        
    },
    jsLoaded : function(component, event, helper) {
        helper.attachDND(component, event, helper);

            $('#idTableScroller').find('div').width($('#idScrolledtable').find('table').width());
            $('#idTableScroller').scroll(function(e) {
                $('#idScrolledTable').scrollLeft($('#idTableScroller').scrollLeft());
            });
            //$('.xxscrolledtable').scroll(function(e) {
            //    $('.tablescroller').scrollLeft($('.scrolledtable').scrollLeft());
            //});
    },

    prev : function (component, event, helper) {
        component.set('v.fromIndex',component.get('v.fromIndex') - component.get('v.pageSize'));
        helper.attachDND(component, event, helper);
    },
    next : function (component, event, helper) {
        component.set('v.fromIndex',component.get('v.fromIndex') + component.get('v.pageSize'));
        helper.attachDND(component, event, helper);
    },
    onSortClick : function (component, event, helper) {
        var whichOne = event.getSource().get('v.value');
        //console.log(whichOne);

        var sortField = component.get('v.sortField');
        var sortDir = component.get('v.sortDir');
        console.log('sortfield=' + sortField);

        if (sortField === whichOne)
        {
            if (sortDir === 'desc')
            {
                sortDir = 'asc';
            }
            else
            {
                sortDir = 'desc'
            }
        }
        else
        {
            sortField = whichOne;
            sortDir = 'asc';
        }
        component.set('v.sortField', sortField);
        component.set('v.sortDir', sortDir);
        component.set('v.fromIndex', 0);
        helper.handleListOrColsChange(component, event, helper);
    },
    changeValue : function (component, event, helper) {
        component.set('v.columns', [
                {label: 'Account name', fieldName: 'Name', type: 'text'},
                {label: 'Account id', fieldName: 'Id', type: 'text'}
            ]);
    },
    colsChange : function (component, event, helper) {
        helper.handleListOrColsChange(component, event, helper);
        
    },
    objectListChange : function (component, event, helper) {
        helper.handleListOrColsChange(component, event, helper);
        component.set('v.fromIndex',0);
    },
    addDND : function (component, event, helper) {
        helper.attachDND(component, event, helper);
    },
})