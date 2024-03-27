import { LightningElement,api,track,wire} from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Forcefully_Deactivate_FIELD from '@salesforce/schema/Contract__c.Force_Deactivation__c';
import Last_Deactivation_Date from '@salesforce/schema/Contract__c.Last_Deactivation_Date__c';
import Expiration_Date from '@salesforce/schema/Contract__c.Expiration_Date__c';

import ID_FIELD from '@salesforce/schema/Contract__c.Id';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';
export default class UpdateForceDeactivateCheckboxContract extends LightningElement {
    @api recordId;
    @track today = new Date();
    isCheckActiveBox=true;
    expirationDate;
    customMessage;
    connectedCallback(){

        var today = new Date();
        this.date=today.toISOString();
    }
   @wire(getRecord, { recordId: '$recordId', fields: [Forcefully_Deactivate_FIELD,Expiration_Date] })
    record({ error, data }) {
        if (data) {
            this.isCheckActiveBox = true;
            if(data.fields.Force_Deactivation__c.value == true ){
                this.isCheckActiveBox = false;
            }
            if(data.fields.Expiration_Date__c.value != null ){
                this.expirationDate = data.fields.Expiration_Date__c.value;
            }
        }
            
    }

    @api invoke() {
        const fields = {};
        if(this.isCheckActiveBox){
            fields[ ID_FIELD.fieldApiName ] = this.recordId;
            fields[ Forcefully_Deactivate_FIELD.fieldApiName] = true;
            fields[ Last_Deactivation_Date.fieldApiName] = this.date;
            this.customMessage = 'Contract activated successfully.'; 
        }   
        else{
            fields[ ID_FIELD.fieldApiName ] = this.recordId;
            fields[ Forcefully_Deactivate_FIELD.fieldApiName] = false;
            fields[ Last_Deactivation_Date.fieldApiName] = null;
            this.customMessage = 'Contract deactivated successfully.'; 
            alert('Do really want to re-activate the contract?');
        }
        const recordInput = {fields};
        if(this.expirationDate<=this.date){
            this.showToast('Error', 'error', 'Contracted is already expired');
        }
        else{
            updateRecord( recordInput )
            .then( () => {
                this.showToast('Success', 'Success', this.customMessage);

            }).catch( error => {
                this.showToast('error', 'error', 'Error updating or reloading record');
                
            });
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