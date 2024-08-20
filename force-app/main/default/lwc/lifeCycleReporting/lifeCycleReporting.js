import { LightningElement, wire ,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLifeCycleRecords from '@salesforce/apex/LifeCycleReportingController.getAccountLifeCycleRecords';
import getSalesManagerList from '@salesforce/apex/CustomerReviewFilterHandler.getSalesManagerList';
import getRepresentativeList from '@salesforce/apex/CustomerReviewFilterHandler.getRepresentativeList';
import getASMManager from '@salesforce/apex/CustomerReviewFilterHandler.getASMManager';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import SALES_ROLE_FIELD from '@salesforce/schema/User.Sales_Role__c';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import USER_COMPANYNAME_FIELD from '@salesforce/schema/User.CompanyName';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import PROFILE_ID_FIELD from '@salesforce/schema/User.ProfileId';
const FIELDS = [SALES_ROLE_FIELD,PROFILE_NAME_FIELD,USER_COMPANYNAME_FIELD,PROFILE_ID_FIELD,USER_NAME_FIELD];

//Custom Labels for Filters
import Filter from '@salesforce/label/c.Filter';
import Select_Company from '@salesforce/label/c.Select_Company';
import Select_Sales_Manager from '@salesforce/label/c.Select_Sales_Manager';
import Representative from '@salesforce/label/c.Representative';
import Company from '@salesforce/label/c.Company';
import Sales_Manager from '@salesforce/label/c.Sales_Manager';
import Select_Representative from '@salesforce/label/c.Select_Representative';
import Visit_Zone from '@salesforce/label/c.Tacticom';
import Segmentation from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Segment';
import Channel from '@salesforce/label/c.Channel';
import CloseButton from '@salesforce/label/c.CloseButton';
import Strategic_Value_Net from '@salesforce/label/c.Strategic_Value_Net';
import Lenses_Net_Sales_L12Mo from '@salesforce/label/c.Lenses_Net_Sales_L12Mo';
import Okay from '@salesforce/label/c.Okay';
import CustomerReviewActivityModal from '@salesforce/label/c.CustomerReviewActivityModal';
import Note from '@salesforce/label/c.Note';
import CustomerReviewChartWarning from '@salesforce/label/c.CustomerReviewChartWarning';

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
    custLabel = {
        Filter,Select_Company,Select_Sales_Manager,Visit_Zone,Segmentation,CloseButton,
        Representative,Company,Sales_Manager,Select_Representative,Channel,CustomerReviewChartWarning,
        Strategic_Value_Net,Lenses_Net_Sales_L12Mo,Okay,CustomerReviewActivityModal,Note
    }

    @wire(getRecord, { recordId: USER_ID, fields: FIELDS })
    wiredUser({ error, data }) {
        if (data) {
            this.currentUserRole = data.fields.Sales_Role__c.value;
            this.profileId = getFieldValue(data, PROFILE_ID_FIELD);
            this.currentUserProfile = getFieldValue(data, PROFILE_NAME_FIELD);
            this.currentUserCompany = getFieldValue(data, USER_COMPANYNAME_FIELD);
            this.currentUserName = getFieldValue(data, USER_NAME_FIELD);
            // Logic based on user role and profile
            if (this.currentUserProfile === 'SFDC LOCAL ADMIN') {
                this.loadSalesManagerOptions();
            } else if (this.currentUserRole === 'ASM' || this.currentUserRole === 'AMS' || this.currentUserRole === 'KAM') {
                this.isASM = true;
                this.setASMManager();
            } else if (this.profileId !== '00eb0000000lainAAA') {
                this.loadSalesManagerOptions();
            }  
            this.fetchAccountRecords();
        } else if (error) {
            this.showToast('Error','Error fetching user data: '+e.message,'error');
        }
    }
    // Set ASM manager details
    setASMManager() {
        getASMManager()
            .then(manager => {
                this.selectedManagerValue = manager.Id;
                this.SalesManagerList = [{ label: manager.Name, value: manager.Id }];
                this.isRepresentativeDisabled = false;
                this.loadRepresentativeOptionsForASM();
            })
            .catch(error => {
                this.showToast('Error','An error occurred during fetching manager ==>'+error.message,'error');
            });
    }
    // Load representative options for ASM role
    loadRepresentativeOptionsForASM() {
        // For ASM, the representative should only be the ASM themselves
        this.OwnerList = [{ label: this.currentUserName, value: this.currentUserId }];
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
    pickVals;
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
    
    get buttonLabel() {
        return this.showFilters ? 'Hide Filters' : 'Show Filters';
    }
    fetchAccountRecords() {
        this.showSpinner = true;
        getLifeCycleRecords()
        .then(result => {
            this.recordsMaster = result.lifeCycleWrapperList;
            this.pickVals = result.pickVals;
            this.accountStats = result.accountStatsMap;
            this.visitflagMap = result.visitFlagMap;
            this.lensesnetsalesl12mo = result.sowL12MoMap;
            this.taskstats = result.taskStatusMap;
            if (this.currentUserRole === 'ASM' || this.currentUserRole === 'AMS' || this.currentUserRole === 'KAM'){
                this.isSalesManagerDisabled = true;
            }else{
                this.isSalesManagerDisabled = false;
                this.OwnerList = [
                    { label: 'No Filter', value: 'No Filter' },  // Add this entry as the first item
                    ...result.ownerNameList.map(user => ({
                        label: user.Name,
                        value: user.Id
                    }))
                ];
                this.SalesManagerListOne = result.salesManagerList.map(option => ({ label: option, value: option }));
                //this.SalesManagerList = result.managerList.map(option => ({ label: option, value: option }));
                this.SalesManagerList = [
                    { label: 'No Filter', value: 'No Filter' },  // Add this entry as the first item
                    ...result.managerList.map(user => ({
                        label: user.Name,
                        value: user.Id
                    }))
                ];
            }
            
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
                    account['summation'] = this.convertToBrowserLocale(account['summation'],account.accountCurrency);
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
    
    @track isSlideVisible = true;

    get buttonContainerClass() {
        return this.isSlideVisible ? 'button-container slide-out' : 'button-container slide-in';
    }

    toggleSlide() {
        this.isSlideVisible = !this.isSlideVisible;
    }

    handleSalesManagerChange(event) {
        this.selectedManagerValue = event.detail.value;
        this.OwnerList = '';
        if(this.selectedManagerValue == 'No Filter' || this.selectedManagerValue == ''){
            this.isRepresentativeDisabled = true;
            this.selectedOwnerValue='';
            this.selectedManagerValue = '';
            this.filteredRecords();
        }else{
            this.loadRepresentativeOptions();
        }
    }
    handleAOChange(event) {
        this.selectedOwnerValue = event.detail.value;
        if(this.selectedOwnerValue == 'No Filter'){
            this.selectedOwnerValue = '';
        }
        this.filteredRecords();
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
    handleCommpanyChange(event) {
        this.selectedCompanyValue = event.detail.value;
        this.isRepresentativeDisabled = true;
        if(this.selectedCompanyValue == 'No Filter' || this.selectedCompanyValue == ''){
            this.selectedCompanyValue = '';
            this.selectedOwnerValue='';
            this.SalesManagerList = this.SalesManagerListOne;
            this.OwnerList = this.OwnerList;
        }else{
            this.selectedManagerValue = '';
        }
        this.OwnerList = '';
        this.loadSalesManagerOptions();
    }
    loadSalesManagerOptions() {
        getSalesManagerList({ companyName: this.selectedCompanyValue })
            .then(data => {
                this.isSalesManagerDisabled = false;
                this.SalesManagerList = [
                    { label: 'No Filter', value: '' }  // Add this entry as the first item
                ].concat(
                    data.map(user => ({
                        label: user.Name,
                        value: user.Id
                    }))
                );                
                this.filteredRecords();
            })
            .catch(error => {
                this.showToast('Error','An error occurred during fetching manager ==>'+error.message,'error');
            });
    }
    // Load representative options based on selected sales manager
    loadRepresentativeOptions() {
        getRepresentativeList({ selectedManagerId: this.selectedManagerValue })
            .then(data => {
                this.isRepresentativeDisabled = false;
                this.OwnerList = [
                    { label: 'No Filter', value: '' }  // Add this entry as the first item
                ].concat(
                    data
                        .map(user => ({
                            label: user.Name,
                            value: user.Id
                        }))
                );
                console.log(JSON.stringify(this.OwnerList));
                this.selectedOwnerValue='';
                this.filteredRecords();
            })
            .catch(error => {
                this.showToast('Error','An error occurred during fetching representatives==>'+error.message,'error');
            });
    }
    filteredRecords() {
        if (this.selectedOwnerValue == '' && this.selectedSegmentationValue == '' && this.selectedTacticomValue == '' && this.selectedChannelValue == '' && this.selectedCompanyValue =='' && this.selectedManagerValue =='') {
            this.records = this.recordsMaster;
            if (['ASM', 'KAM', 'AMS'].includes(this.currentUserRole) && this.profileId !== '00eb0000000lainAAA' && this.currentUserProfile !== 'SFDC LOCAL ADMIN') {
                this.records = this.recordsMaster.filter(record => {
                    return record.Account__r.Owner.Id === this.currentUserId;
                });
            }            
        } else {
            let filteredRecords = this.recordsMaster.filter(record => { 
                // Check if the record matches selected filter values
                let matches = (!this.selectedOwnerValue || record.Account__r.Owner.Id === this.selectedOwnerValue) &&
                              (!this.selectedSegmentationValue || record.Segmentation__c === this.selectedSegmentationValue) &&
                              (!this.selectedTacticomValue || record.Tacticom__c === this.selectedTacticomValue) &&
                              (!this.selectedChannelValue || record.Account__r.CHCUSTCLASSIFICATIONID__c === this.selectedChannelValue) &&
                              (!this.selectedCompanyValue || record.Account__r.Account_Owner_Company__c === this.selectedCompanyValue);

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