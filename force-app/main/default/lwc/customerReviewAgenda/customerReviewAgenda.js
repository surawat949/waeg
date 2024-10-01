import { LightningElement ,api} from 'lwc';
import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import FullCalendarJS_5 from '@salesforce/resourceUrl/FullCalendar5';
import TimeZone from '@salesforce/i18n/timeZone';
import LangLocale from "@salesforce/i18n/lang";
import firstDayOfWeek from '@salesforce/i18n/firstDayOfWeek';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBackgroundColor } from "c/utility";

//Custom Labels
import Today from '@salesforce/label/c.Today';
import Month from '@salesforce/label/c.Month';
import Week from '@salesforce/label/c.Week';
import Day from '@salesforce/label/c.Day';
//Apex Classes
import getEvents from '@salesforce/apex/FullCalenderV2Controller.getAllRelatedEvents';
import getTranslations from '@salesforce/apex/FullCalenderV2Controller.getTranslations';

export default class CustomerReviewAgenda extends LightningElement {
    translations;
    jsInitialised = false;
    isLoading = true;
    timeZone;
    locale;
    allEvents =[];
    events = [];
    calendar;
    headerDate;
    currentUserId;
    startDate;
    endDate;
    custLabel = {
        Today,Month,Week,Day
    }

    @api 
    set representativeId(val){
        this.currentUserId = val;
        this.updateCalenderEvents();
    }

    get representativeId(){
        return this.currentUserId;
    }

    getStartOfWeek(date) {
        const day = date.getDay();
        const diff = date.getDate() - day + (day === 0 ? -6 : 1); // Adjust when day is Sunday
        return new Date(date.setDate(diff));
    }

    connectedCallback(){
        loadScript(this, FullCalendarJS + '/moment.min.js')
         .then(()=>{
            loadScript(this, FullCalendarJS + '/moment-timezone-with-data.min.js')
         });
        getTranslations()
        .then(response => {
            response =  JSON.parse(JSON.stringify(response));
            this.translations = response;
         }).catch(error => {
             this.showToast('Error', 'error', error.message);
        })
        this.setStartAndEndDate(new Date());
    }
    
    setStartAndEndDate(date) {
        const startOfWeek = this.getStartOfWeek(new Date(date));
        const endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(startOfWeek.getDate() + 6);

        this.startDate = startOfWeek.toISOString().split('T')[0];
        this.endDate = endOfWeek.toISOString().split('T')[0];
    }
    renderedCallback() {
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
            let that = this;
            setTimeout(function(){
                that.initializeCalender();
                that.updateCalenderEvents();
                that.setCalendarDate();
            },500);                     
        })
        .catch(error => {
            this.showToast('Error','error','Error loading Full Calendar: ==>'+error.message);
        });
    }
    initializeCalender(){
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
            firstDay:firstDayOfWeek-1,
            editable: false,
            selectable: false,
            events:this.allEvents,
            droppable: false,
            eventMouseEnter : this.handleHover.bind(this),
            eventMouseLeave :this.handleMouseLeave.bind(this)       
        });
        this.calendar.render();
    }
    handleHover(info){
        let nubbinpos = 'slds-nubbin_left-top';
        let top = '-5%';
        let left = '116%';
        let posRect = info.el.getBoundingClientRect();
        let remSpace = Math.floor(screen.width - posRect.left);
        if(remSpace <= 500){
            left = '-200%';
            if($(info.el).hasClass("fc-daygrid-event")){
                left = '-180%'
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
    setCalendarDate(){
        var view = this.calendar.view;
        this.headerDate = view.title;    
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
    updateCalenderEvents(){
        this.isLoading = true;
        this.allEvents = [];
         if(this.calendar){
            var view = this.calendar.view;
            this.calendar.removeAllEvents();
            this.calendar.addEventSource(this.allEvents);
            this.calendar.render();
            this.getAllEvents(view.activeStart,view.activeEnd); 
         } 
    }
    convertDateToISOWithZeroTime(date,isEnd) {
        const d = new Date(date); 
        if(isEnd){
            d.setUTCHours(23, 59, 59, 0);
        }else{
            d.setUTCHours(0, 0, 0, 0);
        }
        const updatedateTime = d.toISOString();
        const year = d.getUTCFullYear();
        const month = String(d.getUTCMonth() + 1).padStart(2, '0'); // Months are zero-based
        const day = String(d.getUTCDate()).padStart(2, '0');
        const hours = String(d.getUTCHours()).padStart(2, '0');
        const minutes = String(d.getUTCMinutes()).padStart(2, '0');
        const seconds = String(d.getUTCSeconds()).padStart(2, '0');
        const milliseconds = String(d.getUTCMilliseconds()).padStart(3, '0');
        return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}.${milliseconds}Z`;
    }
    getAllEvents(start,end){
        let locale = LangLocale;
        if(this.currentUserId){
            getEvents({startDateTime:start,endDateTime:end,userId: this.currentUserId})
            .then(response => {
                this.eventOriginalData = response;
                let Events = JSON.parse(JSON.stringify(response));
                for (let event in Events) {
                    var title ;
                    var allDay;
                    var start;
                    var end;
                    var sfid;
                    var backgroundColor;
                    var editable;
                    if(Events[event].eventType == 'UserEvent'){
                        var leadVisitEvent = Events[event].recordTypeName && Events[event].recordTypeName == 'Lead_Visits' ? true : false;
                        this.timezone = TimeZone;
                        this.locale = locale;                   
                        allDay = Events[event].isAllDayEvent;
                        start = moment(Events[event].startTime).tz(this.timezone).format();
                        end = moment(Events[event].endTime).tz(this.timezone).format();
                        if(Events[event].isPrivate){
                            title = "Busy"
                        }
                        else if(Events[event].subject != null && Events[event].subject != 'undefined'){
                            title = "Event " + Events[event].subject;
                        }
                        else{
                            title = "Event";
                        }
                        if(leadVisitEvent){
                            title = 'Lead Visit Event ';
                        }
                        if(Events[event].isExtraEvent){
                            if(Events[event].visitType ){
                                title += " " + Events[event].visitType;
                            }
                            if(Events[event].description ){
                                title += "\n" + Events[event].description;
                            }
                        }
                    
                        sfid = Events[event].eventId;                    
                        if(leadVisitEvent){
                            backgroundColor = '#5867e8';
                        }else{
                            backgroundColor = '#FF9411';
                        }
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
                    var eyeDoctorEvent = Events[event].recordTypeName && Events[event].recordTypeName == 'Eye_Doctor_Visit' ? true : false;
                    if(eyeDoctorEvent){
                        if(Events[event].contactName){
                            title  = Events[event].contactName;
                        }
                        if(Events[event].visitReason != null){
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
                        if(Events[event].clinicName != null){
                                title = title + "\n" + Events[event].clinicName;
                        }
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
                    }else if(Events[event].accountName != null){   
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

                        if(Events[event].isPrivate){
                            title = "Busy";
                        }
                    }
                        allDay =Events[event].isAllDayEvent;     
                        this.timezone = TimeZone;
                        this.locale = locale;
                        start = moment(Events[event].startTime).tz(this.timezone).format();
                        end = moment(Events[event].endTime).tz(this.timezone).format();                   
                        sfid = Events[event].eventId;
                        backgroundColor = getBackgroundColor(Events[event]);                                             
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
                this.isLoading = false;    
            }).catch(error => {
                this.isLoading = false;
                this.showToast('Error', 'error', error.message);         
            })     
        }else{
            this.isLoading = false;
        }
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
}