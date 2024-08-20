import { LightningElement ,wire, track} from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
import FullCalendarJS_6 from '@salesforce/resourceUrl/FullCalendar5';
import NoHeader from '@salesforce/resourceUrl/HideLightningHeader';
import ACCOUNT_OBJECT from "@salesforce/schema/Account";

//Custom Labels
import listView from '@salesforce/label/c.tabListView';
import location from '@salesforce/label/c.tabMVAAccAdd_Location';
import lifeCycle from '@salesforce/label/c.tab_Life_Cycle';
import campaigns from '@salesforce/label/c.tab_Campaigns';
import accountList from '@salesforce/label/c.tab_Account_List';
import accountMap from '@salesforce/label/c.tab_Account_Map';
import campaignOverview from '@salesforce/label/c.tab_Campaign_Overview';
import plannedVisitsMap from '@salesforce/label/c.tab_Planned_Visits_Map';
import viewFilters from '@salesforce/label/c.View_Hide_Filters';
import removeFilters from '@salesforce/label/c.Remove_Filters';
import viewCalender from '@salesforce/label/c.View_or_Hide_Calender';
import Name from '@salesforce/label/c.Name';
import ZIP from '@salesforce/label/c.ZIP';
import city from '@salesforce/label/c.city';
import State from '@salesforce/label/c.State';
import Last_Visit_S_D from '@salesforce/label/c.Last_Visit_S_D';
import Total_visits_achieved from '@salesforce/label/c.Total_visits_achieved';
import Tacticom from '@salesforce/label/c.Tacticom';
import AccountVisitTabSegmentation from '@salesforce/label/c.AccountVisitTabSegmentation';
import VisionaryAlliance from '@salesforce/label/c.VisionaryAlliance';
import HVC_Loyalty_Program from '@salesforce/label/c.HVC_Loyalty_Program';
import Miyo_Smart_AuthorizeDealer from '@salesforce/label/c.Miyo_Smart_AuthorizeDealer';
import Lens_Net_Sales_L12Mo from '@salesforce/label/c.Lens_Net_Sales_L12Mo';
import AccountShareofWallet3Mo from '@salesforce/label/c.AccountShareofWallet3Mo';
import Local_competitor from '@salesforce/label/c.Local_competitor';
import page from '@salesforce/label/c.Page';
import of from '@salesforce/label/c.of';
import Customer_Review_Stage from '@salesforce/label/c.Customer_Review_Stage';
import Select_Campaign from '@salesforce/label/c.Select_Campaign';
import Exclude_Presented_Campaigns from '@salesforce/label/c.Exclude_Presented_Campaigns';
import Campaign_Priority_Only from '@salesforce/label/c.Campaign_Priority_Only';
import Select_List_View from '@salesforce/label/c.Select_List_View';
import Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY from '@salesforce/label/c.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY';

//Apex classes
import getAccountListViews from '@salesforce/apex/VisitPlanningV2Controller.getAccountListViews';
import getCampaignOptions from '@salesforce/apex/VisitPlanningV2Controller.getCampaignOptions';
import fetchData from '@salesforce/apex/VisitPlanningV2Controller.fetchData';
import getPicklistdata from '@salesforce/apex/VisitPlanningV2Controller.getPicklistValues';

export default class VisitPlanningv2 extends NavigationMixin(LightningElement) {   
    @track listViews = [];
    @track selectedListView = '';
    @track listViewName = '';
    @track records = [];
    @track selectedTacticomValue = '';
    @track selectedSegmentationValue = '';
    @track selectedChannelValue = '';
    @track selectedAlcStageValue = '';
    @track displayedRecords = []; // Records displayed on the current page
    @track pageSize = 20; // Number of records per page
    @track currentPage = 1; // Current page number
    @track tacticomFilter = '';
    @track zipFilter = '' ;
    @track cityFilter = '';
    @track campaignOptions = []; // Campaign options for combobox
    @track selectedCampaignId = ''; // Selected campaign Id
    @track excludePresented = false; // Exclude Presented Campaigns flag
    @track campaignPriorityOnly = false; // Campaign Priority Only flag

    selectedListViewFilters = [];
    toggleButtonText = 'Hide Filters';
    dataMaster;
    isLoading = true;
    picklistOrdered;
    searchResults;
    selectedSearchResult;
    showDropDown = false;
    record;
    custLabel ={
        listView,location,lifeCycle,campaigns,accountList,accountMap,campaignOverview,plannedVisitsMap,Select_List_View,
        viewFilters,removeFilters,viewCalender,page,of,Name,Select_Campaign,Exclude_Presented_Campaigns,Campaign_Priority_Only,
        ZIP,city,State,Last_Visit_S_D,Total_visits_achieved,Tacticom,AccountVisitTabSegmentation,VisionaryAlliance,HVC_Loyalty_Program,
        Miyo_Smart_AuthorizeDealer,Lens_Net_Sales_L12Mo,AccountShareofWallet3Mo,Local_competitor,Customer_Review_Stage,Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY
    }
    sortedColumn;
    sortedDirection = 'asc';
     @track upIconClass = 'sortIcon';
     @track downIconClass = 'sortIconDesc hidden';

    updateIconClasses() {
        if (this.sortedDirection === 'asc') {
            this.upIconClass = 'sortIcon';
            this.downIconClass = 'sortIconDesc hidden';
        } else if (this.sortedDirection === 'desc') {
            this.upIconClass = 'sortIcon hidden';
            this.downIconClass = 'sortIconDesc';
        }
    }

    sortRecs( event ) {

        let colName = event.target.name;
        console.log( 'Column Name is ' + colName );
        if ( this.sortedColumn === colName ) {
            this.sortedDirection = ( this.sortedDirection === 'asc' ? 'desc' : 'asc' );
        }
        else {
            this.sortedDirection = 'asc';
        }
        let isReverse = this.sortedDirection === 'asc' ? 1 : -1;
        this.sortedColumn = colName;
        console.log(this.dataMaster);
        // sort the data
        this.dataMaster = JSON.parse( JSON.stringify( this.dataMaster ) ).sort( ( a, b ) => {
            a = a[ colName ] ? a[ colName ].toLowerCase() : ''; // Handle null values
            b = b[ colName ] ? b[ colName ].toLowerCase() : '';
            return a > b ? 1 * isReverse : -1 * isReverse;
        });
        console.log(this.dataMaster);
        this.updateDisplayedRecords();
        this.currentPage = 1;
        this.applyFilters();
        this.getColumnClass(colName);
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
    Change(event){
        this.Data = event.detail.join(', ');
    }
    mouseDown(event){
        event.preventDefault();
    }
    DragOver(event) {
        event.preventDefault();
    }
    connectedCallback(){
        this.updateIconClasses();
        this.selectedListView = 'All_Accounts_1';
        this.selectedSearchResult = 'All_Accounts_1';

        getPicklistdata()
        .then(result => {
            if (result['Tacticom']) {
                this.TacticomList = result['Tacticom'].map(option => ({ label: option, value: option }));
            }
            if (result['Loyalty']) {
                this.ChannelList = result['Loyalty'].map(option => ({ label: option, value: option }));
            }
            if (result['Stage']) {
                this.ALCStageList = result['Stage'].map(option => ({ label: option, value: option }));
            }
        })
        .catch(error => {
            this.showToast('Error','Error fetching dropdown options: ==>'+error.message,'error');
        });
    }    
    handleRowAction(event) {
        const row = event.currentTarget.dataset.recordId;
        this.navigateToAccountPage(row);
        this.selectedListView = this.listViewName;
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
    @wire(getCampaignOptions)
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
            this.listViewName = this.selectedListView;
            this.selectedListViewFilters = data.info.filteredByInfo;
            this.callApexMethod();
        } else if (error) {
            this.showToast('Error','Error fetching list view data: ==>'+error.message,'error');
        }
    }

    callApexMethod() {
        fetchData({ selectedViewsFilter: this.selectedListViewFilters})
            .then(result => {
                this.records = result;
                this.dataMaster = result;
                this.displayedRecords = result;
                this.updateDisplayedRecords();
                this.currentPage = 1;
                this.applyFilters();
                this.isLoading = false;
                let that =  this;
                setTimeout(function(){
                    that.initializeDraggable(that);
                },1000);
                  
            })
            .catch(error => {
                this.showToast('Error','Error retrieving account Data: ==>'+error.message,'error');
            });
    }
    toggleFilterVisibility() {
        this.showFilters = !this.showFilters; // Toggle filter visibility
        if (this.showFilters) {
            this.toggleButtonText = 'Show Filters';
        } else {
            this.toggleButtonText = 'Hide Filters';
        }
    }
    handleListViewChange(event) {
        this.selectedListView = event.detail.value;
    }
    updateDisplayedRecords() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        this.displayedRecords = this.records.slice(startIndex, startIndex + this.pageSize);
    }
    handleDragStart(event) {
        const $ = jQuery.noConflict();
        if(!this.isJQueryUIInitialized){
            alert('jquery not loaded');
        }
        //event.preventDefault();
        const recordId = event.currentTarget.dataset.id;
        const accName = event.currentTarget.dataset.name;
        const start = event.currentTarget.dataset.starttime;
        const end = event.currentTarget.dataset.endtime;
        event.dataTransfer.setData('text/plain', recordId);
        event.dataTransfer.setData('accountId', recordId);
        event.dataTransfer.setData('accName', accName);
        return $( "<div class='ui-widget-header'>" + accName + "</div>" );
       
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
        const input = event.detail.value.toLowerCase();
        const result = this.picklistOrdered.filter((picklistOption) =>
            picklistOption.label.toLowerCase().includes(input)
        );
        this.searchResults = result;
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
    handleBlur(){
        setTimeout(() => {
            this.clearSearchResults();
        }, 1000);
        
    }
    renderedCallback() {
        if (this.isJQueryUIInitialized) {
            return;
        }
        Promise.allSettled([
            loadScript(this, FullCalendarJS_6 + '/lib/main.js'),
            loadStyle(this, FullCalendarJS_6 + '/lib/main.css'),
        ])
        .then(() => {
            this.isJQueryUIInitialized = true;
                    
        })
        .catch(error => {
            console.log('error'+error);
            this.showToast('Error','Error Updating New Full Calendar: ==>'+error.message,'error');
        });
    }
    initializeDraggable(that) {
        //const $ = jQuery.noConflict();
       /* $(this.template.querySelector('.draggable-row')).draggable({
            helper: "clone",
            iframeFix: true,
            zIndex: 999,
            cursor: "move",
            cursorAt: { top: -12, left: -20 }
        });
        */
        console.log('DOM loaded');
        var containerEl = that.template.querySelector('.accheadersection');
        console.log('containerEl',containerEl);
        new FullCalendar.Draggable(containerEl, {
            itemSelector: '.draggable-row',
            eventData: function(eventEl) {
                return {
                    title: eventEl.innerText
                };
            }
        });
    }

    handleRemoveFilters() {
        this.selectedListView = 'All_Accounts_1';
        this.selectedSearchResult = 'All_Accounts_1';
        this.selectedTacticomValue = '';
        this.cityFilter = '';
        this.zipFilter = '';
        this.selectedSegmentationValue = '';
        this.selectedChannelValue = '';
        this.selectedAlcStageValue = '';
        this.selectedCampaignId = '';
        this.excludePresented = false;
        this.campaignPriorityOnly = false;

        this.records = this.dataMaster;
        this.updateDisplayedRecords();
    }
    handleStatusChange(event) {
        this.selectedTacticomValue = this.template.querySelector('lightning-combobox').value;
        if(this.selectedTacticomValue == 'No Filter'){
            this.selectedTacticomValue = '';
        }
        this.applyFilters();
    }
    handleCityChange(event) {
        this.cityFilter = event.target.value;
        this.applyFilters();
    }
    handleZipChange(event) {
        this.zipFilter = event.target.value;
        this.applyFilters();
    }
    handleChannelChange(event) {
        this.selectedChannelValue = event.detail.value;
        if(this.selectedChannelValue == 'No Filter'){
            this.selectedChannelValue = '';
        }
        this.applyFilters();
    }
    handleSegmentationChange(event) {
        this.selectedSegmentationValue = event.detail.value;
        if(this.selectedSegmentationValue == 'No Filter'){
            this.selectedSegmentationValue = '';
        }
        this.applyFilters();
    }
    handleStageChange(event){
        this.selectedAlcStageValue = event.detail.value;
        if(this.selectedAlcStageValue == 'No Filter'){
            this.selectedAlcStageValue = '';
        }
        this.applyFilters();
    }
    handleCampaignChange(event) {
        this.selectedCampaignId = event.detail.value;
        if(this.selectedCampaignId == 'No Filter'){
            this.selectedCampaignId = '';
        }
        this.applyFilters();
    }
    handleExcludePresentedChange(event) {
        this.excludePresented = event.target.checked;
        this.applyFilters();
    }
    handleCampaignPriorityChange(event) {
        this.campaignPriorityOnly = event.target.checked;
        this.applyFilters();
    }
    applyFilters() {
        this.records = this.dataMaster.filter(account =>
            (
                (this.selectedCampaignId === '' || 
                    (account.Campaign_Membership__r && 
                     account.Campaign_Membership__r.some(member => member.Campaign_ID_String__c === this.selectedCampaignId))
                ) &&
                (
                    !this.excludePresented || (account.Campaign_Membership__r && 
                    account.Campaign_Membership__r.some(member => member.Campaign_Presented__c))
                ) &&
                (
                    !this.campaignPriorityOnly || (account.Campaign_Membership__r && 
                    account.Campaign_Membership__r.some(member => member.Campaign_Priority__c))
                ) &&
                (this.selectedTacticomValue === '' || account.TACTICOM_SOF__c === this.selectedTacticomValue) &&
                (this.cityFilter === '' || (account.Shop_City__c && account.Shop_City__c.toLowerCase().includes(this.cityFilter.toLowerCase()))) &&
                (this.zipFilter === '' || (account.Shop_Postal_Code__c && account.Shop_Postal_Code__c.toLowerCase().includes(this.zipFilter.toLowerCase()))) &&
                (this.selectedSegmentationValue === '' || account.Segmentation_Box__c === this.selectedSegmentationValue) &&
                (this.selectedChannelValue === '' || account.Seiko_Network__c === this.selectedChannelValue) &&
                (this.selectedAlcStageValue === '' || (account.Account_Life_Cycles__r && account.Account_Life_Cycles__r.some(lifeCycle => 
                    lifeCycle.Stage__c !== undefined && 
                    lifeCycle.Stage__c === this.selectedAlcStageValue
                )))
            )
        );
        this.updateDisplayedRecords();
    }
    showToast(title, message,variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }

}