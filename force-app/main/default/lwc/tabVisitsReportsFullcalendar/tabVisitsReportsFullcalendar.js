import { LightningElement ,api, wire} from 'lwc';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import FullCalendarJS_5 from '@salesforce/resourceUrl/FullCalendar5';

import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TimeZone from '@salesforce/i18n/timeZone';
import LangLocale from "@salesforce/i18n/lang";

//Custom Labels
import Today from '@salesforce/label/c.Today';
import Month from '@salesforce/label/c.Month';
import Week from '@salesforce/label/c.Week';
import Day from '@salesforce/label/c.Day';

//Apex Classes
import getEvents from '@salesforce/apex/FullCalenderV2Controller.getEvents';
import getTranslations from '@salesforce/apex/FullCalenderV2Controller.getTranslations';

export default class tabVisitsReportsFullcalendar extends LightningElement {  
    @api recordId;
    jsInitialised = false;
    timeZone;
    locale;
    eventOriginalData = [];
    allEvents =[];
    events = [];
    calendar;
    headerDate;
    custLabel = {
        Today,Month,Week,Day
    }

    connectedCallback(){
        loadScript(this, FullCalendarJS + '/moment.min.js')
         .then(()=>{
            loadScript(this, FullCalendarJS + '/moment-timezone-with-data.min.js')
            .then(()=>{
                console.log('All moment loaded');
            });
         });
        getTranslations()
        .then(response => {
            response =  JSON.parse(JSON.stringify(response));
            this.translations = response;
         }).catch(error => {
             this.showToast('Error', 'error', error.message);
        })
    }

    async renderedCallback() {       
        // Performs this operation only on first render
        if (this.jsInitialised) {
          return;
        }
        this.jsInitialised = true;
        Promise.allSettled([
            loadScript(this, FullCalendarJS + '/jquery.min.js'),
            loadScript(this, FullCalendarJS_5 + '/lib/main.js'),
            loadStyle(this, FullCalendarJS_5 + '/lib/main.css'),
        ])
        .then(() => {
            console.log('All calendar loaded');
            console.log('timeout loaded');
            this.initializeCalender();
            console.log('timeout loaded 1');
            this.updateCalenderEvents();
            console.log('timeout loaded 2');
            this.setCalendarDate();
            console.log('timeout loaded 3');
        })
        .catch(error => {
            this.showToast('Error','error','Error loading Full Calendar: ==>'+error.message);
        });
    }

    initializeCalender(){
        console.log('initializeCalender');
        this.locale = LangLocale;
        const ele = this.template.querySelector('.fullcalendarjs');  
        this.calendar = new FullCalendar.Calendar(ele,{
            timeZone:TimeZone,
            locale:this.locale,
            headerToolbar: {
            left: '',
            center: '',
            right: ''
            },
            height:'44rem',
            initialView: 'timeGridWeek',
            editable: true,
            selectable: false,
            selectHelper: true,     
            events:this.allEvents,
            droppable: false, // this allows things to be dropped onto the calendar
            eventMouseEnter : this.handleHover.bind(this),
            eventMouseLeave :this.handleMouseLeave.bind(this)
        });
        this.calendar.render();  
    }

    updateCalenderEvents(){
        this.allEvents = [];
        var view = this.calendar.view;
        this.getAllEvents(view.activeStart,view.activeEnd);         
    }
    setCalendarDate(){
        var view = this.calendar.view;
        this.headerDate = view.title;    
    }
    getAllEvents(start,end){
        console.log('getAllEvents start'+start);
        console.log('getAllEvents end'+end);
        let locale = LangLocale;
        getEvents({periodStart:start,periodEnd:end})
        .then(response => {
            this.eventOriginalData = response;
            let Events = JSON.parse(JSON.stringify(response));
            console.log('Events response',JSON.stringify(response));
            for (let event in Events) {
                var title ;
                var allDay;
                var start;
                var end;
                var sfid;
                var backgroundColor;
                var editable;
                if(Events[event].eventType == 'UserEvent'){
                    this.timezone = TimeZone;
                    this.locale = locale;
                    allDay = Events[event].isAllDayEvent;
                    start = moment(Events[event].startTime).tz(this.timezone).format();
                    end = moment(Events[event].endTime).tz(this.timezone).format();
                    title = "Event " + Events[event].subject;
                    sfid = Events[event].eventId;                    
                    backgroundColor = '#FF9411';
                    editable=false;
                    this.allEvents.push({
                        title:title,
                        allDay:allDay,
                        start:start,
                        end:end,
                        backgroundColor:backgroundColor,
                        sfid:sfid,
                        editable:editable,
                        isExtraEvent:Events[event].isExtraEvent
                    });
                }
                else{
                    if(Events[event].accountName != null)
                    {
                        title = Events[event].accountName;
                        if(Events[event].accountShopStreet != null)
                        {
                            title  = title + "\n" + Events[event].accountShopStreet;
                        }

                        if(Events[event].accountShopCity != null)
                        {
                            title  = title + "," + Events[event].accountShopCity;
                        }

                        if(Events[event].accountShopZipcode != null)
                        {
                            title  = title + "," + Events[event].accountShopZipcode;
                        }
                       
                        if(Events[event].accountShopstate != null)
                        {
                            title  = title + "," + Events[event].accountShopstate;
                        }

                        if(Events[event].visitReason != null)
                        {
                            try {
                                var visitReason = this.translations.picklists.Visits__c_Visit_Reason__c.find(function(vr) {
                                   return vr.value ===  Events[event].Visit_Reason__c;});
                                title = title + "\n" + visitReason.label;
                            }
                            catch (e)
                            {
                              title = title + "\n" + Events[event].visitReason;
                            }
    
                        }
                        if(Events[event].hoyaAccountId != null)
                        {
                            title = title + "\n" + Events[event].hoyaAccountId;
                        }
                    }
                    console.log('error2');
                    allDay =Events[event].isAllDayEvent;     
                    this.timezone = TimeZone;
                    this.locale = locale;
                    start = moment(Events[event].startTime).tz(this.timezone).format();
                    end = moment(Events[event].endTime).tz(this.timezone).format();                   
                    sfid = Events[event].eventId;
                    if(Events[event].hoyaAccountId != null && Events[event].hoyaAccountId.toUpperCase().startsWith('US') ){
                        backgroundColor = {
                        "Planned" : '#bf8040',
                        "Prepared" : '#bf8040',
                        "Complete" : '#999966',
                        "Cancelled" : 'red'
                        }[Events[event].visitStatus];
                    }
                    else{
                        backgroundColor = {
                        "Planned" : '#bf8040',
                        "Prepared" : '#bf8040',
                        "Complete" : '#999966',
                        "Cancelled" : 'red'
                        }[Events[event].visitStatus];
                        if(Events[event].visitType=='Visit'){
                            backgroundColor = {
                                "Planned" : '#082841',
                                "Prepared" : '#082841',//#039960
                                "Complete" : '#999966',
                                "Cancelled" : 'red'
                            }[Events[event].visitStatus];
                        }
                        if(Events[event].visitType=='Digital Visit'){
                            backgroundColor = {
                                "Planned" : '#2eb82e',
                                "Prepared" : '#2eb82e',//#039960
                                "Complete" : '#999966',//'#bf8040',
                                "Cancelled" : 'red'
                            }[Events[event].visitStatus];
                        }
                        if(Events[event].visitType=='Call'){
                            backgroundColor = {
                                "Planned" : '#ff0066',
                                "Prepared" : '#ff0066',
                                "Complete" : '#999966',//'#ecc6d8',
                                "Cancelled" : 'red'
                            }[Events[event].visitStatus];
                        }                    
                    }
                    
                    this.allEvents.push({
                        title:title,
                        allDay:allDay,
                        start:start,
                        end:end,
                        backgroundColor:backgroundColor,
                        sfid:sfid
                    });
                }
            }           
            this.error = undefined; 
            this.calendar.removeAllEvents();
            this.calendar.addEventSource(this.allEvents);
            this.calendar.render();
         }).catch(error => {
             console.log('errorMessage',error.message);
             this.showToast('Error', 'error', error.message);         
        })     
    }   
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
    handleHover(info){
        let nubbinpos = 'slds-nubbin_left-top';
        let top = '-5%';
        let left = '116%';
        let posRect = info.el.getBoundingClientRect();
        let remSpace = Math.floor(screen.width - posRect.left);
          console.log('remSpace'+remSpace);
        console.log('width'+screen.width);
        console.log('posRect.left'+posRect.left);
        if(remSpace <= 900){
            left = '-350%';
            if($(info.el).hasClass("fc-daygrid-event")){
                left = '-300%'
            }
            nubbinpos = 'slds-nubbin_right-top';
        }
        var parts = info.event.title.split('\n');
        let elem = '<div class="calpopover slds-popover slds-popover_tooltip slds-popover_medium" role="tooltip" style="position:absolute;min-height:40px;transform:rotate(360deg)"><div class="slds-popover__body">';
        parts.forEach((part,index)=>{
            elem += '<span>'+part+'</span></br>';
        });
        elem += '</div></div>';
       let parentelem =  $(info.el).closest('.fc-timegrid-col-events');
        $('.fc-timegrid-col-events').not(parentelem).css('z-index',1); 
        $('.fc-daygrid-event').not(info.el).css('z-index',-1); 
        $(info.el).append(elem);
        $('.calpopover').addClass(nubbinpos);
        $('.calpopover').css('top', top);
        $('.calpopover').css('left', left);

    }
    handleMouseLeave(info) {
        $('.slds-popover').remove();
        $('.fc-timegrid-col-events').css('z-index','3');
        $('.fc-daygrid-event').css('z-index',6); 
    }
    prev(){
        this.calendar.prev();
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    next(){
        this.calendar.next();
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    today(){
        this.calendar.today();
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    month(){      
        this.calendar.changeView('dayGridMonth');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    basicWeek(){
        this.calendar.changeView('timeGridWeek');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    listDay(){
        this.calendar.changeView('timeGridDay');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
}