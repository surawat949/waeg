import { LightningElement ,track,api} from 'lwc';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VisitPlanningCalenderLWC extends LightningElement {
    jsInitialised = false;
    @track _events;

    @api
    get events() {
        return this._events;
    }
    set events(value) {
        this._events=[...value];
    }


    @api
    get eventDataString() {
        return this.events;
    }
    set eventDataString(value) {
        try
        {
            this.events=eval(value);
        }
        catch{
           this.events=[];
        }
    }
    renderedCallback() {

        // Performs this operation only on first render
        if (this.jsInitialised) {
          return;
        }
        this.jsInitialised = true;

    // Executes all loadScript and loadStyle promises
    // and only resolves them once all promises are done
      Promise.all([
          loadScript(this, FullCalendarJS + '/jquery.min.js'),
          //loadScript(this, FullCalendarJS + "/moment-timezone-with-data.min.js'"),
          loadScript(this, FullCalendarJS + "/moment.min.js"),
          loadScript(this, FullCalendarJS + "/fullcalendar.min.js"),
          loadStyle(this, FullCalendarJS + "/fullcalendar.min.css")
      ])
      .then(() => {
        this.initialiseCalendarJs();
      })
      .catch(error => {
          alert(error);
          new ShowToastEvent({
              title: 'Error!',
              message: error,
              variant: 'error'
          })
      })
    }
    initialiseCalendarJs() { 
    var that=this;
    const ele = this.template.querySelector('div.fullcalendarjs');
    //Use jQuery to instantiate fullcalender JS
    $(ele).fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,basicWeek,basicDay'
        },
        defaultDate: new Date(),
        navLinks: true, 
        editable: true,
        eventLimit: true,
        events: this.events,
        dragScroll:true,
        droppable:true,
        weekNumbers:true,
        selectable:true,
        //eventClick: this.eventClick,
        eventClick: function (info) {
        const selectedEvent = new CustomEvent('eventclicked', { detail: info.Id });
        // Dispatches the event.
        that.dispatchEvent(selectedEvent);
        }
    });
}

}