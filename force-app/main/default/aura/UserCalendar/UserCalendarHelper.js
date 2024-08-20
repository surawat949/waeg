({
    getUserEvents: function(component, start, end, userId, timezone, callback){
		//console.log('in getUSerEvents');
		var action = component.get("c.getUserIdEvents");
        action.setParams({
            "periodStart" : start,
            "periodEnd" : end,
            "userId" : userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //console.log('got user-events: ' , response.getReturnValue());
                callback(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    updateCalenderEvents: function(component, event, helper)
    {
        var view = $('#calendar').fullCalendar('getView');
        var userId = component.get("v.userId");
        
        helper.getUserEvents(component, view.start.toDate(), view.end.toDate(), userId, null, function(userEvents)
        {
        	//CDU user event implementation
            var events = component.get('v.events');
            while(events.length > 0) {
                events.pop();
            }
            var userEventList = userEvents.map(function(userEvent)
            {
                   return helper.userEventToCalendarEvent(userEvent, component, event, helper);
             });
            events.push.apply(event, userEventList);
            component.set('v.events',events);
        });
        
    },
    userEventToCalendarEvent: function(userEvent, component, event, helper) {
        var event = {};
        var timezone = $A.get('{!$Locale.timezone}');
        event.allDay = userEvent.IsAllDayEvent;
        //event.start = new Date(userEvent.StartDateTime);
        //event.end = new Date(userEvent.EndDateTime);
        event.start = moment(userEvent.StartDateTime).tz(timezone).format();
        event.end = moment(userEvent.EndDateTime).tz(timezone).format();
     
        event.title = "Event " + userEvent.Subject;
        event.sfid = userEvent.id;
        event.backgroundColor = '#FF9411';
        event.editable=false;
        return event;
    },
    getAccount : function(component, oppId, callback){
        var action= component.get('c.getAccountByOpportunity');
        action.setParams({"oppId": oppId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})