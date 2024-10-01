({
    getContact : function(component, contactId, callback) {
        var action= component.get('c.getContact');
        action.setParams({"recordId": contactId});
        
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
    getUserEvents: function(component, start, end, userId, timezone, callback){
		var action = component.get("c.getUserIdEvents");
        action.setParams({
            "periodStart" : start,
            "periodEnd" : end,
            "userId" : userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
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
            var events = component.get('v.events') || [];
            while(events.length > 0) {
                events.pop();
            }
            var userEventList = userEvents.map(function(userEvent)
            {
                   return helper.userEventToCalendarEvent(userEvent, component, event, helper);
             });
              console.log('events',JSON.stringify(events));
            console.log('userEventList',JSON.stringify(userEventList));
			events.push(...userEventList);
            console.log('userEvents',JSON.stringify(userEvents));
            console.log('events',JSON.stringify(events));
            component.set('v.events',events);
        });
        
    },
    userEventToCalendarEvent: function(userEvent, component, event, helper) {
        var event = {};
        console.log('In userEventToCalendarEvent 1',JSON.stringify(userEvent));
        var timezone = $A.get('{!$Locale.timezone}');
        event.allDay = userEvent.IsAllDayEvent;
        event.start = moment(userEvent.StartDateTime).tz(timezone).format();
        event.end = moment(userEvent.EndDateTime).tz(timezone).format();
        console.log('In userEventToCalendarEvent 2',JSON.stringify(userEvent));
        event.sfid = userEvent.id;
        if(userEvent.RecordTypeId && userEvent.RecordType.DeveloperName == 'Lead_Visits'){
            event.backgroundColor = '#5867e8';
            event.title = "Lead Visit Event " + userEvent.Subject;
        }else{
        	event.backgroundColor = '#FF9411';
            event.title = "Event " + userEvent.Subject;
        }
        event.editable=false;
        event.visitId = userEvent.Visit__c ? userEvent.Visit__c : '';
        event.accountId = (userEvent.Visit__c && userEvent.Visit__r.Account__c) ? userEvent.Visit__r.Account__c : '';
        console.log('In userEventToCalendarEvent 3',JSON.stringify(userEvent));
        return event;
    },

    getStarndardVisit : function(component, callback){
        var action = component.get('c.getStarndardVisitRecordType');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(response.isValid && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
            }
           
        });

        $A.enqueueAction(action);
    }
})