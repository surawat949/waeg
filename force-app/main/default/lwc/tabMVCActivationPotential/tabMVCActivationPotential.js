import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Fields
import PrescriptionPotential from '@salesforce/schema/Contact.Prescription_Potential__c'; 
import Total_Prescriptions from '@salesforce/schema/Contact.Total_Prescriptions_Per_Week__c'; 
// labels
import PrescribingCapacity from '@salesforce/label/c.tabActivationPotentialCapacity';
import PrescribingSegmentation from '@salesforce/label/c.tabActivationPotentialSegmentation';
import IdentifiedRefOpts from '@salesforce/label/c.IdentifiedReferringOpticians';
import RefOptsOrderingfromHVC from '@salesforce/label/c.ReferringOptsOrderingfromHVC';
//object
import Contact_obj from '@salesforce/schema/Contact';
//Apex
import getReferringOpticiansCountList from '@salesforce/apex/TabMVCActivationController.getReferringOpticiansCountList';
export default class TabMVCActivationPotential extends LightningElement {
    @api receivedId;
    Prescription_Potential=[PrescriptionPotential];
    ObjectApiName = Contact_obj;
    IdentifiedReferringOpts;
    ReferringOptsfromHVC;
    PrescriptionsFields1=[Total_Prescriptions];
    
    custLabel = {
        PrescribingCapacity,
        PrescribingSegmentation,
        IdentifiedRefOpts,
        RefOptsOrderingfromHVC
    }
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        getReferringOpticiansCountList({contactId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.IdentifiedReferringOpts = response[0];
            this.ReferringOptsfromHVC = response[1];
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
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