import { LightningElement, wire ,track,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountLifeCycleRecordsUpdated from '@salesforce/apex/LifeCycleReportingController.getAccountLifeCycleRecordsUpdated';
import USER_ID from '@salesforce/user/Id';

//Custom Labels for Filters
import Visit_Zone from '@salesforce/label/c.Tacticom';
import Segmentation from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Segment';
import Channel from '@salesforce/label/c.Channel';
import CloseButton from '@salesforce/label/c.CloseButton';
import Strategic_Value_Net from '@salesforce/label/c.Strategic_Value_Net';
import Lenses_Net_Sales_L12Mo from '@salesforce/label/c.Lenses_Net_Sales_L12Mo';
import Okay from '@salesforce/label/c.Okay';
import CustomerReviewActivityModal from '@salesforce/label/c.CustomerReviewActivityModal';
import Note from '@salesforce/label/c.Note';
//New Filter UI Update
import CustomerReviewChartWarning from '@salesforce/label/c.CustomerReviewChartWarning';
import Consolidation_Team_Performance from '@salesforce/label/c.Consolidate_Team_Activity';

export default class LifeCycleReporting extends LightningElement  {
    @track isChartsVisible = false;
    @track isCompanyFilterVisible = false;
    @track containerClass = 'container';
    @track firstComponentClass = 'full-width';
    @track isSalesManagerDisabled = true;
    @track secondComponentClass = 'hidden';
    @track isShowModal = true;
    @track showSpinner = false;
    @track currentUserRole;
    @track currentUserId = USER_ID;
    @track currentUserProfile;
    @track isRepresentativeDisabled = true;
    @track profileId;

    //New Filter UI Update
    @track isTeamPerformanceChecked = false;
    @track isTeamPerformanceDisabled = true;
    @track repUserRecord = {};
    renderedCallback() {
        const divElement = this.template.querySelector('.customLabelContainer');
        if (divElement) {
            divElement.innerHTML =CustomerReviewActivityModal; // Set the custom label's HTML
        }
    }
    custLabel = {
        Visit_Zone,Segmentation,CloseButton,Channel,CustomerReviewChartWarning,
        Strategic_Value_Net,Lenses_Net_Sales_L12Mo,Okay,CustomerReviewActivityModal,Note,
        Consolidation_Team_Performance    //New Filter UI Update
    }

    //New Filter UI Update
    handleCheckboxEvents(event){
        this.isTeamPerformanceChecked = event.target.checked;
        this.fetchAccountRecords(this.isTeamPerformanceChecked);
    }

    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }

    records;
    recordsMaster;
    stageList;
    pickVals = []; // This will hold the array of values
    stageMap;
    recordId;
    accountStats;
    visitflagMap;
    lensesnetsalesl12mo;
    taskstats;
    displayList = [];
    @track netsaleslast12mosum = 0;
    @track netsaleslfysum = 0;
    pickValsTemp;
    isBarChartDataCalculated=false;
    isBarChartDataReceived=false;
    isCurrencyCodeSame =false;

    @track selectedCompanyValue = '';
    @track selectedOwnerValue = '';
    @track selectedSegmentationValue = '';
    @track selectedTacticomValue = '';
    @track selectedChannelValue = '';
    @track selectedManagerValue = '';
    ChannelList = [
        { label: 'No Filter', value: 'No Filter' },
        { label: 'Independent', value: 'Ind' },
        { label: 'Chain', value: 'Chain' }
    ];
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
    
    fetchAccountRecords() {
        this.showSpinner = true;
        getAccountLifeCycleRecordsUpdated({
            isConsolidatedDataNeeded : this.isTeamPerformanceChecked,
            selectedUserId : this.selectedOwnerValue
        })
        .then(result => {
            this.recordsMaster = result.lifeCycleWrapperList;
            this.pickVals = result.pickVals;
            this.accountStats = result.accountStatsMap;
            this.visitflagMap = result.visitFlagMap;
            this.lensesnetsalesl12mo = result.sowL12MoMap;
            this.taskstats = result.taskStatusMap;         
            this.accountCompanyList = result.accountCompanyList.map(option => ({ label: option, value: option }));
            this.TacticomList = result.TacticomList.map(option => ({ label: option, value: option })); 
            this.filteredRecords();
            if(result.isAdminUser == true){
                this.isCompanyFilterVisible = true;
                this.selectedCompanyValue =  this.currentUserCompany;
                if(this.selectedCompanyValue){
                    this.filteredRecords();
                }
                
            }
            this.calculateDataForCharts();
            this.checkCountryCurrencyCodes();
            let tempPickList  = JSON.parse(JSON.stringify(this.pickVals));
            try{
                for (let account of tempPickList){
                    let cleanedValue = String(account['summation']).replace(/,/g, '');
                    account['summation'] = this.convertToBrowserLocale(parseFloat(cleanedValue),account.accountCurrency);
                }
            }catch(e){
                this.showToast('Error','An error was occurred during stage count==>'+e.message,'error');
            }
            this.pickVals = tempPickList;            
            this.showSpinner = false;
        })
        .catch(error => {
            this.showToast('Error','getLifeCycleRecords error==>'+error.message,'error');
            this.showSpinner = false;

        });
    }
    
    toggleChartsVisibility() {
        if(this.firstComponentClass != 'seventy-width'){
            this.firstComponentClass = 'seventy-width';
            this.secondComponentClass = 'thirty-width';
            if(this.isBarChartDataCalculated==true){
                this.isBarChartDataReceived=true;
            }
            this.toggleChartSlide();
        }else{
            this.firstComponentClass = 'full-width';
            this.secondComponentClass = 'hidden';
            this.isBarChartDataReceived=false;
            this.toggleChartSlide();
        }
        
    }

    get equalwidthHorizontalAndVertical(){
        let len = this.pickVals.length
        return `width: calc(100%/ ${len})`
    }

    @api 
    set representativeId(val){
        this.selectedOwnerValue = val;
        this.isTeamPerformanceChecked = false;
        if(this.selectedOwnerValue != undefined && this.selectedOwnerValue != null){
            this.isRepresentativeDisabled = false;
            this.fetchAccountRecords(this.isTeamPerformanceChecked);
        }else{
            this.recordsMaster = [];
            this.records = this.recordsMaster;
            this.pickVals = {};
            this.filteredRecords;
        }
    }

    // Check if pickVals has items
    get hasPickVals() {
        return this.pickVals && this.pickVals.length > 0;
    }
    get representativeId(){
        return this.selectedRepresentativeId;
    }

    @api 
    set consolidationDisabled(val){
        this.isTeamPerformanceDisabled = val;
    }

    get consolidationDisabled(){
        return this.isTeamPerformanceDisabled;
    }
    handleSegmentationChange(event) {
        this.selectedSegmentationValue = event.detail.value;
        if(this.selectedSegmentationValue == 'No Filter'){
            this.selectedSegmentationValue = '';
        }
        this.filteredRecords();
    }
    handleTacticomChange(event) {
        this.selectedTacticomValue = event.detail.value;
        if(this.selectedTacticomValue == 'No Filter'){
            this.selectedTacticomValue = '';
        }
        this.filteredRecords();
    }
    handleChannelChange(event) {
        this.selectedChannelValue = event.detail.value;
        if(this.selectedChannelValue == 'No Filter'){
            this.selectedChannelValue = '';
        }
        this.filteredRecords();
    }
    filteredRecords() {
        if(this.recordsMaster && this.recordsMaster.length>0){
            if (!this.selectedOwnerValue && this.selectedSegmentationValue == '' && this.selectedTacticomValue == '' && this.selectedChannelValue == '' && this.selectedCompanyValue =='' && this.selectedManagerValue =='') {
                this.records = this.recordsMaster;
                if (['ASM', 'KAM', 'AMS'].includes(this.currentUserRole) && this.profileId !== '00eb0000000lainAAA' && this.currentUserProfile !== 'SFDC LOCAL ADMIN') {
                    this.records = this.recordsMaster.filter(record => {
                        return record.Account__r.Owner.Id === this.currentUserId;
                    });
                }            
            } else {
                let filteredRecords = this.recordsMaster.filter(record => { 
                    // Check if the record matches selected filter values
                    let matches = (!this.selectedSegmentationValue || record.Segmentation__c === this.selectedSegmentationValue) &&
                                (!this.selectedTacticomValue || record.Tacticom__c === this.selectedTacticomValue) &&
                                (!this.selectedChannelValue || record.Account__r.CHCUSTCLASSIFICATIONID__c === this.selectedChannelValue);

                    // Additional check for roles ASM, KAM, AMS
                    if (['ASM', 'KAM', 'AMS'].includes(this.currentUserRole) && this.profileId !== '00eb0000000lainAAA' && this.currentUserProfile !== 'SFDC LOCAL ADMIN') {
                        return matches && record.Account__r.Owner.Id === this.currentUserId;
                    }

                    return matches;
                });
                this.records = filteredRecords;
            }
            this.checkCountryCurrencyCodes();
            this.revalidateStageCount();
            this.calculateDataForCharts();
            this.handleCallChildMethodInParent();
            if(this.isCurrencyCodeSame == false){
                this.firstComponentClass = 'full-width';
                this.secondComponentClass = 'hidden';
                this.isBarChartDataReceived=false;
                this.isChartVisible = false;
            }
        }
    }
    initializeStageMap(records) {
        return records.reduce((obj, record) => {
            obj[record.stage] = 0;
            return obj;
        }, {});
    }

    revalidateStageCount(){
        var tempList = this.records;       
       // Extracting stage values and converting to object with '0' assigned
        let stageSummationMap = this.initializeStageMap(this.pickVals);
        let stageCountMap = this.initializeStageMap(this.pickVals);
        let summationOfStrategicValueMap = this.initializeStageMap(this.pickVals);
        tempList.forEach(record => {
            let stage = record.Stage__c;
            if (stageCountMap.hasOwnProperty(stage)) {
                stageCountMap[stage]++;
                stageSummationMap[stage] = stageSummationMap[stage] + record.Lenses_Net_Sales_Last_12Mo__c;
                summationOfStrategicValueMap[stage] = summationOfStrategicValueMap[stage] + record.Strategic_Value__c;
            } else {
                stageCountMap[stage] = 1;
                stageSummationMap[stage] = stageSummationMap[stage];
                summationOfStrategicValueMap[stage] = summationOfStrategicValueMap[stage];
            }
        });
        let tempPickList  = JSON.parse(JSON.stringify(this.pickVals));
        try{
            for (let account of tempPickList){
                account['noOfRecords'] = stageCountMap[account.stage];
                account['summation'] = this.convertToBrowserLocale(parseInt(stageSummationMap[account.stage]),account.accountCurrency);
                account['summationOfStrategicValue'] = this.convertToBrowserLocale(parseInt(summationOfStrategicValueMap[account.stage]),account.accountCurrency);
            }
        }catch(e){
            this.showToast('Error','An error was occurred during stage count==>'+e.message,'error');
        }
        this.pickVals = tempPickList;
    }

    calculateDataForCharts(){
        this.netsaleslast12mosum = 0;
        this.netsaleslfysum = 0;
        var tempList = this.records;
        tempList.forEach(record => {
            if (isNaN(record.Account__r.Lenses_Net_Sales_Last_12Mo__c) === false) {
                this.netsaleslast12mosum = this.netsaleslast12mosum + record.Account__r.Lenses_Net_Sales_Last_12Mo__c;
            }
            if (isNaN(record.Account__r.Lenses_Net_Sales_LFY__c) === false) {
                this.netsaleslfysum = this.netsaleslfysum + record.Account__r.Lenses_Net_Sales_LFY__c;
            }
            /*
            if(this.netsaleslfysum != undefined){
                this.netsaleslfysum = this.convertToBrowserLocale(this.netsaleslfysum,record.Account__r.CurrencyIsoCode);
            }
            if(this.netsaleslast12mosum != undefined){
                this.netsaleslast12mosum = this.convertToBrowserLocale(this.netsaleslast12mosum,record.Account__r.CurrencyIsoCode);
            }
            */
            this.isBarChartDataCalculated = true;
            
        });
    }
    convertToBrowserLocale(amount,code){
        const userLocale = navigator.language || 'en-US';
        const currencyFormatter = new Intl.NumberFormat(userLocale);
        return currencyFormatter.format(amount);
    }
    handleCallChildMethodInParent() {
        // Accessing the child component
        const childComponent = this.template.querySelector('c-life-cycle-Reporting-Charts');
        
        if (childComponent) {
            // Calling the method on the child component
            childComponent.handleCallChildMethod();
        }
    }

    @track isChartVisible = false;

    get chartContainerClass() {
        return this.isChartVisible ? 'showCharts' : 'hideCharts';
    }

    toggleChartSlide() {
        this.isChartVisible = !this.isChartVisible;
    }

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }
    checkCountryCurrencyCodes() {
        if (this.records && this.records.length > 0) {
            const firstCode = this.records[0].Account__r.CurrencyIsoCode;
            const allSame = this.records.every(record => record.Account__r.CurrencyIsoCode === firstCode);
            if (!allSame) {
                this.isCurrencyCodeSame = false;
            }else{
                this.isCurrencyCodeSame = true;
                this.pickValsTemp = this.pickVals;
                this.pickVals = JSON.parse(JSON.stringify(this.pickValsTemp));
                this.pickVals.forEach(record => {
                    record['accountCurrency'] = firstCode;
                });
                
            }
        }else{
            this.isCurrencyCodeSame = false;
        }
    }

    
}