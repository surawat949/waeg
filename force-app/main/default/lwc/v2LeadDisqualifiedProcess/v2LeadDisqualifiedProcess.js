import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class V2LeadDisqualifiedProcess extends LightningElement {
    @api recordId; 
    @api objectApiName;
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        if (!fields.Lead_Disqualified_Reason__c) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Disqualification reason is required.',
                    variant: 'error',
                })
            );
        } else {
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
    }
    handleSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Lead has been disqualified successfully.',
                variant: 'success',
            })
        );
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}