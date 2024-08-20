import { LightningElement, api,wire } from 'lwc';

import Visit_Frequency from '@salesforce/label/c.Visit_Frequency';
import Last_Contact_Visit_Date from '@salesforce/label/c.Last_Contact_Visit_Date';
import Last_Digital_Visit_Date from '@salesforce/label/c.Last_Digital_Visit_Date';
import Total_Visits_Achived from '@salesforce/label/c.Total_Visits_Achived';
import Contact_Direct_Visit_Frequency from '@salesforce/label/c.Contact_Direct_Visit_Frequency';
import Contact_Digital_Visit_Frequency from '@salesforce/label/c.Contact_Digital_Visit_Frequency';

import total_visit_palnned from '@salesforce/schema/Contact.Total_Visits_Planned__c'; 
import contact_Digital_Visits_Planned from '@salesforce/schema/Contact.Contact_Digital_Visits_Planned__c'; 
import contact_Direct_Visits_Planned from '@salesforce/schema/Contact.Contact_Direct_Visits_Planned__c'; 
import Contact_obj from '@salesforce/schema/Contact';

import getContactVisitFrequency from '@salesforce/apex/TabMVCVisitsTacticomController.getContactVisitFrequency';
import getAccountsByZone from '@salesforce/apex/TabMVCVisitsTacticomController.getAccountsByZone';
import Contact_TACTCOM_FIELD  from '@salesforce/schema/Contact.Contact_Tacticom__c';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import OWNER_NAME from '@salesforce/schema/Contact.Owner.Name';
import OWNER_FIELD from '@salesforce/schema/Contact.OwnerId';
import TACTICOM_SOF from '@salesforce/schema/Contact.Account.TACTICOM_SOF__c';

import Tacticom  from '@salesforce/label/c.Tacticom'; 
import My_Tacticom_Total_Visits from '@salesforce/label/c.My_Tacticom_Total_Visits';

export default class TabMVCVisitsTacticom extends LightningElement {
    @api receivedId;
    contactVisitFrequencyData={};
    objectApiName=Contact_obj;
    isDoughnutChartDataReceived=false;
     
    
    label={
        Visit_Frequency,Last_Contact_Visit_Date,Last_Digital_Visit_Date,Total_Visits_Achived,Contact_Direct_Visit_Frequency,
        Contact_Digital_Visit_Frequency,
        Tacticom,My_Tacticom_Total_Visits
    }

    visits_fields_of_contact=[total_visit_palnned,contact_Direct_Visits_Planned,contact_Digital_Visits_Planned];
    visits_medical_field =[Contact_TACTCOM_FIELD];

    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {

    }

    @wire(getRecord, { recordId:'$receivedId', fields: [OWNER_NAME,OWNER_FIELD,TACTICOM_SOF]})
    AdditionalContactData

    get ownerId() {
        return getFieldValue(this.AdditionalContactData.data, OWNER_FIELD);
    }

    get tacticomSOF() {
        return getFieldValue(this.AdditionalContactData.data, TACTICOM_SOF);
    }
    
    @wire(getContactVisitFrequency,{contactId:'$receivedId'}) contactVisitFrequency ({error,data}){
        
        if(data){
            this.contactVisitFrequencyData=data;
        }
        else if(error){
            this.showToast('Error','Error while getting the Visits','error')
        }
    }

     //Doughnut chart - start
    totalCount=0;
    pieChartLabels=[]
    pieChartData=[]
    pieChartDataTemp = [];
    pieChartLablesTemp = [];
    @wire(getAccountsByZone,{conOwner:'$ownerId'})
    AccountHandler({data, error}){
        if(data){
            const Obj=Object.assign({}, data);
            const arrayObj = Object.values(Obj);           
            arrayObj.forEach(acc => {
                this.pieChartLablesTemp.push(acc.Contact_Tacticom__c);
                this.pieChartDataTemp.push(acc.cnt);
                this.totalCount=this.totalCount+acc.cnt;
            });
            this.pieChartData= JSON.parse(JSON.stringify(this.pieChartDataTemp));
            this.pieChartLabels= JSON.parse(JSON.stringify(this.pieChartLablesTemp));
            this.isDoughnutChartDataReceived=true;
        }
        if(error){
            this.showToast('Error','Error while getting the Visits','error')
        }
    }
   //Douhnut chart end

   showToast(title,message,variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    this.dispatchEvent(event);
}

}