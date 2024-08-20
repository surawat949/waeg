/**
 * Created by thomas.schnocklake on 22.12.17.
 */
({
	prev : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('prev');
		hlp.setCalendarDate(cmp);
	},
	next : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('next');
		hlp.setCalendarDate(cmp);
	},
	today : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('today');
		hlp.setCalendarDate(cmp);
	},
	month : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('changeView','month');
		hlp.setCalendarDate(cmp);
	},
	basicWeek : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('changeView','agendaWeek');
		hlp.setCalendarDate(cmp);
	},
	listWeek : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('changeView','listWeek');
		hlp.setCalendarDate(cmp);
	},
	basicDay : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('changeView','basicDay');
		hlp.setCalendarDate(cmp);
	},
	listDay : function(cmp, evt, hlp) {
		$('#calendar').fullCalendar('changeView','agendaDay');
		hlp.setCalendarDate(cmp);
	},
    jsLoaded : function(cmp, evt, hlp) {
    		console.log('jsLoaded running for event ' + evt.name);
            $(document).ready(function(){

            var timezone = $A.get('{!$Locale.timezone}');
            var locale = $A.get('{!$Locale.langLocale}');
            //console.log('timezone', timezone, locale);
            //timezone='UTC';
            timezone=false;
                $('#calendar').fullCalendar({
                    timezone: timezone,
                    locale: locale,
                    header: {
                                left:   '',
                                center: '',
                                right:  ''
                            },
        eventMouseover: function (data, event, view) {

            //var tooltip = '<div class="tooltiptopicevent" style="width:auto;height:auto;background:#feb811;position:absolute;z-index:10001;padding:10px 10px 10px 10px ;  line-height: 200%;">' + 'title: ' + ': ' + data.title + '</br>' + 'start: ' + ': ' + data.start + '</div>';
            var tooltip = `
<section class="slds-popover slds-nubbin_left-top tooltiptopicevent" role="dialog" id="tooltiptopiceventId">
  <div class="slds-popover__body" id="dialog-body-id-19">
    <p> ` + data.title.replace(new RegExp('\n', 'g'), '<br/>') + `</p>
  </div>
</section>`;
            $("#calendarbodyId").append(tooltip);

            $('#tooltiptopiceventId').css('position', 'fixed');
            $('#tooltiptopiceventId').css('top', event.pageY - 20);
            $('#tooltiptopiceventId').css('left', event.pageX + 30);

        },
        eventMouseout: function (data, event, view) {
            $(this).css('z-index', 8);
            $('#tooltiptopiceventId').remove();

        },

                    defaultView: 'basicDay',
                    contentHeight: 1024,
                    // defaultDate: '2017-03-12',
                    navLinks: false, // can click day/week names to navigate views
                    editable: true,
                    droppable: true, // allows things to be dropped onto the calendar
                    selectable: false,
                    selectHelper: true,
                    eventLimit: true, // allow "more" link when too many events


                    viewRender: function(view) {
                        //console.log('viewRender',view);

                        var viewChangeEvent = cmp.getEvent("viewChange");
                        viewChangeEvent.setParams({
                            "start" : view.start.toDate(),
                            "end" : view.end.toDate()
                        });
                        viewChangeEvent.fire();
                    },
                    events: function(start, end, timezone, callback) {
//                        console.log('get events',start, end, timezone);

                        callback(cmp.get("v.events"));
                    },

                    
                    drop: function(date,jsEvent,ui,resourceId) {
                        //console.log('an event has been dropped!',date,jsEvent,ui,resourceId);
                        //console.log(jsEvent.target.dataset.name);

                        var dropEvent = cmp.getEvent("dropEvent");
                        dropEvent.setParams({
                            "droppedData" : jsEvent.target.dataset,
                            "date" : moment.tz(date.toJSON(), $A.get('{!$Locale.timezone}'))

                        });
                        dropEvent.fire();
                    },
                    eventClick: function(calEvent, jsEvent, view) {
                        //console.log('Event',calEvent);
                        var openEvent = cmp.getEvent("openEvent");
                        openEvent.setParams({
                            "event" : calEvent
                        });
                        openEvent.fire();

                        return false;
                    },
/*
                    eventDataTransform: function(event) {
                        // https://fullcalendar.io/docs/event_data/Event_Object/
                        var evt;
                        // Salesforce Event
                        if (event.Id) {
                            evt = hlp.sObjectToEvent(event);
                        }
                        // Regular Event
                        else {
                            evt = event;
                        }
                        //console.log('eventDataTransform:output',evt);
                        return evt;
                    },
                    */
                    eventDrop: function(event, delta, revertFunc) {
                        //console.log(event.title + " was dropped on " + event.start.format());
                        //if (!confirm("Are you sure about this change?")) {
                        //    revertFunc();
                        //} else {
                            var moveEvent = cmp.getEvent("moveEvent");
                            moveEvent.setParams({
                                "event" : event
                            });
                            moveEvent.fire();
                        //}
                    },
                    eventResize: function(event, delta, revertFunc) {
                        var moveEvent = cmp.getEvent("moveEvent");
                        moveEvent.setParams({
                            "event" : event
                        });
                        moveEvent.fire();
                    },
                    eventReceive: function(event) {
                        //console.log('event received',event);
                        var sObject = hlp.eventToSObject(event);
                        sObject.WhatId = sObject.Id;
                        sObject.Id = null;
                        hlp.updateEvents(cmp,[sObject]);
                        // hlp.getEvents(cmp,[event.sfid]);
                    }
                });



		        hlp.setCalendarDate(cmp);



            });
        },
	loadEvents : function(cmp,evt,hlp) {
// https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/ref_aura_valueChange.htm
//		var events = cmp.get('v.events');
//		console.log('events',events);
//		$('#calendar').fullCalendar('addEventSource',events);
       $('#calendar').fullCalendar( 'refetchEvents' );
	},
	handleDrop : function(cmp,hlp,date,jsEvent,ui,resourceId){
	    //console.log(handleDrop, cmp,hlp,date,jsEvent,ui,resourceId);
    },
})