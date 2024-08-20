import { LightningElement, api, wire } from 'lwc';
import { getListInfoByName } from "lightning/uiListsApi";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from "@salesforce/user/Id";
import LOCALE from '@salesforce/i18n/locale';
import ZoneModal from "c/visitZonesModal";

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
import QuickFilterLabel from '@salesforce/label/c.QuickFilter';
import QuickFilterHelpText from '@salesforce/label/c.QuickFilterHelpText';
import zoneListviews from '@salesforce/label/c.zoneListviews';
import Confirm_Action from '@salesforce/label/c.Confirm_Action';
import Account_Update_Confirmation from '@salesforce/label/c.Account_Update_Confirmation';
import ProspectLimitWarning from '@salesforce/label/c.prospectLimitWarning';
import Channel from '@salesforce/label/c.Channel';
import StrategicValueNet from '@salesforce/label/c.StrategicValue06';
import TotalPlannedVisits from '@salesforce/label/c.Total_Planned_Visits';
// Data Imports
import getCampaignOptions from '@salesforce/apex/VisitZonesController.getCampaignOptions';
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import fetchData from '@salesforce/apex/VisitZonesController.getFilteredAccounts';
import getPicklistdata from '@salesforce/apex/VisitPlanningV2Controller.getPicklistValues';
import removeTacticomSOF from '@salesforce/apex/VisitZonesController.removeTacticomSOF';

export default class VisitZonesFilters extends LightningElement {
    userId = userId;
    quickFilter = '';
    campaignId = '';
    campaignPresented = false;
    campaignPriority = false;
    targetList = false;
    isHVNA = false; 
    campaignOptions = [];
    allowedListviews= [];
    allowedtoDrag = true;
    listViews = [];
    campaignList = [];
    accountArray = [];
    accountColumns = [];
    isLoading = false;
    //_defaultfilterCriteria = {'$Tacticom':'Not Selected','$QuickFilter':this.selectedQuickFilter,'$NotClinics':'Not Clinics'};
    _defaultfilterCriteria = {'$OwnerId':userId,'$Tacticom':'Not Selected','$QuickFilter':this.selectedQuickFilter,'$NotClinics':'Not Clinics'};
    filterCriteria = {...this._defaultfilterCriteria};
    custLabel ={
        QuickFilterHelpText,QuickFilterLabel,listView,location,lifeCycle,campaigns,campaignOverview,plannedVisitsMap,Select_List_View,lblDistance,
        TotalPlannedVisits,StrategicValueNet,Channel,ProspectLimitWarning,Account_Update_Confirmation,Confirm_Action,
        removeFilters,page,of,Name,Select_Campaign,Exclude_Presented_Campaigns,Campaign_Priority_Only,lblDisplay,lblHideDisplay,
        ZIP,city,State,Last_Visit_S_D,Total_visits_achieved,Tacticom,AccountVisitTabSegmentation,VisionaryAlliance,HVC_Loyalty_Program,
        Show_Calender,Hide_Calender,Show_Filters,Hide_Filters,Account_has_Visit_planned_in_next_fortnight,Visit_not_planned_in_next_fortnight,
        Miyo_Smart_AuthorizeDealer,Lens_Net_Sales_L12Mo,AccountShareofWallet3Mo,Local_competitor,Customer_Review_Stage,
        Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY,Hoya_Account_ID,Accounts,label_save,schedule,cancel,AddExtraActivity,
        ExtraActivityPopup,Calender_Details,AssignedTo,Start_Date,End_Date,e_status,IsAllDayEvent,IsPrivate,Subject,Type,accountStatus,state    
    };
    toggleButtonText = this.custLabel.Hide_Filters;
    _showFilters = true;
    searchResults;
    showDropDown = false;
    records = [];
    displayedRecords = []; 
    listData = '';
    recordCount = 0; //Total number of records
    pageSize = 10; // Number of records per page
    currentPage = 1; // Current page number
    ChannelList;
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
    selectedListView;
    selectedQuickFilter;
    selectedCity;
    selectedState;
    selectedChannelValue;
    selectedSegmentationValue;
    selectedCampaignId;
    selectedExcludePresented;
    selectedCampaignPriorityOnly;
    selectedListViewFilters = [];
    picklistOptions = [{'Seiko_Network__c':'Account'}];
    connectedCallback(){
       getPicklistdata({objectFieldMap: JSON.stringify(this.picklistOptions)})
         .then(result => {
            console.log('getPicklistdata result'+JSON.stringify(result));
            if(result){
                if (result['Seiko_Network__c']) {
                    this.ChannelList =  [{ label: 'No Filter', value: '' },...result['Seiko_Network__c']];
                }
            }
        })
        .catch(error => {
            this.showToast('Error','Error fetching picklist Values: ==> '+JSON.stringify(error),'error');
        });
        this.callApexMethod('$Default');
        this.processListviews();
    }

    processListviews(){
        this.listViews = JSON.parse(zoneListviews);
    }
    @api 
    set showFilters(val){
        this._showFilters = val;
    }

    get showFilters(){
        return this._showFilters;
    }

    @api resetFilters(){
        this.selectedListView = null;
        this.selectedQuickFilter = '';
        this.selectedCity = '';
        this.selectedState = '';
        this.selectedChannelValue = '';
        this.selectedSegmentationValue = '';
        this.selectedCampaignId = '';
        this.selectedExcludePresented = false;
        this.selectedCampaignPriorityOnly = false;
        this.selectedListViewFilters = [];
        this.filterCriteria = {...this._defaultfilterCriteria};
        this.records = [];
        this.displayedRecords = [];
        this.updateDisplayedRecords();
        this.currentPage = 1;
        this.isLoading = false;
        this.clearSearchResults();
        this.callApexMethod('$Default');
    }

    @api refreshData(){
        let listView = this.selectedListView ? this.selectedListView : '';
        this.callApexMethod(listView);
    }

    @wire(getCampaignOptions, { showCampaign: true })
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
   /* 
   // Not required replaced with custom label
   @wire(getAccountListViews)
    wiredListViews({ error, data }) {
        if (data) {
            console.log('Listview data',JSON.stringify(data));
            this.listViews = data.map(listView => ({
                label: listView.Name,
                value: listView.DeveloperName
            }));
            console.log('Listview parsed',JSON.stringify(this.listViews));
        } else if (error) {
            this.showToast('Error','Error retrieving account list views: ==>'+error.message,'error');
        }
    }
    // Need to use this and get all List views at a time and parse the result
    @wire(getListInfosByName, {names: ['Account.Customers_w_o_Visit_Zones_CHAINS_V2']})
    getListInfosByNameWire({ data }) {
        if (data && data.results) {
           // this.listInfos = data.results.map(({ result }) => result);
            console.log('this.listInfos '+JSON.stringify(data.results ));
        }
    }*/

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
        this.records = JSON.parse(JSON.stringify(this.records)).sort((a, b) => {
            let aValue = getNestedValue(a, colName);
            let bValue = getNestedValue(b, colName);
                        if (aValue === null || aValue === undefined) aValue = '';
            if (bValue === null || bValue === undefined) bValue = '';
            if (typeof aValue === 'string') aValue = aValue.toLowerCase();
            if (typeof bValue === 'string') bValue = bValue.toLowerCase();
            if (aValue === null && bValue !== null) return -1 * isReverse;
            if (aValue !== null && bValue === null) return 1 * isReverse;
            if (aValue === null && bValue === null) return 0;
            if (typeof aValue === 'number' && typeof bValue === 'number') {
                return (aValue - bValue) * isReverse;
            }
            return (aValue > bValue ? 1 : -1) * isReverse;
        });
        this.updateDisplayedRecords();
        this.currentPage = 1;
}

    @wire(getListInfoByName, { objectApiName: ACCOUNT_OBJECT.objectApiName, listViewApiName: '$selectedListView' })
    listViewInfo({ error, data }) {
        if (data && data.filteredByInfo) {
            this.selectedListViewFilters = data.filteredByInfo;
            this.listData = JSON.stringify(data);
            if(this.selectedListView){
                this.callApexMethod('');
            }
        } else if (error) {
            this.showToast('Error','Error fetching list view data: ==>'+error.message,'error');
        }
    }

    isMouseDownInside = false;

    toggleFilterVisibility() {
        this.showFilters = !this.showFilters; // Toggle filter visibility
        if (this.showFilters) {
            this.toggleButtonText = this.custLabel.Show_Filters;
        } else {
            this.toggleButtonText = this.custLabel.Hide_Filters;
        }
    }
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
    clearSearchResults() {
        this.searchResults = null;
    }
    showPicklistOptions() {
        if (!this.searchResults) {
            this.showDropDown = true;
            this.searchResults = this.picklistOrdered;
        }
    }

    callApexMethod(filter) {
        let hasZeroSales = false;
        this.isLoading = true;
        if(filter != '$Default'){
            filter = this.selectedListView
        }
        fetchData({ selectedViewsFilter: this.selectedListViewFilters ,filterCriteria :this.filterCriteria, listViewName: filter, listDetails : this.listData})
        .then(result => {
            if(result && result.filteredAccounts){
                this.fetchAccountData(result.filteredAccounts);
                console.log('>>>result',result.filteredAccounts);
                if (result.prospectCount >= 20) {
                        console.log('>>>this.allowedtoDrag',this.allowedtoDrag);
                        this.allowedtoDrag = false;
                        console.log('>>>this.allowedtoDrag',this.allowedtoDrag);
                }
            }else{
                 this.isLoading = false;
            }
        })
        .catch(error => {
            this.showToast('Error', 'Error retrieving account Data: ==> ' + error.message, 'error');
            this.isLoading = false;
        });
    }

    fetchAccountData(result){
        this.records = result.map(account => {
            let formattedLnetSales = null;
            const locale = LOCALE;
            if (account.Lenses_Net_Sales_Last_12Mo__c) {
                const netSales = account.Lenses_Net_Sales_Last_12Mo__c;
                formattedLnetSales = new Intl.NumberFormat(locale, { style: 'currency', currency: account.CurrencyIsoCode }).format(netSales);
            }else{
                formattedLnetSales = new Intl.NumberFormat(locale, { style: 'currency', currency: account.CurrencyIsoCode }).format(0);
            }
            return {
                ...account,
                FormattedLenses_Net_Sales_Last_12Mo: formattedLnetSales,
                recordUrl: `/lightning/r/Account/${account.Id}/view`
            };
        });
        this.displayedRecords = this.records;
        this.updateDisplayedRecords();
        this.currentPage = 1;
        this.isLoading = false;
    }

    updateDisplayedRecords() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        this.displayedRecords = this.records.slice(startIndex, startIndex + this.pageSize);
        this.recordCount = this.records.length;
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
            this.callApexMethod('');
        }, 500);
    }

    handleListViewChange(event) {
        this.selectedListView = event.target.value;
    }

    handleQuickFilterChange(event) {
        this.selectedQuickFilter = event.target.value;
    }

    handleSearch(){
        this.HandleFilterChanges(this.selectedQuickFilter,'$QuickFilter');
    }

    handleCityChange(event) {
        this.selectedCity = event.target.value;
        this.HandleFilterChanges(this.selectedCity,'Shop_City__c');
    }

    handleStateChange(event) {
        this.selectedState = event.target.value;
        this.HandleFilterChanges(this.selectedState,'Shop_State__c');
    }

    handleChannelChange(event){
        this.selectedChannelValue = event.target.value;
        this.HandleFilterChanges(this.selectedChannelValue,'Seiko_Network__c');
    }

    handleSegmentationChange(event){
        this.selectedSegmentationValue = event.target.value;
        this.HandleFilterChanges(this.selectedSegmentationValue,'Segmentation_Net__c');
    }

    handleCampaignChange(event) {
        this.selectedCampaignId = event.target.value;
        this.HandleFilterChanges(this.selectedCampaignId,'Campaign_Membership__r.Central_Campaign__c');
    }

    handleExcludePresentedChange(event) {
        this.selectedExcludePresented = event.target.checked;
        this.HandleFilterChanges(this.selectedExcludePresented,'Campaign_Membership__r.Campaign_Presented__c');
    }
    handleCampaignPriorityChange(event) {
        this.selectedCampaignPriorityOnly = event.target.checked;
        this.HandleFilterChanges(this.selectedCampaignPriorityOnly,'Campaign_Membership__r.Campaign_Priority__c');
    }

    handleDragStart(event) {
        const target = event.target;

        // Log all data attributes for debugging
        console.log('Data attributes:', target.dataset);
        const lensesNetSales = target.dataset.lensesNetSalesLast12mo;
        if(!this.allowedtoDrag && (lensesNetSales <= 0 || lensesNetSales == null)){
            event.preventDefault();
            this.openProspectLimitWarning();
            return;
        }
        event.dataTransfer.setData('recordId', event.target.dataset.recordId);
        event.dataTransfer.setData('stage','');
        event.dataTransfer.effectAllowed = 'move';
    }
    handleDragOver(event) {
        event.preventDefault();
        event.dataTransfer.dropEffect = 'move';
    }
    refreshcardData(){
        const event = new CustomEvent('refreshcarddata', {
            detail: 'refresh',
            bubbles: false,
            composed: true        
        });
        this.dispatchEvent(event);
    }
    async openConfirmation(itemId) {
        ZoneModal.open({
            header : this.custLabel.Confirm_Action, 
            body: this.custLabel.Account_Update_Confirmation,
            buttonlabel: 'Confirm',
            size: 'small' //small, medium, large, and full
        }).then((result) => {
            if(result == 'Confirm'){
                this.updateAccount(itemId);
            }
        });
    }

    async openProspectLimitWarning() {
        ZoneModal.open({
            header : 'Warning', 
            body: this.custLabel.ProspectLimitWarning,
            buttonlabel: 'Ok',
            hidecancel : true,
            size: 'small' //small, medium, large, and full
        }).then((result) => {
            console.log(result);
        });
    }
    handleDrop(event){
        const itemId = event.dataTransfer.getData('recordId');
        const stage =  event.dataTransfer.getData('stage');
        if(stage){
            this.openConfirmation(itemId);
        }
    }
    updateAccount(droppedId){
        removeTacticomSOF({ accountId: droppedId})
        .then(result => {
            this.showToast('Success','Updated Successfully','success');
            let that =this;
            setTimeout(function(){
                if(that.selectedListView){
                    that.callApexMethod('');
                }else{
                    that.callApexMethod('$Default');
                }
                that.refreshcardData();
            },10);
        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
        });
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

}