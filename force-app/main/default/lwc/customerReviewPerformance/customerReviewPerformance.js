import { LightningElement, wire, track } from 'lwc';

//Getting fields for UI API
import USER_COMPANYNAME_FIELD from '@salesforce/schema/User.CompanyName';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import PROFILE_ID_FIELD from '@salesforce/schema/User.ProfileId';
import alc_performance_graph from '@salesforce/resourceUrl/alc_performance_graph';

import alc_performance_blue_backgrnd from '@salesforce/resourceUrl/alc_performance_blue_backgrnd';
import alc_performance_kpi from '@salesforce/resourceUrl/alc_performance_kpi';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import SALES_ROLE_FIELD from '@salesforce/schema/User.Sales_Role__c';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import USER_REGION from '@salesforce/schema/User.User_Region__c';
import CURRENCYISOCODE from '@salesforce/schema/User.DefaultCurrencyIsoCode';
import COMPANYNAME from '@salesforce/schema/User.CompanyName';

//Calling apex methods
import getPerformanceDetails from '@salesforce/apex/CustomerReviewPerfomanceController.getPerformanceDetails';
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
import Consolidation_Team_Performance from '@salesforce/label/c.Consolidation_Team_Performance';

//toast message declaration 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Custom Labels for data table
import Monthly_Performance from '@salesforce/label/c.Monthly_Performance';
import Sales_Per_Active_Accounts from '@salesforce/label/c.Sales_Per_Active_Accounts';
import Active_Accounts from '@salesforce/label/c.Active_Accounts';
import Visits from '@salesforce/label/c.visits';
import Prospection_Rate_A3_B3_C3 from '@salesforce/label/c.Prospection_Rate_A3_B3_C3';
import Greater_than_01 from '@salesforce/label/c.Greater_than_01';
import Greater_than_500_USD from '@salesforce/label/c.Greater_than_500_USD';
import CustomerReviewAdminAlert from '@salesforce/label/c.CustomerReviewAdminAlert';
import CustomerReviewErrorAlert from '@salesforce/label/c.CustomerReviewErrorAlert';

import Team_or_User_Sales_Performance from '@salesforce/label/c.Team_or_User_Sales_Performance';
import Team_or_User_Key_Performance_Indicators from '@salesforce/label/c.Team_or_User_Key_Performance_Indicators';

import Direct_Digital from '@salesforce/label/c.Direct_Digital';
import Days_in_Field from '@salesforce/label/c.Days_in_Field';
import Accounts_Visited from '@salesforce/label/c.Accounts_Visited';
import Visits_A3_B3_C3 from '@salesforce/label/c.Visits_A3_B3_C3';
import Accounts_Visited_A3_B3_C3 from '@salesforce/label/c.Accounts_Visited_A3_B3_C3';

export default class CustomerReviewPerformance extends LightningElement {
    @track companyOptions = [];
    @track salesManagerOptions = [];
    @track representativeOptions = [];
    @track isRepresentativeDisabled = true;
    @track isSalesManagerDisabled = true;
    @track isRepresentativeReadonly = false;
    @track isCompanyDisabled = true;
    @track isASM = false;
    @track isSlideVisible = false;
    @track displayListView = 'hidden';
    @track selectedCompany;
    @track selectedSalesManagerId;
    @track selectedRepresentativeId;
    @track currentUserId = USER_ID;
    @track currentUserName;
    @track currentUserRole;
    @track alc_performance_graph = alc_performance_graph;
    @track alc_performance_kpi = alc_performance_kpi;
    @track isTeamPerformanceChecked = false;
    @track isTeamPerformanceDisabled = true;
    @track emptyData = [];
    @track data = [];
    @track showSpinner = false;
    @track IsAuthorizedToUser = false;
    @track months = [               
        { label: 'APR', value: 'APR' },
        { label: 'MAY', value: 'MAY' },
        { label: 'JUN', value: 'JUN' },
        { label: 'JUL', value: 'JUL' },
        { label: 'AUG', value: 'AUG' },
        { label: 'SEP', value: 'SEP' },
        { label: 'OCT', value: 'OCT' },
        { label: 'NOV', value: 'NOV' },
        { label: 'DEC', value: 'DEC' },
        { label: 'JAN', value: 'JAN' },
        { label: 'FEB', value: 'FEB' },
        { label: 'MAR', value: 'MAR' },
        { label: 'TOT YTD', value: 'TOT YTD' },
    ];

    @track activeSales = [];
    @track greaterThan0 = [];
    @track greaterThan500 = [];
    @track dVisits = [];
    @track uniqueDaysCount = [];
    @track accountsVisitedLst = [];
    @track visitsA3 = [];
    @track accsVisitedA3 = [];
    @track tableMonths = [];
    @track emptyRow = [];
	@track persistantRepData = [];
    @track currencyTitle = 'Lenses Net Sales';
    @track greaterThan500Currency = '';
    @track repUserRecord = {};
    @track currentUserRegion;
    @track currentUserCurrency;
    @track companyName;
    @track currentUserDefaultCurrency
	custLabel = {
        Filter,Select_Company,Select_Sales_Manager,
        Representative,Company,Sales_Manager,Select_Representative,
		Consolidation_Team_Performance,Monthly_Performance,Sales_Per_Active_Accounts,
		Active_Accounts,Visits,Prospection_Rate_A3_B3_C3,Greater_than_01,
		Greater_than_500_USD,Direct_Digital,Days_in_Field,Accounts_Visited,Visits_A3_B3_C3,Accounts_Visited_A3_B3_C3,
        CustomerReviewAdminAlert,CustomerReviewErrorAlert,Team_or_User_Sales_Performance,Team_or_User_Key_Performance_Indicators		
    }
	
    connectedCallback(){
        this.loadFirstTabEmptyData();
		this.loadSecondTabEmptyData();
    }   
    get containerStyle() {
        return `background-image: url(${alc_performance_blue_backgrnd});`;
    }   
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [SALES_ROLE_FIELD, USER_NAME_FIELD, PROFILE_NAME_FIELD, USER_COMPANYNAME_FIELD,USER_REGION,CURRENCYISOCODE,COMPANYNAME,PROFILE_ID_FIELD]
    })
    userData({ error, data }) {
        if (data) {
            const salesRole = getFieldValue(data, SALES_ROLE_FIELD);
            const profileName = getFieldValue(data, PROFILE_NAME_FIELD);
            const profileId = getFieldValue(data, PROFILE_ID_FIELD);
            this.currentUserName = getFieldValue(data, USER_NAME_FIELD);
            this.currentUserRole = salesRole;   
            this.currentUserRegion = getFieldValue(data, USER_REGION);
            this.currentUserCurrency = getFieldValue(data, CURRENCYISOCODE);
            this.companyName =  getFieldValue(data, COMPANYNAME);
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
    loadFirstTabEmptyData(){
         const metrics = ["Quota FY","Sales FY","% Quota Achievement","Sales Last FY","% Last Year Achievement"];
         const months = ["APR", "AUG", "DEC", "FEB", "JAN", "JUL", "JUN", "MAR", "MAY", "NOV", "OCT", "SEP", "TOT_YTD"];
         this.data = metrics.map(metric => ({
             metric,
             values: Object.fromEntries(months.map(month => [month, ""]))
         }));
    }
	loadSecondTabEmptyData(){ 
        this.tableMonths = ['AUG', 'SEP', 'OCT', 'NOV', 'DEC', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL'];
        this.activeSales = ['', '', '', '', '', '', '', '', '', '', '', ''];
        this.greaterThan0 = ['', '', '', '', '', '', '', '', '', '', '', ''];
        this.greaterThan500 = ['', '', '', '', '', '', '', '', '', '', '', ''];
        this.dVisits = ['', '', '', '', '', '', '', '', '', '', '', ''];
        this.uniqueDaysCount =['', '', '', '', '', '', '', '', '', '', '', ''];
        this.accountsVisitedLst = ['', '', '', '', '', '', '', '', '', '', '', ''];
        this.visitsA3 = ['', '', '', '', '', '', '', '', '', '', '', ''];
        this.accsVisitedA3 = ['', '', '', '', '', '', '', '', '', '', '', ''];

        //Adding default empty rows.
        this.emptyRow = ['', '', '', '', '', '', '', '', '', '', '', ''];     
    }
    loadCompanyOptions() {
        getCompanies()
        .then(data => {
            this.companyOptions = data.map(company => ({
                label: company,
                value: company
            }));
            this.isCompanyDisabled = false;
            this.isSalesManagerDisabled = true;
        })
        .catch(error => {
            this.showToast(this.custLabel.CustomerReviewErrorAlert,this.custLabel.CustomerReviewAdminAlert,'error','dismissable');
            console.error(error);
        });
    }
    handleCompanyChange(event) {
        this.selectedCompany = event.detail.value;
        this.isSalesManagerDisabled = false;
        this.isRepresentativeDisabled = true;
        this.representativeOptions = [];
        this.loadSalesManagerOptions();
        this.resetAllArrays();
        this.loadFirstTabEmptyData();
	    this.loadSecondTabEmptyData();
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
            this.showToast(this.custLabel.CustomerReviewErrorAlert,this.custLabel.CustomerReviewAdminAlert,'error','dismissable');
            console.error(error);
        });
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
            this.showToast(this.custLabel.CustomerReviewErrorAlert,this.custLabel.CustomerReviewAdminAlert,'error','dismissable');
            console.error(error);
        });
    }

    handleSalesManagerChange(event) {
        this.selectedSalesManagerId = event.detail.value;
        this.isRepresentativeDisabled = false;
        this.loadRepresentativeOptions();
        this.resetAllArrays();
        this.loadFirstTabEmptyData();
	    this.loadSecondTabEmptyData();
    }
    loadRepresentativeOptions() {
        getRepresentativeList({ selectedManagerId: this.selectedSalesManagerId })
        .then(data => {
            this.persistantRepData = data;
            this.representativeOptions = data.map(user => ({
                label: user.Name,
                value: user.Id
            })).sort((a, b) => a.label.localeCompare(b.label));
        })
        .catch(error => {
            this.showToast(this.custLabel.CustomerReviewErrorAlert,this.custLabel.CustomerReviewAdminAlert,'error','dismissable');
            console.error(error);
        });
    }
    loadRepresentativeOptionsForASM() {
        this.representativeOptions = [{ label: this.currentUserName, value: this.currentUserId }];
        this.persistantRepData =  [{
            "Id": this.currentUserId,
            "Name": this.currentUserName,
            "Sales_Role__c": this.currentUserRole,
            "User_Region__c": this.currentUserRegion,
            "defaultCurrencyISOcode": this.currentUserCurrency,
            "CompanyName" : this.companyName
        }];
    }
    get buttonContainerClass() {
        return this.isSlideVisible ? 'button-container slide-in' : 'button-container slide-out';
    }
    toggleSlide() {
        this.isSlideVisible = !this.isSlideVisible;
    }    
    handleRepresentativeChange(event) {
        this.selectedRepresentativeId = event.detail.value;
        this.isRepresentativeDisabled = false;
        let matchingRecord = this.persistantRepData.find(record => record.Id === event.detail.value);        
        this.repUserRecord = matchingRecord;
        let representativeRole = matchingRecord.Sales_Role__c;
        if(representativeRole === 'NSM' || representativeRole === 'RSM' || representativeRole === 'RMS'){
            this.isTeamPerformanceDisabled = false;
            this.isTeamPerformanceChecked = false;
        }else{
            this.isTeamPerformanceDisabled = true;
            this.isTeamPerformanceChecked = false;
        }
        this.getPerformanceDetailsUtility(false);
    }     
    handleCheckboxEvents(event){
        this.isTeamPerformanceChecked = event.target.checked;
        if(this.isTeamPerformanceChecked){
            this.getPerformanceDetailsUtility(true);
        }else{
            this.getPerformanceDetailsUtility(false);
        }
    }
    
    getPerformanceDetailsUtility(requireConsolidation) {
        this.showSpinner = true;
        this.resetAllArrays();
        getPerformanceDetails({ user: this.repUserRecord, requireConsolidation : requireConsolidation})
        .then(result => { 
            if (result) {           
                this.budgetUtility(result.budgetDetails);                
                this.convertData(result)
            }else{
                this.loadFirstTabEmptyData();
                this.loadSecondTabEmptyData();
            }
            this.showSpinner = false;
        })
        .catch(error => {
            this.loadFirstTabEmptyData();
		    this.loadSecondTabEmptyData();
            this.showToast(this.custLabel.CustomerReviewErrorAlert,this.custLabel.CustomerReviewAdminAlert,'error','dismissable');
            this.showSpinner = false;
        }); 
    }
    resetAllArrays(){
        this.tableMonths = [];
        this.activeSales = [];
        this.greaterThan0 = [];
        this.greaterThan500 = [];
        this.dVisits = [];
        this.uniqueDaysCount = [];
        this.accountsVisitedLst = [];
        this.visitsA3 = [];
        this.accsVisitedA3 = [];
        this.data = [];
    }    
    
    convertData(jsonData) {
        // Utility function to map data with CSS classes
        const mapDataWithClass = (monthList, dataArray, dynamicMonth) => {
            return monthList.map((item, index) => ({
                value: dataArray[index],
                class: (item === dynamicMonth) ? 'dynamic-css' : ''
            }));
        };
    
        // Get the previous month
        let previousMonthName = this.getPreviousMonth();
    
        // Set properties
        this.showSpinner = false;
        this.tableMonths = jsonData.monthList;
        // Round and format data as needed
        this.activeSales = mapDataWithClass(jsonData.monthList, jsonData.activeSales.map(value => Math.round(value)), previousMonthName);
        this.greaterThan0 = mapDataWithClass(jsonData.monthList, jsonData.greaterThan0.map(value => Math.round(value)), previousMonthName);
        this.greaterThan500 = mapDataWithClass(jsonData.monthList, jsonData.greaterThan500.map(value => Math.round(value)), previousMonthName);
        this.dVisits = mapDataWithClass(jsonData.monthList, jsonData.dVisits.map(value => Math.round(value)), previousMonthName);
        this.uniqueDaysCount = mapDataWithClass(jsonData.monthList, jsonData.uniqueDaysCount.map(value => Math.round(value)), previousMonthName);
        this.accountsVisitedLst = mapDataWithClass(jsonData.monthList, jsonData.accountsVisitedLst.map(value => Math.round(value)), previousMonthName);
    
        let visitsA3Temp = jsonData.visitsA3.map(value => parseFloat(value.toFixed(2)));
        this.visitsA3 = mapDataWithClass(jsonData.monthList, visitsA3Temp.map(value => `${value}%`), previousMonthName);
        this.accsVisitedA3 = mapDataWithClass(jsonData.monthList, jsonData.accsVisitedA3.map(value => Math.round(value)), previousMonthName);
    
        this.currencyTitle = jsonData.title;
        this.greaterThan500Currency = jsonData.greaterThan500Currency;
    }
    
    budgetUtility(budgetDetails){
        let performanceList = budgetDetails.map(item => {
            const roundedValues = Object.fromEntries(
                Object.entries(item.values).map(([key, value]) => {
                    let roundedValue = Math.round(value);
                    if(item.metric.includes('%')){
                        roundedValue = parseFloat(value.toFixed(2))
                        roundedValue = `${roundedValue}%`;
                    }
                    return [key, roundedValue];
                })
            );
            return {
                ...item,
                values: roundedValues
            };
        });
        if(performanceList.length > 0){
            let previousMonthName = this.getPreviousMonth();
            let performanceListTemp = performanceList.map(item => {
                const updatedValues = Object.keys(item.values).reduce((acc, month) => {
                  acc[month] = {
                    value: item.values[month],
                    class: month === previousMonthName ? 'dataCell dynamic-css' : 'dataCell'                    
                  };
                  return acc;
                }, {});
                return {                    
                    metric: item.metric,
                    values: updatedValues,
                    isPercentageHolder : item.metric.includes('%')
                };
            });
            console.log(JSON.stringify(performanceListTemp));
            this.data = performanceListTemp;
        }else{
            this.loadFirstTabEmptyData();
        }
    }
    showToast(title, message, variant,mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
    getPreviousMonth() {
        const monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        const currentDate = new Date();
        const previousMonthIndex = (currentDate.getMonth() - 1 + 12) % 12;
        return monthNames[previousMonthIndex];
    }
}