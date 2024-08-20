/**
 * Created by thomas.schnocklake on 04.01.18.
 */
({
	getVisit: function(component,visitId, callback) {
		// https://fullcalendar.io/docs/event_data/Event_Object/
		//console.log('in getVisit');

        var action = component.get("c.getVisit");
        action.setParams({
            "visitId": visitId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //console.log('got visits: ' , response.getReturnValue());
                callback(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
	getEvents: function(component,start, end, timezone, callback) {
		// https://fullcalendar.io/docs/event_data/Event_Object/
		//console.log('in getEventList');

        var action = component.get("c.getVisits");
        action.setParams({
            "periodStart" : start,
            "periodEnd" : end
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //console.log('got visits: ' , response.getReturnValue());
                callback(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    //CDU Start user-event implementation
    getUserEvents: function(component, start, end, timezone, callback){
		//console.log('in getUSerEvents');
		var action = component.get("c.getUserEvents");
        action.setParams({
            "periodStart" : start,
            "periodEnd" : end
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
    //CDU end user-event
    //
	upsertVisit: function(component, visit, callback) {
		//console.log('addVisit');

// http://salesforce.stackexchange.com/questions/113816/refresh-a-jquery-accordion-in-a-lightning-component
// https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/js_cb_mod_ext_js.htm

        window.setTimeout(
            $A.getCallback(function(){

                var action = component.get("c.upsertVisit");
                action.setParams({
                    "visit" : visit
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (component.isValid() && state === "SUCCESS") {
                        //console.log('visit',response.getReturnValue());
                        callback(null, response.getReturnValue());
                    }
                    else if (component.isValid() && state === "ERROR") {
                        //console.log('events',response.getReturnValue());
                        callback(response.getError(), response.getReturnValue());
                    }
                });
                $A.enqueueAction(action);
        }),0);

	},
    updateCalenderEvents: function(component, event, helper)
    {
        var view = $('#calendar').fullCalendar('getView');
        helper.getEvents(component,view.start.toDate(), view.end.toDate(), null, function(visits)
        {
            var translations = component.get('v.translations');
            var events = visits.map(function(visit)
            {
                return helper.visitToCalendarEvent(visit, component, event, helper, translations);
            });
            component.set('v.events',events);
        });
        helper.getUserEvents(component, view.start.toDate(), view.end.toDate(), null, function(userEvents)
        {
        	//CDU user event implementation
			var events = component.get('v.events');
            var userEventList = userEvents.map(function(userEvent)
            {
                   return helper.userEventToCalendarEvent(userEvent, component, event, helper);
             });
            events.push.apply(event, userEventList);
            component.set('v.events',events);
        });
        
    },
    visitToCalendarEvent : function(visit, component, event, helper, translations) {
        var event = {};
        event.title = visit.Name;
        if(visit.Account__r)
        {
            event.title = visit.Account__r.Name;
            event.label = '';
            if(visit.Account__r.Shop_City__c != null)
            {
                event.title  = event.title + "\n" + visit.Account__r.Shop_City__c;
            }
            if(visit.Visit_Reason__c != null)
            {
                try {
                    var Visit_Reason__c = translations.picklists.Visits__c_Visit_Reason__c.find(function(vr) {
                        return vr.value === visit.Visit_Reason__c;
                    });

                    event.title = event.title + "\n" + Visit_Reason__c.label;
                }
                catch (e)
                {
                    event.title = event.title + "\n" + visit.Visit_Reason__c;
                }

            }
            if(visit.Account__r.Hoya_Account_ID__c != null)
            {
                event.title = event.title + "\n" + visit.Account__r.Hoya_Account_ID__c;
            }
        }

        event.title += '\n' + event.label;
        event.allDay = visit.Is_All_Day_Event__c;
        event.start = new Date(visit.Start_Time__c);
        event.end = new Date(visit.End_Time__c);

        var timezone = $A.get('{!$Locale.timezone}');
        event.start = moment(visit.Start_Time__c).tz(timezone).format();
        event.end = moment(visit.End_Time__c).tz(timezone).format();
        event.sfid = visit.Id;
        //console.log('event',event);
        
        //VPM Color coding
        console.log('HOYA Account Id-->'+visit.Account__r.Hoya_Account_ID__c);
        
        if(visit.Account__r.Hoya_Account_ID__c && visit.Account__r.Hoya_Account_ID__c.toUpperCase().startsWith('US') ){
                    
            event.backgroundColor = {
            "Planned" : '#bf8040',
            "Prepared" : '#bf8040',
            "Complete" : '#999966',
            "Cancelled" : 'red'
        }[visit.Visit_Status__c];
        if((visit.HVNA_Appointment__c=='NO - Cold-call')||(visit.HVNA_Appointment__c=='None')){
            event.backgroundColor = {
                "Planned" : '#0000FF',
                "Prepared" : '#0000FF',//#039960
                "Complete" : '#999966',
                "Cancelled" : 'red'
            }[visit.Visit_Status__c];
        }
        if(visit.HVNA_Appointment__c=='YES - Requested by rep'){
            event.backgroundColor = {
                "Planned" : '#008000',
                "Prepared" : '#008000',//#039960
                "Complete" : '#999966',//'#bf8040',
                "Cancelled" : 'red'
            }[visit.Visit_Status__c];
        }
        if(visit.HVNA_Appointment__c=='YES - Requested by customer'){
            event.backgroundColor = {
                "Planned" : '#FF0000',
                "Prepared" : '#FF0000',
                "Complete" : '#999966',//'#ecc6d8',
                "Cancelled" : 'red'
            }[visit.Visit_Status__c];
        }
             if(!(visit.HVNA_Appointment__c)){
            event.backgroundColor = {
                "Planned" : '#FF0000',
                "Prepared" : '#FF0000',//#039960
                "Complete" : '#999966',//'#bf8040',
                "Cancelled" : 'red'
            }[visit.Visit_Status__c];
        }

        }
        else{
            
            event.backgroundColor = {
            "Planned" : '#bf8040',
            "Prepared" : '#bf8040',
            "Complete" : '#999966',
            "Cancelled" : 'red'
        }[visit.Visit_Status__c];
        if(visit.Visit_Type__c=='Visit'){
            event.backgroundColor = {
                "Planned" : '#082841',
                "Prepared" : '#082841',//#039960
                "Complete" : '#999966',
                "Cancelled" : 'red'
            }[visit.Visit_Status__c];
        }
        if(visit.Visit_Type__c=='Digital Visit'){
            event.backgroundColor = {
                "Planned" : '#2eb82e',
                "Prepared" : '#2eb82e',//#039960
                "Complete" : '#999966',//'#bf8040',
                "Cancelled" : 'red'
            }[visit.Visit_Status__c];
        }
        if(visit.Visit_Type__c=='Call'){
            event.backgroundColor = {
                "Planned" : '#ff0066',
                "Prepared" : '#ff0066',
                "Complete" : '#999966',//'#ecc6d8',
                "Cancelled" : 'red'
            }[visit.Visit_Status__c];
        }

            
        }
        
        return event;
    },
    //CDU 17/04/2018 standard event
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
    //end CDU
    getContactsForAccount: function(component, accountId, callback) {
        var action = component.get("c.getContactsForAccount");
        action.setParams({
            "accountId" : accountId
        });
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