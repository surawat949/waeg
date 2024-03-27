import { LightningElement, api ,track,wire} from 'lwc';
import TacticomDetails from '@salesforce/apex/TabVisitsController.TacticomDetails';
import getAccByZone from '@salesforce/apex/TabVisitsController.getAccountsByZone';
import ParentAggregate from '@salesforce/apex/TabVisitsController.Aggregate';
import recommendedAccountsByZone from '@salesforce/apex/TabVisitsController.recommendedAccountsByZone';
import getIndicators from '@salesforce/apex/TabVisitsIndicatorController.getAIIndicators';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PARENTID_FIELD from '@salesforce/schema/Account.ParentId';
import OWNER_NAME from '@salesforce/schema/Account.Owner.Name';
import BUDDYOWNER_FIELD from '@salesforce/schema/Account.TACTICOM_Owner__c';
import OWNER_FIELD from '@salesforce/schema/Account.OwnerId';
import TACTICOM_SOF from '@salesforce/schema/Account.TACTICOM_SOF__c';
import APACVisitVisitSummary from '@salesforce/label/c.APACVisitVisitSummary';
import Segmentation_Box from '@salesforce/schema/Account.Segmentation_Box__c';
import Last_Visit_date from '@salesforce/schema/Account.Last_Visit_date__c';
import Last_Digital_Visit_date from '@salesforce/schema/Account.Last_Digital_Visit_Date__c';
import Total_Visits_Achieved from '@salesforce/schema/Account.Total_Visits_Achieved__c';
import Visit_Frequency_Status from '@salesforce/schema/Account.Visit_Frequency_Status__c';
import Digital_Visits_Frequency from '@salesforce/schema/Account.Digital_Visits_Frequency__c';
import Total_Visits_Planned from '@salesforce/schema/Account.Total_Visits_Planned__c';
import Agreed_Visits from '@salesforce/schema/Account.Agreed_Visits__c';
import Agreed_No_of_Digital_Visits from '@salesforce/schema/Account.Agreed_No_of_Digital_Visits__c';
import Tacticom from '@salesforce/label/c.Tacticom';
import Parent_Account_Segmentation from '@salesforce/label/c.Parent_Account_Segmentation';
import Add_Parent_Account from '@salesforce/label/c.Add_Parent_Account';
import { NavigationMixin } from 'lightning/navigation';
import Parent_Account_Potential from '@salesforce/label/c.Parent_Account_Potential';
import Parent_Account_Potential_helptext from '@salesforce/label/c.Parent_Account_Potential_helptext';
import Parent_Account_Total_Sales from '@salesforce/label/c.Parent_Account_Total_Sales';
import Parent_Account_Total_Sales_Helptext from '@salesforce/label/c.Parent_Account_Total_Sales_Helptext';
import Parent_Account_SOW from '@salesforce/label/c.Parent_Account_SOW';
import Parent_Account_SOW_Text from '@salesforce/label/c.Parent_Account_SOW_Text';
import Parent_Account_Number from '@salesforce/label/c.Parent_Account_Number';
import Local_Segmentation from '@salesforce/label/c.Local_Segmentation';
import Tacticom_Sub_area from '@salesforce/label/c.Tacticom_Sub_area';
import Buddy_account_owner from '@salesforce/label/c.Buddy_account_owner';
import My_Tacticom_Total_Visits from '@salesforce/label/c.My_Tacticom_Total_Visits';
import Tacticom_SEIKO from '@salesforce/label/c.Tacticom_SEIKO'; 
import Tacticom_HOYA from '@salesforce/label/c.Tacticom_HOYA'; 
import MY_TACTICOM from '@salesforce/label/c.MY_TACTICOM'; 
import Sum_of_Total_Visits_per_year from '@salesforce/label/c.Sum_of_Total_Visits_per_year';
import View_Report from '@salesforce/label/c.View_Report';
import RECOMMENDED_TACTICOM from '@salesforce/label/c.RECOMMENDED_TACTICOM';
import Parent_Recommended_Segmentation from '@salesforce/label/c.Parent_Recommended_Segmentation';
import Total_Visits from '@salesforce/label/c.Total_Visits';
import Campaigns from '@salesforce/label/c.Campaigns';
import Life_Cycle from '@salesforce/label/c.Life_Cycle';
import TACTICOM_Buddy_Partner from '@salesforce/label/c.TACTICOM_Buddy_Partner';
import Opportunities from '@salesforce/label/c.opportunities';
import Manual_Segment from '@salesforce/schema/Account.Manual_Segment__c';
import AccObj from '@salesforce/schema/Account';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';

export default class TabVisitsTacticom extends NavigationMixin(LightningElement) {
   
    isSpinner=false;
    @api receivedId;
    @api objectApiName;
    @track tacticomDetail={};
    @track aggrResult={};
    ownerIdAccount;
    recommendedTacticom;
    tacticomReportId;
    isDoughnutChartDataReceived=false;
    isBarChartDataReceived=false;
    fields=[TACTICOM_SOF];
    BuddyField = [BUDDYOWNER_FIELD];
    // Indicator Variables
    strategicValueIndicator;
    tacticomIndicator;
    totalVisitsIndicator;
    campaignsIndicator;
    busiOppIndicator;
    lifeCycleIndicator;

    //helpText
    totalVisitsHelpText;
    strategicValueHelpText;
    busiOppHelpText;
    campaignsHelpText;
    showpadIndicator;
    tacticomHelpText;
    lifeCycleHelpText;

    section2Fields = [Manual_Segment];
    Account_Obj = AccObj;
   
    accountSegmentationfields = [Segmentation_Box ,Last_Visit_date,Last_Digital_Visit_date,Total_Visits_Achieved, Visit_Frequency_Status, Digital_Visits_Frequency
        ,Total_Visits_Planned,Agreed_Visits,Agreed_No_of_Digital_Visits];
  
    label = {
        APACVisitVisitSummary,
        Tacticom,
        Parent_Account_Segmentation,
        Add_Parent_Account,
        Parent_Account_Potential,
        Parent_Account_Potential_helptext,
        Parent_Account_Total_Sales,
        Parent_Account_Total_Sales_Helptext,
        Parent_Account_SOW,
        TACTICOM_Buddy_Partner,
        Parent_Account_SOW_Text,
        Parent_Account_Number,
        Local_Segmentation,
        Tacticom_Sub_area,
        Buddy_account_owner,
        My_Tacticom_Total_Visits,
        Tacticom_SEIKO,
        Tacticom_HOYA,
        MY_TACTICOM,
        Sum_of_Total_Visits_per_year,
        View_Report,
        RECOMMENDED_TACTICOM,
        Parent_Recommended_Segmentation,
        Total_Visits,
        Campaigns,
        Opportunities,
        Life_Cycle,
        TACTICOM_Buddy_Partner,
    };

    constructor() {
        super();
        // passed parameters are not yet received here
    }
      
   connectedCallback() {
    }
    
    @wire(TacticomDetails, { recordId:'$receivedId'}) tacticomDetailsFromApex({data,error}){

        if(data){
              this.tacticomDetail=JSON.parse(data);
        }
        else if(error){
            this.showToast('Error','Error while fetching the tacticom details '+JSON.stringify(error.message),'error');
        }
    };

    @wire(getRecord, { recordId:'$receivedId', fields: [PARENTID_FIELD,BUDDYOWNER_FIELD,TACTICOM_SOF,OWNER_FIELD,OWNER_NAME]})
    AdditionalAccountData

     get parentId() {
        return getFieldValue(this.AdditionalAccountData.data, PARENTID_FIELD);
    }

    get buddyOwner() {
        return getFieldValue(this.AdditionalAccountData.data, BUDDYOWNER_FIELD);
    }

    get tacticomSOF() {
        return getFieldValue(this.AdditionalAccountData.data, TACTICOM_SOF);
    }

    get ownerId(){
        return getFieldValue(this.AdditionalAccountData.data, OWNER_FIELD);
    }

    get ownerName(){
        return getFieldValue(this.AdditionalAccountData.data, OWNER_NAME);
    }
  
// @wire(ParentAggregate, { parentId:'$parentId'}) AggregateData({data,error}){
    @wire(ParentAggregate, { parentId:'$receivedId'}) AggregateData({data,error}){
        if(data){
            console.log(data);
        this.aggrResult=data;
        }
        else if(error){
            this.showToast('Error','Error while loading Parent & Child Accounts Segmentation'+error.message,'error');
        }
    };

  //Doughnut chart - start
   totalCount=0;
   pieChartLabels=[]
    pieChartData=[]
    pieChartDataTemp = [];
    pieChartLablesTemp = [];
    @wire(getAccByZone,{accOwner:'$ownerId'})
    AccountHandler({data, error}){
        if(data){
            const Obj=Object.assign({}, data);
            const arrayObj = Object.values(Obj);
            arrayObj.forEach(acc => {
                this.pieChartLablesTemp.push(acc.TACTICOM_SOF__c);
                this.pieChartDataTemp.push(acc.cnt);
                this.totalCount=this.totalCount+acc.cnt;
            });
            this.pieChartData= JSON.parse(JSON.stringify(this.pieChartDataTemp));
            this.pieChartLabels= JSON.parse(JSON.stringify(this.pieChartLablesTemp));
         this.isDoughnutChartDataReceived=true;
        }
        if(error){
            this.isDoughnutChartDataReceived=true;
            this.showToast('Error','Error while loading the My Tactiom Visits Chart'+error.message,'error');
        }
    }
    @wire(getIndicators, {receivedId: '$receivedId'})  getIndicators ({error, data}) {
        if(data){
            /** 
             * following are the names of images in Static resource
             * GreenLightAlert.png
             * GreenLight.png
             * GreyLight.png
             * GreyLightAlert.png
             * RedLight.png
             * RedLightAlert.png
             * YellowLight.png
             * 
             * */ 
            
            // Set the variable value here based on apex response.
            //apex will retun a wrapper with all indicator image name/ some other keyword like 'salesGreenSpecial'.
            this.totalVisitsIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.flagTotalVisits);
            this.strategicValueIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.strategicValueIndicator);
            this.busiOppIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.busiOppIndicator);
            this.campaignsIndicator =  AI_Indicators + '/'+this.getIndicatorImage(data.campaignsIndicator);
            this.tacticomIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.tacticomFlag);
            this.lifeCycleIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.lifeCycleFlag);

            //helpText
            this.totalVisitsHelpText = data.flagTotalVisitsHelpText;
            this.strategicValueHelpText = data.strategicValueIndicatorHelpText;
            this.busiOppHelpText = data.busiOppIndicatorHelpText;
            this.campaignsHelpText = data.campaignsIndicatorHelpText;
            this.showpadIndicator = data.showpadIndicatorHelpText;
            this.tacticomHelpText = data.tacticomFlagHelpText;
            this.lifeCycleHelpText = data.lifeCycleFlagHelpText;
            console.log(data.campaignsIndicatorHelpText);
        }else if(error){
            this.showToast('Error','XXX An error was occurred ==>'+error.message,'error');
        }
    }
   //Douhnut chart end
   getIndicatorImage(indicator){
    if(indicator == 'GREY')
        return 'GreyLight.png';
    else if(indicator == 'GREYALERT')
        return 'GreyLightAlert.png';
    else if(indicator == 'RED')
        return 'RedLight.png';
    else if(indicator == 'REDALERT')
        return 'RedLightAlert.png';
    else if(indicator == 'GREEN')
        return 'GreenLight.png';
    else if(indicator == 'GREENALERT')
        return 'GreenLightAlert.png';

}
  //Bar chart - start
   recommendedVisitsData=[]
   recommendedVisitsPerSubArea=[]
   recommendedVisitsDataTemp=[]
   recommendedVisitsPerSubAreaTemp=[]
   @wire(recommendedAccountsByZone,{accOwner:'$ownerId'})
     recommendedVisitsHandler({data, error}){
       if(data){
        const Obj=Object.assign({}, data);
        const arrayObj = Object.values(Obj);

            arrayObj.forEach(acc => {
               this.recommendedVisitsDataTemp.push(acc.recommendedVisit);
               this.recommendedVisitsPerSubAreaTemp.push(acc.recommendedVisitPerSubArea);
           });
           this.recommendedVisitsData= JSON.parse(JSON.stringify(this.recommendedVisitsDataTemp));
           this.recommendedVisitsPerSubArea= JSON.parse(JSON.stringify(this.recommendedVisitsPerSubAreaTemp));
           this.isBarChartDataReceived=true;
       }
       if(error){
            this.showToast('Error','Error while loading the Recommened Visits Chart'+error.message,'error');
            this.isBarChartDataReceived=true;
       }
   }
  //Bar chart end

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }
 
}