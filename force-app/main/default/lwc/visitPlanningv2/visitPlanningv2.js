import { LightningElement ,wire, track} from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendar5';
import NoHeader from '@salesforce/resourceUrl/HideLightningHeader';
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import LOCALE from '@salesforce/i18n/locale';
import { getRecord } from 'lightning/uiRecordApi';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import userId from "@salesforce/user/Id";
import userName from '@salesforce/schema/User.Name';
//Custom Labels
import Accounts from '@salesforce/label/c.Accounts';
import Hoya_Account_ID from '@salesforce/label/c.Hoya_Account_ID';
import listView from '@salesforce/label/c.tabListView';
import location from '@salesforce/label/c.SFDC_V_2_tabMVAAccount_Location';
import lifeCycle from '@salesforce/label/c.Life_Cycle';
import campaigns from '@salesforce/label/c.Campaigns';
import accountList from '@salesforce/label/c.tab_Account_List';
import accountMap from '@salesforce/label/c.tab_Account_Map';
import campaignOverview from '@salesforce/label/c.tab_Campaign_Overview';
import plannedVisitsMap from '@salesforce/label/c.tab_Planned_Visits_Map';
import removeFilters from '@salesforce/label/c.Remove_Filters';
import Name from '@salesforce/label/c.Name';
import ZIP from '@salesforce/label/c.ZIP';
import city from '@salesforce/label/c.city';
import State from '@salesforce/label/c.State';
import Last_Visit_S_D from '@salesforce/label/c.Last_Visit_S_D';
import Total_visits_achieved from '@salesforce/label/c.Total_Visits_Achived';
import Tacticom from '@salesforce/label/c.Tacticom';
import AccountVisitTabSegmentation from '@salesforce/label/c.AccountVisitTabSegmentation';
import VisionaryAlliance from '@salesforce/label/c.VisionaryAlliance';
import HVC_Loyalty_Program from '@salesforce/label/c.HVC_Program';
import Miyo_Smart_AuthorizeDealer from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_MyoSmart';
import Lens_Net_Sales_L12Mo from '@salesforce/label/c.Lens_Net_Sales_L12Mo';
import AccountShareofWallet3Mo from '@salesforce/label/c.Share_of_wallet_3Mo';
import Local_competitor from '@salesforce/label/c.Local_competitor';
import page from '@salesforce/label/c.Page';
import of from '@salesforce/label/c.of';
import Customer_Review_Stage from '@salesforce/label/c.Customer_Review_Stage';
import Select_Campaign from '@salesforce/label/c.Select_Campaign';
import Exclude_Presented_Campaigns from '@salesforce/label/c.Exclude_Presented_Campaigns';
import Campaign_Priority_Only from '@salesforce/label/c.Campaign_Priority_Only';
import Select_List_View from '@salesforce/label/c.Select_List_View';
import Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY from '@salesforce/label/c.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY';
import lblDistance from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_Distance';
import Show_Calender from '@salesforce/label/c.Show_Calender';
import Hide_Calender from '@salesforce/label/c.Hide_Calender';
import Show_Filters from '@salesforce/label/c.Show_Filters';
import Hide_Filters from '@salesforce/label/c.Hide_Filters';
import Account_has_Visit_planned_in_next_fortnight from '@salesforce/label/c.Account_has_Visit_planned_in_next_fortnight';
import Visit_not_planned_in_next_fortnight from '@salesforce/label/c.Visit_not_planned_in_next_fortnight';
import lblDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Display';
import lblHideDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Hide';
import ExtraActivityPopup from '@salesforce/label/c.ExtraActivityPopup';
import Calender_Details from '@salesforce/label/c.Calender_Details';
import AssignedTo from '@salesforce/label/c.tabTaskModalAssignedTo';
import Start_Date from '@salesforce/label/c.Start_Date';
import End_Date from '@salesforce/label/c.End_Date';
import e_status from '@salesforce/label/c.e_status';
import IsAllDayEvent from '@salesforce/label/c.IsAllDayEvent';
import IsPrivate from '@salesforce/label/c.IsPrivate';
import Subject from '@salesforce/label/c.tabTaskModalSubject';
import Type from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_AccType';
import AddExtraActivity from '@salesforce/label/c.AddExtraActivity';
import label_save from '@salesforce/label/c.tabLabelSave';
import cancel from '@salesforce/label/c.ButtonCancel';
import schedule from '@salesforce/label/c.Schedule';
import accountStatus from '@salesforce/label/c.Account_Status';
import state from '@salesforce/label/c.SFDC_V2_MVA_Activation_State';
//Apex classes
import getAccountListViews from '@salesforce/apex/VisitPlanningV2Controller.getAccountListViews';
import getCampaignOptions from '@salesforce/apex/VisitPlanningV2Controller.getCampaignOptions';
import fetchData from '@salesforce/apex/VisitPlanningV2Controller.fetchData';
import getPicklistdata from '@salesforce/apex/VisitPlanningV2Controller.getPicklistValues';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
import getExtraActivityRecType from '@salesforce/apex/FullCalenderV2Controller.getExtraActivityRecTypeId';
import addExtraActivity from '@salesforce/apex/FullCalenderV2Controller.addExtraActivity';

export default class VisitPlanningv2 extends NavigationMixin(LightningElement) {   
    assignedTo;
    userName;
    userId = userId;
    type;
    isPrivate=false;
    isAllDay=false;
    start;
    end;
    data;
    description;
    isLoading;
    eventRecTypeId;
    typeOptions;
    isValidationSuccess;
    isModalOpen;
    isModalLoading =false;
    @track listViews = [];
    @track selectedListView = '';
    //@track listViewName = '';
    @track records = [];
    @track selectedTacticomValue = '';
    @track selectedSegmentationValue = '';
    @track selectedChannelValue = '';
    @track selectedAlcStageValue = '';
    @track displayedRecords = []; // Records displayed on the current page
    @track recordCount = 0; //Total number of records
    @track pageSize = 20; // Number of records per page
    @track currentPage = 1; // Current page number
    @track tacticomFilter = '';
    @track zipFilter = '' ;
    stateFilter = '';
    @track cityFilter = '';
    @track campaignOptions = []; // Campaign options for combobox
    @track selectedCampaignId = ''; // Selected campaign Id
    @track excludePresented = false; // Exclude Presented Campaigns flag
    @track campaignPriorityOnly = false; // Campaign Priority Only flag
    @track showCalender = true;
    @track firstComponentClass = 'slds-size--1-of-2';
    @track secondComponentClass = 'slds-size--1-of-2';

    custLabel ={
        listView,location,lifeCycle,campaigns,accountList,accountMap,campaignOverview,plannedVisitsMap,Select_List_View,lblDistance,
        removeFilters,page,of,Name,Select_Campaign,Exclude_Presented_Campaigns,Campaign_Priority_Only,lblDisplay,lblHideDisplay,
        ZIP,city,State,Last_Visit_S_D,Total_visits_achieved,Tacticom,AccountVisitTabSegmentation,VisionaryAlliance,HVC_Loyalty_Program,
        Show_Calender,Hide_Calender,Show_Filters,Hide_Filters,Account_has_Visit_planned_in_next_fortnight,Visit_not_planned_in_next_fortnight,
        Miyo_Smart_AuthorizeDealer,Lens_Net_Sales_L12Mo,AccountShareofWallet3Mo,Local_competitor,Customer_Review_Stage,
        Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY,Hoya_Account_ID,Accounts,label_save,schedule,cancel,AddExtraActivity,
        ExtraActivityPopup,Calender_Details,AssignedTo,Start_Date,End_Date,e_status,IsAllDayEvent,IsPrivate,Subject,Type,accountStatus,state
    }

    initialisedCalendar = false;
    selectedListViewFilters = [];
    toggleButtonText = this.custLabel.Hide_Filters;
    toggleCalenderViewText = this.custLabel.Hide_Calender;
    dataMaster;
    isLoading = true;
    picklistOrdered;
    searchResults;
    selectedSearchResult;
    showDropDown = false;
    showCampaign = false;
    record;
    sortedColumn;
    delayDropDownTimeout;
    sortedDirection = 'asc';
    filterCriteria = {};
   
    @wire(getRecord, { recordId: userId, fields: [userName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.Name.value != null) {
                this.userName = data.fields.Name.value;
                this.assignedTo = this.userName;
            }
        }
    }
    @wire(getExtraActivityRecType)
    getRecTypeId({data,error}){
        if(data){
            data = JSON.parse(JSON.stringify(data));
            this.eventRecTypeId = data;
            
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(getPicklistValuesByRecordType, {objectApiName : 'Event', recordTypeId: '$eventRecTypeId'})
    TYPE_PICKLIST_VALUE({data,error}){
        if(data){
            this.typeOptions = data.picklistFieldValues.Type.values;
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }    
           handlePrivate(event){
        this.isPrivate = event.target.checked;
    }
    handleAllDay(event){
        this.isAllDay = event.target.checked;
    }
    handleEnd(event){
        this.end = event.detail.value;
    }
    handleStart(event){
        this.start = event.detail.value;
    }
    handleType(event){
        this.type = event.detail.value;
    }
    handleDescription(event){
        this.description = event.detail.value;
    }
    handleCreateEvent(event){
        event.preventDefault();
        this.isLoading  = false;
        this.isValidationSuccess = true;       
        var inputCmp = this.template.querySelector('.type');
        var type = inputCmp.value;
        if (type == '' || type == null ) {
           this.showToast('Error', 'Please select Type', 'error');
           this.isValidationSuccess = false;
           return;
        }         
        var startDate = this.template.querySelector('.start');
        var start = startDate.value;
        if (start == '' || start == null ) {
            this.showToast('Error', 'Please select Start Date', 'error');
            this.isValidationSuccess = false;
            return;
        }  
        var endDate = this.template.querySelector('.end');
        var end = endDate.value;
        if (end == '' || end == null ) {
            this.showToast('Error', 'Please select End Date', 'error');
            this.isValidationSuccess = false;
            return;
        }
        if(this.isValidationSuccess){
            this.isModalLoading =true; 
            addExtraActivity({
                recTypeId:this.eventRecTypeId,
                userId:this.userId,
                EventType:this.type,
                description:this.description,                
                startTime:this.start,
                endTime:this.end,
                allDayEvent:this.isAllDay,
                isPrivate :this.isPrivate
            }).then(result=>{      
                this.isModalLoading =false;
                this.isModalOpen = false;
                setTimeout(
                    this.template.querySelector('c-full-calenderv2').refresh()
                    ,100);
                this.type = null;
                this.description = null;
                this.start = null;
                this.end = null;
                this.allDayEvent = false;
                this.isPrivate = false;
            }).catch(error=>{
                this.showToast('Error', 'Error', error.message);                
            });
        } 
            }
    closePopup() {
        this.isModalOpen = false;
    }

    handleCalenderView(){
        this.showCalender = !this.showCalender;
        if(this.showCalender == false){
            this.firstComponentClass = 'slds-size--2-of-2';
            this.secondComponentClass = 'slds-hide';
            this.toggleCalenderViewText = this.custLabel.Show_Calender;
        }else{
            this.firstComponentClass = 'slds-size--1-of-2';
            this.secondComponentClass = 'slds-size--1-of-2';
            this.toggleCalenderViewText = this.custLabel.Hide_Calender;
        }
    }
    
    sortRecords(event) {
        let colName = event.target.name;
        let isAsc = this.sortedColumn === colName ? !this.sortedDirection : true;
        this.sortedColumn = colName;
        this.sortedDirection = isAsc;
            this.records.sort((a, b) => {
            let aValue = a.Last_Sales_Statistics__r ? parseFloat(a.Last_Sales_Statistics__r[0].Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c) : isAsc ? Number.MAX_VALUE : -Number.MAX_VALUE;
            let bValue = b.Last_Sales_Statistics__r ? parseFloat(b.Last_Sales_Statistics__r[0].Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c) : isAsc ? Number.MAX_VALUE : -Number.MAX_VALUE;
                if (!isNaN(aValue) && !isNaN(bValue)) {
                return isAsc ? (aValue - bValue) : (bValue - aValue);
            } else if (isNaN(aValue) && isNaN(bValue)) {
                return 0;
            } else if (isNaN(aValue)) {
                return isAsc ? -1 : 1;
            } else {
                return isAsc ? 1 : -1;
            }
        });
        this.updateDisplayedRecords();
        this.currentPage = 1;
    }
    
        sortRecs( event ) {
        let colName = event.target.name;
        if (this.sortedColumn === colName) {
            this.sortedDirection = (this.sortedDirection === 'asc' ? 'desc' : 'asc');
        } else {
            this.sortedDirection = 'asc';
        }
        let isReverse = this.sortedDirection === 'asc' ? 1 : -1;
        this.sortedColumn = colName;
        const getNestedValue = (obj, path) => {
            return path.split('.').reduce((acc, part) => {
                if (Array.isArray(acc)) {
                    return acc.map(item => item && item[part]);
                }
                return acc && acc[part];
            }, obj);
        };
        const parseDate = (dateStr) => {
            if (!dateStr) return null;
            const [day, month, year] = dateStr.split('/');
            return new Date(`${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`);
        };
        const isDateColumn = colName === 'Last_Visit_date__c';
        this.records = JSON.parse(JSON.stringify(this.records)).sort((a, b) => {
            let aValue = getNestedValue(a, colName);
            let bValue = getNestedValue(b, colName);
                        if (aValue === null || aValue === undefined) aValue = '';
            if (bValue === null || bValue === undefined) bValue = '';
            if (isDateColumn) {
                aValue = aValue ? parseDate(aValue) : null;
                bValue = bValue ? parseDate(bValue) : null;
            } else {
                if (typeof aValue === 'string') aValue = aValue.toLowerCase();
                if (typeof bValue === 'string') bValue = bValue.toLowerCase();
            }
            if (aValue === null && bValue !== null) return -1 * isReverse;
            if (aValue !== null && bValue === null) return 1 * isReverse;
            if (aValue === null && bValue === null) return 0;
            if (isDateColumn || (typeof aValue === 'number' && typeof bValue === 'number')) {
                return (aValue - bValue) * isReverse;
            }
            return (aValue > bValue ? 1 : -1) * isReverse;
        });
            this.updateDisplayedRecords();
        this.currentPage = 1;
}

    TacticomList;
    ChannelList;
    ALCStageList;
    SegmentationList = [
        { label: 'No Filter', value: 'No Filter' },
        { label: 'UNCATEGORIZED', value: 'UNCATEGORIZED' },
        { label: 'A1', value: 'A1' },
        { label: 'A2', value: 'A2' },
        { label: 'A3', value: 'A3' },
        { label: 'B1', value: 'B1' },
        { label: 'B2', value: 'B2' },
        { label: 'B3', value: 'B3' },
        { label: 'C1', value: 'C1' },
        { label: 'C2', value: 'C2' },
        { label: 'C3', value: 'C3' }
    ];
    constructor(){
        super();
        loadStyle(this, NoHeader);
    }
    mouseDown(event){
        event.preventDefault();
    }
    DragOver(event) {
        event.preventDefault();
    }
    connectedCallback(){
        document.addEventListener('mouseup', this.handleDocumentMouseUp);
        this.selectedListView = 'All_Accounts_1';
        this.selectedSearchResult = 'All_Accounts_1';
        
        Promise.all([
            getPicklistdata(),
            getUserDetail()
        ])
        .then(results => {
            var result = results[0];
            var resultOne = results[1];
            if (result['Tacticom']) {
                this.TacticomList = result['Tacticom'].map(option => ({ label: option, value: option }));
            }
            if (result['Loyalty']) {
                this.ChannelList = result['Loyalty'].map(option => ({ label: option, value: option }));
            }
            if (result['Stage']) {
                this.ALCStageList = result['Stage'].map(option => ({ label: option, value: option }));
            }
            if(resultOne === true){
                this.showCampaign = true;
            }
        })
        .catch(error => {
            this.showToast('Error','Error fetching picklist Values: ==> '+JSON.stringify(error),'error');
        });
    }    
    handleRowAction(event) {
        const row = event.currentTarget.dataset.recordId;
        this.navigateToAccountPage(row);
        //this.selectedListView = this.listViewName;
    }
    navigateToAccountPage(accountId) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view',
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }
    @wire(getCampaignOptions, { showCampaign: '$showCampaign' })
    wiredCampaignOptions({error, data}) {
        if (data) {
            // Transform campaign data into combobox options format
            this.campaignOptions = data.map(campaign => ({
                label: campaign.Name,
                value: campaign.Id
            }));
            this.campaignOptions = [
                { label: 'No Filter', value: '' }, // New record added first
                ...this.campaignOptions // Spread existing records
            ];
        } else if (error) {
            this.showToast('Error','Error fetching campaign options ==>'+error.message,'error');
        }
    }
    @wire(getAccountListViews)
    wiredListViews({ error, data }) {
        if (data) {
            this.listViews = data.map(listView => ({
                label: listView.Name,
                value: listView.DeveloperName
            }));
            this.picklistOrdered = this.listViews.sort((a,b)=>{
                if(a.label < b.label){
                    return -1
                }
            })
        } else if (error) {
            this.showToast('Error','Error retrieving account list views: ==>'+error.message,'error');
        }
    }
    @wire(getListUi, { objectApiName: ACCOUNT_OBJECT.objectApiName, listViewApiName: '$selectedListView' })
    listViewInfo({ error, data }) {
        if (data) {
            this.isLoading = true;
            this.selectedListViewFilters = data.info.filteredByInfo;
            this.callApexMethod();
        } else if (error) {
            this.showToast('Error','Error fetching list view data: ==>'+error.message,'error');
        }
    }

    callApexMethod() {
        fetchData({ selectedViewsFilter: this.selectedListViewFilters ,filterCriteria :this.filterCriteria, listViewName: this.selectedListView})
        .then(result => {
            this.isLoading = true;
            this.fetchAccountData(result);
            let that = this;
            setTimeout(function() {
                that.initializeDraggable(that);
            }, 1000);
        })
        .catch(error => {
            this.showToast('Error', 'Error retrieving account Data: ==> ' + error.message, 'error');
            this.isLoading = false;
        });
    }
    fetchAccountData(result){
        this.records = result.map(account => {
            let formattedLastVisitDate = null;
            let formattedLnetSales = null;
            const locale = LOCALE;
            if (account.Last_Visit_date__c) {
                const date = new Date(account.Last_Visit_date__c);
                formattedLastVisitDate = new Intl.DateTimeFormat('en-GB', {
                    dateStyle: 'short'
                }).format(date);
            }
            if (account.Lenses_Net_Sales_Last_12Mo__c) {
                const netSales = account.Lenses_Net_Sales_Last_12Mo__c;
                formattedLnetSales = new Intl.NumberFormat(locale, { style: 'currency', currency: account.CurrencyIsoCode }).format(netSales);
            }else{
                formattedLnetSales = new Intl.NumberFormat(locale, { style: 'currency', currency: account.CurrencyIsoCode }).format(0);
            }
            return {
                ...account,
                Last_Visit_date__c: formattedLastVisitDate,
                FormattedLenses_Net_Sales_Last_12Mo: formattedLnetSales,
                recordUrl: `/lightning/r/Account/${account.Id}/view`
            };
        });
        this.dataMaster = this.records;
        this.displayedRecords = this.records;
        this.updateDisplayedRecords();
        this.currentPage = 1;
        this.displayOnMap();
        this.isLoading = false;
    }

    toggleFilterVisibility() {
        this.showFilters = !this.showFilters; // Toggle filter visibility
        if (this.showFilters) {
            this.toggleButtonText = this.custLabel.Show_Filters;;
        } else {
            this.toggleButtonText = this.custLabel.Hide_Filters;;
        }
    }
    handleListViewChange(event) {
        this.selectedListView = event.detail.value;
    }
    updateDisplayedRecords() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        this.displayedRecords = this.records.slice(startIndex, startIndex + this.pageSize);
        this.recordCount = this.records.length;
    }
    addExtraActivity(event){
        this.isModalOpen=true;  
    }  
    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updateDisplayedRecords();
        }
    }
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updateDisplayedRecords();
        }
    }
    get totalPages() {
        return Math.ceil(this.records.length / this.pageSize);
    }
    get isFirstPage() {
        return this.currentPage === 1;
    }
    get isLastPage() {
        return this.currentPage === this.totalPages;
    }
    get selectedValue() {
        return this.selectedSearchResult ? this.selectedSearchResult.label : null;
    }
    search(event) {
        this.isLoading = true;
        const input = event.detail.value.toLowerCase();
        const result = this.picklistOrdered.filter((picklistOption) =>
            picklistOption.label.toLowerCase().includes(input)
        );
        this.searchResults = result;
        if(input === ''){
            this.selectedListView = 'All_Accounts_1';
        }
        this.isLoading = false;
    }
    selectSearchResult(event) {
        const selectedValue = event.currentTarget.dataset.value;
        this.selectedListView = selectedValue;
        this.selectedSearchResult = this.picklistOrdered.find(
            (picklistOption) => picklistOption.value === selectedValue
        );
        this.clearSearchResults();
    }
    clearSearchResults() {
        this.searchResults = null;
    }
    showPicklistOptions() {
        if (!this.searchResults) {
            this.showDropDown = true;
            this.searchResults = this.picklistOrdered;
        }
    }
    
    renderedCallback() {
        if (this.isJQueryUIInitialized) {
            return;
        }
        Promise.allSettled([
            loadScript(this, FullCalendarJS + '/lib/main.js'),
            loadStyle(this, FullCalendarJS + '/lib/main.css')
        ])
        .then(() => {
            this.isJQueryUIInitialized = true;
            //this.initializeDraggable();           
        })
        .catch(error => {
            this.showToast('Error','Error loading jQuery and jQuery UI: ==>'+error.message,'error');
        });
    }
    initializeDraggable(that) {
        console.log('initializeDraggable');
        /*const $ = jQuery.noConflict();
        $(this.template.querySelector('.draggable-row')).draggable({
            helper: "clone",
            iframeFix: true,
            zIndex: 999,
            cursor: "move",
            cursorAt: { top: -12, left: -20 }
        });*/
        console.log('DOM loaded'+typeof FullCalendar);
        if(!this.initialisedCalendar){
            var containerEl = that.template.querySelector('.accheadersection');
            console.log('containerEl',containerEl);
            FullCalendar.Draggable(containerEl, {
                itemSelector: '.draggable-row',
                eventData: function(eventEl) {
                    return {
                        title: eventEl.innerText,
                        recordId: eventEl.dataset.id
                    };
                }
            });
            this.initialisedCalendar = true;
        }
    }

    handleRemoveFilters() {
        this.selectedListView = 'All_Accounts_1';
        this.selectedSearchResult = 'All_Accounts_1';
        this.selectedTacticomValue = '';
        this.cityFilter = '';
        this.zipFilter = '';
        this.stateFilter = '';
        this.selectedSegmentationValue = '';
        this.selectedChannelValue = '';
        this.selectedAlcStageValue = '';
        this.selectedCampaignId = '';
        this.excludePresented = false;
        this.campaignPriorityOnly = false;
        this.records = this.dataMaster;
        this.filterCriteria = {};
        this.records = this.dataMaster;
        this.callApexMethod();
    }
    HandleFilterChanges(value,apiName){
        clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            if(value == 'No Filter'){
                value = '';
            }
            if(value){
                this.filterCriteria[apiName] = value;
            }else{
                delete this.filterCriteria[apiName];
            }
            this.callApexMethod();
        }, 500);
    }
    handleCityChange(event) {
        this.cityFilter = event.target.value;
        this.HandleFilterChanges(this.cityFilter,'Shop_City__c');
    }
    handleZipChange(event) {
        this.zipFilter = event.target.value;
        this.HandleFilterChanges(this.zipFilter,'Shop_Postal_Code__c');
    }    
    handleStateChange(event) {
        this.stateFilter = event.target.value;
        this.HandleFilterChanges(this.stateFilter,'Shop_State__c');
    }
    handleStatusChange(event) {
        this.selectedTacticomValue = this.template.querySelector('lightning-combobox').value;
        this.HandleFilterChanges(this.selectedTacticomValue,'TACTICOM_SOF__c');
    }
    handleChannelChange(event) {
        this.selectedChannelValue = event.detail.value;
        this.HandleFilterChanges(this.selectedChannelValue,'Seiko_Network__c');
    }
    handleSegmentationChange(event) {
        this.selectedSegmentationValue = event.detail.value;
        this.HandleFilterChanges(this.selectedSegmentationValue,'Segmentation_Box__c');
    }
    handleStageChange(event){
        this.selectedAlcStageValue = event.detail.value;
        this.HandleFilterChanges(this.selectedAlcStageValue,'Account_Life_Cycles__r.Stage__c');
    }
    handleCampaignChange(event) {
        this.selectedCampaignId = event.detail.value;
        this.HandleFilterChanges(this.selectedCampaignId,'Campaign_Membership__r.Central_Campaign__c');
    }
    handleExcludePresentedChange(event) {
        this.excludePresented = event.target.checked;
        this.HandleFilterChanges(this.excludePresented,'Campaign_Membership__r.Campaign_Presented__c');
    }
    handleCampaignPriorityChange(event) {
        this.campaignPriorityOnly = event.target.checked;
        this.HandleFilterChanges(this.campaignPriorityOnly,'Campaign_Membership__r.Campaign_Priority__c');
    }
    
    showToast(title,message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }


    //Account Map portion
    @track zoomLevel = 12;
    @track vCenter;
    @track displayListView = 'hidden';
    @track mapMarkerTitle = 'Account Location';
    @track selectedMarkerValue = '';
    @track isDisplayList = true;
    @track dataOne = []; // Array to hold records with Visits__r.startdate < today or > today + 14
    @track dataTwo = [];
    @track datTwoMarkers = [];
    @track datOneMarkers = [];
    mapMarker = [];
    handleListViewShow(){
        this.displayListView = 'visible';
        this.isDisplayList = false;
    }

    handleListViewHide(){
        this.displayListView = 'hidden';
        this.isDisplayList = true;
    }
    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
    }
    displayOnMap(){
        this.dataOne = [];
        this.dataTwo = [];
        this.datOneMarkers = [];
        this.datTwoMarkers = [];
        const today = new Date();
        const todayPlus14 = new Date();
        todayPlus14.setDate(todayPlus14.getDate() + 14);

        this.records.forEach(record => {
            if (record.Visits__r && record.Visits__r[0].Start_Day__c) {
                const startDate = new Date(record.Visits__r[0].Start_Day__c);

                if (startDate > today && startDate < todayPlus14) {
                    this.dataOne.push(record);
                } else {
                    this.dataTwo.push(record);
                }
            } else {
                this.dataTwo.push(record);
            }
        });

        if(this.dataOne.length>0){
            this.datOneMarkers = this.dataOne
            .filter(account => account?.sf_latitude__c)
            .map(account => ({
            location : {
                //Latitude : account.sf_latitude__c,
                //Longitude : account.sf_longitude__c ,
                Street : account.Shop_Street__c,
                City : account.Shop_City__c,
                State : account.Shop_State__c,
                PostalCode : account.Shop_Postal_Code__c,
                Country : account.Shop_Country__c,

            },
            title : account.Name,
            value : account.Name,
            mapIcon : {
                path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                fillColor: 'red',
                fillOpacity: .6,
                strokeWeight: 1,
                scale: 1.2,  
            },
            icon : 'standard:campaign',
            description :   '<b>Account Name : </b>'+account.Name +
                            '<br><b>Street : </b>' + account.Shop_Street__c + '<br><b>City : </b>'+account.Shop_City__c +
                            '<br><b>Visit Date : </b>' + account.Visits__r[0].Start_Day__c + '<br><b>Zip : </b>'+account.Shop_Postal_Code__c + 
                            '<br><b>State : </b>' + account.Shop_State__c,

            }));
        }
        if(this.dataTwo.length>0){
            this.datTwoMarkers = this.dataTwo
            .filter(account => account?.sf_latitude__c)
            .map(account => ({
            location : {
                Street : account.Shop_Street__c,
                City : account.Shop_City__c,
                State : account.Shop_State__c,
                PostalCode : account.Shop_Postal_Code__c,
                Country : account.Shop_Country__c,
            },
            title : account.Name,
            value : account.Name,
            mapIcon : {
                path: 'M11,0A11.01245,11.01245,0,0,0,0,11C0,21.36133,9.95166,29.44238,10.37549,29.78125a1.00083,1.00083,0,0,0,1.249,0C12.04834,29.44238,22,21.36133,22,11A11.01245,11.01245,0,0,0,11,0Z',
                fillColor: 'red',
                fillOpacity: .6,
                strokeWeight: 1,
                scale: 0.9,  
            },
            icon : 'standard:campaign',
            description :   '<b>Account Name : </b>'+account.Name +
                            '<br><b>Street : </b>' + account.Shop_Street__c + '<br><b>City : </b>'+account.Shop_City__c + 
                            '<br><b>State : </b>' + account.Shop_State__c + '<br><b>Zip : </b>'+account.Shop_Postal_Code__c,

            }));
        }
        var accountWithLatitude = {};
        
        if(this.dataTwo.length > 0){
            accountWithLatitude = this.dataTwo.find(account => {
                return account.Shop_Postal_Code__c !== '' || account.Shop_State__c !== '' || account.Shop_Country__c !== '' || account.Shop_State__c !== '';
            });
        }else if(this.dataOne.length > 0){
            accountWithLatitude = this.dataOne.find(account => {
                return account.Shop_Postal_Code__c !== '' || account.Shop_State__c !== '' || account.Shop_Country__c !== '' || account.Shop_State__c !== '';
            });
        }

        this.vCenter = {
            location : {
                //Latitude: accountWithLatitude?.sf_latitude__c || 0, // default to 0 if undefined
                //Longitude: accountWithLatitude?.sf_longitude__c || 0, // default to 0 if undefined            
                Street : accountWithLatitude?.Shop_Street__c || '',
                City : accountWithLatitude?.Shop_City__c || '',
                State : accountWithLatitude?.Shop_State__c || '',
                PostalCode : accountWithLatitude?.Shop_Postal_Code__c || '',
                Country : accountWithLatitude?.Shop_Country__c || ''
            },
        };

        //this.mapMarker = this.datOneMarkers;
        this.mapMarker = [...this.datOneMarkers, ...this.datTwoMarkers];
    }
    handleKeyChange(event){
        //get the value when changed the combo-box.
        this.isLoading = true;
        if(event.target.name === 'picklistOptDistance'){
            this.distanceValue = event.target.value;
            
            if(this.distanceValue == 20){
                this.zoomLevel = 12;
            }else if(this.distanceValue == 30){
                this.zoomLevel = 11;
            }else if(this.distanceValue == 50){
                this.zoomLevel = 10;
            }else if(this.distanceValue == 100){
                this.zoomLevel = 9;
            }else if(this.distanceValue == 200){
                this.zoomLevel = 8;
            }else if(this.distanceValue == 300){
                this.zoomLevel = 7;
            }else if(this.distanceValue == 500){
                this.zoomLevel = 6;
            }else{
                this.zoomLevel = 12;
            }
            this.displayOnMap();
        }
        this.isLoading = false;
    }
    get optDistanceValue(){
        return[
            {label : '20', value : '20'},
            {label : '30', value : '30'},
            {label : '50', value : '50'},
            {label : '100', value : '100'},
            {label : '200', value : '200'},
            {label : '300', value : '300'},
            {label : '500', value : '500'}
        ];
    }
    isMouseDownInside = false;

    handleFocusIn() {
        this.isMouseDownInside = true;
    }
    handleFocusOut(event) {
                this.isMouseDownInside = this.template.querySelector('.combo-box').contains(event.target);
    }
    handleMouseDown(event) {
        this.isMouseDownInside = this.template.querySelector('.combo-box').contains(event.target);
            }
    handleBlur(event){
        clearTimeout(this.delayTimeoutOne);
        this.isMouseDownInside = this.template.querySelector('.combo-box').contains(event.target);
        if(!this.isMouseDownInside){
            this.delayTimeoutOne =  setTimeout(() => {
                this.clearSearchResults();
            }, 1000);
        }
    }   
    disconnectedCallback() {
        document.removeEventListener('mouseup', this.handleDocumentMouseUp);
    }
   
    handleDocumentMouseUp = (event) => {
        clearTimeout(this.delayTimeoutOne);
        if(!this.isMouseDownInside){
            this.delayTimeoutOne =  setTimeout(() => {
                this.clearSearchResults();
            }, 1000);
        }
        this.isMouseDownInside = this.template.querySelector('.combo-box').contains(event.target);
    }
    closeModal(){
        this.isModalOpen = false;
    }
}