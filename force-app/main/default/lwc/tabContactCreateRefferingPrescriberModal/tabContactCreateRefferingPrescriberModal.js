import {LightningElement, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import createAccountContactRel from '@salesforce/apex/TabActivationMedicalProgramController.createAccountContactRel';
import label_AccContact from '@salesforce/label/c.tabTaskModalAccContact';
import label_New_Prescriber from '@salesforce/label/c.SFDC_V_2_Prescribers_New_Prescriber';
import label_Account from '@salesforce/label/c.Account';

export default class TabContactCreateRefferingPrescriberModal extends LightningElement {
    @api receivedId;
    // @api activationPrescriber;
    isModalOpen = false;
    objectAPI='Account';
    contactId;
    labelAccContact = label_AccContact;
    label_New_Prescriber = label_New_Prescriber;
    label_Account = label_Account;

    handleLookupSelectionAccounContact(event) {
        if (event.detail.selectedRecord != undefined) {
            this.contactId = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value = event.detail.selectedRecord.Id;
        }

    }
    contactCH(event) {
        this.contactId = event.target.value;
        
    }
    handleSave() {
        createAccountContactRel({accountId: this.receivedId, contactId: this.contactId}).then(result => {
            if (result == 'Success') {
                const evt = new ShowToastEvent({title: "Success", message: "New Prescriber added", variant: "success"});
                this.dispatchEvent(evt);
                let ev = new CustomEvent('savesuccess');
                this.dispatchEvent(ev);
                this.closeModal();

            } else if (result == 'Duplicate') {
                const evt = new ShowToastEvent({title: "Alert!", message: " Prescriber already added", variant: "error"});
                this.dispatchEvent(evt);

            }


        }).catch(error => {
            if (error.body.message.includes('DUPLICATE_VALUE')) {
                const evt = new ShowToastEvent({title: "Error", message: " Prescriber already exists", variant: "error"});
                this.dispatchEvent(evt);
            }
            this.message = 'Error Creating ';
			
        });

    }

    @api displayModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;

    }

    showSuccessToast() {
        const evt = new ShowToastEvent({title: "Success", message: "New Prescriber added", variant: "success"});
        this.dispatchEvent(evt);
    }
}