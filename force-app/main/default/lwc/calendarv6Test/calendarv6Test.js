import { LightningElement , wire} from 'lwc';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import FullCalendarJS_6 from '@salesforce/resourceUrl/FullCalendar5';

import userId from "@salesforce/user/Id";
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TimeZone from '@salesforce/i18n/timeZone';
import LangLocale from "@salesforce/i18n/langLocale";
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
import getVisitId from '@salesforce/apex/FullCalenderV2Controller.getVisitId';
export default class VisitPlanningCalenderLWC extends LightningElement {
    translations;
    accountId;
    jsInitialised = false;
    headerDate;
    timeZone;
    eventOriginalData = [];
    allEvents =[];
    events = [];
    custLabel = {
        Today,Month,Week,Day
    }
    constructor(){
        super();
    }   
    connectedCallback(){
        getTranslations()
        .then(response => {
            response =  JSON.parse(JSON.stringify(response));
            console.log(response);
            this.translations = response;
         }).catch(error => {
             this.showToast('Error', error.message, error.message);
        })
    }
    async renderedCallback() {
        // Performs this operation only on first render
        if (this.jsInitialised) {
          return;
        }
        this.jsInitialised = true;

        // Executes all loadScript and loadStyle promises
        // and only resolves them once all promises are done
       /* function promiseA(){
            return new Promise((resolve, reject) => {
                const script = document.createElement('script');
                script.src = FullCalendarJS + '/jquery.min.js'; // Set the source of the script 
                script.onload = resolve; // Resolve the promise when the script is loaded
                script.onerror = reject; // Reject the promise if there is an error loading the script
                document.head.appendChild(script); 
            });
        }       
        Promise.all([
            promiseA(),
            promiseB(),
            promiseC(),*/
        /*await Promise.allSettled([  
            loadScript(this, FullCalendarJS + '/jquery.min.js'),
            loadScript(this, FullCalendarJS + '/jquery-ui.min.js'),
            loadScript(this, FullCalendarJS + '/moment.min.js')
        ]).then(()=>{
                Promise.allSettled([                
                loadScript(this, FullCalendarJS + '/moment-timezone-with-data.min.js'),
                loadScript(this, FullCalendarJS + '/fullcalendar.min.js'),
                loadScript(this, FullCalendarJS + '/locale-all.js'),
                loadScript(this, FullCalendarJS + '/jquery.ui.touch-punch.js'),
                loadScript(this, FullCalendarJS + '/jquery.dataTables.min.js'),
                loadStyle(this, FullCalendarJS + '/fullcalendar.min.css'),
                loadStyle(this, FullCalendarJS + '/jquery.dataTables.min.css')
               // loadScript(this,JQuweryFC)
            ]).then(() => {  
                this.initialiseCalendarJs();
                this.updateCalenderEvents();
                this.setCalendarDate();
            });
        }).catch(error => {
            alert(error);
            new ShowToastEvent({
                title: 'Error!',
                message: error,
                variant: 'error'
            })
            
        })*/


        Promise.allSettled([
            loadScript(this, FullCalendarJS_6 + '/lib/main.js'),
            loadStyle(this, FullCalendarJS_6 + '/lib/main.css'),
        ])
        .then(() => {
            this.initV6();
            //this.updateCalenderEvents();
            //this.setCalendarDate();          
        })
        .catch(error => {
            this.showToast('Error','error','Error loading New Full Calendar: ==>'+error.message);
        });
       
    }

    initV6(){
        const ele = this.template.querySelector('.fullcalendarjs');    
        var calendar = new FullCalendar.Calendar(ele, {
            headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            editable: true,
            droppable: true, // this allows things to be dropped onto the calendar
            drop: function(info) {
               alert('info');
            }
        });

        calendar.render();
         
    }
    initialiseCalendarJs() { 
       
    const $ = jQuery.noConflict();
    const ele = this.template.querySelector('div.fullcalendarjs');    
    //Use jQuery to instantiate fullcalender JS
    $(ele).fullCalendar({
        // plugins to load

       // plugins: ['dayGrid','timeGrid','interactioon'],
        timezone: false,
        locale: LangLocale,
        header: {
            left:'',
            center: '',
            right:  ''
        },
        defaultView: 'agendaWeek',
        navLinks: false,
        editable: true,
        droppable: true,
        height:'800',
        selectable: false,
        selectHelper: true,
        eventLimit: true,        
        events:this.allEvents,
        /*dayClick: function(date, allDay, jsEvent, view) {
            console.log(date);
            var Id="Id";
            var name ="Name";          
             var v={};
             v.sobjectType = 'Visits__c';
             v.Account__c = Id;
             v.Account__r = {
                 sobjectType : 'Account',
                 Id: Id,
                 Name: name,
             };
             //debugger;
             v.Start_Time__c = date.format();
             v.End_Time__c = date.add(60, 'minutes').format();
             v.Call_To_Action_Notes__c = null;
             v.Visit_Reason__c = null;
             v.Call_To_Action__c = null;
            // v.Campaign_name__c = component.get('v.campaignId');
             v.Visit_Planning_Tracker__c = 'Visit Planning';
            // var user = $A.get("$SObjectType.CurrentUser");
     
             v.Assigned_to__c = userId;
             v.Visit_Notes__c = null;
             v.Visit_Type__c = null;           
             console.log(v);
 
             this.showPopUp(v);
        },  */
        dayClick: this.handleDrop.bind(this),       
        //eventMouseover : this.eventMouseoverHandler.bind(this)       
        eventClick: this.eventClickHandler.bind(this),
        eventReceive: function(info) {
            console.log('event received!', info.event);
        },
        drop:function(date,jsEvent,ui,resourceId) {
            var start = moment(date.format()); //lose the extended fullCalendar moment with its "ambiguously-timed" feature, which gets in the way here
            var end = start.clone();
            var allDay = true;
            
                console.log(date);
        },
      //  drop: this.handleDrop.bind(this),
        eventDrop: function(event, delta, revertFunc) {
            alert(event.title + " was dropped on " + event.start.format());
            if (!confirm("Are you sure about this change? ")) {
              revertFunc();
            }
        }
    });
    
    }
    handleDragOver(event) {
        event.preventDefault();    
    }    
    handleDrop(event){    
        console.log(event); 
           // event.preventDefault();        
            //var Id = event.dataTransfer.getData('recordId');  
           // var name = event.dataTransfer.getData('name');
           var Id="Id";
           var name ="Name";     
           var start=new Date();     
            var v={};
            v.sobjectType = 'Visits__c';
            v.Account__c = Id;
            v.Account__r = {
                sobjectType : 'Account',
                Id: Id,
                Name: name,
            };
            //debugger;
            v.Start_Time__c = start;
            v.End_Time__c = new Date(start.getTime() + 60 * 60000);;
            v.Call_To_Action_Notes__c = null;
            v.Visit_Reason__c = null;
            v.Call_To_Action__c = null;
           // v.Campaign_name__c = component.get('v.campaignId');
            v.Visit_Planning_Tracker__c = 'Visit Planning';
           // var user = $A.get("$SObjectType.CurrentUser");
    
            v.Assigned_to__c = userId;
            v.Visit_Notes__c = null;
            v.Visit_Type__c = null;           
            console.log(v);

            this.showPopUp(v);

    }
    async showPopUp(visit){
        console.log(visit);
         await visitCreatePopup.open({
            size: 'small',
            visit: visit
          });          
          this.updateCalenderEvents();
    }
    eventClickHandler = (event, jsEvent, view) => {
        if(event.title != null && !event.title.startsWith('Event')){
            const titleArray = event.title.split('\n');
            var count = titleArray.length;
            if(event.start > new Date()){              
                var hoyaAccId = titleArray[count-1];
                getAccountId({hoyaAccId :hoyaAccId})
                .then(response => {                  
                    var url =  '/' + response;
                    if(response == null ){
                        this.showToast('Error', error, 'Missing data like HoyaAccountId');  
                    }
                    else{
                        window.open(url, "_blank");
                    }
                }).catch(error => {
                    this.showToast('Error', error, error.message);         
                })
            }
            else{
                var start = event.start;
                var end = event.end;
                var hoyaAccId = titleArray[count-1];
                var objective = titleArray[count-2];
                getVisitId({startTime:start,endTime:end,hoyaAccountId:hoyaAccId,mainObjective:objective})
                .then(response => {                  
                    var url =  '/' + response;if(response == null ){
                        this.showToast('Error', error, 'Missing data like HoyaAccountId,Visit Reason etc');  
                    }
                    else{
                        window.open(url, "_blank");
                    }
                }).catch(error => {
                    this.showToast('Error', error, error.message);         
                })
            }
        }
    }
    setCalendarDate(){
        const $ = jQuery.noConflict();
        let ele = this.template.querySelector('div.fullcalendarjs');
        var view = $(ele).fullCalendar('getView').name;
        var moment =  $(ele).fullCalendar('getDate');
        if (view.includes('month')) {
            this.headerDate = moment.format('MMMM YYYY');
        } else
        if (view.includes('day')) {
            this.headerDate = moment.format('MMMM DD, YYYY');
        } else
        if (view.includes('week') || view.includes('Week'))  {
            var startDay = moment.startOf('week').format('DD');
            var endDay = moment.endOf('week').format('DD');
            this.headerDate = moment.format('MMM ') + startDay + ' – ' + endDay + moment.format(', YYYY');
        }
    }
    prev(){
        const $ = jQuery.noConflict();
        let ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar('prev');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    next(){
        const $ = jQuery.noConflict();
        let ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar('next');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    today(){
        const $ = jQuery.noConflict();
        let ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar('today');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    month(){
        const $ = jQuery.noConflict();
        let ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar('changeView','month');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    basicWeek(){
        const $ = jQuery.noConflict();
        let ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar('changeView','agendaWeek');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    listDay(){
        const $ = jQuery.noConflict();
        let ele = this.template.querySelector('div.fullcalendarjs');
        $(ele).fullCalendar('changeView','agendaDay');
        this.setCalendarDate();
        this.updateCalenderEvents();
    }
    
    updateCalenderEvents(){
        this.allEvents = [];
        let ele = this.template.querySelector('div.fullcalendarjs');
        const $ = jQuery.noConflict();
        var view = $(ele).fullCalendar('getView');  
        this.getAllEvents(view.start.toDate(),view.end.toDate());         
    }
    getAllEvents(start,end){
        getEvents({periodStart:start,periodEnd:end})
        .then(response => {
            console.log(response);
            this.eventOriginalData = response;
            let Events = JSON.parse(JSON.stringify(response));
            console.log(Events);
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
                        editable:editable
                    });
                }
                else{
                    if(Events[event].accountName != null)
                    {
                        title = Events[event].accountName;
                        if(Events[event].accountShopCity != null)
                        {
                            title  = title + "\n" + Events[event].accountShopCity;
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
                    start = moment(Events[event].startTime).tz(this.timezone).format();
                    end = moment(Events[event].endTime).tz(this.timezone).format();                   
                    sfid = Events[event].Id;
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
            console.log(this.allEvents);
            this.error = undefined; 
            const ele = this.template.querySelector('div.fullcalendarjs');
            const $ = jQuery.noConflict();
            $(ele).fullCalendar('removeEvents');
            $(ele).fullCalendar('removeEventSources');
            $(ele).fullCalendar('addEventSource',this.allEvents);
            $(ele).fullCalendar('rerenderEvents');
         }).catch(error => {
             this.showToast('Error', error, error.message);         
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