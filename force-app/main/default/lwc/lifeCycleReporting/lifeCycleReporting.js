import { LightningElement, wire ,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLifeCycleRecords from '@salesforce/apex/LifeCycleReportingController.getAccountLifeCycleRecords';

export default class LifeCycleReporting extends LightningElement  {
    @track isChartsVisible = false;
    @track isCompanyFilterVisible = false;
    @track containerClass = 'container';
    @track firstComponentClass = 'full-width';
    @track secondComponentClass = 'hidden';
    @track isShowModal = true;
    @track showSpinner = false;
    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }
    addnewiconflag;
    records;
    recordsMaster;
    stageList;
    pickVals;
    stageMap;
    recordId;
    accountStats;
    lensesnetsalesl12mo;
    taskstats;
    visitflagMap;
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

    /*TacticomList = [
        { label: 'No Filter', value: 'No Filter' },
        { label: 'Sub-area 1', value: 'Sub-area 1' },
        { label: 'Sub-area 2', value: 'Sub-area 2' },
        { label: 'Sub-area 3', value: 'Sub-area 3' },
        { label: 'Sub-area 4', value: 'Sub-area 4' },
        { label: 'Sub-area 5', value: 'Sub-area 5' }
    ];*/
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
    CompanyNameList = [
        { label: 'No Filter', value: 'No Filter' },
        { label: 'HOTA', value: 'HOTA' },
        { label: 'HAPL', value: 'HAPL' },
        { label: 'HLAT', value: 'HLAT' },
        { label: 'HLBE', value: 'HLBE' },
        { label: 'HLBR', value: 'HLBR' },
        { label: 'HLCO', value: 'HLCO' },
        { label: 'HLCA', value: 'HLCA' },
        { label: 'HLCH', value: 'HLCH' },
        { label: 'HLCZ', value: 'HLCZ' },
        { label: 'HLFR', value: 'HLFR' },
        { label: 'HLHK', value: 'HLHK' },
        { label: 'HLHU', value: 'HLHU' },
        { label: 'HLIB', value: 'HLIB' },
        { label: 'HLNL', value: 'HLNL' },
        { label: 'HLPH', value: 'HLPH' },
        { label: 'HLPO', value: 'HLPO' },
        { label: 'HLRO', value: 'HLRO' },
        { label: 'HLRU', value: 'HLRU' },
        { label: 'HLSA', value: 'HLSA' },
        { label: 'HLSE', value: 'HLSE' },
        { label: 'HLSH', value: 'HLSH' },
        { label: 'HLSI', value: 'HLSI' },
        { label: 'HLTR', value: 'HLTR' },
        { label: 'HLUK', value: 'HLUK' },
        { label: 'HODG', value: 'HODG' },
        { label: 'HOLA', value: 'HOLA' },
        { label: 'HOLD', value: 'HOLD' },
        { label: 'HOLF', value: 'HOLF' },
        { label: 'HOLI', value: 'HOLI' },
        { label: 'HOLK', value: 'HOLK' },
        { label: 'HOLM', value: 'HOLM' },
        { label: 'HVEU', value: 'HVEU' },
        { label: 'MENA', value: 'MENA' },
        { label: 'SOA', value: 'SOA' },
        { label: 'SOB', value: 'SOB' },
        { label: 'SOC', value: 'SOC' },
        { label: 'SOES', value: 'SOES' },
        { label: 'SOE', value: 'SOE' },
        { label: 'SOF', value: 'SOF' },
        { label: 'SOG', value: 'SOG' },
        { label: 'SOHU', value: 'SOHU' },
        { label: 'SOI', value: 'SOI' },
        { label: 'SOPL', value: 'SOPL' },
        { label: 'SORU', value: 'SORU' },
        { label: 'SOSA', value: 'SOSA' },
        { label: 'SOT', value: 'SOT' },
        { label: 'SOUK', value: 'SOUK' },
        { label: 'SRX', value: 'SRX' },
        { label: 'SRX-CA', value: 'SRX-CA' },
        { label: 'THAI', value: 'THAI' },
        { label: 'VEUS', value: 'VEUS' },
        { label: 'HLID', value: 'HLID' },
        { label: 'ILENS', value: 'ILENS' },
        { label: 'HLIN', value: 'HLIN' },
        { label: 'HOMM', value: 'HOMM' },
        { label: 'HLSV', value: 'HLSV' }
    ];

    get buttonLabel() {
        return this.showFilters ? 'Hide Filters' : 'Show Filters';
    }
    connectedCallback() {
        this.showSpinner = true;
        getLifeCycleRecords()
        .then(result => {
            console.log(JSON.stringify(result));
            this.records = result.lifeCycleWrapperList;
            this.recordsMaster = result.lifeCycleWrapperList;
            this.pickVals = result.pickVals;
            this.accountStats = result.accountStatsMap;
            this.visitflagMap = result.visitFlagMap;
            this.lensesnetsalesl12mo = result.sowL12MoMap;
            this.taskstats = result.taskStatusMap;
            this.addnewiconflag = result.addNewIconFlag;
            this.OwnerList = result.ownerNameList.map(option => ({ label: option, value: option }));
            this.SalesManagerList = result.salesManagerList.map(option => ({ label: option, value: option }));
            this.accountCompanyList = result.accountCompanyList.map(option => ({ label: option, value: option }));
            this.TacticomList = result.TacticomList.map(option => ({ label: option, value: option })); 
            console.log('>>result.TacticomList',result.TacticomList);
            if(result.isAdminUser == true){
                this.isCompanyFilterVisible = true;
                this.selectedCompanyValue =  this.accountCompanyList.find(item => item.label !== "No Filter").value;
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
    
    @track isSlideVisible = false;

    get buttonContainerClass() {
        return this.isSlideVisible ? 'button-container slide-out' : 'button-container slide-in';
    }

    toggleSlide() {
        this.isSlideVisible = !this.isSlideVisible;
    }

    handleSalesManagerChange(event) {
        this.selectedManagerValue = event.detail.value;
        if(this.selectedManagerValue == 'No Filter'){
            this.selectedManagerValue = '';
        }
        this.filteredRecords();
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
        if(this.selectedCompanyValue == 'No Filter'){
            this.selectedCompanyValue = '';
        }
        this.filteredRecords();
    }
    filteredRecords() {
        if(this.selectedOwnerValue == '' && this.selectedSegmentationValue == '' && this.selectedTacticomValue == '' && this.selectedChannelValue == '' && this.selectedCompanyValue =='' && this.selectedManagerValue ==''){
            this.records = this.recordsMaster;
        }else{
            let filteredRecords = this.recordsMaster.filter(record => { 
                // Check if the record matches selected filter values
                return (!this.selectedOwnerValue || record.Account__r.Owner.Name === this.selectedOwnerValue) &&
                       (!this.selectedSegmentationValue || record.Segmentation__c === this.selectedSegmentationValue) &&
                       (!this.selectedTacticomValue || record.Tacticom__c === this.selectedTacticomValue) &&
                       (!this.selectedManagerValue || record.Account__r.Account_Owners_Manager__c === this.selectedManagerValue) &&
                       (!this.selectedChannelValue || record.Account__r.CHCUSTCLASSIFICATIONID__c === this.selectedChannelValue) &&
                       (!this.selectedCompanyValue || record.Account__r.Account_Owner_Company__c === this.selectedCompanyValue);
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
                
                console.log(this.pickVals);
            }
        }else{
            this.isCurrencyCodeSame = false;
        }
    }

    
}