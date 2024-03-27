import { LightningElement, api, wire,track} from 'lwc';
import Visits_Obj from '@salesforce/schema/Visits__c';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import Visit_Type from '@salesforce/schema/Visits__c.Visit_Type__c';  
import Assigned_To from '@salesforce/schema/Visits__c.Assigned_to__c';      //new field - need create on Account object
import Account from '@salesforce/schema/Visits__c.Account__c';                       
import Start_Date_Time from '@salesforce/schema/Visits__c.Start_Date_Time__c';
import End_Date_Time from '@salesforce/schema/Visits__c.End_Date_Time__c';
import Related_Contact from '@salesforce/schema/Visits__c.Contact__c';
import Duration_Minutes from '@salesforce/schema/Visits__c.Duration_Minutes__c';
import Is_All_Day_Event from '@salesforce/schema/Visits__c.Is_All_Day_Event__c';
import Coaching_Visit from '@salesforce/schema/Visits__c.Coaching_Visit__c';
import Visit_Notes from '@salesforce/schema/Visits__c.Visit_Notes__c';
import Visit_Reason from '@salesforce/schema/Visits__c.Visit_Reason__c';
import Call_To_Action from '@salesforce/schema/Visits__c.Call_To_Action__c';
import Visit_Status from '@salesforce/schema/Visits__c.Visit_Status__c';
import Actions_executed from '@salesforce/schema/Visits__c.Actions_executed__c';
import Call_To_Action_Notes from '@salesforce/schema/Visits__c.Call_To_Action_Notes__c';
import Expected_Incremental_Sales from '@salesforce/label/c.Expected_Incremental_Sales';
import Monthly_Incremental from '@salesforce/label/c.Monthly_Incremental';
import Visit_Objective_followUp from '@salesforce/schema/Visits__c.Visit_Objective_follow_up_notes__c';
import Visit_Planning_Tracker__c from '@salesforce/schema/Visits__c.Visit_Planning_Tracker__c';
import Visit_Preparation_Tracker__c from '@salesforce/schema/Visits__c.Visit_Preparation_Tracker__c';
import Visit_Planned_Tracker__c from '@salesforce/schema/Visits__c.Visit_Planned_Tracker__c';
import Visit_Tacticom_Tracker__c from '@salesforce/schema/Visits__c.Visit_Tacticom_Tracker__c';
import Visit_CreationDate_Tracker__c from '@salesforce/schema/Visits__c.Visit_Creation_Day_Tracker__c';
import Visit_Start_Day_Tracker__c from '@salesforce/schema/Visits__c.Visit_Start_Day_Tracker__c';
import Visit_Home_Office_Tracker from '@salesforce/schema/Visits__c.Visit_Home_Office_Tracker__c';
import Visit_Reporting_Day_Tracker__c from '@salesforce/schema/Visits__c.Visit_Reporting_Day_Tracker__c';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import getIdentifiedBusinesssOpp from '@salesforce/apex/tabVisitDetailFormController.getBusinessOpportunityRelatedAccount';
import createBusinessOpportunity from '@salesforce/apex/TabVisitsCampOppController.createBusinessOpportunity';
import getUserInfo from '@salesforce/apex/tabVisitDetailFormController.getUserInfo';

//LWC component to create Identified Business Opportunity
import project_id from '@salesforce/label/c.project_id';
import creation_date from '@salesforce/label/c.creation_date';
import project_name from '@salesforce/label/c.project_name';
import yearly_incremental_sales from '@salesforce/label/c.yearly_incremental_sales';
import opp_status from '@salesforce/label/c.opp_status';
import priority from '@salesforce/label/c.priority';
import Project_Description from '@salesforce/label/c.Project_Description';

import label_category1 from '@salesforce/label/c.category';
import label_status from '@salesforce/label/c.Status';
import Name from '@salesforce/label/c.tabContactModalName';
import description from '@salesforce/label/c.Description';
import Next_StepsForm from '@salesforce/label/c.Next_Steps';
import Priority_Level from '@salesforce/label/c.Priority_Level';
import Visit_Report from '@salesforce/label/c.Visit_Report';
import Visit_Preparation from '@salesforce/label/c.Visit_Preparation';
import Visit_Detail from '@salesforce/label/c.Visit_Detail';
import opportunitiesSec from '@salesforce/label/c.opportunitiesSec';
import label_save from '@salesforce/label/c.tabLabelSave';
import label_Close from '@salesforce/label/c.tabLabelClose';
import Next_Steps from '@salesforce/label/c.Next_Steps';
import IdentifiedBusinessOpp from '@salesforce/label/c.IdentifiedBusinessOpp';
import Visit_Tracker from '@salesforce/label/c.Visit_Tracker';
//refresh the table



export default class TabVisitsDetailForm extends LightningElement {
    isModalOpen = false; //for opportunity popup
    @track isLWCDisabled = false;
    @api recordId;
    label_Project_Description=Project_Description;
    isDataTableRefresh;
    showSpinner = false;
    labelClose = label_Close;
    labelCategory = label_category1;
    labelStatus = label_status;
    name =Name;
    Description = description;
    next_Steps = Next_Steps;
    priority_Level = Priority_Level;
    expected_Incremental_Sales = Expected_Incremental_Sales;
    monthly_Incremental = Monthly_Incremental;
    labelSave = label_save;
    labelClose = label_Close;
    VisitTracker = Visit_Tracker;

    projectName;
    description;
    category;
    nextSteps;
    status;
    level;
    monthlyInc;
    errors = '';
    objectApiName = Visits_Obj;
    fields=   [Visit_Type,Assigned_To,Account,Start_Date_Time,End_Date_Time,Related_Contact,Duration_Minutes,Is_All_Day_Event,Coaching_Visit];
    fields1 = [Visit_Reason,Visit_Objective_followUp];
    //fields2 = [Visit_Reason,Call_To_Action,Visit_Status];
    fields3 = [Call_To_Action,Call_To_Action_Notes,Visit_Status];
    fields4 = [Actions_executed];
    fields5 = [Visit_Notes];
    fields6 = [Visit_Planning_Tracker__c,Visit_Preparation_Tracker__c,Visit_Planned_Tracker__c,Visit_Tacticom_Tracker__c,Visit_CreationDate_Tracker__c,Visit_Start_Day_Tracker__c,Visit_Home_Office_Tracker,Visit_Reporting_Day_Tracker__c];

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
    @track accountId;
    @track OppRecord;
    label={project_id,creation_date,project_name,
         yearly_incremental_sales,opp_status,priority,Next_StepsForm,
        Visit_Detail,Visit_Report,Visit_Preparation,opportunitiesSec,IdentifiedBusinessOpp,Visit_Tracker
    }

    @wire(getUserInfo, {}) 
    userData({ error, data }) {
        if(data) {
            if(data.Profile.Name == "System Administrator") {    
                this.isLWCDisabled = true;
            }
        } else if(error) {
            this.showToast('Error', 'Error fetching profile of User',error);
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: [Account] })
    record({ error, data }) {
        if (data) {
            this.accountId = data.fields.Account__c.value;
        }
        else if(error){
            this.showToast('Error', 'Error',error);
        }
    }
showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
    @track columns = [
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
            label: this.label.opp_status,
            fieldName: 'Project_Status__c',
             type: 'text',
            sortable: true
        },

        {
            label: this.label.priority,
            fieldName: 'Priority_level__c',
            type: 'number',
            sortable: true
        }
    ];
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
    getRelatedRecords() {
        getIdentifiedBusinesssOpp({VisitId: this.recordId})
        .then(result => {
            if(result){
                result = JSON.parse(JSON.stringify(result));
                result.forEach(res=>{
                    res.nameLink = '/' + res.Id;
                });
                this.OppRecord = result;
                this.isDataTableRefresh=true;
            }
        })    
        .catch(error => {
            this.OppRecord = undefined;
            this.showToast('Error', 'Error',error);
        });
    }
    handleOppCount(data){
        let allOppData = data;
        if(allOppData.length > 5){
            this.oppCount = '5+';
        }else{
            this.oppCount = allOppData.length;
        }
    }
   
    showOppCreatePage(){
        this.isModalOpen= true;
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
    connectedCallback() {
        this.isLoading = true;
        this.isDataTableRefresh=true;
        this.getRelatedRecords();
       
    }
    handleSuccess(event) {
        //Bug 1064 Fix- Adding placeholder for success logic
        const updatedRecord = event.detail.id;
        //console.log('onsuccess: ', updatedRecord);
    }
    onSave(event){
        if(this.projectName =='' || this.projectName == null){
            alert('Project Name must have the value, please input some values Project Name field');
        }
        else{
            this.showSpinner = true ;
            this.isDataTableRefresh=false;
            createBusinessOpportunity({
                projectName : this.projectName,
                accountId : this.accountId,
                description : this.description,
                category : this.category,
                nextSteps : this.nextSteps,
                level : this.level,
                monthlyInc : this.monthlyInc,
                status : this.status
            }).then(result=>{
                this.showSpinner = false;
                this.closePopup();
                this.getRelatedRecords();
                this.projectName='';
                this.description='';
                this.category='';
                this.nextSteps='';
                this.status='';
                this.level='';
                this.monthlyInc='';
            }).catch(error=>{
                this.showSpinner = false;
                this.showToast('Error', 'Error',error);
            });
        }
    }
    closePopup() {
        this.isModalOpen = false;       
    }

}