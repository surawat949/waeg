import { LightningElement,api,track,wire} from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Forcefully_Deactivate_FIELD from '@salesforce/schema/Contract__c.Force_Deactivation__c';
import Last_Deactivation_Date from '@salesforce/schema/Contract__c.Last_Deactivation_Date__c';
import ID_FIELD from '@salesforce/schema/Contract__c.Id';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';
export default class UpdateForceDeactivateChechboxContract extends LightningElement {
    @api recordId;
    @track today = new Date();
    contractList;
    isCheckActiveBox=true;
    connectedCallback(){

        var today = new Date();
    
        this.date=today.toISOString();
        console.log(today.toISOString());
    }
    @wire(getRecord, { recordId: '$recordId', fields: [Forcefully_Deactivate_FIELD] })
    record({ error, data }) {
        if (data) {
            this.contractList = data;
            console.log('>>',this.contractList);
            console.log('??here',data.fields.Forcefully_Deactivate__c.value);
            if(data.fields.Forcefully_Deactivate__c.value == true ){
                this.isCheckActiveBox = false;
            }
        }
            
    }

    @api invoke() {

        console.log( "Inside Invoke Method" );
        console.log( "Record Id is " + this.recordId );
        const fields = {};
        if(this.isCheckActiveBox){
            fields[ ID_FIELD.fieldApiName ] = this.recordId;
            fields[ Forcefully_Deactivate_FIELD.fieldApiName] = true;
            fields[ Last_Deactivation_Date.fieldApiName] = this.date;}    
        else{
            fields[ ID_FIELD.fieldApiName ] = this.recordId;
            fields[ Forcefully_Deactivate_FIELD.fieldApiName] = false;
            fields[ Last_Deactivation_Date.fieldApiName] = null;}
        

        const recordInput = {fields};

        updateRecord( recordInput )
        .then( () => {
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Success',
                    message: 'Contract updated',
                    variant: 'success'
                } )
            );
        }).catch( error => {
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Error updating or reloading record',
                    message: error.body.message,
                    variant: 'error'
                } )
            );
        });

    }

}