import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Apex
//import getContactList from '@salesforce/apex/TabActivationController.getContactList';
import getMainMyopiaControlField from '@salesforce/apex/TabActivationMPMiyosmart.getMainMyopiaDefault';

export default class TabActivationMedicalProgram extends LightningElement {
    @api receivedId;

    MainMyopiaControl;
   
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        console.log('child connected call-' + this.receivedId);
    }

    @wire(getMainMyopiaControlField, {recordId : '$receivedId'})
    getMyopiaControl({error, data}){
        if(error){
            this.showToast('Error', 'Error', error.message);
        }else if(data){
            this.MainMyopiaControl = data;
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