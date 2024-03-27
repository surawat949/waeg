import { LightningElement, api, wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

//Platform Event
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

import CampaignMemberShip from '@salesforce/label/c.CampaignMemberShip';
import Member from '@salesforce/label/c.Member';
import CampaignName from '@salesforce/label/c.CampaignName';
import start from '@salesforce/label/c.start';
import End from '@salesforce/label/c.End';
import Presentation from '@salesforce/label/c.Presentation';
import Interest from '@salesforce/label/c.Interest';
import select from '@salesforce/label/c.select';
import report from '@salesforce/label/c.report';
import IdentifiedBusinessOpp from '@salesforce/label/c.IdentifiedBusinessOpp';
import opportunities from '@salesforce/label/c.opportunities';
import category from '@salesforce/label/c.category';
import date from '@salesforce/label/c.date';
import comments from '@salesforce/label/c.comments';
import Status from '@salesforce/label/c.Status';
import add from '@salesforce/label/c.add';
import opportunitiesSec from '@salesforce/label/c.opportunitiesSec';
import oppName  from '@salesforce/label/c.oppName';
import stage from '@salesforce/label/c.stage';
import closeDate from '@salesforce/label/c.closeDate';
import remainingDays from '@salesforce/label/c.remainingDays';
import project_id from '@salesforce/label/c.project_id';
import creation_date from '@salesforce/label/c.creation_date';
import project_name from '@salesforce/label/c.project_name';
import label_category from '@salesforce/label/c.category';
import yearly_incremental_sales from '@salesforce/label/c.yearly_incremental_sales';
import opp_status from '@salesforce/label/c.opp_status';
import priority from '@salesforce/label/c.priority';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_new from '@salesforce/label/c.NewButtonRelatedList';

//identified business opportunity pop up 
import label_save from '@salesforce/label/c.tabLabelSave';
import label_Close from '@salesforce/label/c.tabLabelClose';
import label_category1 from '@salesforce/label/c.category';
import label_status from '@salesforce/label/c.Status';
import Project_Description from '@salesforce/label/c.Project_Description';
import headingIBO from '@salesforce/label/c.headingIBO';
import Name from '@salesforce/label/c.Name';
import description from '@salesforce/label/c.Description';
import Next_Steps from '@salesforce/label/c.Next_Steps';
import Priority_Level from '@salesforce/label/c.Priority_Level';
import Expected_Incremental_Sales from '@salesforce/label/c.Expected_Incremental_Sales';
import Monthly_Incremental from '@salesforce/label/c.Monthly_Incremental';

import createBusinessOpportunity from '@salesforce/apex/TabVisitsCampOppController.createBusinessOpportunity';
import getIdentifiedBusinesssOpp from '@salesforce/apex/TabVisitsCampOppController.getBusinessOpportunityRelatedAccount';
import getCampaignMembership from '@salesforce/apex/TabVisitsCampOppController.getCampaignMembership';
import getOpp from '@salesforce/apex/TabVisitsCampOppController.getOpportunity';

export default class TabVisitsCampOpp extends NavigationMixin(LightningElement) {
    @api receivedId;
    @track OppRecord;
    oppData;
    oppCount = 0;
    displayCampaignViewAllButton = false;
    displayIdentifiedOppViewAllButton = false;
    displayOppViewAllButton = false;
    campaignCount=0;
    opportunityCount=0;
    campaigns;
    businessOpportunities;
    opportunities;
    navigateToRecordTypePage=false;
    navigateToEditForm=false;
    businessRowId=''; 

    isModalOpen = false; //for opportunity popup

    subscription = {};
    CHANNEL_NAMEAC = '/event/Refresh_Related_List_AC__e';
    CHANNEL_NAME = '/event/RefreshOpportunity__e';
   
    label={
        CampaignMemberShip,Member,CampaignName,start,End,Presentation,Interest,select,report,IdentifiedBusinessOpp,opportunities,category,
        date,comments,Status,add,opportunitiesSec,oppName,stage,closeDate,remainingDays,project_id,	project_id,creation_date,project_name,
        label_category, yearly_incremental_sales,opp_status,priority,label_viewall,label_new
    }

    //identified business opportunity pop up labels
    IdentifiedBusinessOppData;
    showSpinner = false;
    label_Project_Description=Project_Description;
    labelSave = label_save;
    labelClose = label_Close;
    labelCategory = label_category1;
    labelStatus = label_status;
    labelheadingIBO = headingIBO; 
    name =Name;
    Description = description;
    next_Steps = Next_Steps;
    priority_Level = Priority_Level;
    expected_Incremental_Sales = Expected_Incremental_Sales;
    monthly_Incremental = Monthly_Incremental;

    projectName;
    description;
    category;
    nextSteps;
    status;
    level;
    monthlyInc = 0;
    errors;

    @track campaigncolumns = [
        {
            label: this.label.Member,
            fieldName: 'nameLink',
            type: 'url',
                typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: false

        },
        {
            label: this.label.CampaignName,
            fieldName: 'Campaign_Name_t__c',
            type: 'text',
            sortable: false
        },
        {
            label: this.label.start,
            fieldName: 'Campaign_Start_Date_t__c',
            type: 'date',
            sortable: false 
        },
        {
            label: this.label.End,
            fieldName: 'Campaign_End_Date_t__c',
            type: 'date',
            sortable: false
        },
        {
            label: this.label.Presentation,
            fieldName: 'Date_of_presentation__c',
            type: 'date',
            sortable: false
        },
        {
            label: this.label.Interest,
            fieldName: 'Campaign_Interested__c',
            type: 'text',
            sortable: false
        }
    ];

    @track businessOppColumns = [
        {
            label: this.label.project_id,
            fieldName: 'nameLink',
            type: 'url',
            typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true
        },
        {
            label: this.label.creation_date,
            fieldName: 'CreatedDate',
              type: 'date',
             sortable: true
        },
        {
            label: this.label.project_name,
            fieldName: 'Project_Name__c',
             type: 'text',
            sortable: true 
        },
        {
            label: this.label.yearly_incremental_sales,
            fieldName: 'Yearly_Incremental_Sales_Formula__c',
            type: 'currency',
            sortable: true
        },
        {
            label: this.label.priority,
            fieldName: 'Priority_level__c',
            type: 'number',
            sortable: true
        },
        {
            label: this.label.opp_status,
            fieldName: 'Project_Status__c',
             type: 'text',
            sortable: true
        }
       
    ];

    @track oppColumns = [
        {
            label: this.label.oppName,
            fieldName: 'nameLink',
            type: 'url',
                typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: false

        },
        {
            label: this.label.stage,
            fieldName: 'StageName',
            type: 'text',
            sortable: false
        },
        {
            label: this.label.closeDate,
            fieldName: 'CloseDate',
            type: 'date',
            sortable: false 
        },
        {
            label: this.label.remainingDays,
            fieldName: 'Days_Remain_To_Close__c',
            type: 'number',
            sortable: false
        }
    ];
 
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.isLoading = true;
        this.getRelatedRecords();
        this.getCampaignMembership();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
        });
        subscribe(this.CHANNEL_NAMEAC, -1, this.refreshListACM).then(response => {
            this.subscription = response;
        });
    }

    refreshList = ()=> {
        this.isLoading = true;
        this.getRelatedRecords();
    }
    refreshListACM = ()=> {
        this.isLoading = true;
        this.getCampaignMembership();
    }

    navigateOppCreatePage(event){
       this.navigateToNewPage('Opportunity');
       this.navigateToRecordTypePage=true;
    }

    navigateToOppRelatedList(event){
        this.navigateToRelatedList('Opportunities');
    }

    navigateToCampaignRelatedList(event){
        this.navigateToRelatedList('Campaign_Membership__r');
    }

    navigateToNewCampaignPage(objectName){
        const defaultValues = encodeDefaultFieldValues({
            Account_Name__c : this.receivedId
         });
 
         this[ NavigationMixin.Navigate]({
             type : 'standard__objectPage',
             attributes : {
                 objectApiName : objectName,
                 actionName : 'new'
             },
             state: {
                 defaultFieldValues: defaultValues,
                 useRecordTypeCheck : 1,
                 navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
             }
         });
    }
    
    navigateToNewPage(objectName){
        const defaultValues = encodeDefaultFieldValues({
            AccountId : this.receivedId
         });
 
         this[ NavigationMixin.Navigate]({
             type : 'standard__objectPage',
             attributes : {
                 objectApiName : objectName,
                 actionName : 'new'
             },
             state: {
                 defaultFieldValues: defaultValues,
                 useRecordTypeCheck : 1,
                 navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
             }
         });
    }

    navigateToRelatedOppList(){
        this.navigateToRelatedList('Identified_Business_Opportunities__r');
    }
 
    navigateToRelatedList(relationshipName){
            this[ NavigationMixin.GenerateUrl ]({
                type : 'standard__recordRelationshipPage',
                attributes : {
                    recordId : this.receivedId,
                    objectApiName : 'Account',
                    relationshipApiName : relationshipName,
                    actionName : 'view'
                }
            }).then(url => {
                window.open(url, '_blank');
            });
        }
    getCampaignMembership() {
        getCampaignMembership({accountId: this.receivedId})
        .then(result => {
        if(result){
            result = JSON.parse(JSON.stringify(result));
            result.forEach(res=>{
                res.nameLink = '/' + res.Id;
            });

            let allVCampaigns=result;
            this.campaigns = (allVCampaigns.length <= 5) ? [...allVCampaigns] : [...allVCampaigns].splice(0,5);
            this.displayCampaignViewAllButton = true;

            if(result.length > 5){
                this.campaignCount='5+';
            }
            else{
                this.campaignCount=allVCampaigns.length;
            }
        }
        }).catch(error => {
            this.showToast("Error", "Error while getting the Opportunity Details : "+error, 
            "error");
        });
      }

      showCampaignPage(){
        this.navigateToNewCampaignPage('Account_Campaing_Member__c');
      }

      @wire(getIdentifiedBusinesssOpp, {accountId:'$receivedId'}) OppRec(result){
       this.IdentifiedBusinessOppData = result;
       if(result.data && result.data.length>0){
       let data = JSON.parse(JSON.stringify(result.data));
        data.forEach(res=>{
            res.nameLink = '/' + res.Id;
        });
        this.OppRecord = (data.length<=5) ? [...data] : [...data].splice(0,5);
        this.displayIdentifiedOppViewAllButton = true;
        if(result.data.length > 5){
            this.oppCount = '5+';
        }else{
            this.oppCount = data.length;
        }
       
        }else if (result.error){
        this.showToast("Error", "Error while getting the Business Opportunity Details : "+result.error.message, 
        "error");
    }
   }
   
    getRelatedRecords() {
        getOpp({accountId: this.receivedId})
        .then(result => {
            if(result){
                result = JSON.parse(JSON.stringify(result));
                result.forEach(res=>{
                    res.nameLink = '/' + res.Id;
                });
    
                let allOpps=result;
                
                this.opportunities = (allOpps.length <= 5) ? [...allOpps] : [...allOpps].splice(0,5);
                this.displayOppViewAllButton = true;

                if(allOpps.length >5){
                    this.opportunityCount='5+';
                }
                else{
                    this.opportunityCount=allOpps.length;
                }
            }
        })
        .catch(error => {
            this.opportunities = undefined;
            this.showToast("Error", "Error while getting the Opportunity Details : "+error.message, 
            "error");
        });

      }

      updateRecordView() {
        setTimeout(() => {
             eval("$A.get('e.force:refreshView').fire();");
        }, 1000);  
     }
  
     redirectToEditPage(event){
        let rowId = event.target.dataset.recordId;
        this.businessRowId=rowId
        this.navigateToEditForm=true
     }

     navigateToRecordEditPage(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'edit'
            }
        });
    }

     disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });
    }

    showOppCreatePage(){
        this.isModalOpen= true;
    }

    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }


    //Identified business opportunity Creation  - Start
    get categoryOptions(){
        return [
            { label : 'Product Mix', value : 'Product Mix'},
            { label : 'Instrument', value : 'Instrument'},
            { label : 'Service', value : 'Service'},
            { label : 'Challenge', value : 'Challenge'},
            { label : 'Promotion', value : 'Promotion'},
            { label : 'Event', value : 'Event'},
            { label : 'ECP’s project', value : 'ECP’s project'},
            { label : 'Other', value : 'Other'}
        ];
    }
  
    closePopup() {
      this.isModalOpen = false;  
      this.projectName='';
      this.description='';
      this.category='';
      this.nextSteps='';
      this.status='';
      this.level='';
      this.monthlyInc= 0;
      this.errors = '';     
      
    }

    get statusOptions(){
        return [
            { label : 'Not Started', value : 'Not Started'},
            { label : 'In progress', value : 'In progress'},
            { label : 'Posponed', value : 'Posponed'},
            { label : 'Abandoned', value : 'Abandoned'},
            { label : 'Delivered', value : 'Delivered'}
        ];
    }

    get levelOptions(){
        return [
            { label : '1', value : '1'},
            { label : '2', value : '2'},
            { label : '3', value : '3'}
        ];
    }


    projectNameCH(event){
        this.projectName = event.target.value; 
    }
 
    categoryCH(event){
        this.category = event.target.value;
    }
 
    descriptionCH(event){
        this.description = event.target.value;
    }
 
    nextStepsCH(event){
        this.nextSteps = event.target.value;
    }
 
    statusCH(event){
        this.status = event.target.value;
    }
 
    levelCH(event){
        this.level = event.target.value;
    }
 
    statusCH(event){
        this.status = event.target.value;
    }
 
    monthlyIncCH(event){
        this.monthlyInc = event.target.value;
    }

    onSave(event){
        if(this.projectName == '' || this.projectName == null){
            this.showToast('Error', 'Project Name cannot be empty', 'Error');
        }else if(this.category == '' || this.category == null){
            this.showToast('Error', 'Category cannot be empty', 'Error');
        }else if(this.description == '' || this.description == null){
            this.showToast('Error', 'Description cannot be empty', 'Error');
        }else if(this.status == '' || this.status == null){
            this.showToast('Error', 'Status cannot be empty', 'Error');
        }else{
            this.showSpinner = true;
            createBusinessOpportunity({
                projectName : this.projectName,
                accountId : this.receivedId,
                category : this.category,
                description : this.description,
                status : this.status,
                nextSteps : this.nextSteps,
                level : this.level,
                monthlyInc : this.monthlyInc
            }).then(result=>{
                this.showSpinner = false;
                this.closePopup();
                this.showToast('Success', 'Successfully Created Business Opportunity', 'Success');
                this.performRefresh();
            }).catch(error=>{
                this.showSpinner = false;
                this.errors = 'Error Creating Identified Opportunity ' + JSON.stringify(error);
            });
        }
    }

    async performRefresh() {
        await refreshApex(this.IdentifiedBusinessOppData);  
    }

    //Identified business opportunity Creation  - End

}