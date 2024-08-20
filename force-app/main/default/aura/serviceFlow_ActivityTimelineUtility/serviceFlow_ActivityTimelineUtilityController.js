({
	doInit : function(component, event, helper) {
        component.set("v.isLoading",true);
        var action = component.get("c.getActivityTimeline");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "eventType" : component.get("v.eventType")
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var timelineGroups = response.getReturnValue();
                var activeSections = [];                
                timelineGroups.forEach(function(timelineGroup, index){
                    var sectionName = 'Section'+index;
                    activeSections.push(sectionName);
                    timelineGroup.sectionName = sectionName;
                    timelineGroup.items.forEach(function(activityDateField, index){
                        activityDateField.activityDate = activityDateField.hasOwnProperty('activityDate') ? activityDateField.activityDate : 'No due date';
                    });
                });
                console.log(JSON.stringify(timelineGroups));
                component.set("v.timelineGroups", timelineGroups);
                component.set("v.activeSections", activeSections);
                component.set("v.isLoading",false);
            }
        });
        $A.enqueueAction(action);
    },
})