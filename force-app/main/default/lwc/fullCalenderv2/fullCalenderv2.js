import { LightningElement ,api, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import FullCalendarJS_5 from '@salesforce/resourceUrl/FullCalendar5';
import userId from "@salesforce/user/Id";
import userName from '@salesforce/schema/User.Name'; 
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TimeZone from '@salesforce/i18n/timeZone';
import LangLocale from "@salesforce/i18n/lang";
import firstDayOfWeek from '@salesforce/i18n/firstDayOfWeek';
import visitCreatePopup from 'c/visitCreatePopup';

//Custom Labels
import Today from '@salesforce/label/c.Today';
import Month from '@salesforce/label/c.Month';
import Week from '@salesforce/label/c.Week';
import Day from '@salesforce/label/c.Day';
//Apex Classes
import getEvents from '@salesforce/apex/FullCalenderV2Controller.getEvents';
import getTranslations from '@salesforce/apex/FullCalenderV2Controller.getTranslations';
import getAccountId from '@salesforce/apex/FullCalenderV2Controller.getAccountId';
import upsertVisit from '@salesforce/apex/FullCalenderV2Controller.upsertVisit';
export default class VisitPlanningCalenderLWC extends NavigationMixin(LightningElement) {   
    translations;
    visit;
    @api top;
    @api right;
    showToolTip;
    toolTip1;
    toolTip2;
    toolTip3;
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
    @api refresh(){
        this.updateCalenderEvents();
    }
    constructor(){
        super();
    }   
    @wire(getRecord, { recordId: userId, fields: [userName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.Name.value != null) {
                this.userName = data.fields.Name.value;
            }
        }
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
        console.log(firstDayOfWeek);
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
            editable: true,
            selectable: false,
            selectHelper: true,     
            events:this.allEvents,
            eventClick: this.eventClickHandler.bind(this),
            droppable: true, // this allows things to be dropped onto the calendar
            eventMouseEnter : this.handleHover.bind(this),
            eventMouseLeave :this.handleMouseLeave.bind(this),
            eventReceive: this.handleExternalDrop.bind(this),
            eventDrop:this.handleEventDrop.bind(this),
            eventResize:this.handleEventDrop.bind(this)           
        });
        this.calendar.render();  
    }
    
    handleHover(info){
        let nubbinpos = 'slds-nubbin_left-top';
        let top = '-5%';
        let left = '116%';
        let posRect = info.el.getBoundingClientRect();
        let remSpace = Math.floor(screen.width - posRect.left);
        if(remSpace <= 350){
            left = '-446%';
            if($(info.el).hasClass("fc-daygrid-event")){
                left = '-400%'
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
    handleEventDrop(info){
        var v={};
        v.sobjectType = 'Visits__c';
        v.Id = info.event.extendedProps.sfid;
        var start = info.event.start;
        var end = info.event.end;
        let offset = moment.parseZone(start).tz(TimeZone).utcOffset();
        let startDate = moment(start).utc(false).format();
        let endDate = moment(end).utc(false).format();
        var correctedStartDate = moment(startDate).subtract(offset, "minutes").format();
        var correctedEndDate = moment(endDate).subtract(offset, "minutes").format();
        v.Start_Time__c = new Date(correctedStartDate);
        v.End_Time__c = new Date(correctedEndDate);
        upsertVisit({visit : v})
        .then(response => {
            response =  JSON.parse(JSON.stringify(response));
            this.visit = response;
            this.updateCalenderEvents();
         }).catch(error => {
             this.showToast('Error', error, error.message);
        })
        
    } 
    handleMouseLeave(info) {
        $('.slds-popover').remove();
        $('.fc-timegrid-col-events').css('z-index','3');
        $('.fc-daygrid-event').css('z-index',6); 
    }
    handleExternalDrop(info){ 
        var Id = info.event.extendedProps.recordId;  
        var name =  info.event.title;
        var start=  info.event.start;  
        var v={};
        v.sobjectType = 'Visits__c';
        v.Account__c =Id;
        v.AccountName = name;
        v.Account__r = {
            sobjectType : 'Account',
            Id: Id,
            Name: name,
        };
        let offset = moment.parseZone(start).tz(TimeZone).utcOffset();
        let startDate = moment(start).utc(false).format();
        let endDate = moment(start).add(60, 'minutes').utc(false).format();
        var correctedStartDate = moment(startDate).subtract(offset, "minutes").format();
        var correctedEndDate = moment(endDate).subtract(offset, "minutes").format();
        v.Start_Time__c = correctedStartDate;
        v.End_Time__c = correctedEndDate;
        v.Call_To_Action_Notes__c = null;
        v.Visit_Reason__c = null;
        v.Call_To_Action__c = null;
        v.Assigned_to__c = userId;
        v.userName = this.userName;
        v.Visit_Notes__c = null;
        v.Visit_Type__c = null;      
        this.showPopUp(v);
}
async showPopUp(visit){
        await visitCreatePopup.open({
        size: 'small',
        visit: visit
        });          
        this.updateCalenderEvents();
}
navigateToRecord(recordId,ObjectName){
    const pageReference = {
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId, // Replace with the actual record ID
            objectApiName: ObjectName, // Replace with the object API name
            actionName: 'view'
        }
    };

    // Use the Navigate method to navigate to the specified record page
    this[NavigationMixin.Navigate](pageReference);
}
eventClickHandler = (info) => {
    if(info.event.title != null && info.event.title.startsWith('Event') && info.event.extendedProps.isExtraEvent != null && info.event.extendedProps.isExtraEvent == true){
        var url = '/'+info.event.extendedProps.sfid;
        window.open(url, "_blank");
       // this.navigateToRecord(info.event.extendedProps.sfid,'Event');
    }
    if(info.event.title != null && !info.event.title.startsWith('Event')){
        const titleArray = info.event.title.split('\n');
        var count = titleArray.length;        
        if(info.event.start > new Date()){    
            var hoyaAccId = titleArray[count-1];
            getAccountId({hoyaAccId :hoyaAccId})
            .then(response => {                  
                var url =  '/' + response;
                if(response == null ){
                    this.showToast('Error', error, 'Missing data like HoyaAccountId');  
                }
                else{
                   // this.navigateToRecord(response,'Account');
                    window.open(url, "_blank");
                }
            }).catch(error => {
                this.showToast('Error', error, error.message);         
            })
        }
        else{          
            var visitId = info.event.extendedProps.sfid;
            var url = '/' + visitId;
          //  this.navigateToRecord(info.event.extendedProps.sfid,'Visits__c');
            window.open(url, "_blank");
        }
    }
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
        this.allEvents = [];
        var view = this.calendar.view;
        this.getAllEvents(view.activeStart,view.activeEnd);         
    }
    getAllEvents(start,end){
        let locale = LangLocale;
        getEvents({periodStart:start,periodEnd:end})
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
                    this.timezone = TimeZone;
                    this.locale = locale;                   
                    allDay = Events[event].isAllDayEvent;
                    start = moment(Events[event].startTime).tz(this.timezone).format();
                    end = moment(Events[event].endTime).tz(this.timezone).format();
                    if(Events[event].subject != null && Events[event].subject != 'undefined'){
                        title = "Event " + Events[event].subject;
                    }
                    else{
                        title = "Event";
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
                    allDay =Events[event].isAllDayEvent;     
                    this.timezone = TimeZone;
                    this.locale = locale;
                    start = moment(Events[event].startTime).tz(this.timezone).format();
                    end = moment(Events[event].endTime).tz(this.timezone).format();                   
                    sfid = Events[event].eventId;
                    if(Events[event].visitType=='Visit'){
                        backgroundColor = {
                            "Planned" : '#082841',
                            "Prepared" : '#082841',
                            "Complete" : '#999966',
                            "Cancelled" : 'red'
                        }[Events[event].visitStatus];
                    }
                    else if(Events[event].visitType=='Digital Visit'){
                        backgroundColor = {
                            "Planned" : '#2eb82e',
                            "Prepared" : '#2eb82e',
                            "Complete" : '#999966',
                            "Cancelled" : 'red'
                        }[Events[event].visitStatus];
                    }
                    else if(Events[event].visitType=='Call'){
                        backgroundColor = {
                            "Planned" : '#ff0066',
                            "Prepared" : '#ff0066',
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
}