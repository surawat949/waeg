import { LightningElement, api ,wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//labels
import potentialTab from '@salesforce/label/c.PotentialTab';
import netSales from '@salesforce/label/c.Net_Sales';
import grossSales from '@salesforce/label/c.Gross_Sales';
import returns from '@salesforce/label/c.Returns';
import shipments from '@salesforce/label/c.Shipments';
import pdf from '@salesforce/label/c.Product_Mix_PDF';
//fields
import accCountry from '@salesforce/schema/Account.Shop_Country__c';

export default class TabStatistics extends LightningElement {
    @api recordId;
    isGermanyAccount;
    accountCountry;
    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        potentialTab,netSales,grossSales,returns,shipments,pdf
    }
    @wire(getRecord, { recordId: "$recordId", fields:[accCountry] })
    record( { error, data }){
        if(data){
            this.accountCountry = data.fields.Shop_Country__c.value;
            if(this.accountCountry == 'DE')
                this.isGermanyAccount = true;
            else
                this.isGermanyAccount = false;
        }
        else if(error){
            this.showToast('Error', 'Error',error);
        }
    }
    connectedCallback() {       
        //console.log('parent connected callback call' + this.recordId);        
    }

    renderedCallback(){
    }
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}