import { LightningElement,track,api,wire } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import AccountId from '@salesforce/schema/Account_Life_Cycle__c.Account__c';
import stage from '@salesforce/schema/Account_Life_Cycle__c.Stage__c';

import getVisits from '@salesforce/apex/TabAccountLifeCycleDetailPageController.getVisits';
import getBusinessOppa from '@salesforce/apex/TabAccountLifeCycleDetailPageController.getBusinessOpp';

//LWC component to create Identified Business Opportunity
import project_id from '@salesforce/label/c.project_id';
import creation_date from '@salesforce/label/c.creation_date';
import project_name from '@salesforce/label/c.project_name';
import yearly_incremental_sales from '@salesforce/label/c.yearly_incremental_sales';
import opp_status from '@salesforce/label/c.opp_status';
import priority from '@salesforce/label/c.priority';
import Assigned_To from '@salesforce/label/c.Assigned_To';
import Reports_Date from '@salesforce/label/c.Reports_Date';
import Visit_Notes from '@salesforce/label/c.Visit_Notes';
import Call_To_Action from '@salesforce/label/c.Visit_Main_Outcome';

import IdentifiedBusinessOpp from '@salesforce/label/c.IdentifiedBusinessOpp';
import LastVisitsreports from '@salesforce/label/c.Last_3_Visits_reports';
import AccountLifeCycleCompetitors from '@salesforce/label/c.Account_Life_Cycle_Competitors';


// Account fields
import Account from '@salesforce/schema/Account';
import firstCompetitorName from '@salesforce/schema/Account.First_Competitor_local_name__c';
import secondCompetitorName from '@salesforce/schema/Account.Second_Competitor_Local_Name__c';
import firstCompetitorMainStrength from '@salesforce/schema/Account.First_Competitor_Main_Strength__c';
import secondCompetitorMainStrength from '@salesforce/schema/Account.Second_Competitor_Main_Strength__c';
import firstCompetitorMainWeakness from '@salesforce/schema/Account.First_Competitor_Main_Weakness__c';
import secondCompetitorMainWeakness from '@salesforce/schema/Account.Second_Competitor_Main_Weakness__c';


export default class TabAccountLifeCycleDetailPage extends LightningElement {
    @api recordId;
    AccountId;
    objectApiName = Account;
    stage;
    OppRecord;
    visitRecord;
    showCompetitors=false;
    showOpp=false;
    fields1=[firstCompetitorName,secondCompetitorName,firstCompetitorMainStrength,
        secondCompetitorMainStrength,firstCompetitorMainWeakness,secondCompetitorMainWeakness];
    label={project_id,creation_date,project_name,
        yearly_incremental_sales,opp_status,priority,IdentifiedBusinessOpp,Assigned_To,
        Reports_Date,Visit_Notes,LastVisitsreports,AccountLifeCycleCompetitors,Call_To_Action

   }
    
    @wire(getRecord, { recordId: '$recordId', fields: [ AccountId,stage] })
    getAccountId({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
                this.AccountId = data.fields.Account__c.value;
                this.stage = data.fields.Stage__c.value;
                if(this.stage == 'Discover' || this.stage == 'Engage' || this.stage == 'Negotiate'){
                    this.showCompetitors=true;
                    this.showOpp=false;
                }
                if(this.stage == 'On-board' || this.stage == 'Develop' || this.stage == 'Build Loyalty'){
                    this.showOpp=true;
                    this.showCompetitors=false;
                }
                
        }
    }
    @track columns = [
        {
            label: this.label.project_id,
            fieldName: 'nameLink',
            type: 'url',
            typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true,
            

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
    @track columnVisit = [
        {
            label: this.label.Reports_Date,
            fieldName: 'Start_Day__c',
            type: 'date',
            sortable: true,
            initialWidth: 147,

        },
        {
            label: this.label.Assigned_To,
            fieldName: 'Visit_assigned_to__c',
              type: 'text',
             sortable: true,
             initialWidth: 155,
        },
        {
            label: 'Visit Main objective',
            fieldName: 'Visit_Reason__c',
              type: 'text',
             sortable: true,
             initialWidth: 155,
        },
        {
            label:'Visit Objective Notes',
            fieldName: 'Visit_Objective_follow_up_notes__c',
            type: 'text',
            sortable: true ,
            wrapText: true,
            initialWidth: 400,
        },
        {
            label:'Visit notes',
            fieldName: 'Visit_Notes__c',
            type: 'text',
            sortable: true ,
            wrapText: true,
            initialWidth: 400,
        },
        {
            label: 'Visit Main Outcome',
            fieldName: 'Call_To_Action__c',
            type: 'text',
            sortable: true,
            wrapText: true,
            initialWidth: 250,
        }
    ];
    @wire(getBusinessOppa, {recordId:'$AccountId'}) 
    getBusinessOppa({error, data}){
        if(data && data.length > 0){
            console.log('>>>',JSON.stringify(data));
            data = JSON.parse(JSON.stringify(data));
            data.forEach(res=>{ 
                    res.nameLink = '/' + res.Id;
                });
                this.OppRecord = [...data];
                console.log('>>>',data);
                console.log('>>>',this.OppRecord);
            }
        else if (error){
            //this.showToast('Error','Error While fetching the Tasks'+error.message,'error');
        }
    }
    @wire(getVisits, {recordId:'$AccountId'}) 
    getVisits({error, data}){
        if(data && data.length > 0){
            data = JSON.parse(JSON.stringify(data));
                this.visitRecord = data;
          }
          else if (error){
            //this.showToast('Error','Error While fetching the Tasks'+error.message,'error');
          }
      }

   
}