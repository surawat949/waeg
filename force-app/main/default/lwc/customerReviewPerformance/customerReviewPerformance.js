import { LightningElement, api, track } from 'lwc';
import alc_performance_graph from '@salesforce/resourceUrl/alc_performance_graph';
import alc_performance_blue_backgrnd from '@salesforce/resourceUrl/alc_performance_blue_backgrnd';
import alc_performance_kpi from '@salesforce/resourceUrl/alc_performance_kpi';

//Calling apex methods
import getPerformanceDetails from '@salesforce/apex/CustomerReviewPerfomanceController.getPerformanceDetails';
import getVisitDetails from '@salesforce/apex/CustomerReviewPerfomanceController.getVisitDetails';

//Custom Labels for Filters
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
import Visits_Per_Day_In_Field from '@salesforce/label/c.Visits_Per_Day_In_Field';
import GREATER_THAN_500_USD_PERCENTAGE from '@salesforce/label/c.GREATER_THAN_500_USD_PERCENTAGE';
import NewDoors from '@salesforce/label/c.Monthly_New_Doors';
import LostDoors from '@salesforce/label/c.Monthly_Lost_Door';
import Direct_Digital from '@salesforce/label/c.Direct_Digital';
import Days_in_Field from '@salesforce/label/c.Days_in_Field';
import Accounts_Visited from '@salesforce/label/c.Accounts_Visited';
import Visits_A3_B3_C3 from '@salesforce/label/c.Visits_A3_B3_C3';
import Accounts_Visited_A3_B3_C3 from '@salesforce/label/c.Accounts_Visited_A3_B3_C3';

export default class CustomerReviewPerformance extends LightningElement {
    @track displayListView = 'hidden';
    @track selectedRepresentativeId;
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
	@track visitsPerDayInField = [];
	@track greaterThan500USDPercentage = [];
    @track accsVisitedA3 = [];
    @track tableMonths = [];
    @track emptyRow = [];
	@track persistantRepData = [];
    @track currencyTitle = 'Lenses Net Sales';
    @track greaterThan500Currency = '';
    @track repUserRecord = {};
    newDoorCount = [];
    lostDoorCount = [];
    activeSalesAvg='';
    greaterThan0Avg='';
    greaterThan500Avg='';
    dVisitsAvg='';
    uniqueDaysCountAvg='';
    accountsVisitedLstAvg='';
    greaterThan500PercAvg='';
    visitsA3Avg='';
    accsVisitedA3Avg='';
    visitsPerDayInFieldAvg='';
    newDoorAvg='';
    lostDoorAvg='';
    last12MonAvg='L12Mo AVG';
	custLabel = {
		Consolidation_Team_Performance,Monthly_Performance,Sales_Per_Active_Accounts,
		Active_Accounts,Visits,Prospection_Rate_A3_B3_C3,Greater_than_01,
		Greater_than_500_USD,Direct_Digital,Days_in_Field,Accounts_Visited,Visits_A3_B3_C3,Accounts_Visited_A3_B3_C3,
        CustomerReviewAdminAlert,CustomerReviewErrorAlert,Team_or_User_Sales_Performance,Team_or_User_Key_Performance_Indicators,
        Visits_Per_Day_In_Field,GREATER_THAN_500_USD_PERCENTAGE,NewDoors,LostDoors
    }

    @api 
    set representativeObj(val){
        this.loadFirstTabEmptyData();
        this.loadSecondTabEmptyData();
        this.isTeamPerformanceChecked = false;
        //this.resetAllArrays();
        if(val && val.Id){
            this.selectedRepresentativeId = val.Id;
            this.repUserRecord = val;
            this.getPerformanceDetailsUtility(false);
        }else{
            this.repUserRecord = {};
            this.selectedRepresentativeId = null;
        }
    }

    get representativeObj(){
        return this.selectedRepresentativeId;
    }

    @api 
    set consolidationDisabled(val){
        this.isTeamPerformanceDisabled = val;
    }

    get consolidationDisabled(){
        return this.isTeamPerformanceDisabled;
    }
	
	
    connectedCallback(){
        this.loadFirstTabEmptyData();
		this.loadSecondTabEmptyData();
    }   
	get containerStyle() {
        return `background-image: url(${alc_performance_blue_backgrnd});`;
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
        const date = new Date();
        var lastMonths = [],
        monthNames = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
        for (var i = 0; i < 12; i++) {
            lastMonths.push(monthNames[date.getMonth()]);
            date.setMonth(date.getMonth() - 1);
        }
        this.tableMonths = lastMonths;
        this.activeSales = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.greaterThan0 = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.greaterThan500 = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.dVisits = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.uniqueDaysCount =['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.accountsVisitedLst = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.visitsA3 = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.accsVisitedA3 = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.visitsPerDayInField = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.greaterThan500USDPercentage = ['', '', '', '', '', '', '', '', '', '', '', '']; 
        this.newDoorCount = ['', '', '', '', '', '', '', '', '', '', '', ''];  
        this.lostDoorCount = ['', '', '', '', '', '', '', '', '', '', '', ''];          
        this.activeSalesAvg = '';
        this.greaterThan0Avg = '';
        this.greaterThan500Avg = '';
        this.greaterThan500PercAvg = '';
        this.accountsVisitedLstAvg = '';
        this.accsVisitedA3Avg = '';
        this.visitsA3Avg = '';
        this.visitsPerDayInFieldAvg = '';
        this.dVisitsAvg = '';
        this.uniqueDaysCountAvg ='';
        this.newDoorAvg='';
        this.lostDoorAvg='';
        //Adding default empty rows.
        this.emptyRow = ['', '', '', '', '', '', '', '', '', '', '', '',''];  
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
        Promise.all([
            getPerformanceDetails({ user: this.repUserRecord, requireConsolidation : requireConsolidation}), 
            getVisitDetails({ user: this.repUserRecord, requireConsolidation : requireConsolidation}) 
        ])
        .then((results) => {
            this.salesData = results[0];  
            this.visitsData = results[1];
            this.budgetUtility(this.salesData.budgetDetails);
            this.convertData(this.salesData,this.visitsData);  
            this.showSpinner = false;
        })
        .catch((error) => {
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
		this.visitsPerDayInField = [];
		this.greaterThan500USDPercentage = [];
        this.newDoorCount = [];
        this.lostDoorCount = [];
        this.last12MonAvg='';
        this.activeSalesAvg = '';
        this.greaterThan0Avg = '';
        this.greaterThan500Avg = '';       
        this.newDoorAvg = '';
        this.lostDoorAvg = '';
        this.greaterThan500PercAvg = '';
        this.accountsVisitedLstAvg = '';
        this.accsVisitedA3Avg = '';
        this.visitsA3Avg = '';
        this.visitsPerDayInFieldAvg = '';
        this.dVisitsAvg = '';
        this.uniqueDaysCountAvg ='';
    }    
    
    convertData(jsonData,visitData) {
        // Utility function to compare with average and assign class        
        const mapDataWithClass = (monthList, dataArray, avgValue, dynamicMonth, isDoorsNewOrLost) => {
            return monthList.map((item, index) => ({
                value:dataArray[index],
                class: (item === dynamicMonth) ? 'dynamic-css' : '',
                fieldClass: isDoorsNewOrLost ? ((parseFloat(dataArray[index]) > avgValue) ? 'red-highlight' : '') : ((parseFloat(dataArray[index]) < avgValue) ? 'red-highlight' : '')
            }));
        }; 
        // Get the previous month
        let previousMonthName = this.getPreviousMonth();    
        this.tableMonths = jsonData.monthList;
        // Round and format data as needed
        this.activeSales = mapDataWithClass(jsonData.monthList, jsonData.activeSales.map(value => Math.round(value)), jsonData.activeSalesAvg, previousMonthName, false);
        this.greaterThan0 = mapDataWithClass(jsonData.monthList, jsonData.greaterThan0.map(value => Math.round(value)), jsonData.greaterThan0Avg, previousMonthName, false);
        this.greaterThan500 = mapDataWithClass(jsonData.monthList, jsonData.greaterThan500.map(value => Math.round(value)), jsonData.greaterThan500Avg, previousMonthName, false);
      
        this.currencyTitle = jsonData.title;
        this.greaterThan500Currency = jsonData.greaterThan500Currency;		
		let greaterThan500USDPercentageTemp = jsonData.greaterThan500USDPercentage.map(value => Math.round(value)); 
        this.greaterThan500USDPercentage = mapDataWithClass(jsonData.monthList, greaterThan500USDPercentageTemp.map(value => `${value}%`), jsonData.greaterThan500USDPercAvg, previousMonthName, false);
        this.newDoorCount = mapDataWithClass(jsonData.monthList, jsonData.newDoorCount.map(value => Math.round(value)), jsonData.newDoorAvg, previousMonthName, true);
        this.lostDoorCount = mapDataWithClass(jsonData.monthList, jsonData.LostDoorCount.map(value => Math.round(value)), jsonData.lostDoorAvg, previousMonthName, true);       

        this.activeSalesAvg = jsonData.activeSalesAvg;
        this.greaterThan0Avg = jsonData.greaterThan0Avg;
        this.greaterThan500Avg = jsonData.greaterThan500Avg;       
        this.newDoorAvg = jsonData.newDoorAvg;
        this.lostDoorAvg = jsonData.lostDoorAvg;
        this.greaterThan500PercAvg = jsonData.greaterThan500USDPercAvg+'%';
        this.last12MonAvg = 'L12Mo AVG';

        this.dVisits = mapDataWithClass(visitData.monthList, visitData.dVisits.map(value => Math.round(value)), visitData.dVisitsAvg, previousMonthName, false);
        this.uniqueDaysCount = mapDataWithClass(visitData.monthList, visitData.uniqueDaysCount.map(value => Math.round(value)), visitData.uniqueDaysCountAvg, previousMonthName, false);
        this.accountsVisitedLst = mapDataWithClass(visitData.monthList, visitData.accountsVisitedLst.map(value => Math.round(value)), visitData.accountsVisitedLstAvg, previousMonthName, false);
        let visitsA3Temp = visitData.visitsA3.map(value => Math.round(value)); 
        this.visitsA3 = mapDataWithClass(visitData.monthList, visitsA3Temp.map(value => `${value}%`), visitData.visitsA3Avg, previousMonthName, false);
        this.accsVisitedA3 = mapDataWithClass(visitData.monthList, visitData.accsVisitedA3.map(value => Math.round(value)), visitData.accsVisitedA3Avg, previousMonthName, false);
		let visitsPerDayInFieldTemp = visitData.visitsPerDayInField.map(value => Math.floor(value * 10) / 10);  
		this.visitsPerDayInField = mapDataWithClass(visitData.monthList, visitsPerDayInFieldTemp, visitData.visitsPerDayInFieldAvg, previousMonthName, false);		
        this.dVisitsAvg = visitData.dVisitsAvg;
        this.uniqueDaysCountAvg = visitData.uniqueDaysCountAvg;
        this.accountsVisitedLstAvg = visitData.accountsVisitedLstAvg;
        this.visitsA3Avg = visitData.visitsA3Avg+'%';
        this.accsVisitedA3Avg = visitData.accsVisitedA3Avg;
        this.visitsPerDayInFieldAvg = visitData.visitsPerDayInFieldAvg;
	}   
    budgetUtility(budgetDetails){
        let performanceList = budgetDetails.map(item => {
            const roundedValues = Object.fromEntries(
                Object.entries(item.values).map(([key, value]) => {
                    let roundedValue = Math.round(value);
                    if(item.metric.includes('%')){
                        //roundedValue = parseFloat(value.toFixed(2))
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
            //console.log(JSON.stringify(performanceListTemp));
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