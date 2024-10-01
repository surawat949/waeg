import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { updateRecord } from 'lightning/uiRecordApi';
export default class V2LeadDisqualified extends LightningElement {
    @api recordId;
    connectedCallback() {
        setTimeout(() => {
            this.updateLeadStatus();
        }, 5);        
    }
    updateLeadStatus(){
        const fields = {};
        fields["Id"] = this.recordId;
        fields["Status"] = 'Lead Abandoned';        
        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {     
            this.dispatchEvent(new CloseActionScreenEvent());
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error updating Lead status: ' + error.body.message,
                    variant: 'error',
                })
            );
        });
    }
}