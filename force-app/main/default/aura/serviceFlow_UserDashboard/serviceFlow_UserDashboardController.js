({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    handleFilters : function (component, event, helper) {
        let clickedDashboard = event.currentTarget.dataset.value;      
        if(clickedDashboard == 'totalCases'){
        	$A.util.addClass(component.find('totalCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('openCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksClosed'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsClosed'), 'boxdynamiccss');
        }else if(clickedDashboard == 'openCases'){
            $A.util.removeClass(component.find('totalCases'), 'boxdynamiccss');
            $A.util.addClass(component.find('openCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksClosed'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsClosed'), 'boxdynamiccss');
        }else if(clickedDashboard == 'tasksOpen'){
            $A.util.removeClass(component.find('totalCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('openCases'), 'boxdynamiccss');
            $A.util.addClass(component.find('tasksOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksClosed'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsClosed'), 'boxdynamiccss');
        }else if(clickedDashboard == 'tasksClosed'){
            $A.util.removeClass(component.find('totalCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('openCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksOpen'), 'boxdynamiccss');
            $A.util.addClass(component.find('tasksClosed'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsClosed'), 'boxdynamiccss');
        }else if(clickedDashboard == 'callsOpen'){
            $A.util.removeClass(component.find('totalCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('openCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksClosed'), 'boxdynamiccss');
            $A.util.addClass(component.find('callsOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsClosed'), 'boxdynamiccss');
        }else if(clickedDashboard == 'callsClosed'){
            $A.util.removeClass(component.find('totalCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('openCases'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksOpen'), 'boxdynamiccss');
            $A.util.removeClass(component.find('tasksClosed'), 'boxdynamiccss');
            $A.util.removeClass(component.find('callsOpen'), 'boxdynamiccss');
            $A.util.addClass(component.find('callsClosed'), 'boxdynamiccss');
        }
    }
})