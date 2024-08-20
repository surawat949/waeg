import { LightningElement, api,wire } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import ACCOUNT_HOYAID from '@salesforce/schema/Account.Hoya_Account_ID__c';
import Calendar_Year_Product_Mix from '@salesforce/label/c.Calendar_Year_Product_Mix';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



const FIELDS = [
    ACCOUNT_HOYAID
];  

export default class TabStatisticsProductMixPdf extends LightningElement {
    @api receivedId;
    statPdf;
    accHoyaId;
    statConsoPdf
    HLBE_dashboard;
    HLBE_web_microfiche;
    HLBE_Quick_reading;
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    label = {Calendar_Year_Product_Mix}
    
    @wire(getRecord, { recordId: '$receivedId', fields: [ACCOUNT_HOYAID] })
    record({ error, data }) {
        if (data) {
            this.accHoyaId = data.fields.Hoya_Account_ID__c.value;
                        this.statPdf = 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+this.receivedId+'&name='+this.accHoyaId+'.pdf';
            this.statConsoPdf ='http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+this.receivedId+'&name='+this.accHoyaId+'conso.pdf';
            // for HLBE
            this.HLBE_dashboard = 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=HLBE&id='+ this.receivedId+'&name='+ this.accHoyaId +'.dashboard.pdf';
            this.HLBE_web_microfiche = 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=HLBE&id='+ this.receivedId+'&name='+ this.accHoyaId +'.macrofiche.pdf';
            this.HLBE_Quick_reading = 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=HLBE&id='+ this.receivedId+'&name='+ this.accHoyaId +'.qreading.pdf';
        }
    else if(error){
            this.showToast('Error', 'Error',error);
        }
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