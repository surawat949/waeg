import { LightningElement, api ,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { RefreshEvent } from 'lightning/refresh';
import { NavigationMixin } from 'lightning/navigation';
//Apex Classes
import TacticomDetails from '@salesforce/apex/TabVisitsController.TacticomDetails';
//import getAccByZone from '@salesforce/apex/TabVisitsController.getAccountsByZone';
import ParentAggregate from '@salesforce/apex/TabVisitsController.Aggregate';
//import recommendedAccountsByZone from '@salesforce/apex/TabVisitsController.recommendedAccountsByZone';
import getIndicators from '@salesforce/apex/TabVisitsIndicatorController.getAIIndicators';
import SFDC_V2_StandardTask from '@salesforce/apex/Utility.getTaskSFDCStandardTask';
import CreateNewTask from '@salesforce/apex/TabVisitsTacticomController.CreateNewTaskRequestNewVisits';
import getSupportVisitsInfo from '@salesforce/apex/TabVisitsTacticomController.getSupportVisitsInfo';
import getChatterUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
//Fields
import Id from '@salesforce/user/Id';
import Manual_Segment from '@salesforce/schema/Account.Manual_Segment__c';
import AccObj from '@salesforce/schema/Account';
import PARENTID_FIELD from '@salesforce/schema/Account.ParentId';
import OWNER_NAME from '@salesforce/schema/Account.Owner.Name';
import BUDDYOWNER_FIELD from '@salesforce/schema/Account.TACTICOM_Owner__c';
import OWNER_FIELD from '@salesforce/schema/Account.OwnerId';
import TACTICOM_SOF from '@salesforce/schema/Account.TACTICOM_SOF__c';
import APACVisitVisitSummary from '@salesforce/label/c.APACVisitVisitSummary';
import Segmentation_Box_Net from '@salesforce/schema/Account.Segmentation_Net__c';
import Segmentation_Box_Gross from '@salesforce/schema/Account.Segmentation_Gross__c';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import Last_Visit_date from '@salesforce/schema/Account.Last_Visit_date__c';
import Last_Digital_Visit_date from '@salesforce/schema/Account.Last_Digital_Visit_Date__c';
import Total_Visits_Achieved from '@salesforce/schema/Account.Total_Visits_Achieved__c';
import Visit_Frequency_Status from '@salesforce/schema/Account.Visit_Frequency_Status__c';
import Digital_Visits_Frequency from '@salesforce/schema/Account.Digital_Visits_Frequency__c';
import Total_Visits_Planned from '@salesforce/schema/Account.Total_Visits_Planned__c';
import Agreed_Visits from '@salesforce/schema/Account.Agreed_Visits__c';
import Agreed_No_of_Digital_Visits from '@salesforce/schema/Account.Agreed_No_of_Digital_Visits__c';
import LOCAL_CONSOLIDATION from '@salesforce/schema/Account.Local_Consolidation_Key__c';
import accCountry from '@salesforce/schema/Account.Shop_Country__c';
import AGREE_VISIT from '@salesforce/schema/Account.Agreed_Visits__c';
import AGREE_DIGITAL_VISIT from '@salesforce/schema/Account.Agreed_No_of_Digital_Visits__c';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import ACCOUNT_HOYA_ACC_ID from '@salesforce/schema/Account.Hoya_Account_ID__c';
import ACCOUNT_OWNER_NAME from '@salesforce/schema/Account.Account_Owner_Name__c';
import ACCOUNT_HVC_INTER_CHAN from '@salesforce/schema/Account.CHCUSTCLASSIFICATIONID__c';
import ACCOUNT_SEGMENT from '@salesforce/schema/Account.Segmentation_Box__c';
import ACCOUNT_STRATEGIC from '@salesforce/schema/Account.Potential__c';
import ACCOUNT_MANAGER_NAME from '@salesforce/schema/Account.Account_Owners_Manager__c';
import ACCOUNT_MANAGER_ID from '@salesforce/schema/Account.Owner.ManagerId';
import totalVisitsPerformed from '@salesforce/schema/Account.Total_Visits_Performed__c';
//Custom Labels
import Tacticom from '@salesforce/label/c.Tacticom';
import Add_Parent_Account from '@salesforce/label/c.Add_Parent_Account';
import All_Account_Associated_Segmentation from '@salesforce/label/c.All_Account_Associated_Segmentation';
import Consolidation_Key_Strategic_Value from '@salesforce/label/c.Consolidation_Key_Strategic_Value';
import Consolidation_Key_Strategic_HelpText from '@salesforce/label/c.Consolidation_Key_Strategic_HelpText';
import Consolidation_Key_Share_Of_Wallet from '@salesforce/label/c.Consolidation_Key_Share_Of_Wallet';
import Consolidation_Key_SOW_HelpText from '@salesforce/label/c.Consolidation_Key_SOW_HelpText';
import Consolidation_Key_Segmentation from '@salesforce/label/c.Consolidation_Key_Segmentation';
import Consolidation_Key_Segmentation_HelpText from '@salesforce/label/c.Consolidation_Key_Segmentation_HelpText';
import Parent_Account_Number from '@salesforce/label/c.Parent_Account_Number';
import Local_Segmentation from '@salesforce/label/c.Local_Segmentation';
import Tacticom_Sub_area from '@salesforce/label/c.Tacticom_Sub_area';
import Buddy_account_owner from '@salesforce/label/c.Buddy_account_owner';
import My_Tacticom_Total_Visits from '@salesforce/label/c.My_Tacticom_Total_Visits';
import Tacticom_SEIKO from '@salesforce/label/c.Tacticom_SEIKO'; 
import Tacticom_HOYA from '@salesforce/label/c.Tacticom_HOYA'; 
//import MY_TACTICOM from '@salesforce/label/c.MY_TACTICOM'; 
//import Sum_of_Total_Visits_per_year from '@salesforce/label/c.Sum_of_Total_Visits_per_year';
import View_Report from '@salesforce/label/c.View_Report';
//import RECOMMENDED_TACTICOM from '@salesforce/label/c.RECOMMENDED_TACTICOM';
//import Parent_Recommended_Segmentation from '@salesforce/label/c.Parent_Recommended_Segmentation';
import Total_Visits from '@salesforce/label/c.Total_Visits';
import Campaigns from '@salesforce/label/c.Campaigns';
import Life_Cycle from '@salesforce/label/c.Life_Cycle';
import TACTICOM_Buddy_Partner from '@salesforce/label/c.TACTICOM_Buddy_Partner';
import Opportunities from '@salesforce/label/c.opportunities';
import Representative_Level from '@salesforce/label/c.Representative_Level';
import Team_Level from '@salesforce/label/c.Team_Level';
import Total_Visits_Performed from '@salesforce/label/c.Total_Visits_Performed';
import Support_Visits_Performed from '@salesforce/label/c.Support_Visits_Performed';
import Last_Support_Visit_Date from '@salesforce/label/c.Last_Support_Visit_Date';
import Support_Digital_Visit_Performed from '@salesforce/label/c.Support_Digital_Visit_Performed';
import Last_Support_Digital_Visit_Date from '@salesforce/label/c.Last_Support_Digital_Visit_Date';
//Static Resources
import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';
export default class TabVisitsTacticom extends NavigationMixin(LightningElement) {
   
    isSpinner=false;
    showAllTab=false;
    @api receivedId;
    @api objectApiName;
    @track tacticomDetail={};
    @track aggrResult={};
    @track isModalOpen = false;
    @track value = 'New';
    @track statusOption;
    @track defaultComment = 'Account Id';
    @track isActiveDisabled = false;

    isVisitPlan = false;
    isDigitalVisitPlan = false;
    isManagerAvailable = false;
    SubjectName;
    AccountName;
    HoyaAccountId;
    OwnerName;
    HVCInterChannel;
    Segmentation;
    StrategicVal;
    DirectVisitsPlaned;
    DigitalVisitPlaned;
    TotalVisitPlaned;
    TotalVisitAchived;

    ownerIdAccount;
    recommendedTacticom;
    isGermanyAccount;
    accountCountry;
    tacticomReportId;
    isDoughnutChartDataReceived=false;
    isBarChartDataReceived=false;
    fields=[TACTICOM_SOF];
    BuddyField = [BUDDYOWNER_FIELD];
    keyValue;
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

    @track OwnerId;
    AccountId;
    WhatId;
    TaskStatusRecordTypeId;
    status = this.value;
    RequestVisitPlan;
    RequestDigitalVisitPlan;
    CurrentUserName;
    supportVisitsCount = 0;
    supportDigitalVisitCount = 0;
    lastSupportVisitDate;
    lastSupportDigitalVisitDate;
    lastDigitalVisitBy;
    totalvisits = 0;
    visitsCount = 0;
    lastVisitBy;
    accountSegmentationfieldsNet = [Segmentation_Box_Net,Last_Visit_date,Last_Digital_Visit_date,Total_Visits_Achieved, Visit_Frequency_Status, Digital_Visits_Frequency
        ,Total_Visits_Planned,Agreed_Visits,Agreed_No_of_Digital_Visits];
    accountSegmentationfieldsGross = [Segmentation_Box_Gross,Last_Visit_date,Last_Digital_Visit_date,Total_Visits_Achieved, Visit_Frequency_Status, Digital_Visits_Frequency
        ,Total_Visits_Planned,Agreed_Visits,Agreed_No_of_Digital_Visits];
    ManualSegment=[Manual_Segment];    
  
    label = {
        APACVisitVisitSummary,
        Tacticom,
        Add_Parent_Account,
        TACTICOM_Buddy_Partner,
        Parent_Account_Number,
        Local_Segmentation,
        Tacticom_Sub_area,
        Buddy_account_owner,
        My_Tacticom_Total_Visits,
        Tacticom_SEIKO,
        Tacticom_HOYA,
        View_Report,
        Total_Visits,
        Campaigns,
        Opportunities,
        Life_Cycle,
        TACTICOM_Buddy_Partner,
        All_Account_Associated_Segmentation,
        Consolidation_Key_Strategic_HelpText,
        Consolidation_Key_Strategic_Value,
        Consolidation_Key_Share_Of_Wallet,
        Consolidation_Key_SOW_HelpText,
        Consolidation_Key_Segmentation,
        Consolidation_Key_Segmentation_HelpText,Representative_Level,Team_Level,Total_Visits_Performed,Support_Visits_Performed,Last_Support_Visit_Date,
        Support_Digital_Visit_Performed,Last_Support_Digital_Visit_Date
    };

    constructor() {
        super();
        // passed parameters are not yet received here
    }
      
   connectedCallback() {
    }
   
   
    @wire(getRecord, { recordId:'$receivedId', fields: [ LOCAL_CONSOLIDATION , accCountry,totalVisitsPerformed] })
    localKeyDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.Local_Consolidation_Key__c.value != null) {
                this.keyValue = data.fields.Local_Consolidation_Key__c.value;
            }        
            this.accountCountry = data.fields.Shop_Country__c.value;
            if(this.accountCountry == 'DE'){
                this.isGermanyAccount = true;
            }
            else
                this.isGermanyAccount = false;
            if(data.fields.Total_Visits_Performed__c != null){
                this.visitsCount = data.fields.Total_Visits_Performed__c.value;
            }
            getSupportVisitsInfo({AccountId: this.receivedId})
            .then(result => {
                var supportData = JSON.parse(JSON.stringify(result));
                var isSupportVisitsExists = false;
                if(supportData.supportVisitCount != undefined && supportData.supportVisitCount != null){
                     this.supportVisitsCount = supportData.supportVisitCount;
                     this.totalvisits = this.visitsCount + supportData.supportVisitCount;
                     isSupportVisitsExists = true;
                }
                if(supportData.supportDigitalVisitCount != undefined && supportData.supportDigitalVisitCount != null){
                    this.supportDigitalVisitCount = supportData.supportDigitalVisitCount;
                    if(isSupportVisitsExists)
                        this.totalvisits = this.totalvisits + supportData.supportDigitalVisitCount;
                    else
                        this.totalvisits = this.visitsCount + supportData.supportDigitalVisitCount;
                    isSupportVisitsExists = true;
                }
                if(!isSupportVisitsExists){
                    this.totalvisits = this.visitsCount;
                }
                this.lastSupportVisitDate =  supportData.lastSupportVisitDate;
                this.lastVisitBy = supportData.lastSupportVisitBy;
                this.lastSupportDigitalVisitDate =  supportData.lastSupportDigitalVisitDate;
                this.lastDigitalVisitBy = supportData.lastSupportDigitalVisitBy;

            })
            .catch(error => {
                this.showToast('Error','Error while fetching the Support Visit Details '+JSON.stringify(error.message),'error');
            })
        }
    }  
    @wire(getRecord, {recordId : '$receivedId', fields: [AGREE_VISIT, AGREE_DIGITAL_VISIT, ACCOUNT_NAME, ACCOUNT_HOYA_ACC_ID, ACCOUNT_OWNER_NAME, ACCOUNT_HVC_INTER_CHAN, ACCOUNT_SEGMENT, ACCOUNT_STRATEGIC, Total_Visits_Planned,Total_Visits_Achieved,ACCOUNT_MANAGER_NAME]})
    VisitPlanValuesDetails({data, error}){
        if(data){
            if(data.fields.Agreed_Visits__c.value > 0 && data.fields.Agreed_Visits__c.value!=null){
                this.isVisitPlan = true;
                this.DirectVisitsPlaned = data.fields.Agreed_Visits__c.value;
            }else{
                this.isVisitPlan = false;
                this.DirectVisitsPlaned = 0;
            }
            if(data.fields.Agreed_No_of_Digital_Visits__c.value > 0 && data.fields.Agreed_No_of_Digital_Visits__c.value!=null){
                this.isDigitalVisitPlan = true;
                this.DigitalVisitPlaned = data.fields.Agreed_No_of_Digital_Visits__c.value;
            }else{
                this.isDigitalVisitPlan = false;
                this.DigitalVisitPlaned = 0;
            }

            if(data.fields.Account_Owners_Manager__c.value != null){
                this.isManagerAvailable = true;
            }else{
                this.isManagerAvailable = false;
            }

            console.log('Manager available '+this.isManagerAvailable + ' Manager = > '+data.fields.Account_Owners_Manager__c.value);

            this.AccountName = data.fields.Name.value;
            this.HoyaAccountId = data.fields.Hoya_Account_ID__c.value;
            this.OwnerName = data.fields.Account_Owner_Name__c.value;
            this.HVCInterChannel = data.fields.CHCUSTCLASSIFICATIONID__c.value;
            this.Segmentation = data.fields.Segmentation_Box__c.value;
            this.StrategicVal = data.fields.Potential__c.value;
            this.TotalVisitPlaned = data.fields.Total_Visits_Planned__c.value;
            this.TotalVisitAchived = data.fields.Total_Visits_Achieved__c.value;
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(getRecord, { recordId: Id, fields : [USER_NAME_FIELD]})
    getCurrentUser({data, error}){
        if(data){
            this.CurrentUserName = data.fields.Name.value;
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(TacticomDetails, { recordId:'$receivedId'}) tacticomDetailsFromApex({data,error}){

        if(data){
              this.tacticomDetail=JSON.parse(data);
        }
        else if(error){
            this.showToast('Error','Error while fetching the tacticom details '+JSON.stringify(error.message),'error');
        }
    };

    @wire(SFDC_V2_StandardTask)
    standard_sfdcv2_task({data,error}){
        if(data){
            data = JSON.parse(JSON.stringify(data));
            this.TaskStatusRecordTypeId = data;
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(getPicklistValuesByRecordType, {objectApiName : 'Task', recordTypeId: '$TaskStatusRecordTypeId'})
    STATUS_PICKLIST_VALUE({data,error}){
        if(data){
            this.statusOption = data.picklistFieldValues.Status.values;
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(getRecord, { recordId:'$receivedId', fields: [PARENTID_FIELD,BUDDYOWNER_FIELD,TACTICOM_SOF,OWNER_FIELD,OWNER_NAME,AGREE_VISIT,AGREE_DIGITAL_VISIT,ACCOUNT_MANAGER_ID,ACCOUNT_MANAGER_NAME]})
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

    get DirectVisitPlan(){
        return getFieldValue(this.AdditionalAccountData.data, AGREE_VISIT);
    }

    get DigittalVisitPlan(){
        return getFieldValue(this.AdditionalAccountData.data, AGREE_DIGITAL_VISIT);
    }

    get ManagerIdVal(){
        return getFieldValue(this.AdditionalAccountData.data, ACCOUNT_MANAGER_ID);
    }

    get ManagerName(){
        return getFieldValue(this.AdditionalAccountData.data, ACCOUNT_MANAGER_NAME);
    }
        
// @wire(ParentAggregate, { parentId:'$parentId'}) AggregateData({data,error}){
   @wire(ParentAggregate, { parentId:'$receivedId',key: '$keyValue'}) AggregateData({data,error}){
        if(data){
        this.aggrResult=data;
        }
        else if(error){
            this.showToast('Error','Error while loading All Associated Accounts Segmentation'+error.message,'error');
        }
    };

  //Doughnut chart - start
   /*totalCount=0;
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
    */
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
   /*recommendedVisitsData=[]
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
   */
  //Bar chart end

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }
    @wire(getChatterUserDetail)
    allStages({data }) {
        if (data) {
            this.showAllTab = data;
        } 
        else{
            this.showAllTab = false;
        }
    }

     //surawat add this - 20240514 - Task 1406
    openModal(){
        this.isModalOpen = true;
    }

     closeModal(){
        this.isModalOpen = false;
        this.HoyaAccountId = '';
        this.HVCInterChannel = '';
        this.Segmentation = '';
        this.StrategicVal = '';
        this.TotalVisitPlaned = '';
        this.TotalVisitAchived = '';
        this.WhatId = this.receivedId;
        this.status = this.value;
        //this.RequestVisitPlan = '';
        //this.RequestDigitalVisitPlan = '';
        this.isActiveDisabled = false;
    }
    
    AssignToChange(event){
        this.OwnerId = event.target.value;
        
    }

    requestVisitPlanChange(event){
        this.RequestVisitPlan = event.target.value;
    }

    requestDigitalVisitPlanChange(event){
        this.RequestDigitalVisitPlan = event.target.value;
    }

    handleLookupUserChange(event){
        if(event.detail.selectedRecord != undefined){
            this.OwnerId = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-7]').value = event.detail.selectedRecord.Id;
        }else{
            this.OwnerId = undefined;
            this.template.querySelector('lightning-input[data-my-id=form-input-7]').value = null;
        }
    }

     handleSaveData(){
        this.isActiveDisabled = true;
        let currentDate = new Date();
        currentDate.setDate(currentDate.getDate()+7);       //add for duedate just current day plus 7 days.
        let OwnerIdText = this.template.querySelector('lightning-input[data-my-id=form-input-7]').value;
        let directvisitplanRequest = this.template.querySelector('lightning-input[data-my-id=form-input-4]').value;
        let digitalvistplanRequest = this.template.querySelector('lightning-input[data-my-id=form-input-5]').value;

        this.OwnerId = OwnerIdText;
        this.RequestVisitPlan = directvisitplanRequest;
        this.RequestDigitalVisitPlan = digitalvistplanRequest;
        this.defaultComment = 'Account Name : '+this.AccountName + '\n' +
                'Account Code : '+this.HoyaAccountId + '\n' + 
                'Account Owner : '+this.OwnerName + '\n' +
                'Account HVC Channel : '+this.HVCInterChannel + '\n' +
                'Segmentation : '+this.Segmentation + '\n' +
                'Strategic Value : '+this.StrategicVal + '\n' +
                'Direct Visit Planned : '+this.DirectVisitsPlaned + '\n' + 
                'Digital Visit Planned : '+this.DirectVisitsPlaned + '\n' +
                'Total Visit Planned : '+this.TotalVisitPlaned + '\n' +
                'Total Visit Achieved : '+this.TotalVisitAchived + '\n' +
                'Requester : '+this.CurrentUserName + '\n' +
                'Requested Direct Visit Planned : '+this.RequestVisitPlan + '\n' +
                'Requested Digital Visit Planned : '+this.RequestDigitalVisitPlan;

        if(this.OwnerId == null || this.OwnerId == ''){
            this.showToast('Error', 'Assign To is the mandatory field', 'error');
            this.isActiveDisabled = false;

        }else if(this.RequestVisitPlan == null || this.RequestVisitPlan == ''){
            this.showToast('Error', 'Please input value request visit planned', 'error');
            this.isActiveDisabled = false;
            
        }else if(this.RequestDigitalVisitPlan == null || this.RequestDigitalVisitPlan == ''){
            this.showToast('Error', 'Please input value request digital planned', 'error');
            this.isActiveDisabled = false;
        }else{
            this.closeModal();
            this.isSpinner = true;
            CreateNewTask({
                Subject : 'Request For Modification Of Planned Visits',
                WhatId : this.receivedId,
                status : this.status,
                AssignTo : this.OwnerId,
                Description : this.defaultComment,
                duedate : currentDate,
                requestVisitPlan : this.RequestVisitPlan,
                requestDigitalVisitPlan : this.RequestDigitalVisitPlan
            }).then(result=>{
                this.showToast('Success', 'Create Request Visits Successfully', 'success');
                this.updateRecordView();
                this.isSpinner = false;
                this.OwnerId = '';
                this.RequestVisitPlan = '';
                this.RequestDigitalVisitPlan = '';
            }).catch(error=>{
                this.closeModal();
                this.showToast('Error', 'An error was occurred : '+JSON.stringify(error), 'error');
                this.OwnerId = '';
                this.isSpinner = false;
            });
        }
    }

    updateRecordView(){
        setTimeout(() => {
            
        },1000);
        this.dispatchEvent(new RefreshEvent());
    }
 
}