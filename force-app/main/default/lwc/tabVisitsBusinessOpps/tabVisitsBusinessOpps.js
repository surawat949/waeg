import { LightningElement,api,track,wire } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
//Platform Event
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
//Custom Labels
import IdentifiedBusinessOpp from '@salesforce/label/c.IdentifiedBusinessOpp';
import label_new from '@salesforce/label/c.NewButtonRelatedList';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import opportunitiesSec from '@salesforce/label/c.opportunities';
import Project_Description from '@salesforce/label/c.Project_Description';
import Name from '@salesforce/label/c.Name';
import description from '@salesforce/label/c.Description';
import Next_Steps from '@salesforce/label/c.Next_Steps';
import Priority_Level from '@salesforce/label/c.Priority_Level';
import Expected_Incremental_Sales from '@salesforce/label/c.Expected_Incremental_Sales';
import Monthly_Incremental from '@salesforce/label/c.Monthly_Incremental';
import label_category from '@salesforce/label/c.category';
import label_status from '@salesforce/label/c.Status';
import oppName  from '@salesforce/label/c.oppName';
import stage from '@salesforce/label/c.stage';
import closeDate from '@salesforce/label/c.closeDate';
import remainingDays from '@salesforce/label/c.remainingDays';
import project_id from '@salesforce/label/c.project_id';
import creation_date from '@salesforce/label/c.creation_date';
import project_name from '@salesforce/label/c.project_name';
import yearly_incremental_sales from '@salesforce/label/c.yearly_incremental_sales';
import opp_status from '@salesforce/label/c.opp_status';
import priority from '@salesforce/label/c.priority';
//identified business opportunity pop up 
import label_save from '@salesforce/label/c.tabLabelSave';
import cancel from '@salesforce/label/c.ButtonCancel';
import headingIBO from '@salesforce/label/c.headingIBO';
import label_Close from '@salesforce/label/c.tabLabelClose';

import createBusinessOpportunity from '@salesforce/apex/TabVisitsCampOppController.createBusinessOpportunity';
//Apex Classes
import getIdentifiedBusinesssOpp from '@salesforce/apex/TabVisitsCampOppController.getBusinessOpportunityRelatedAccount';
import getChatterUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
import getOpp from '@salesforce/apex/TabVisitsCampOppController.getOpportunity';
export default class TabVisitsBusinessOpps extends NavigationMixin(LightningElement){    
    @api receivedId;    
    @track OppRecord;
    oppCount = 0;    
    showAllTab=false;    
    opportunityCount=0;    
    opportunities;
    displayIdentifiedOppViewAllButton = false;    
    displayOppViewAllButton = false;
    isModalOpen = false; //for opportunity popup
    projectName;
    nextSteps;
    label={
        label_viewall,label_new,IdentifiedBusinessOpp,opportunitiesSec,Project_Description,Name,description,Next_Steps,Priority_Level,
        Expected_Incremental_Sales,Monthly_Incremental,project_id,creation_date,project_name,yearly_incremental_sales,priority,
        opp_status,oppName,stage,closeDate,remainingDays,label_save,cancel,headingIBO,label_Close,Project_Description,Name,label_category,
        description,Next_Steps,label_status,Priority_Level,Expected_Incremental_Sales,Monthly_Incremental
    }   
    errors;
    showSpinner = false;    
    monthlyInc = 0;   
    subscription = {};
    CHANNEL_NAME = '/event/RefreshOpportunity__e';
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.isLoading = true;
        this.getRelatedRecords();        
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            let errorData = error;
			let triggerAlert = true;
			if(errorData.advice.reconnect === "handshake" || errorData.advice.reconnect === "none"){
				triggerAlert = false;
                setTimeout(() => {
                    this.handleSubscribe();
                }, 20000); // 20000 milliseconds = 20 seconds
			}
			if(triggerAlert){
                this.showToast("Error",JSON.stringify(errorData.error), "error");
			}
        });
    }
    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.isLoading = true;
            this.getRelatedRecords();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
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
    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });
    }
    showOppCreatePage(){
        this.isModalOpen= true;
    }
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
    navigateToOppRelatedList(event){
        this.navigateToRelatedList('Opportunities');
    }
    navigateOppCreatePage(event){
        this.navigateToNewPage('Opportunity');
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
    get statusOptions(){
        return [
            { label : 'Not Started', value : 'Not Started'},
            { label : 'In progress', value : 'In progress'},
            { label : 'Postponed', value : 'Postponed'},
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
    @wire(getChatterUserDetail)
    allStages({data }) {
        if (data) {
            this.showAllTab = data;
        } 
        else{
            this.showAllTab = false;
        }
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
    monthlyIncCH(event){
        this.monthlyInc = event.target.value;
    }
    onSave(event){
        const requiredFields = this.template.querySelectorAll('lightning-input, lightning-combobox');
        let missingFields = [];
        
        requiredFields.forEach(field => {
            if (field.required && !field.value) {
                missingFields.push(field.label);
                field.classList.add('slds-has-error'); // Highlight the field
            } else {
                field.classList.remove('slds-has-error'); // Remove highlight if filled
            }
        });

        if (missingFields.length > 0) {
            const toastEvent = new ShowToastEvent({
                title: 'Missing Required Fields',
                message: 'Please fill in the following required fields: ' + missingFields.join(', '),
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
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
    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}