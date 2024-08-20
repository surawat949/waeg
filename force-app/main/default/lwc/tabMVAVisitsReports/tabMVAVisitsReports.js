import { LightningElement, api,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import visits from '@salesforce/label/c.visits';
import contact from '@salesforce/label/c.Contact';
import visitType  from '@salesforce/label/c.VisitType';
import visit_Objective from '@salesforce/label/c.Visit_Objective';
import visit_ID from '@salesforce/label/c.Visit_ID';
import date from '@salesforce/label/c.date';
import { NavigationMixin } from 'lightning/navigation';
import Last_Visit_Date from '@salesforce/label/c.Last_Visit_Date';
import Total_Visits_Achieved from '@salesforce/label/c.Total_Visits_Achived';
import Office_Visits_Frequency from '@salesforce/label/c.Office_Visits_Frequency';
import Digital_Visits_Frequency from '@salesforce/label/c.Digital_Visits_Frequency';
import Visit_Frequency from '@salesforce/label/c.Visit_Frequency';
import ViewAll from '@salesforce/label/c.ViewAllRelatedList';
import VisitAssignedTo from '@salesforce/label/c.Visit_assigned_to';
import getVisits from '@salesforce/apex/TabMVAVisitsController.getVisitsBasedOnContacts';
//import getVisitFrequency from '@salesforce/apex/TabMVAVisitsController.getVisitFrequency';
import AllAssociatedContact from '@salesforce/apex/TabMVAActivationContactController.getAllContactsHierarchy';


export default class TabMVAVisitsReports extends NavigationMixin(LightningElement) {
    @api receivedId;
    isLoading = true;
    visitCount=0;
    isVisitDataExists = false;
    isVisitFreqDataExists = false;
    visitsData;
    accountsLinkedToContacts;

    visitFrequencyData;

    connectedCallback(){
        //console.log('XXX Received Id = > '+this.receivedId);
        this. getAllContactData();
    }

    lables={
        visits, contact, visitType, visit_Objective, visit_ID ,date,
        Last_Visit_Date, Total_Visits_Achieved, Office_Visits_Frequency, Digital_Visits_Frequency,
        Visit_Frequency, ViewAll, VisitAssignedTo
    }

    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'Visits__r',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }

    @wire(getVisits,{accountId:'$receivedId'}) visitRecords ({error,data}){
    if(data){
        this.isLoading = false;
        data = JSON.parse(JSON.stringify(data));
        if(data.length > 0){
        this.isVisitDataExists = true;
        data.forEach(res=>{
            res.nameLink = res.Id!= undefined ? '/' + res.Id : '';
            res.contactLink = res.Contact__c!= undefined ? '/' + res.Contact__c : '';
            res.contactName = res.Related_Contact__c!= undefined  ? res.Related_Contact__c : '';
        });

        let allVisits=data;
        this.visitsData = (allVisits.length <= 5) ? [...allVisits] : [...allVisits].splice(0,5);

        if(allVisits.length>5){
            this.visitCount='5+';
        }
        else{
            this.visitCount=allVisits.length;
        }
      }
    }
    else if(error){
        this.showToast('Error',error,'error');
    }
    }

    getAllContactData(){
        AllAssociatedContact({recordId : this.receivedId}).then(response=>{
            if(response){
                response = JSON.parse(JSON.stringify(response));
                if(response.length > 0)
                    this.isVisitFreqDataExists = true;
                    response.forEach(res=>{
                    res.link = '/' + res.ContactId;
                });
                let allVisitsFrequency=response;
                this.visitFrequencyData = allVisitsFrequency;
            }
        }).catch(error=>{
            debugger;
            this.response = undefined;
            this.showToast('Error',JSON.stringify(error.message),'error','dismissable');
        });
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