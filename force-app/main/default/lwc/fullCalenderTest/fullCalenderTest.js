import { LightningElement } from 'lwc';
import fullCalendarJS from '@salesforce/resourceUrl/FullCalendarNew';
import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import TimeZone from '@salesforce/i18n/timeZone';
import LangLocale from "@salesforce/i18n/langLocale";
import getEvents from '@salesforce/apex/FullCalenderV2Controller.getEvents';
export default class FullCalenderTest extends LightningElement {
    isScriptsLoaded;
    allEvents;
    calendar;
    handleDragStart(event) {
        if(!this.isScriptsLoaded){
            alert('jquery not loaded');
        }
       // event.preventDefault();
        const recordId = 'id';
        event.dataTransfer.setData('text/plain', 'drag');
        event.dataTransfer.setData('title', 'drag');
    }
    async renderedCallback() {
        if (this.isJQueryUIInitialized) {
            return;
        }
        try {
            await Promise.all([
                loadScript(this, fullCalendarJS + '/main.min.js'),
                loadStyle(this, fullCalendarJS + '/main.min.css')
            ]);
            this.initializeCalendar();
            this.isScriptsLoaded =true;
        } catch (error) {
            this.error = error;
        }
    
    }   
    initializeCalendar() {       
        var Calendar = FullCalendar.Calendar;
        var Draggable = FullCalendar.Draggable;

        var containerEl = document.getElementById('external-events');
        var calendarEl = document.getElementById('calendar');
        var checkbox = document.getElementById('drop-remove');

        // initialize the external events
        // -----------------------------------------------------------------

        new Draggable(containerEl, {
            itemSelector: '.fc-event',
            eventData: function(eventEl) {
            return {
                title: eventEl.innerText
            };
            }
        });

        // initialize the calendar
        // -----------------------------------------------------------------

        var calendar = new Calendar(calendarEl, {
            headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            editable: true,
            droppable: true, // this allows things to be dropped onto the calendar
            drop: function(info) {
            // is the "remove after drop" checkbox checked?
            if (checkbox.checked) {
                // if so, remove the element from the "Draggable Events" list
                info.draggedEl.parentNode.removeChild(info.draggedEl);
            }
            }
        });

        calendar.render();
    

    /*new FullCalendarInteraction.ThirdPartyDraggable(draggableEl, {    
        eventData: function(eventEl) {
            return {
              title: eventEl.innerText.trim()
            }
          }
    })*/
        
    }
    
}