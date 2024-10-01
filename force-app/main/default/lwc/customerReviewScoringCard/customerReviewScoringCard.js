import { LightningElement,api,track } from 'lwc';
//Custom Labels for Filters
import Consolidation_Team_Performance from '@salesforce/label/c.Consolidation_Team_Performance';
//toast message declaration 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Custom Labels for data table
import Monthly_Performance from '@salesforce/label/c.Monthly_Performance';
import Level_1_FONDAMENTALS from '@salesforce/label/c.Level_1_FONDAMENTALS';
import Level_2_VISITS from '@salesforce/label/c.Level_2_VISITS';
import Level_3_DATA_COLLECTION from '@salesforce/label/c.Level_3_DATA_COLLECTION';
import Level_4_KEY_ACTIVITIES from '@salesforce/label/c.Level_4_KEY_ACTIVITIES';
import MiyoSmartSegmentation from '@salesforce/label/c.MiyoSmartSegmentation';
import Use_Of_Showpad from '@salesforce/label/c.Use_Of_Showpad';
import Active_Campaigns from '@salesforce/label/c.Active_Campaigns';
import H_S_Hub from '@salesforce/label/c.H_S_Hub';
import HVC_Loyatly_Program from '@salesforce/label/c.HVC_Loyatly_Program';
import Business_Opportunities_A1_A2_B1_B2 from '@salesforce/label/c.Business_Opportunities_A1_A2_B1_B2';
import Referring_Prescribers_A1_A2_B1_B2 from '@salesforce/label/c.Referring_Prescribers_A1_A2_B1_B2';
import Competitors_SOW_90 from '@salesforce/label/c.Competitors_SOW_90';
import Contacts from '@salesforce/label/c.Contacts';
import StrategicValue from '@salesforce/label/c.StrategicValue';
import Respect_Of_Planned_Visits from '@salesforce/label/c.Respect_Of_Planned_Visits';
import Use_Of_Visit_Zones from '@salesforce/label/c.Use_Of_Visit_Zones';
import ProspectionRate_A3_B3_C3 from '@salesforce/label/c.ProspectionRate_A3_B3_C3';
import Visits_Per_Day_In_Field from '@salesforce/label/c.Visits_Per_Day_In_Field';
import Reporting_In_Max_1_Day from '@salesforce/label/c.Reporting_In_Max_1_Day';
import Preparation_Of_Visits from '@salesforce/label/c.Preparation_Of_Visits';
import Use_Of_Visit_Planning from '@salesforce/label/c.Use_Of_Visit_Planning';
import Planning_Visits_In_Advance from '@salesforce/label/c.Planning_Visits_In_Advance';
import Planning_During_Home_Office_Day from '@salesforce/label/c.Planning_During_Home_Office_Day';

export default class CustomerReviewScoringCard extends LightningElement {
    @track isTeamPerformanceChecked = false;
    @track isTeamPerformanceDisabled = true;
    @track displayListView = 'hidden';
    @track selectedRepresentativeId;
    @track showSpinner = false;
    @track repUserRecord = {};
    @track IsAuthorizedToUser = false;
    @track months = [  
        { label: 'AUG', value: 'AUG' },
        { label: 'SEP', value: 'SEP' },
        { label: 'OCT', value: 'OCT' },
        { label: 'NOV', value: 'NOV' },
        { label: 'DEC', value: 'DEC' },
        { label: 'JAN', value: 'JAN' },
        { label: 'FEB', value: 'FEB' },
        { label: 'MAR', value: 'MAR' },
        { label: 'APR', value: 'APR' },
        { label: 'MAY', value: 'MAY' },
        { label: 'JUN', value: 'JUN' },
        { label: 'JUN', value: 'JUN' },
        { label: 'Objective', value: 'Objective' },
        { label: 'L12Mo vs. Objective', value: 'L12Mo vs. Objective' },
    ];
    @track emptyRow = [];
    @track planningDuringHomeOfficeDay = [];
    @track planningVisitsInAdvance = [];
    @track useOfVisitPlanning = [];
    @track preparationOfVisits = [];
    @track reportingInMax1Day = [];
    @track visitsPerDayInField = [];    
    @track prospectionRateA3B3C3 = [];
    @track respectOfPlannedVisits = [];
    @track useOfVisitZones = [];

    @track strategicValue = [];
    @track contacts = [];
    @track competitorsSow = [];
    @track referringPrescribers = [];
    @track businessOpportunities = [];
    @track hvcLoyatlyProgram = [];
    @track hsHub = [];
    @track activeCampaigns = [];
    @track useOfShowpad = [];
    @track miyoSmartSegmentation = [];
    custLabel = {
        Level_1_FONDAMENTALS,
        Level_2_VISITS,
        Level_3_DATA_COLLECTION,
        Level_4_KEY_ACTIVITIES,
        MiyoSmartSegmentation,
        Use_Of_Showpad,
        Active_Campaigns,
        H_S_Hub,
        HVC_Loyatly_Program,
        Business_Opportunities_A1_A2_B1_B2,
        Referring_Prescribers_A1_A2_B1_B2,
        Competitors_SOW_90,
        Contacts,
        StrategicValue,
        Respect_Of_Planned_Visits,
        Use_Of_Visit_Zones,
        ProspectionRate_A3_B3_C3,
        Visits_Per_Day_In_Field,
        Reporting_In_Max_1_Day,
        Preparation_Of_Visits,
        Use_Of_Visit_Planning,
        Planning_Visits_In_Advance,
        Planning_During_Home_Office_Day,
        Consolidation_Team_Performance,
        Monthly_Performance
    };    
    @api 
    set representativeObj(val){
        this.loadEmptyData();
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
        this.loadEmptyData();
    }
    loadEmptyData(){
        this.planningDuringHomeOfficeDay = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.planningVisitsInAdvance = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.useOfVisitPlanning = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.preparationOfVisits = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.reportingInMax1Day = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.emptyRow = ['', '', '', '', '', '', '', '', '', '', '', '','',''];

        this.visitsPerDayInField = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.prospectionRateA3B3C3 = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.useOfVisitZones = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.respectOfPlannedVisits = ['', '', '', '', '', '', '', '', '', '', '', '','',''];

        this.strategicValue = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.contacts = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.competitorsSow = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.referringPrescribers = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.businessOpportunities = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.hvcLoyatlyProgram = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.hsHub = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.activeCampaigns = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.useOfShowpad = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
        this.miyoSmartSegmentation = ['', '', '', '', '', '', '', '', '', '', '', '','',''];
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
        this.showSpinner = false;       
    }
    resetAllArrays(){
        this.planningDuringHomeOfficeDay = [];
        this.planningVisitsInAdvance = [];
        this.useOfVisitPlanning = [];
        this.preparationOfVisits = [];
        this.reportingInMax1Day = [];
        this.visitsPerDayInField = [];
        this.prospectionRateA3B3C3 = [];
        this.useOfVisitZones = [];
        this.respectOfPlannedVisits = [];
        this.strategicValue = [];
        this.contacts = [];
        this.competitorsSow = [];
        this.referringPrescribers = [];
        this.businessOpportunities = [];
        this.hvcLoyatlyProgram = [];
        this.hsHub = [];
        this.activeCampaigns = [];
        this.useOfShowpad = [];
        this.miyoSmartSegmentation = []; 
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
}