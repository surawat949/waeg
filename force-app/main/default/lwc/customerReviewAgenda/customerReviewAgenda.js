import { LightningElement ,api, wire} from 'lwc';
import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import FullCalendarJS_5 from '@salesforce/resourceUrl/FullCalendar5';
import TimeZone from '@salesforce/i18n/timeZone';
import LangLocale from "@salesforce/i18n/lang";
import firstDayOfWeek from '@salesforce/i18n/firstDayOfWeek';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from '@salesforce/user/Id';
import SALES_ROLE_FIELD from '@salesforce/schema/User.Sales_Role__c';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import USER_COMPANYNAME_FIELD from '@salesforce/schema/User.CompanyName';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import PROFILE_ID_FIELD from '@salesforce/schema/User.ProfileId';

//Custom Labels
import Today from '@salesforce/label/c.Today';
import Month from '@salesforce/label/c.Month';
import Week from '@salesforce/label/c.Week';
import Day from '@salesforce/label/c.Day';
//Apex Classes
import getEvents from '@salesforce/apex/FullCalenderV2Controller.getAllRelatedEvents';
import getTranslations from '@salesforce/apex/FullCalenderV2Controller.getTranslations';
import getAccountId from '@salesforce/apex/FullCalenderV2Controller.getAccountId';
import getSalesManagerList from '@salesforce/apex/CustomerReviewFilterHandler.getSalesManagerList';
import getRepresentativeList from '@salesforce/apex/CustomerReviewFilterHandler.getRepresentativeList';
import getASMManager from '@salesforce/apex/CustomerReviewFilterHandler.getASMManager';
import getCompanies from '@salesforce/apex/CustomerReviewFilterHandler.getCompanies';

//Custom Labels for Filters
import Filter from '@salesforce/label/c.Filter';
import Select_Company from '@salesforce/label/c.Select_Company';
import Select_Sales_Manager from '@salesforce/label/c.Select_Sales_Manager';
import Representative from '@salesforce/label/c.Representative';
import Company from '@salesforce/label/c.Company';
import Sales_Manager from '@salesforce/label/c.Sales_Manager';
import Select_Representative from '@salesforce/label/c.Select_Representative';

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
    selectedCompany;
    selectedSalesManagerId;
    selectedRepresentativeId;
    isSlideVisible = false;
    isASM = false;
    showDateFields = true;
    companyOptions = [];
    salesManagerOptions = [];
    representativeOptions = [];
    isRepresentativeDisabled = true;
    isSalesManagerDisabled = true;
    isRepresentativeReadonly = false;
    isCompanyDisabled = true;
    currentUserName;
    currentUserRole;
    startDate;
    endDate;
    custLabel = {
        Today,Month,Week,Day, Filter,Select_Company,Select_Sales_Manager,
        Representative,Company,Sales_Manager,Select_Representative
    }
    toggleSlide() {
        this.isSlideVisible = !this.isSlideVisible;
    }
    get buttonContainerClass() {
        return this.isSlideVisible ? 'button-container slide-in' : 'button-container slide-out';
    }

    @api 
    set representativeId(val){
        this.currentUserId = val;
        this.updateCalenderEvents();
    }

    get representativeId(){
        return this.currentUserId;
    }

    @wire(getRecord, { recordId: userId, fields: [SALES_ROLE_FIELD, USER_NAME_FIELD, PROFILE_NAME_FIELD,USER_COMPANYNAME_FIELD,PROFILE_ID_FIELD] })
    userData({ error, data }) {
        if (data) {
            const salesRole = getFieldValue(data, SALES_ROLE_FIELD);
            const profileName = getFieldValue(data, PROFILE_NAME_FIELD);
            const profileId = getFieldValue(data, PROFILE_ID_FIELD);
            this.currentUserName = getFieldValue(data, USER_NAME_FIELD);
            this.currentUserRole = salesRole;
            // Logic based on user role and profile
            if (profileName === 'SFDC LOCAL ADMIN') {
                this.loadSalesManagerOptions();
            } else if (profileId === '00eb0000000lainAAA') {
                this.loadCompanyOptions();
            } else if (salesRole === 'ASM' || salesRole === 'AMS' || salesRole === 'KAM') {
                this.isASM = true;
                this.setASMManager();
            } else {
                this.loadSalesManagerOptions();
            }
        } else if (error) {
            console.error(error);
        }
    }

    
    setASMManager() {
        getASMManager()
            .then(manager => {
                this.selectedSalesManagerId = manager.Id;
                this.salesManagerOptions = [{ label: manager.Name, value: manager.Id }];
                this.isSalesManagerDisabled = true;
                this.isRepresentativeDisabled = false;
                this.isRepresentativeReadonly = true;
                this.loadRepresentativeOptionsForASM();
            })
            .catch(error => {
                console.error(error);
            });
    }

    loadCompanyOptions() {
        getCompanies()
            .then(data => {
                this.companyOptions = data.map(company => ({
                    label: company,
                    value: company
                }));
                this.isCompanyDisabled = false;
                this.isSalesManagerDisabled = true; // Ensure Sales Manager is disabled initially for Admin
            })
            .catch(error => {
                console.error(error);
            });
    }
    
    loadSalesManagerOptions() {
        getSalesManagerList({ companyName: this.selectedCompany })
        .then(data => {
            this.isSalesManagerDisabled = false;
            this.salesManagerOptions = data.map(user => ({
                label: user.Name,
                value: user.Id
            }));
        })
        .catch(error => {
            console.error(error);
        });
    }

    getStartOfWeek(date) {
        const day = date.getDay();
        const diff = date.getDate() - day + (day === 0 ? -6 : 1); // Adjust when day is Sunday
        return new Date(date.setDate(diff));
    }

    handleCompanyChange(event) {
        this.selectedCompany = event.detail.value;
        this.isSalesManagerDisabled = false;
        this.isRepresentativeDisabled = true; // Disable Representative dropdown
        this.representativeOptions = []; // Clear Representative dropdown options
        this.loadSalesManagerOptions();
        this.currentUserId = null;
        this.updateCalenderEvents();
    }
    
    handleSalesManagerChange(event) {
        this.selectedSalesManagerId = event.detail.value;
        this.currentUserId = null;
        this.isRepresentativeDisabled = false;
        this.loadRepresentativeOptions();
        this.updateCalenderEvents();
    }

    handleRepresentativeChange(event) {
        this.showDateFields = true;
        this.selectedRepresentativeId = event.detail.value;
        this.isRepresentativeDisabled = false;
        this.currentUserId = this.selectedRepresentativeId;
        this.updateCalenderEvents();
    }
    loadRepresentativeOptions() {
        getRepresentativeList({ selectedManagerId: this.selectedSalesManagerId})
            .then(data => {
                this.representativeOptions = data
                    .map(user => ({
                        label: user.Name,
                        value: user.Id
                    }))
            })
            .catch(error => {
                console.error(error);
            });
    }
    
    loadRepresentativeOptionsForASM() {
        // For ASM, the representative should only be the ASM themselves
        this.representativeOptions = [{ label: this.currentUserName, value: userId }];
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
                            if(Events[event].isPrivate){
                                title = "Busy"
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